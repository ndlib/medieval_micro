require 'fastercsv'

namespace :db do
  namespace :import do

    desc 'Imports Facsimiles the provided CSV file. If no row is specified all rows are imported.'
    task :csv, [:path_to_csv_file, :row_id] => :environment do |t, args|
      puts <<-DESC
 Both the ActiveRecord models and their associated Solr documents are being created by default. This may take a while.
 To speed things up you can disable indexing by setting the DO_NOT_INDEX environment variable. Like so:
 $ DO_NOT_INDEX=true bundle exec rake db:import:csv[path/to/data.csv]
      DESC

      import_row = args[:row_id] ? args[:row_id].to_i : nil

      imported_cities      = []
      imported_date_ranges = []
      imported_languages   = []
      imported_libraries   = []
      number_of_records    = 0
      row_count            = 0
      baseline_time        = 0

      FasterCSV.foreach(args[:path_to_csv_file]) do |row|
        if !row[0].blank? && ( import_row ? ( row_count == import_row ) : true )
          fascimile = Facsimile.new(
            :id                       => row[0],
            :title                    => row[1],
            :alternate_names          => row[2],
            :shelf_mark               => row[4],
            :origin                   => row[5],
            :dimensions               => row[6],
            :century_keywords         => row[7],
            :date_description         => row[8],
            :author                   => row[12],
            :content                  => row[13],
            :hand                     => row[14],
            :illuminations            => (row[15] == 'yes' ? true : false),
            :type_of_decoration       => row[16],
            :musical_notation         => (row[17] == 'yes' ? true : false),
            :type_of_musical_notation => row[18],
            :call_number              => row[19],
            :commentary_volume        => (row[20] == 'yes' ? true : false),
            :nature_of_facsimile      => row[21],
            :series                   => row[22],
            :publication_date         => row[23],
            :place_of_publication     => row[24],
            :publisher                => row[25],
            :printer                  => row[26],
            :notes                    => row[27],
            :bibliography             => row[28]
          )

          if fascimile.save
            unless row[10].blank?
              row[10].split('--').each do |name|
                language = Language.find_or_create_by_name( name.strip )

                if language
                  fascimile.languages << language
                  imported_languages  << language
                end
              end
            end

            unless row[9].blank?
              row[9].split('--').each do |code|
                date_range = DateRange.find_or_create_by_code( code.strip )

                if date_range
                  fascimile.date_ranges << date_range
                  imported_date_ranges  << date_range
                end
              end
            end

            unless row[3].blank?
              row[3].split('--').each do |location|
                segments     = location.split(',')
                library_name = segments.first.strip
                if segments.count > 1
                  city_name = segments
                  city_name.slice!(0)
                  city_name[0].upcase!
                  city_name = city_name.join(',').strip
                else
                  city_name = nil
                end

                city    = City.find_or_create_by_name(city_name)
                library = Library.find_or_create_by_name(library_name)

                if city
                  library.city = city
                  imported_cities << city
                end

                if library.save
                  fascimile.libraries << library
                  imported_libraries  << library
                end
              end
            end
          end

          number_of_records += 1
        end
        puts "Imported row #{row_count} in #{Time.now - baseline_time}s"
        row_count += 1
        baseline_time = Time.now
      end

      puts "#{number_of_records} records were processed."
      puts "#{imported_languages.count} languages imported"
      puts "#{imported_date_ranges.count} date ranges imported."
      puts "#{imported_libraries.count} libraires imported."
      puts "#{imported_cities.count} cities imported."
    end

    desc 'Imports the "languages" column from the provided CSV file. (Column index defaults to 10)'
    task :languages, [:path_to_csv_file, :column_index] => :environment do |t, args|
      column = args[:column_index] ? args[:column_index] : 10

      imported_languages = []
      number_of_records  = 0

      FasterCSV.foreach(args[:path_to_csv_file]) do |row|
        unless row[column].blank?
          row[column].split('--').each do |name|
            language = Language.find_or_create_by_name( name.strip )
            imported_languages << language if language.save
          end
        end
        number_of_records += 1
      end

      puts "#{number_of_records} records were processed."
      puts "#{imported_languages.count} languages were imported"
    end

    desc 'Imports the "countries of origin" implied by the "origin" column from the provided csv file. (column index defaults to 5)'
    task :countries_of_origin, [:path_to_csv_file, :column_index] => :environment do |t, args|
      column = args[:column_index] ? args[:column_index] : 5

      imported_countries = []
      updated_facsimiles = []
      number_of_records  = 0

      FasterCSV.foreach(args[:path_to_csv_file]) do |row|
        puts "Processing row: #{number_of_records}"
        unless (row[column].blank? || row[0].blank?)
          begin
            facsimile = Facsimile.find(row[0])

            # The formatting isn't consistent in the origin field -- this is a good-faith effort to accommodate it.
            country_name = row[column].strip.gsub(/[\.,]*$/,'').split(',').last.split('--').first.strip

            country_of_origin = Country.find_or_create_by_name( country_name )
            imported_countries << country_of_origin if country_of_origin.save

            facsimile.country_id = country_of_origin.id
            updated_record = facsimile.save
            updated_facsimiles << facsimile if updated_record

            puts "Updating Facsimile: #{row[0]} with Country: #{country_name}"
          rescue ActiveRecord::RecordNotFound
            #NOOP
          end
        end
        number_of_records += 1
      end

      puts "#{number_of_records} records were processed."
      puts "#{updated_facsimiles.count} facsimiles were updated."
      puts "#{imported_countries.count} countries of origin were imported."
    end

    desc 'Imports the "type of text" column from the provided csv file. (column index defaults to 12)'
    task :text_classifications, [:path_to_csv_file, :column_index] => :environment do |t, args|
      column = args[:column_index] ? args[:column_index] : 11

      imported_classifications = []
      updated_facsimiles       = []
      number_of_records        = 0

      FasterCSV.foreach(args[:path_to_csv_file]) do |row|
        puts "Processing row: #{number_of_records}"
        unless (row[column].blank? || row[0].blank?)
          begin
            facsimile = Facsimile.find(row[0])
            existing_facsimile_classifications = facsimile.classifications

            terms = row[column].split('--')

            terms.each do | term |
              unless term.blank?
                classification = Classification.find_or_create_by_name( term.strip )
                imported_classifications << classification unless existing_facsimile_classifications.include? classification
                facsimile.classifications << classification
              end
            end

            unless existing_facsimile_classifications.eql? facsimile.classifications
              updated_facsimiles << facsimile
            end

          rescue ActiveRecord::RecordNotFound
            #NOOP
          end
        end
        number_of_records += 1
      end

      puts "#{number_of_records} records were processed."
      puts "#{updated_facsimiles.count} facsimiles were updated."
      puts "#{imported_classifications.count} text classifications were imported."
    end

    desc 'Imports the "date ranges" column from the provided CSV file. (Column index defaults to 9)'
    task :date_range, [:path_to_csv_file, :column_index] => :environment do |t, args|
      column = args[:column_index] ? args[:column_index] : 9

      imported_date_ranges = []
      number_of_records    = 0

      FasterCSV.foreach(args[:path_to_csv_file]) do |row|
        unless row[column].blank?
          row[column].split('--').each do |code|
            date_range = DateRange.find_or_create_by_code( code.strip )
            imported_date_ranges << date_range if date_range.save
          end
        end
        number_of_records += 1
      end

      puts "#{number_of_records} records were processed."
      puts "#{imported_date_ranges.count} date ranges created."
    end

    desc 'Imports the "libraires" column from the provided CSV file. (Column index defaults to 3)'
    task :libraries, [:path_to_csv_file, :column_index] => :environment do |t, args|
      column = args[:column_index] ? args[:column_index] : 3

      imported_libraries = []
      imported_cities    = []
      number_of_records  = 0

      FasterCSV.foreach(args[:path_to_csv_file]) do |row|
        unless row[column].blank?
          row[column].split('--').each do |location|
            segments     = location.split(',')
            library_name = segments.first.strip
            if segments.count > 1
              city_name = segments
              city_name.slice!(0)
              city_name[0].upcase!
              city_name = city_name.join(',').strip
            else
              city_name = nil
            end

            city    = City.find_or_create_by_name(city_name)
            library = Library.find_or_create_by_name(library_name)

            if city
              library.city = city
              imported_cities << city
              puts city_name
            else
              puts "No City Created"
            end

            if library.save
              imported_libraries << library
              puts library_name
            else
              puts "Library could not be Saved"
            end
          end
        end
        number_of_records += 1
        puts '----------'
      end

      puts "#{number_of_records} records were processed."
      puts "#{imported_libraries.count} libraires created."
      puts "#{imported_cities.count} cities created."
    end

  end
end

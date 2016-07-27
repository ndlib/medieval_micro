# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class CatalogController < ApplicationController

  include Blacklight::Catalog

  before_filter :add_medieval_library

  def solr_search_params(*args)
    begin
      super.merge(init_params)
    rescue
      super(init_params)
    end
  end

  def init_params
    if !params.has_key?(:qt)
      params.merge({qt: nil})
    end
    params
  end

  configure_blacklight do |config|
    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = {
      :qt => 'search',
      :qf => [
        'format_t',                   # Shared fields
        'title_t',
        'library_t',
        'city_t',
        'shelf_mark_t',
        'alternate_names_t',          # Facsimile specific fields
        'origin_t',
        'country_of_origin_t',
        'dimensions_t',
        'century_keywords_t',
        'date_description_t',
        'date_range_t',
        'language_t',
        'author_t',
        'content_t',
        'hand_t',
        'illuminations_t',
        'type_of_decoration_t',
        'musical_notation_t',
        'type_of_musical_notation_t',
        'call_number_t',
        'commentary_volume_t',
        'nature_of_facsimile_t',
        'series_t',
        'publication_date_t',
        'place_of_publication_t',
        'publisher_t',
        'printer_t',
        'notes_t',
        'bibliography_t',
        'classification_t',
        'mss_name_t',                 # Microfilm specific fields
        'mss_note_t',
        'collection_t',
        'reel_t',
        'hesburgh_location_t'
      ],
      :rows => 10 
    }

    ## Default parameters to send on single-document requests to Solr. These settings are the Blackligt defaults (see SolrHelper#solr_doc_params) or
    ## parameters included in the Blacklight-jetty document requestHandler.
    #
    #config.default_document_solr_params = {
    #  :qt => 'document',
    #  ## These are hard-coded in the blacklight 'document' requestHandler
    #  # :fl => '*',
    #  # :rows => 1
    #  # :q => '{!raw f=id v=$id}'
    #}

    # solr field configuration for search results/index views
    config.index.show_link = 'title_s'
    config.index.record_display_type = 'format'

    # solr field configuration for document/show views
    config.show.html_title = 'title_s'
    config.show.heading = 'title_s'
    config.show.display_type = 'format'

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _ted_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar
    config.add_facet_field 'format', :label => 'Format'
    config.add_facet_field 'library_facet', :label => 'Library', :limit => 10
    config.add_facet_field 'city_facet', :label => 'City', :limit => 10
    config.add_facet_field 'country_of_origin_facet', :label => 'Country of Origin', :limit => 10
    config.add_facet_field 'collection_facet', :label => 'Collection', :limit => 10
    config.add_facet_field 'language_facet', :label => 'Language', :limit => 10
    config.add_facet_field 'date_range_facet', :label => 'Date Range', :limit => 10
    config.add_facet_field 'illuminations_facet', :label => 'Illuminations', :limit => 10
    config.add_facet_field 'musical_notation_facet', :label => 'Musical Notation', :limit => 10
    config.add_facet_field 'commentary_volume_facet', :label => 'Commentary Volume', :limit => 10
    config.add_facet_field 'classification_facet', :label => 'Type of Text', :limit => 10


    config.add_facet_field 'example_query_facet_field', :label => 'Publish Date', :query => {
       :years_5 => { :label => 'within 5 Years', :fq => "pub_date:[#{Time.now.year - 5 } TO *]" },
       :years_10 => { :label => 'within 10 Years', :fq => "pub_date:[#{Time.now.year - 10 } TO *]" },
       :years_25 => { :label => 'within 25 Years', :fq => "pub_date:[#{Time.now.year - 25 } TO *]" }
    }


    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    #config.add_index_field 'format', :label => 'Format'
    config.add_index_field 'title_s', :label => 'Title:'
    config.add_index_field 'library_facet', :label => 'Library'
    config.add_index_field 'city_facet', :label => 'City:'
    config.add_index_field 'shelf_mark_s', :label => 'Shelf Mark:'
    config.add_index_field 'mss_name_s', :label => 'Mss Name:'
    config.add_index_field 'mss_note_s', :label => 'Mss Note:'
    config.add_index_field 'collection_facet', :label => 'Collection:'
    config.add_index_field 'reel_s', :label => 'Reel:'
    config.add_index_field 'hesburgh_location_s', :label => 'Hesburgh Location:'
    config.add_index_field 'alternate_names_s', :label => 'Alternate Names:'
    config.add_index_field 'language_facet', :label => 'Language:'
    config.add_index_field 'illuminations_facet', :label => 'Illuminations:'
    config.add_index_field 'musical_notation_facet', :label => 'Musical Notation:'
    config.add_index_field 'call_number_s', :label => 'Call Number:'
    config.add_index_field 'commentary_volume_facet', :label => 'Commentary Volume:'

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    config.add_show_field 'title_s', :label => 'Title:'
    config.add_show_field 'library_facet', :label => 'Library:'
    config.add_show_field 'language_facet', :label => 'Language:'
    config.add_show_field 'city_facet', :label => 'City:'
    config.add_show_field 'shelf_mark_s', :label => 'Shelf Mark:'
    config.add_show_field 'mss_name_s', :label => 'Mss Name:'
    config.add_show_field 'mss_note_s', :label => 'Mss Note:'
    config.add_show_field 'collection_facet', :label => 'Collection:'
    config.add_show_field 'reel_s', :label => 'Reel:'
    config.add_show_field 'hesburgh_location_s', :label => 'Hesburgh Location:'
    config.add_show_field 'alternate_names_s', :label => 'Alternate Names:'
    config.add_show_field 'origin_s', :label => 'Origin:'
    config.add_show_field 'country_of_origin_facet', :label => 'Country of Origin:'
    config.add_show_field 'dimensions_s', :label => 'Dimensions:'
    config.add_show_field 'date_description_s', :label => 'Date Description:'
    config.add_show_field 'author_s', :label => 'Author:'
    config.add_show_field 'content_s', :label => 'Content:'
    config.add_show_field 'hand_s', :label => 'Hand:'
    config.add_show_field 'illuminations_facet', :label => 'Illuminations:'
    config.add_show_field 'type_of_decoration_s', :label => 'Type of Decoration:'
    config.add_show_field 'musical_notation_facet', :label => 'Musical Notation:'
    config.add_show_field 'type_of_muiscal_notation_s', :label => 'Type of Musical Notation:'
    config.add_show_field 'call_number_s', :label => 'Call Number:'
    config.add_show_field 'commentary_volume_facet', :label => 'Commentary Volume:'
    config.add_show_field 'nature_of_facsimile_s', :label => 'Nature of Facsimile:'
    config.add_show_field 'series_s', :label => 'Series:'
    config.add_show_field 'publication_date_s', :label => 'Publication Date:'
    config.add_show_field 'place_of_publication_s', :label => 'Place of Publication:'
    config.add_show_field 'publisher_s', :label => 'Publisher:'
    config.add_show_field 'printer_s', :label => 'Printer:'
    config.add_show_field 'notes_s', :label => 'Notes:'
    config.add_show_field 'bibliography_s', :label => 'Bibliography:'
    config.add_show_field 'classification_facet', :label => 'Type of Text:'

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.

    config.add_search_field 'all_fields', :label => 'All Fields'

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.

    config.add_search_field('title') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = { :'spellcheck.dictionary' => 'title' }

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      field.solr_local_parameters = {
        :qf => '$title_qf',
        :pf => '$title_pf'
      }
    end

    config.add_search_field('author') do |field|
      field.solr_parameters = { :'spellcheck.dictionary' => 'author' }
      field.solr_local_parameters = {
        :qf => '$author_qf',
        :pf => '$author_pf'
      }
    end

    # Specifying a :qt only to show it's possible, and so our internal automated
    # tests can test it. In this case it's the same as
    # config[:default_solr_parameters][:qt], so isn't actually neccesary.
    config.add_search_field('subject') do |field|
      field.solr_parameters = { :'spellcheck.dictionary' => 'subject' }
      field.qt = 'search'
      field.solr_local_parameters = {
        :qf => '$subject_qf',
        :pf => '$subject_pf'
      }
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc, pub_date_sort desc, title_sort asc', :label => 'relevance'
    config.add_sort_field 'pub_date_sort desc, title_sort asc', :label => 'year'
    config.add_sort_field 'author_sort asc, title_sort asc', :label => 'author'
    config.add_sort_field 'title_sort asc, pub_date_sort desc', :label => 'title'

    # If there are more than this many search results, no spelling ("did you 
    # mean") suggestion is offered.
    config.spell_max = 5
  end

  def add_medieval_library
    params[:active_branch_code] = 'medieval_library'
  end

end

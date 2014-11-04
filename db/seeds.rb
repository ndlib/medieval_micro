# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

['administrators','editors'].each do |role_name|
  Role.find_or_create_by_name(role_name)
end

admin = Role.find_by_name('administrators')

['rbalekai','dbrubak1','msmyth','rjohns14'].each do |username|
  user = User.find_or_create_user_by_username(username)
  user.roles << admin
end

date_ranges = YAML::load(File.open(File.join(Rails.root,'test/fixtures/date_ranges.yml')))
date_ranges.each_value do |attributes|
  date_range = DateRange.find_or_create_by_code(attributes['code'])
  date_range.update_attributes!(:start_date => attributes['start_date'], :end_date => attributes['end_date'])
end

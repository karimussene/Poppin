# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'json'
require 'moving_avg'
require 'pp'

trends_file = 'db/trends_w_average_data.json'

def load_trends_json(trends_file, city)
  opened_file = File.open trends_file
  data = JSON.parse(File.read(opened_file))
  relevant_data = data[city]
  return relevant_data.flatten
end

def insert_trends_into_database(trends_data_file)
  data = load_trends_json(trends_data_file, 'sydney')
  data.each do |cuisine|
    #iterate over all cuisines
    key = cuisine.keys
    cuisine.dig(key[0], 'timelineData').each do |item|
      #iterate over the time series
      puts "new record"
      new_trend_record = Trend.new(
        city: City.where(name: 'Sydney').first,
        month: item['formattedTime'],
        value: item['value'][0],
        cuisine: Cuisine.where(name: key[0]).first,
        moving_average: item['moving_average'],
        )
      new_trend_record.save!
    end
  end
  puts "Created Trend Data for all cuisines with moving average"
end

insert_trends_into_database(trends_file)

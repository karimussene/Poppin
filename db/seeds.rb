
  # This file should contain all the record creation needed to seed the database with its default values.
  # The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
  #
  # Examples:
  #
  #   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
  #   Character.create(name: 'Luke', movie: movies.first)
require "zomato_api.rb"
require 'json'
require 'moving_avg'
require 'pp'

  puts "Destroy RestaurantCuisines ---------------------"
  RestaurantCuisine.destroy_all
  puts "Destroy FavoriteCuisines ---------------------"
  FavoriteCuisine.destroy_all
  puts "Destroy Restaurants ----------------------------"
  Restaurant.destroy_all

  puts "Destroy Trend ----------------------------------"
  Trend.destroy_all
  puts "Destroy Cuisines -------------------------------"
  Cuisine.destroy_all
  puts "Destroy Cities -------------------------------"
  City.destroy_all






  puts "Seed for Sydney --------------------------------"
  # zomato id for Sydney is 260; Lisbon is 82

  puts "Create city instance for Sydney ----------------"
  City.create(name: "Sydney")
  zom_city_id = "260"

  puts "Fetch cuisines from Zomato API ----------------"
  cuisines = ZomatoApi.getcuisines(zom_city_id)
  cuisines["cuisines"].each do |c|
    Cuisine.create!(name: c["cuisine"]["cuisine_name"])
  end

def load_restaurants_json(filename)
  restaurants = JSON.parse(filename)
  restaurants.each do |restaurant_json|

    name = restaurant_json["name"]
    address = restaurant_json["address"]
    attendance = restaurant_json["reviews"].to_i
    latitude = restaurant_json["latitude"]
    longitude = restaurant_json["longitude"]
    price_range = restaurant_json["price_range"].to_i
    rating = restaurant_json["rating"].to_i
    city = restaurant_json["city"]
    cuisine_string = restaurant_json["cuisine_string"]
    photo = restaurant_json["photo"]
    res = Restaurant.new(name: name, address: address, attendance: attendance, latitude: latitude, longitude: longitude, price_range: price_range, rating: rating,photo: photo)
    res.city = City.where(name: city).first
    res.save!

    cuisine_array = cuisine_string.split(", ")
    cuisine_array.each do |cuisine|
      RestaurantCuisine.create!(restaurant: Restaurant.last, cuisine: Cuisine.find_by_name(cuisine))
    end
  end
end


puts "Create restaurants from scraped Json files --------"


json_files = ['restaurants2019-09-04 16:36:57 +0100.json',
              'restaurants2019-09-04 17:05:47 +0100.json',
              'restaurants2019-09-04 17:11:30 +0100.json',
              'restaurants2019-09-04 17:20:11 +0100.json',
              'restaurants2019-09-04 18:31:27 +0100.json',
              'restaurants2019-09-05 09:49:06 +0100.json',
              'restaurants2019-09-05 10:07:43 +0100.json',
              'restaurants2019-09-05 11:19:37 +0100.json'
            ]

json_files.each do |file|
  load_restaurants_json(File.read(file))
end



puts "Create trends from json files ---------------------"

trends_file = 'db/trends_w_average_data.json'

def load_trends_json(trends_file, city)
  # load the trends data file into a ruby hash
  opened_file = File.open trends_file
  data = JSON.parse(File.read(opened_file))
  relevant_data = data[city]
  return relevant_data.flatten
end

def insert_trends_into_database(trends_data_file)
  data = load_trends_json(trends_data_file, 'sydney')
  data.each do |cuisine|
    #iterate over all cuisines
    key = cuisine.keys # array with the name of this cuisine. Could be refactored
    cuisine.dig(key[0], 'timelineData').each do |item|
      #iterate over the time series
      new_trend_record = Trend.new(
        city: City.where(name: 'Sydney').first,
        month: item['formattedTime'],
        value: item['value'][0].to_i,
        cuisine: Cuisine.where(name: key[0]).first,
        moving_average: item['moving_average'].to_i,
        )
      if ["2014","2015","2016","2017","2018","2019"].any? {|word| item['formattedTime'].include?(word)}
        new_trend_record.save!

      end
    end
  end
  puts "Created Trend Data for all cuisines with moving average"
end

insert_trends_into_database(trends_file)

puts "create scaled attendance -----------------------"

def mov_av_sum(city,cuisine)
  Trend.where(city: city).where(cuisine:cuisine).sum(:moving_average)
end

Trend.all.each do |t|
  cuisine_attendance = t.cuisine.restaurants.sum(:attendance)
  if mov_av_sum(t.city,t.cuisine) != 0
    ratio = t.moving_average / mov_av_sum(t.city,t.cuisine).to_f
  else
    ratio = 1/Trend.where(city: t.city).where(cuisine:t.cuisine).count.to_f
  end
  t.scaled_attendance = cuisine_attendance * ratio
  t.save
end

puts "Assign photo to cuisines-----------------------"

Cuisine.all.each do |c|
  if RestaurantCuisine.where(cuisine:c).first
  c.photo = RestaurantCuisine.where(cuisine:c).first.restaurant.photo
  c.save
  end
end




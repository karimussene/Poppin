  # This file should contain all the record creation needed to seed the database with its default values.
  # The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
  #
  # Examples:
  #
  #   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
  #   Character.create(name: 'Luke', movie: movies.first)
  require "zomato_api.rb"

  puts "Destroy models ------"
  RestaurantCuisine.destroy_all
  Cuisine.destroy_all
  Restaurant.destroy_all

  puts "Seed for Sydney ------"
  # zomato id for Sydney is 260; Lisbon is 82

  puts "Create city instance for Sydney -----"
  City.create(name: "Sydney")
  zom_city_id = "260"

  puts "Fetch cuisines from Zomato API -----"
  cuisines = ZomatoApi.getcuisines(zom_city_id)
  cuisines["cuisines"].each do |c|
    Cuisine.create!(name: c["cuisine"]["cuisine_name"])
  end

def load_restaurants_json(filename)
  restaurants = JSON.parse(filename)
  restaurants.each do |restaurant_json|

    name = restaurant_json["name"]
    address = restaurant_json["address"]
    attendance = restaurant_json["reviews"]
    latitude = restaurant_json["latitude"]
    longitude = restaurant_json["longitude"]
    price_range = restaurant_json["price_range"]
    rating = restaurant_json["rating"]
    city = restaurant_json["city"]
    cuisine_string = restaurant_json["cuisine_string"]

    res = Restaurant.new(name: name, address: address, latitude: latitude, longitude: longitude, price_range: price_range, rating: rating)
    res.city = City.where(name: city).first
    res.save!

    cuisine_array = cuisine_string.split(", ")
    cuisine_array.each do |cuisine|
      RestaurantCuisine.create!(restaurant: Restaurant.last, cuisine: Cuisine.find_by_name(cuisine))
    end
  end
end

puts "Create restaurants from scraped Json files --------"

json_files = ['restaurants2019-09-04 16:36:57 +0100.json','restaurants2019-09-04 17:05:47 +0100.json';'restaurants2019-09-04 17:11:30 +0100.json','restaurants2019-09-04 17:20:11 +0100.json']
json_files.each do |file|
  load_restaurants_json(File.read(file))
end

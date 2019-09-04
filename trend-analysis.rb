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
local_file = 'trends-file.json'
@city = 'sydney'

def file_load(file, city)
  #load the json file into a ruby hash
  opened_file = File.open file
  data = JSON.parse(File.read(opened_file))
  relevant_data = data[city]
  return relevant_data.flatten
end

def calculate_moving_average(data_array)
  # access the values per month per cuisine
  # algorithm for calculating the moving average field
  calculator = MovingAvg::Calculator.new(strategy: :sma)
  calculator.moving_avg(data_array)
end

def insert_moving_average(file)
  # insert that moving average into the hash at a certain position
  data = file_load(file, @city)
  data.each do |cuisine|
    @moving_average_data = []
    @moving_average_results = []
    key = cuisine.keys
    i = 0
    cuisine.dig(key[0], 'timelineData').each do |item|
      @moving_average_data << item['value'][0]
      @moving_average_data.shift unless @moving_average_data.size <= 3
      moving_average = calculate_moving_average(@moving_average_data)
      @moving_average_results << {'moving_average' => moving_average}
    end
    cuisine.dig(key[0], 'timelineData').each do |item|
      i += 1
      if i >= @moving_average_results.size
        item.merge!('moving_average' => item['value'][0])
      else
        item.merge!(@moving_average_results[i])
      end
    end
  end
  output = {@city => data}
  return output
end

def write_to_json(data)
  # write the hash with the new key/value pairs into a json file
  File.open("trends_w_average_data.json","w") do |f|
    f.write(data.to_json)
  end
  puts "File created"
end

write_to_json(insert_moving_average(local_file))

require 'net/http'
require 'net/https'
require 'uri'
# require 'nokogiri' #read XML


class ZomatoApi
  def self.getcuisines(city_id)
    url = URI("https://developers.zomato.com/api/v2.1/cuisines?city_id=#{city_id}")
    request = Net::HTTP::Get.new(url) #defining the request
    request["user-key"] = ENV["ZOMATO_KEY"]
    request["Accept"] = "application/json"
    # request.use_ssl = true
    response = Net::HTTP.start(url.hostname, url.port, use_ssl: true) { |http|
      http.request(request)
    } #start a call and set parameters for the url (hostname and port, by default 8080)
  return JSON.parse(response.body)
  end

  def self.getRestaurant(city_id, start_num, count)
    url = URI("https://developers.zomato.com/api/v2.1/search?entity_id=#{city_id}&entity_type=city&start=#{start_num}&count=#{count}")
    request = Net::HTTP::Get.new(url)
    request["user-key"] = ENV["ZOMATO_KEY"]
    request["Accept"] = "application/json"
    response = Net::HTTP.start(url.hostname, url.port, use_ssl: true) { |http|
      http.request(request)
    }
    return JSON.parse(response.body)
  end
end



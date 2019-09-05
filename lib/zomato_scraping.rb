require 'open-uri'
require 'nokogiri'
require 'mechanize'
require 'json'

class ZomatoScraper
  def self.scrape
    places = []

    agent = Mechanize.new # IH: simulate a new browser?
    agent.user_agent_alias = 'Mac Safari' # IH: user_agent_alias is part of the gem?
    start = 201
    limit = 250 # page limit in url = Number of page to scape. This depends on the availability of the website

    for page_number in start..limit
      url = URI("https://www.zomato.com/sydney/restaurantes?page=#{page_number}")

      # Search each link inside a card
      agent.get(url).search(".result-title.hover_feedback").each do |link|
        # #####TODO 1: will click the link and scrape data inside that link
        agent_inside = Mechanize.new
        agent_inside.user_agent_alias = 'Mac Safari'
        inside_page_link = link[:href]
        ## We enter the page for each link and save the data we want
        current_agent = agent_inside.get(inside_page_link)

        place = {
          name: get_place_name(current_agent),
          vote: get_votes_count(current_agent),
          reviews: get_reviews_count(current_agent),
          address: get_address(current_agent),
          city: "Sydney",
          latitude: get_place_lat_lng(current_agent)[0],
          longitude: get_place_lat_lng(current_agent)[1],
          price_range: get_price_range(current_agent),
          rating: get_rating(current_agent),
          cuisine_string: get_cuisines(current_agent),
          photo: get_photo(current_agent),
          locality: get_place_locality(current_agent)
        }
        places << place
      end
    end
    save(places)
    return places
  end

  private

  def self.get_place_name(agent)
    return agent.search(".ui.res-name.mb0.header").text.to_s.strip
  end

  def self.get_votes_count(agent)
    return agent.search("[itemprop='ratingCount']").text.to_s.strip
  end

  def self.get_reviews_count(agent)
    result = agent.search("[data-tab_type='reviews'] span").text.to_s.strip

    if result.match(/\d+/) && (result.match(/\d+/).any?
      result.match(/\d+/)[0]
    else
      "0"
   end
  end

  def self.get_address(agent)
    return agent.search(".res-main-address span").text.to_s.strip
  end

  def self.get_place_lat_lng(agent)
    # get script text
    data = agent.search(".resmap.pos-relative.mt5.mb5 script").text.to_s.strip
    # remove var part of text
    data = data.match(/\{.*\}/)
    if data
      data = data[0]
      # convert string to hash
      data = eval(data)
      [data[:lat], data[:lon]]
    else
      [nil, nil]
    end
  end

  # def self.get_price_range(agent)
  #   array = []
  #   main_cost = agent.search(".res-info-detail")
  #   if main_cost.search('span')[2]
  #     a = main_cost.search('span')[2].text.to_s.strip
  #     array = a.split('.')
  #   end
  #   # if bug from zomato
  #   if array.empty?
  #     a = 0
  #   elsif array[0].gsub(/\D/,'').nil?
  #     a = 0
  #   else
  #     a = array[0].gsub(/\D/,'')
  #   end

  #   return a.to_i/2
  # end

  def self.get_price_range(agent)
    # get the text from the price html element
    cost_element = agent.search('.res-info-detail span[aria-label]').text.to_s.strip
    # get the cost from the text
    cost = cost_element.match(/\d+/)
    # if there is a cost convert it and divide by 2, else 0
    cost && cost[0] != '' ? cost[0].to_f / 2 : 0
  end

  def self.get_rating(agent)
    return agent.search(".rating-div.rrw-aggregate").text.to_s.strip.gsub(/\/5$/,'').to_f
  end

  def self.get_cuisines(agent)
    a = agent.search(".res-info-cuisines.clearfix")
    array = []
    a.search(".zred").each do |type|
      array << type.text.to_s
    end
    return array
  end

  def self.get_photo(agent)
    a = agent.search("#progressive_image")
    return a.attr("data-url").value
  end

  def self.get_place_locality(agent)
    return agent.search(".left.grey-text.fontsize3").text.to_s.strip
  end

  def self.save(data)
    File.open("restaurants#{Time.now}.json", "w+") do |f|
      f << data.to_json
    end
  end
end

p ZomatoScraper.scrape

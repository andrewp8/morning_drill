require "sinatra"
require "sinatra/reloader"
require "http"

#GMAP, WEATHER, OPENAI APIS
gmap_api = ENV.fetch("GMAPS_KEY")
weather_api = ENV.fetch("PIRATE_WEATHER_KEY")
openai_api = ENV.fetch("OPENAI_API_KEY")

before {
    # ========= DATE ============
    @today = Time.now.strftime('%m/%d/%Y')
    @weekday_name = Time.now.strftime('%A')
}

get("/") do

  erb(:homepage)
  
end

post("/display"){
  location = params["user_location"]
  # ======GMAP DATA======
  gmap_url = "https://maps.googleapis.com/maps/api/geocode/json?address=Merchandise%20Mart%20"+location.gsub(" ","%20")+"&key="+gmap_api
  gmap_raw_response =  HTTP.get(gmap_url).to_s
  gmap_parsed_response = JSON.parse(gmap_raw_response)
  gmap_location_result = gmap_parsed_response.dig("results",0, "geometry", "location")
  @lat = gmap_location_result["lat"]
  @lng = gmap_location_result["lng"]

  # ======WEATHER DATA======
  weather_url = "https://api.pirateweather.net/forecast/"+weather_api+"/"+ @lat.to_s + ","+ @lng.to_s
  weather_raw_response = HTTP.get(weather_url).to_s
  weather_parsed_response = JSON.parse(weather_raw_response)
  
  @current_temp =  weather_parsed_response.dig("currently", "temperature")
  @current_summary = weather_parsed_response.dig("currently", "summary")
  
  over_10_percent = false
  @umbrella_mgs = ""
  weather_data = weather_parsed_response.dig("hourly", "data")
  weather_data[1,12].each_with_index{|hourly, idx| precip_prob = hourly["precipProbability"]*100

  if precip_prob > 10
    # what if there is one hour's precip_prob < 10, line 44 won't we executed. 
    over_10_percent = true
  end
  }
  over_10_percent == true ? @umbrella_mgs = "#{location.capitalize} is #{@current_summary.downcase}ing and currently #{@current_temp} degree. You might want to carry an umbrella!" : @umbrella_mgs = "#{location.capitalize} is #{@current_summary.downcase} and currently #{@current_temp} degree. Enjoy your day!"

  # ======== JOKES =========
  joke_URL = "https://geek-jokes.sameerkumar.website/api?format=json"
  joke_response = HTTP.get(joke_URL).to_s
  joke_parsed_response = JSON.parse(joke_response)
  @joke = joke_parsed_response["joke"]

  # ======== MESSAGE =========
  user_input = params["user_input"]
  openai_url = "https://api.openai.com/v1/chat/completions"

    openai_request_headers_hash = {
    "Authorization" => "Bearer #{openai_api}",
    "content-type" => "application/json"
  }

  openai_request_body_hash = {
    "model" => "gpt-3.5-turbo",
    "messages" => [
      {
        "role" => "system",
        "content" => "You are a helpful assistant who talks like a funny and silly robot."
      },
      {
        "role" => "user",
        "content" => "#{user_input.to_s}"
      }
    ]
  }

  # generate hash to json string
  openai_request_body_json = JSON.generate(openai_request_body_hash)

  openai_raw_response = HTTP.headers(openai_request_headers_hash).post(
    openai_url,
    :body => openai_request_body_json
  ).to_s

  openai_parsed_response = JSON.parse(openai_raw_response)

  openai_response = openai_parsed_response.dig("choices",0,"message","content")
  if openai_response != nil || openai_response != ""
    @message = openai_response
  else
    @message = "Oopsie-daisy! Silly me ran out of thinking juice! Time to refill my brain tank. Let's take a quick break to purchase more brainy tokens. My circuits need a snack!"
  end
  erb(:display)
}

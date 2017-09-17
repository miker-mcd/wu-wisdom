require 'json'
require 'open-uri'
require 'nokogiri'
require 'net/http'
require 'rest-client'

# $url = URI("http://api.musixmatch.com/ws/1.1/artist.albums.get?artist_id=54662&apikey=#{ENV["MUSIXMATCH_API_KEY"]}")
# http = Net::HTTP.new($url.host, $url.port)
# request = Net::HTTP::Get.new($url)
# $response = http.request(request)

# ghostface artist_id = "54662"
artist_response = RestClient.get("http://api.musixmatch.com/ws/1.1/artist.albums.get", params: {artist_id: "54662", apikey: "#{ENV["MUSIXMATCH_API_KEY"]}"})

sleep 1

parsed_artist_response = JSON.parse(artist_response.body)

artist_album_ids = parsed_artist_response["message"]["body"]["album_list"].map {|entry| entry["album"]["album_id"]}

album_track_requests = []
artist_album_ids.each do |album_id|
  album_track_requests << RestClient.get("http://api.musixmatch.com/ws/1.1/album.tracks.get", params: {album_id: "#{album_id}", apikey: "#{ENV["MUSIXMATCH_API_KEY"]}"})
  sleep 1
end

parsed_tracks_requests = []
album_track_requests.each do |tracks_request|
  parsed_tracks_requests << JSON.parse(tracks_request.body)
end

album_track_ids = []
parsed_tracks_requests.each do |track_request|
  album_track_ids << track_request["message"]["body"]["track_list"].map {|entry| entry["track"]["track_id"]}
end

lyrics_requests = []
album_track_ids.flatten.each do |track_id|
  lyrics_requests << RestClient.get("http://api.musixmatch.com/ws/1.1/track.lyrics.get", params: {track_id: "#{track_id}", apikey: "#{ENV["MUSIXMATCH_API_KEY"]}"})
  sleep 1
end

parsed_lyrics_requests = []
lyrics_requests.each do |lyrics_request|
  parsed_lyrics_requests << JSON.parse(lyrics_request.body)
end

parsed_lyrics_requests.delete_if{ |lyrics_request| lyrics_request["message"]["body"] == [] }

tracks_lyrics = parsed_lyrics_requests.map do |lyrics_request|
  lyrics_request["message"]["body"]["lyrics"]["lyrics_body"].split("\n")
end

line_count = tracks_lyrics.flatten.length

rand_line = tracks_lyrics.flatten[rand(line_count)]

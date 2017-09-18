require 'json'
require 'rest-client'

SLEEP_TIME = 0.5

get '/wumembers' do
  @wumembers = Wumember.all
  erb :"/wumembers/index"
end

get '/wumembers/:id' do
  @wumember = Wumember.find(params[:id])
  artist_response = RestClient.get("http://api.musixmatch.com/ws/1.1/artist.albums.get", params: {artist_id: "#{@wumember.artist_id}", apikey: "#{ENV["MUSIXMATCH_API_KEY"]}"})
  sleep SLEEP_TIME

  parsed_artist_response = JSON.parse(artist_response.body)
  artist_album_ids = parsed_artist_response["message"]["body"]["album_list"].map {|entry| entry["album"]["album_id"]}

  album_track_requests = []
  artist_album_ids.each do |album_id|
    album_track_requests << RestClient.get("http://api.musixmatch.com/ws/1.1/album.tracks.get", params: {album_id: "#{album_id}", apikey: "#{ENV["MUSIXMATCH_API_KEY"]}"})
    sleep SLEEP_TIME
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
    sleep SLEEP_TIME
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

  @rand_line = tracks_lyrics.flatten[rand(line_count)]

  erb :"/wumembers/show"
end

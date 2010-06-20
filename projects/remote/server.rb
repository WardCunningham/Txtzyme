require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
require 'json'

#use Rack::Auth::Basic do |username, password|
#  username == 'guest' && password == 'please'
#end

configure do
  $tz = File.open '/dev/cu.usbmodem12341', 'r+'
end

before do
  content_type "application/json"
end

helpers do

  def putz string
    $tz.puts string
    puts "\033[32m#{string}\033[0m"
  end

  def getz
    $tz.gets.chomp
  end

  def sync
    uniq = rand(1000000).to_s;
    putz "_#{uniq}_"
    result = getz until result == uniq
  end

  def dict prog
    sync
    putz prog + '_end_'
    data = {}
    while true do
      key = getz
      break if key == 'end'
      data[key] = getz.to_i
    end
    data.to_json
  end

  def vect prog, sequence
    sync
    putz prog
    sequence.collect{|i| [i, getz.to_i] }.to_json
  end

end

get %r{/([b-f])/([0-7])} do |port, pin|
  dict "_bit_#{pin}#{port}ip"
end

put %r{/([b-f])/([0-7])} do |port, pin|
  dict "_bit_#{pin}#{port}#{params[:state]}op"
end

get %r{/ch/([0-9])} do |ch|
  vect "101{#{ch}sp50u}", (0..100).map{|i|i*50}
end

put '/slide' do
  dict "6d0o35{0c1o#{params[:state]}u0o20m}6d1o"
end

get '/' do
  content_type "text/html"
	haml :index
end

get '/stylesheet.css' do
  content_type 'text/css'
  sass :stylesheet
end

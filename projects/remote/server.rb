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

  def dict prog
    $tz.puts prog + '_end_'
    data = {}
    while true do
      key = $tz.gets.chomp
      break if key == 'end'
      data[key] = $tz.gets.to_i
    end
    data.to_json
  end

  def vect prog, sequence
    $tz.puts prog
    sequence.collect{|i| [i, $tz.gets.to_i] }.to_json
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

get '/' do
  content_type "text/html"
	haml :index
end

get '/stylesheet.css' do
  content_type 'text/css'
  sass :stylesheet
end

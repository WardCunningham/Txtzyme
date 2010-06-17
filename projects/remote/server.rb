require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'

use Rack::Auth::Basic do |username, password|
  username == 'guest' && password == 'please'
end

configure do
  $tz = File.open '/dev/cu.usbmodem12341', 'r+'
end

helpers do
  def tz(prog)
    $tz.puts prog
    $tz.gets
  end
end

before do
  @req = request.inspect
end

get %r{/([b-f])/([0-7])} do |port, pin|
  tz "6d1o100m0o#{pin}#{port}ip"
end

get '/' do
	haml :index
end

get '/stylesheet.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :stylesheet
end


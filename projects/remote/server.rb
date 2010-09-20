require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
require 'json'

enable :lock

use Rack::Auth::Basic do |username, password|
 username == 'guest' && password == 'please'
end

configure do
  $tz = File.open '/dev/cu.usbmodem12341', 'r+'
end

before do
  content_type "text/plain"
  putz "6d0o"
end

after do
  putz "6d1o"
end

helpers do

  def putz string
    $tz.puts string
    puts "\033[32m#{string}\033[0m"
  end

  def getz string = nil
    putz string if string
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

  def avg prog
    sync
    putz prog + "_done_"
    result = []
    while true do
      value = getz
      break if value == 'done'
      result << value.to_f
    end
    result.inject() {|s, e| s + e} / result.length
  end

  def text prog
    sync
    putz prog + "_endoftext_"
    result = ''
    while true do
      value = getz
      break if value == 'endoftext'
      result << value << "\n"
    end
    result
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

get %r{/fft/([0-9])} do |ch|
  putz "#{N}{#{ch}sp50u7b1o0o}"
  f = (0..(N-1)).collect{|i| getz.to_f}
  mean = (f.inject(0){|s,e|s+e})/N
  f = f.collect{|y| y-mean }
  FFT f
  (0..(N/2-1)).collect{|i| [20000.0*i/N, f[i].abs]}.to_json
end

put '/slide' do
  dict "35{5d1o#{params[:state]}u0o20m}"
end

get '/ss' do
  {
    :mpx4250 => avg("100{6sp150u}"),
    :a2010  => avg("100{0sp150u}"),
    :a2011  => avg("100{1sp150u}"),
    :a2012  => avg("100{2sp150u}"),
    :a2013  => avg("100{3sp150u}"),
    :a2014  => avg("100{4sp150u}"),
  }.to_json
end

get '/ss/onewire' do
  `cd ../onewire; perl ./scan.pl`
end

get '/mcu' do
  { :version => getz("v"), :help => text("h") }.to_json
end

get '/' do
  content_type "text/html"
	haml :index
end

get '/stylesheet.css' do
  content_type 'text/css'
  sass :stylesheet
end

get '/upload' do
  content_type "text/html"
  haml :upload
end

post '/upload' do
  content_type "text/html"
  unless params[:file] &&
         (tmpfile = params[:file][:tempfile]) &&
         (name = params[:file][:filename])
    @error = "No file selected"
    haml :upload
  end
  STDERR.puts "Uploading file, original name #{name.inspect}"
  # while blk = tmpfile.read(65536)
  #   File.open(path, "wb") { |f| f.write(tmpfile.read) }
  #   # here you would write it to its final location
  #   STDERR.puts blk.inspect
  # end
  path = File.join("public/files", name)
  File.open(path, "wb") { |f| f.write(tmpfile.read) }
  "Upload complete"
end



# http://juno.myjp.net/code/top.php

require 'mathn'

N = 1<<8
Hadamard = Matrix[[1,1],[1,-1]]/Math.sqrt(2)

def Phase(theta)
  Matrix[[1,0],[0,Complex.polar(1,theta)]]
end

def R(k)
  lambda {|x,y| (Hadamard*Phase(2*Math::PI*k/N)*Vector[x,y]).to_a}
end

def FFT(arr,s=0,n=arr.size)
  abort 'error! not powers of 2' if n&(n-1)!=0
  if n==2 then
    arr[s],arr[s+1] = R(0).call(arr[s],arr[s+1])
  else
    i=-1
    arr[s,n] = arr.slice(s,n).partition {|_| i+=1; i%2==0}.flatten
    FFT(arr,s,n/2)
    FFT(arr,s+n/2,n/2)
    for i in 0...n/2 do
      arr[s+i],arr[s+i+n/2] = R(i*N/n).call(arr[s+i],arr[s+i+n/2])
    end
  end
  return
end

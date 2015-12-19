# A simple URL shortner with Sinatra and redis. 

require 'rubygems'
require 'sinatra'
require 'redis'
require 'uri'

#Connection parameters to redis server
#@redis  = Redis.new(:host => 'localhost' , :port => 6379, :password => nil) # no password setup for redis
#redis = Redis.new
before do
    # uri = URI.parse(ENV["localhost:6379"])
    @redis = Redis.new(:host => 'localhost', :port => '6379', :password => nil ) if !@redis
end

#A helper function
#First actually
helpers do
	def linktoken
		(Time.now.to_i + rand(36**8)).to_s(36) # Time now as integer + Random integer using rand converted to string
	end
end

# Get the index page to be loaded
get '/' do
	erb :index # index page to be displayed
end 

# Get the url posted 
post '/' do
	#insert it to redis if it is  a valid ur
	unless (params[:url] =~ URI::regexp).nil?
		@token = linktoken
		@redis.set("links:#{@token}", params[:url])
		erb :shortened
	else
		@error = "Please enter a valid URL"
		erb :index
	end
end

#redirect the token to the given url
get '/:token' do
	url = @redis.get("links:#{params[:token]}")
	unless url.nil?
		redirect(url)
	end
	erb :expired
end







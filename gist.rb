#!/usr/bin/env ruby
require 'httparty'
require 'json'

class Gist
  include HTTParty
  base_uri 'https://api.github.com'

	def initialize token
		@token = token
	end

  def create files
    
    filehash = {}	
    files.each do |f|
      file = File.open(f, "rb")
      contents = file.read
      filehash[f] = {:content => contents}
    end

    data = { 
	:description => files.join(", "),
	:files => filehash
    }
    self.class.post("/gists", :query => {:access_token => @token }, :body => data.to_json)
  end

end

config_file = ".gist.conf"

if File.exist? config_file
	file = File.open(config_file, "rb")
  token = file.read
	if token.size <= 0
		puts "Invalid token in #{config_file}"
	end
else
	puts "Please enter your github token:"
	token = gets.chomp
	puts "Saving token to #{config_file}"
	file = File.open(config_file, "w")
	file.write token
end 


if ARGV.size > 0
  files = ARGV
	gist = Gist.new token
  response = gist.create files
  puts response["html_url"]
else
 p "Requires atleast one file as argument"
end

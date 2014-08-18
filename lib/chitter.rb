require 'time'

class Chitter

	attr_reader :data

	def initialize(writer,reader)
		@writer = writer
		@reader = reader
		@data = {}
		@exit = false
	end

	def time_difference(post_time)
		diff = Time.now - post_time
		if diff > 60
			return ' (' + (diff/60).round.to_s + ' minute(s) ago)'
		end
		return ' (' + (diff).round.to_s + ' second(s) ago)'
	end


	def post(user, message)
		@data[user] = {follows: [], posts: {},} unless @data.include? user
		@data[user][:posts][Time.now] = message
	end


end
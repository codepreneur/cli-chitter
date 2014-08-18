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

	def read(user)
		@data[user][:posts].each {|time,post| @writer.call post.join(' ') + time_difference(time)}
	end


	def follow(user, somebody)
		@data[user][:follows].push(somebody) unless @data[user][:follows].include? somebody
	end


	def wall(user)
		posters = (@data[user][:follows] + [user])
		sorted = posters.map{|poster| @data[poster][:posts].map{|time,post| poster + " - " + post.join(' ') + " " + time.to_s }}.flatten.sort_by!{|post| post.split[-3..-1].join(' ') }.reverse
		sorted.each{|post| @writer.call post.split[0..-4].join(' ') + time_difference( Time.parse(post.split[-3..-1].join(' ')) )}
	end


end
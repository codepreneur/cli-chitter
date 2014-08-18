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


	def instructions
		menu  = "Welcome to Chitter!\n"
		menu += "console-based social networking application\n"
		menu += "posting: <user name> -> <message>\n"
		menu += "reading: <user name>\n"
		menu += "following: <user name> follows <another user>\n"
		menu += "wall: <user name> wall\n"
		menu += "Type 'exit' to exit\n"
	end


	def parse_input
		input = @reader.call.chomp.split
		
		if input.length == 1 && input[0] != 'exit'
			read(input[0])
		elsif input.include? '->' 
			post(input[0],input[2..-1])
		elsif input.include? 'follows' 
			follow(input[0],input[2])
		elsif input.include? 'wall'
			wall(input[0])
		elsif input[0] == 'exit'
			exit
		else
			@writer.call "Sorry unrecognised command"
		end
			
	end


	def control_flow
		@writer.call ""
		@writer.call instructions
		while not @exit == true
			print "> "
			parse_input
		end
	end



	if __FILE__ == $0
		Chitter.new(method(:puts), method(:gets)).control_flow
	end


end
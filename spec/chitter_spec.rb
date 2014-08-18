require 'chitter'

describe Chitter do

	before(:each) do
		@writer = double('writer')
		@reader = double('reader')
    @chitter = Chitter.new(@writer, @reader)
    @time_now = Time.parse("Feb 24 2014") 
    # 2014-02-24 00:00:00 +0000 
  end

  context "can calculate time difference in" do
  	it "seconds" do
  		expect(@chitter.time_difference(Time.now - 30)).to eq " (30 second(s) ago)" 
  	end

  	it "minutes" do
			expect(@chitter.time_difference(Time.now - 120)).to eq " (2 minute(s) ago)"
  	end
  end

  

end
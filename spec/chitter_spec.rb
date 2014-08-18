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


  context "posting" do

  	it "can post" do
  		@chitter.post("Vaidas", %w{Testing Things})
  		expect(@chitter.data["Vaidas"][:posts].values.flatten).to eq ["Testing", "Things"]
  	end

  end


  context "reading" do

  	it "can read" do
  		@chitter.post("Vaidas", %w{Testing Things})
  		expect(@writer).to receive(:call).with("Testing Things (0 second(s) ago)")
  		@chitter.read("Vaidas")
  	end

  end


  context "following" do

  	it "can follow" do
	  	@chitter.post("Vaidas", %w{Testing Things})
	  	@chitter.post("Gabriel", %w{Helping Things})
	  	@chitter.follow("Vaidas","Gabriel")
	  	expect(@chitter.data["Vaidas"][:follows]).to eq ["Gabriel"]
	  end

  end


  context "wall" do
  	it "displays posts chronologically (most recent first)" do
  		@chitter.post("Vaidas", %w{Testing Things})
	  	expect(@writer).to receive(:call).with("Vaidas - Testing Things (0 second(s) ago)")
	  	@chitter.wall("Vaidas")
	  	# A bit of race condition here
  	end
  end 



end
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

  

  context "user interface" do
  	
  	it "posting: <user name> -> <message>" do
  		allow(@reader).to receive(:call).and_return('Vaidas -> Testing Things')
  		expect(@chitter).to receive(:post).with("Vaidas", ["Testing", "Things"])
  		@chitter.parse_input

  	end

  	it "reading: <user name>" do
  		allow(@reader).to receive(:call).and_return('Vaidas')
  		expect(@chitter).to receive(:read).with("Vaidas")
  		@chitter.parse_input
  	end

  	it "following: <user name> follows <another user>" do
  		allow(@reader).to receive(:call).and_return('Vaidas follows Gabriel')
  		expect(@chitter).to receive(:follow).with("Vaidas", "Gabriel")
  		@chitter.parse_input
  	end

  	it "wall: <user name> wall" do
  		allow(@reader).to receive(:call).and_return('Vaidas wall')
  		expect(@chitter).to receive(:wall).with("Vaidas")
  		@chitter.parse_input
  	end

  	it "Type 'exit' to exit" do
  		allow(@reader).to receive(:call).and_return('exit')
  		expect{@chitter.parse_input}.to raise_error SystemExit
  	end


  end



end
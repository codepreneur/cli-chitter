require 'chitter'

describe Chitter do

	before(:each) do
		@writer = double('writer')
		@reader = double('reader')
    @chitter = Chitter.new(@writer, @reader)
    @time_now = Time.parse("Feb 24 2014") 
    # 2014-02-24 00:00:00 +0000 
  end


end
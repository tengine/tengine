require 'spec_helper'

require 'timeout'
require 'eventmachine'

describe "Eventmachine" do

  describe "#defer" do

    it "2 cascaded defers" do
      buffer = []
      blocks = []
        EM.run_test do
          blocks[4] = lambda{|a| buffer << [4, a]; EM.stop }
          blocks[3] = lambda{ buffer << 3; 3 }
          blocks[2] = lambda{|a| buffer << [2, a]; EM.defer(blocks[3], blocks[4])}
          blocks[1] = lambda{ buffer << 1; 1 }
          blocks[0] = lambda{ buffer << 0; EM.defer(blocks[1], blocks[2])}
          blocks[0].call
        end
      buffer.should == [0, 1, [2, 1], 3, [4, 3]]
    end

    it "4 cascaded defers" do
      buffer = []
      blocks = []
        EM.run_test do
          blocks[8] = lambda{|a| buffer << [8, a]; EM.stop }
          blocks[7] = lambda{ buffer << 7; 7 }
          blocks[6] = lambda{|a| buffer << [6, a]; EM.defer(blocks[7], blocks[8])}
          blocks[5] = lambda{ buffer << 5; 5 }
          blocks[4] = lambda{|a| buffer << [4, a]; EM.defer(blocks[5], blocks[6])}
          blocks[3] = lambda{ buffer << 3; 3 }
          blocks[2] = lambda{|a| buffer << [2, a]; EM.defer(blocks[3], blocks[4])}
          blocks[1] = lambda{ buffer << 1; 1 }
          blocks[0] = lambda{ buffer << 0; EM.defer(blocks[1], blocks[2])}
          blocks[0].call
        end
      buffer.should == [0, 1, [2, 1], 3, [4, 3], 5, [6, 5], 7, [8, 7]]
    end

    it "15 cascaded defers" do
      buffer = []
      blocks = []
      EM.threadpool_size.should == 20
        EM.run_test do
          count = 30
          blocks[count    ] = lambda{|a| buffer << [count, a]; EM.stop }
          blocks[count - 1] = lambda{ buffer << (count - 1); count - 1 }
          (count/ 2 - 1).times do |idx|
            m = idx * 2 + 1
            n = idx * 2 + 2
            blocks[n] = lambda{|a| buffer << [n, a]; EM.defer(blocks[n + 1], blocks[n + 2])}
            blocks[m] = lambda{ buffer << m; m }
          end
          blocks[0] = lambda{ buffer << 0; EM.defer(blocks[1], blocks[2])}
          blocks[0].call
        end
      buffer.should == [
        0, 1, [2, 1], 3, [4, 3], 5, [6, 5], 7, [8, 7], 9, [10, 9],
        11, [12, 11], 13, [14, 13], 15, [16, 15], 17, [18, 17], 19, [20, 19],
        21, [22, 21], 23, [24, 23], 25, [26, 25], 27, [28, 27], 29, [30, 29]
      ]
    end

  end

end

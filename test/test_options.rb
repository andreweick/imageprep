require 'rubygems'
require 'bundler/setup'

require 'test/unit'
require 'shoulda'

require_relative '../lib/imageprep/options.rb'

class TestOptions < Test::Unit::TestCase
  context "specifying one file name" do 
    should "return error" do
      opts = ImagePrep::Options.new(["file1"])
      assert_equal
    end
  end
end
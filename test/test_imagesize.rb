#!/usr/bin/ruby

require 'rubygems'
require 'bundler/setup'

require 'test/unit'

require_relative '../lib/imageprep/imagesize'

class TestOptions < Test::Unit::TestCase
  def test_names
  	test = ImagePrep::ImageSize.new("./test/output/", ["/data/original/2013/2013-01-01/landscape-big-enough-2895x1930.jpg"])
  end
end

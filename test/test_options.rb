#!/usr/bin/ruby

require 'rubygems'
require 'bundler/setup'

require 'test/unit'
require_relative '../lib/imageprep/options'

class TestOptions < Test::Unit::TestCase
  opts = ImagePrep::Options.new(["-o", "/tmp", "image1", "image2"])
  assert_equal ["image1", "image2"], opts.images_to_load
end
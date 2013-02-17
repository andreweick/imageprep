#!/usr/bin/ruby

require 'rubygems'
require 'bundler/setup'

require 'test/unit'
require 'tmpdir'

require_relative '../lib/imageprep/imagesize'

class TestOptions < Test::Unit::TestCase
	# Image constant names
	TestImages = { 	:landscape => "./test/data/landscape-big-enough-2895x1930.jpg",
									:portrait	=> "./test/data/portrait-big-enough-3840x5760.jpg",
									:notbigenough	=> "./test/data/not-big-enough-1333x2000.jpg"
								}

	def test_imagesExists
		TestImages.each do |nature, filename|
			assert_equal File::exists?(filename), true
		end
  end

  def test_resize
  	Dir.mktmpdir {|dir|
	  	is = ImagePrep::ImageSize.new("#{dir}")
	  	emitedImages = is.emitSizedImages([TestImages[:landscape]])
	  	puts emitedImages.values.inspect
	  	assert_equal true,false
  	}
  end
end

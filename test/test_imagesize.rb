#!/usr/bin/ruby

require 'rubygems'
require 'bundler/setup'

require 'test/unit'
require 'tmpdir'
require 'json'

require 'mini_magick'

require_relative '../lib/imageprep/imagesize'

class TestOptions < Test::Unit::TestCase
	# Image constant names
	TestImages = { 	
		landscape: 			"./test/data/landscape-big-enough-2895x1930.jpg",
		portrait: 			"./test/data/portrait-big-enough-3840x5760.jpg",
		notbigenough: 	"./test/data/not-big-enough-1333x2000.jpg"
	}

  # To see what is in all the EXIF data for an image: 
  # identify -format "%[exif:*]" not-big-enough-1333x2000.jpg
	def test_imagesExists
		TestImages.each do |nature, filename|
			assert_equal File::exists?(filename), true
		end
  end

  def test_resize_landscape
  	Dir.mktmpdir {|dir|
	  	is = ImagePrep::ImageSize.new(TestImages[:landscape],"#{dir}")
	  	is.emitedImages.each { |width, filename| 
	  		image = MiniMagick::Image.open(filename)
				assert_equal width, image[:width]
	  	}
	  	puts "is.to_o: #{is.to_octopress}"
  	} #delete temporary directory
  end

  def test_resize_portrait
  	Dir.mktmpdir {|dir|
	  	is = ImagePrep::ImageSize.new(TestImages[:portrait],"#{dir}")
	  	is.emitedImages.each { |width, filename| 
	  		image = MiniMagick::Image.open(filename)
				assert_equal width, image[:width]
	  	}
  	} #delete temporary directory
  end

  def test_resize_not_big_enough
  	Dir.mktmpdir {|dir|
	  	is = ImagePrep::ImageSize.new(TestImages[:notbigenough],"#{dir}")
	  	is.emitedImages.each { |width, filename| 
	  		image = MiniMagick::Image.open(filename)
				assert_equal width, image[:width]
	  	}
  	} #delete temporary directory
  end


end

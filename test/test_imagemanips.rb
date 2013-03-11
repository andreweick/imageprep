#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'test/unit'
require 'tmpdir'
require 'json'

require 'mini_magick'

require_relative '../lib/imageprep/imagemanips'

class TestOptions < Test::Unit::TestCase
	# Image constant names
	TestImages = { 	
		landscape: 			"./test/data/landscape-big-enough-2895x1930.jpg",
		portrait: 			"./test/data/portrait-big-enough-3840x5760.jpg",
		notbigenough: 	"./test/data/not-big-enough-1333x2000.jpg",
	  needstrip:      "./test/data/2013-01-19 at 10-54-54.jpg" 
	}

  # To see what is in all the EXIF data for an image: 
  # identify -format "%[exif:*]" not-big-enough-1333x2000.jpg
	def test_imagesExists
		TestImages.each do |nature, filename|
			assert_equal(File::exists?(filename), true)
		end
  end

  def test_copy_source
  	Dir.mktmpdir {|tmploc|
  		im = ImagePrep::ImageManips.new(TestImages[:landscape], tmploc)
			cfn = File.join(tmploc,"/original/2013/2013-01-15/landscape-big-enough-2895x1930.jpg")  		
  		assert_equal(im.copyOriginal, cfn)
  		assert_equal(File::exists?(cfn), true)

  		im = ImagePrep::ImageManips.new(TestImages[:portrait], tmploc)
  		cfn = File.join(tmploc,"original/2013/2013-01-11/portrait-big-enough-3840x5760.jpg")
  		assert_equal(im.copyOriginal, cfn)
  		assert_equal(File::exists?(cfn), true)

  		im = ImagePrep::ImageManips.new(TestImages[:notbigenough], tmploc)
  		cfn = File.join(tmploc,"original/2006/2006-12-29/not-big-enough-1333x2000.jpg")
  		assert_equal(im.copyOriginal, cfn)
  		assert_equal(File::exists?(cfn), true)

  		im = ImagePrep::ImageManips.new(TestImages[:needstrip], tmploc)
  		cfn = File.join(tmploc,"original/2013/2013-01-19/2013-01-19_at_10-54-54.jpg")
  		assert_equal(im.copyOriginal, cfn)
  		assert_equal(File::exists?(cfn), true)
  	}
  end

  # def test_resize_landscape
  # 	Dir.mktmpdir {|dir|
	 #  	im = ImagePrep::ImageManips.new(TestImages[:landscape],"#{dir}")
	 #  	im.copyOriginal
	 #  	puts "path: #{File.join(dir, im.originalDir, "landscape-big-enough-2895x1930.jpg")}"
	 #  	assert_equal(File::exists?(File.join(dir, im.originalDir, "landscape-big-enough-2895x1930.jpg")), true)
	 #  	im.generateYamlMeta
	 #  	assert_equal(File::exists?(File.join(dir, im.originalDir, "landscape-big-enough-2895x1930.yaml")), true)
	 #  	im.generateSized.each { |width, filename| 
	 #  		image = MiniMagick::Image.open(filename)
		# 		assert_equal(width, image[:width])
	 #  	}
  # 	} #delete temporary directory
  # end

  # def test_resize_portrait
  # 	Dir.mktmpdir {|dir|
	 #  	is = ImagePrep::ImageSize.new(TestImages[:portrait],"#{dir}")
	 #  	is.emitSizedImages
	 #  	is.emitedImages.each { |width, filename| 
	 #  		image = MiniMagick::Image.open(filename)
		# 		assert_equal(width, image[:width])
	 #  	}
  # 	} #delete temporary directory
  # end

  # def test_resize_not_big_enough
  # 	Dir.mktmpdir {|dir|
	 #  	is = ImagePrep::ImageSize.new(TestImages[:notbigenough],"#{dir}")
	 #  	is.emitSizedImages
	 #  	is.emitedImages.each { |width, filename| 
	 #  		image = MiniMagick::Image.open(filename)
		# 		assert_equal(width, image[:width])
	 #  	}
  # 	} #delete temporary directory
  # end

  # def test_resize_needstrip
  # 	Dir.mktmpdir {|dir|
	 #  	is = ImagePrep::ImageSize.new(TestImages[:needstrip],"#{dir}")
	 #  	is.emitSizedImages
	 #  	is.emitedImages.each { |width, filename| 
	 #  		image = MiniMagick::Image.open(filename)
		# 		assert_equal(width, image[:width])
	 #  	}
  # 	} #delete temporary directory
  # end

end
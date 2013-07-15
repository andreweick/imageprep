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
    landscape:      "./test/data/landscape-big-enough-2895x1930.jpg",
    portrait:       "./test/data/portrait-big-enough-3840x5760.jpg",
    notbigenough:   "./test/data/not-big-enough-1333x2000.jpg",
    needstrip:      "./test/data/2013-01-19 at 10-54-54.jpg",
    scan:           "./test/data/2013 02 11 20 24 33 jasmine 1.jpg" 
  }

  TestResultImages= {
    landscape:      "/2013/2013-01-15/landscape-big-enough-2895x1930",
    portrait:       "/2013/2013-01-11/portrait-big-enough-3840x5760",
    notbigenough:   "/2006/2006-12-29/not-big-enough-1333x2000",
    needstrip:      "/2013/2013-01-19/2013-01-19-at-10-54-54",
    scan:           "/2013/2013-04-23/2013-02-11-20-24-33-jasmine-1" 
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
      TestImages.each { |image_type, image_name|
        im = ImagePrep::ImageManips.new(image_name, tmploc)
        cfn = File.join(tmploc,"original", TestResultImages[image_type] + ".jpg")  
        assert_equal(im.copyOriginal, cfn)
        assert_equal(File::exists?(cfn), true)
      }
    }
  end

  def test_resize
    Dir.mktmpdir {|dir|
      TestImages.each { |image_type, image_name|
        im = ImagePrep::ImageManips.new(image_name,"#{dir}")
        im.generateSized
        im.emitedImages.each { |width, filename| 
          image = MiniMagick::Image.open(filename)
          assert_equal(width, image[:width])
        }
      }
    } #delete temporary directory
  end

end
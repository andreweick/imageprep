#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'test/unit'
require 'tmpdir'
require 'json'

require 'mini_magick'

require_relative '../lib/imageprep/resize'
require_relative '../lib/imageprep/metadata'

class TestOptions < Test::Unit::TestCase
  # Image constant names
  ResizeTestImages = {  
    landscape:      "./test/data/landscape-big-enough-2895x1930.jpg",
    portrait:       "./test/data/portrait-big-enough-3840x5760.jpg",
    notbigenough:   "./test/data/not-big-enough-1333x2000.jpg",
    needstrip:      "./test/data/2013-01-19 at 10-54-54.jpg",
    scan:           "./test/data/2013 02 11 20 24 33 jasmine 1.jpg"
  }

  # To see what is in all the EXIF data for an image: 
  # identify -format "%[exif:*]" not-big-enough-1333x2000.jpg

  def test_source_images_exists
    ResizeTestImages.each do |image_type, filename|
      assert(File::exists?(filename), "Image #{filename} does not exist")
    end
  end

  def test_original_image_copy
    Dir.mktmpdir {|dir|
      ResizeTestImages.each { |image_type, image_name|
        rz = ImagePrep::Resize.new(image_name, "#{dir}")
        dest = rz.original_image
        assert(FileUtils.compare_file(image_name, dest), "Image(s) were not copied to orginial directory")
      }
    } #delete temporary directory
  end

  def test_resize
    Dir.mktmpdir {|dir|
      ResizeTestImages.each { |image_type, image_name|
        rz = ImagePrep::Resize.new(image_name, "#{dir}")
        rz.generated_images

        ImagePrep::Resize::WIDTHS.each { |width| 
          md = ImagePrep::MetaData.new(image_name)
          filename = File.join(dir,"generated", "#{md.date_time_original.year}","#{md.date_time_original.strftime('%Y-%m-%d')}", "#{width}", md.strip_space)
          assert(File::exists?(filename), "Image #{filename} does not exist")
          assert_equal(width, MiniMagick::Image.open(filename)[:width])
        }
      }
    } #delete temporary directory
  end

  def test_do_work
    image_processed = Array.new
    Dir.mktmpdir { |dir|
      ResizeTestImages.each { |image_type, image_name|
        image_processed.push(ImagePrep::Resize.new(image_name, "#{dir}").do_work)
      }
 
      image_processed.each { |filename|  
        assert(File::exists?(filename), "File #{filename} does not exists and should have been created by do_work")
      }
    }
  end

end
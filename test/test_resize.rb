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
  # To see what is in all the EXIF data for an image: 
  # identify -format "%[exif:*]" not-big-enough-1333x2000.jpg

  def setup
    @test_images ||= JSON.parse(File.read('./test/data/test_images.json'))
  end

  def test_images_exists
    @test_images["images"].each { |ti|
      assert(File::exists?(ti['file']))
    }
  end

  def test_original_image_copy
    Dir.mktmpdir {|dir|
      @test_images["images"].each { |ti|
        rz = ImagePrep::Resize.new(ti['file'], "#{dir}")
        dest = rz.original_image
        assert(File::exists?(dest), "Image #{ti['file']} was not copied to orginial directory")
        assert(File::exists?("#{File.dirname(dest)}/#{File.basename(dest, ".*")}.json"), "JSON file for Image #{ti['file']} was not created to orginial directory #{dest}")
      }
    } #delete temporary directory
  end

  def test_resize
    Dir.mktmpdir {|dir|
      @test_images["images"].each { |ti|
        rz = ImagePrep::Resize.new(ti['file'], "#{dir}")
        names = rz.generated_images

        names.each { |name| 
          assert(File::exists?(name), "Image #{name} does not exist")
          File.basename(name,'.*') =~ /-([0-9]*)x[0-9]*$/
          assert_equal($1, MiniMagick::Image.open(name)[:width].to_s, "#{name} is not width #{$1} it is #{ MiniMagick::Image.open(name)[:width]}")
        }
      }
    } #delete temporary directory
  end

  # def test_do_work
  #   image_processed = Array.new
  #   Dir.mktmpdir { |dir|
  #     @test_images.each { |image_type, image_name|
  #       image_processed.push(ImagePrep::Resize.new(image_name, "#{dir}").do_work)
  #     }
 
  #     image_processed.each { |filename|  
  #       assert(File::exists?(filename), "File #{filename} does not exists and should have been created by do_work")
  #     }
  #   }
  # end

end
#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'test/unit'
require 'tmpdir'
require 'json'

require 'mini_magick'

require_relative '../lib/imageprep/stage'
require_relative '../lib/imageprep/metadata'

class TestOptions < Test::Unit::TestCase
  # To see what is in all the EXIF data for an image: 
  # identify -format "%[exif:*]" not-big-enough-1333x2000.jpg

  def setup
    @test_images ||= JSON.parse(File.read('./test/data/test_images.json'))

    @test_images["images"].each { |ti|
      assert(File::exists?(ti['file']))
    }
  end

  def test_stage_orignal
    Dir.mktmpdir {|dir|
      @test_images["images"].each { |ti|
        stage = ImagePrep::Stage.new(ti['file'], "#{dir}")
        dest = stage.stage_original
        
        # Test that file got copied
        assert(File::exists?(dest), "Image #{ti['file']} was not copied to orginial directory")
        
        stage.write_json
        # Test JSON file got created
        assert(File::exists?("#{File.dirname(dest)}/#{File.basename(dest, ".*")}.json"), "JSON file for Image #{ti['file']} was not created to orginial directory #{dest}")
      }
    } #delete temporary directory
  end

  def test_update_exif_date
    Dir.mktmpdir {|dir|
      @test_images["images"].each { |ti|
        case ti['name']
        when "Landscape"
          stage = ImagePrep::Stage.new(ti['file'], "#{dir}")
          dest = stage.stage_original
          
          # Test that file got copied
          assert(File::exists?(dest), "Image #{ti['file']} was not copied to orginial directory")
          md = ImagePrep::MetaData.new dest
          assert(md.date_time_original.to_date != DateTime.now.to_date, "The EXIF date should not be today")
          assert(md.declared_date == true, "EXIF *DID NOT* have date defined by staging operation for #{ti['name']}")
          when "NoMetaData"
          stage = ImagePrep::Stage.new(ti['file'], "#{dir}")
          dest = stage.stage_original
          
          # Test that file got copied
          assert(File::exists?(dest), "Image #{ti['file']} was not copied to orginial directory")
          md = ImagePrep::MetaData.new dest
          assert(md.date_time_original.to_date == DateTime.now.to_date, "The EXIF date should be today for #{ti['name']}.")
          assert(md.declared_date == true, "EXIF *DID NOT* have date defined by staging operation for #{ti['name']}")
        end
      }
    }
  end

end
#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'bundler/setup'

require 'test/unit'
require 'date'
require 'fileutils'
require 'json'

require_relative '../lib/imageprep/metadata'

class TestOptions < Test::Unit::TestCase

  def setup
    @test_images ||= JSON.parse(File.read('./test/data/test_images.json'))
  end

  def test_images_exists
    @test_images["images"].each { |ti|
      assert(File::exists?(ti['file']))
    }
  end

  def test_image_metadata
    @test_images["images"].each { |ti|
      md = ImagePrep::MetaData.new(ti['file'])
      json_file_name = "#{File.dirname(ti['file'])}/#{File.basename(ti['file'],'.*')}.json"
      jf = JSON.parse(File.read(json_file_name))
      jf.each { |attrib|  
        assert_equal(md.send(attrib[0]), attrib[1],"#{attrib[0]} value for image #{ti['file']}")
      }
    }
  end

  def test_write_json
    Dir.mktmpdir {|dir|
      @test_images["images"].each { |ti|  
        # md = ImagePrep::MetaData.new(File.join(dir, ti['file']))
        # json_file = md.write_json(ti['file'])
        # assert(File.exists?(json_file, "Did not create #{json_file}"))
      }
    } # delete temporary directory
  end

  def test_to_frac
    assert_equal(2.8, "28/10".to_frac)
    assert_equal(2, "2/1".to_frac)
    assert_equal(2, "2".to_frac)
    assert_equal(0, "0".to_frac)
    assert_equal(nil, "".to_frac)
  end

  def test_to_slug
    assert_equal("this-is-a-test", "this is a test".to_slug)
    assert_equal("this-is-a-test", "This Is A Test".to_slug)
    assert_equal("this-is-a-test", "This Is A Test   ".to_slug)
    assert_equal("this-is-a-test", "    This Is A Test   ".to_slug)
  end
end
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
      ti["EXIF"][0].each { |attrib|
        puts "attrib is #{attrib}"
      } unless ti["EXIF"].nil?
    }
  end

  def test_write_json
    @test_images["images"].each { |ti|  
      md = ImagePrep::MetaData.new(ti['file'])
      md.write_json(ti['file'])
    }
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
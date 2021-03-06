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

    @test_images["images"].each { |ti|
      assert(File::exists?(ti['file']))
    }

    @temp_dir = Dir.mktmpdir
    FileUtils.mkdir File.join(@temp_dir, "original")
    @test_images["images"].each { |ti|
      FileUtils.cp(ti['file'], File.join(@temp_dir, "original"))
    }
  end

  def teardown
    FileUtils.remove_entry @temp_dir
  end

  def test_resize_long
    ipr = ImagePrep::Resize.new(@temp_dir)
    ipr.resized_names.each { |name| 
      assert(File::exists?(name), "Image #{name} does not exist")
      File.basename(name,'.*') =~ /-([0-9]*)x[0-9]*$/
      assert_equal($1, MiniMagick::Image.open(name)[:width].to_s, "#{name} is not width #{$1} it is #{ MiniMagick::Image.open(name)[:width]}")
    }
  end

end
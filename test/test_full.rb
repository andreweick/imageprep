#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'bundler/setup'

require 'test/unit'
require 'date'
require 'fileutils'

require_relative '../lib/imageprep/metadata'
require_relative '../lib/imageprep/resize'

class TestFull < Test::Unit::TestCase
  # Image constant names
  FullTestImages = {  
    landscape:      "./test/data/landscape-big-enough-2895x1930.jpg",
    portrait:       "./test/data/portrait-big-enough-3840x5760.jpg",
    notbigenough:   "./test/data/not-big-enough-1333x2000.jpg",
    needstrip:      "./test/data/2013-01-19 at 10-54-54.jpg",
    scan:           "./test/data/2013 02 11 20 24 33 jasmine 1.jpg" 
  }

  def test_imagesExists
    FullTestImages.each do |nature, filename|
      assert(File::exists?(filename))
    end
  end

  def test_generate_octo
    image_processed = Array.new
    Dir.mktmpdir { |dir|
      FullTestImages.each do |nature, filename|  
        rz = ImagePrep::Resize.new(filename, "#{dir}")
        rz.do_work

        # Write out YAML file describing image
        md = ImagePrep::MetaData.new(filename).write_pyaml(rz.path_original_dir)
        image_processed.push(ImagePrep::Resize.new(filename, "#{dir}").do_work)
      end

      image_processed.each { |filename|  
        assert(File::exists?(filename), "test_generate_octo #{filename} did not get created by Resize")
        
        yaml_file = File.join(File.dirname(filename), File.basename(filename, ".*") + ".yaml")
        assert(File::exists?(yaml_file), "Yaml file #{yaml_file} not created.")
      }
    }
  end

end
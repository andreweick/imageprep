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
  def setup
    @test_images ||= YAML.load_file('./test/data/test_images.yaml')
  end

  def test_imagesExists
    @test_images.each do |nature, filename|
      assert(File::exists?(filename))
    end
  end

  def test_generate_octo
    image_processed = Array.new
    Dir.mktmpdir { |dir|
      @test_images.each do |nature, filename|  
        rz = ImagePrep::Resize.new(filename, "#{dir}")
        rz.do_work

        # Write out YAML file describing image
        md = ImagePrep::MetaData.new(filename).write_yaml(rz.path_original_dir)
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
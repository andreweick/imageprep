#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'bundler/setup'

require 'test/unit'
require 'date'
require 'fileutils'

require_relative '../lib/imageprep/octo'

class TestOcto < Test::Unit::TestCase
  # Image constant names
  OctoTestImages = [  
    "./test/data/landscape-big-enough-2895x1930.jpg",
    "./test/data/portrait-big-enough-3840x5760.jpg",
    "./test/data/not-big-enough-1333x2000.jpg",
    "./test/data/2013-01-19 at 10-54-54.jpg",
    "./test/data/2013 02 11 20 24 33 jasmine 1.jpg" 
  ]

  def test_images_exists
    OctoTestImages.each do |filename|
      assert(File::exists?(filename))
    end
  end

  def test_generate_octo
    # Dir.mktmpdir {|dir|
      ImagePrep::Octo.new(OctoTestImages, "/tmp").to_octopress
    # }
  end

end
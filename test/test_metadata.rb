#!/usr/bin/ruby
# encoding: utf-8

require 'rubygems'
require 'bundler/setup'

require 'test/unit'
require 'date'
require 'fileutils'

require_relative '../lib/imageprep/metadata'

class TestOptions < Test::Unit::TestCase
	# Image constant names
	TestImages = { 	
		landscape: 			"./test/data/landscape-big-enough-2895x1930.jpg",
		portrait: 			"./test/data/portrait-big-enough-3840x5760.jpg",
		notbigenough: 	"./test/data/not-big-enough-1333x2000.jpg"
	}

	def test_imagesExists
		TestImages.each do |nature, filename|
			assert_equal File::exists?(filename), true
		end
  end

  def test_landscape
  	meta = ImagePrep::MetaData.new(TestImages[:landscape])
  	dto = Date.new(2013,1,15)
  	assert_equal(dto.year, meta.dateTimeOriginal.year)
  	assert_equal(dto.month, meta.dateTimeOriginal.month)
  	assert_equal(dto.day, meta.dateTimeOriginal.day)

  	assert_equal(meta.exposureTime, "1/125")
  	assert_equal(meta.focalLength, 40)
  	assert_equal(100, meta.iso)
  	assert_equal("Canon EOS 5D Mark III", meta.camera)

  	assert_equal(["Libby Eick", "libby", "studio"], meta.keywords)
  	assert_equal("\u00A9 2013 Andrew Eick, all rights reserved.", meta.copyright)  # '\u00A9' is copyright symbol (c)
 		assert_equal(nil, meta.caption)
 		assert_equal("Lazy Saturday", meta.headline)
  	assert_equal("McLean", meta.city)
  	assert_equal("VA", meta.state)
  	assert_equal("USA", meta.country)

    assert_equal(2895, meta.width)
    assert_equal(1930, meta.heigth)
    assert_equal(TestImages[:landscape], meta.fileName)
    assert_equal(File.basename(TestImages[:landscape]), meta.name)
  end

  def test_notbigenough
  	meta = ImagePrep::MetaData.new(TestImages[:notbigenough])
  	dto = Date.new(2006,12,29)
  	assert_equal(dto.year, meta.dateTimeOriginal.year)
  	assert_equal(dto.month, meta.dateTimeOriginal.month)
  	assert_equal(dto.day, meta.dateTimeOriginal.day)

  	assert_equal(meta.exposureTime, "1/30")
  	assert_equal(meta.focalLength, 52)
  	assert_equal(800, meta.iso)
  	assert_equal("Canon EOS 5D", meta.camera)

  	# assert_equal(["christmas", "libby", "present"], meta.keywords)  # This is a flickr keyworded thing, space delimeted
  	assert_equal("\u00A9 2006 Andrew Eick, all rights reserved.", meta.copyright)  # '\u00A9' is copyright symbol (c)
 		assert_equal(nil, meta.caption)
 		assert_equal("Libby opens a present", meta.headline)
  	assert_equal(nil, meta.city)
  	assert_equal(nil, meta.state)
  	assert_equal(nil, meta.country)

    assert_equal(1333, meta.width)
    assert_equal(2000, meta.heigth)
    assert_equal(TestImages[:notbigenough], meta.fileName)
    assert_equal(File.basename(TestImages[:notbigenough]), meta.name)
  end

  def test_portrait
    portraitOctopressYaml = <<-OCTO
name: portrait-big-enough-3840x5760.jpg
fileName: ./test/data/portrait-big-enough-3840x5760.jpg
heigth: 5760
width: 3840
dateTimeOriginal: 2013-01-11T18:04:00+00:00
keywords:
- Libby Eick
- aedc
- libby
- studio
copyright: © 2013 Andrew Eick, all rights reserved.
headline: Libby reading a book
caption: Libby reading her book
city: McLean
state: VA
country: USA
exposureTime: 1/200
focalLength: 40
iso: 100
camera: Canon EOS 5D Mark III
OCTO
  	meta = ImagePrep::MetaData.new(TestImages[:portrait])
  	dto = Date.new(2013,1,11)
  	assert_equal(dto.year, meta.dateTimeOriginal.year)
  	assert_equal(dto.month, meta.dateTimeOriginal.month)
  	assert_equal(dto.day, meta.dateTimeOriginal.day)

  	assert_equal(meta.exposureTime, "1/200")
  	assert_equal(meta.focalLength, 40)
  	assert_equal(100, meta.iso)
  	assert_equal("Canon EOS 5D Mark III", meta.camera)

  	assert_equal(["Libby Eick", "aedc", "libby", "studio"], meta.keywords)
  	assert_equal("\u00A9 2013 Andrew Eick, all rights reserved.", meta.copyright)  # '\u00A9' is copyright symbol (c)
 		assert_equal("Libby reading her book", meta.caption)
 		assert_equal("Libby reading a book", meta.headline)
  	assert_equal("McLean", meta.city)
  	assert_equal("VA", meta.state)
  	assert_equal("USA", meta.country)

    assert_equal(3840, meta.width)
    assert_equal(5760, meta.heigth)
    assert_equal(TestImages[:portrait], meta.fileName)
    assert_equal(File.basename(TestImages[:portrait]), meta.name)
    puts "Andy: #{meta.to_octopress}\n"
    # puts "Andy2: #{portraitOctopressYaml}"
    # assert_equal(portraitOctopressYaml, meta.to_octopress)
  end

end
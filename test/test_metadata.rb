#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'bundler/setup'

require 'test/unit'
require 'date'
require 'fileutils'

require_relative '../lib/imageprep/metadata'

class TestOptions < Test::Unit::TestCase
  # Image constant names
  MetadataTestImages = {  
    landscape:      "./test/data/landscape-big-enough-2895x1930.jpg",
    portrait:       "./test/data/portrait-big-enough-3840x5760.jpg",
    notbigenough:   "./test/data/not-big-enough-1333x2000.jpg",
    needstrip:      "./test/data/2013-01-19 at 10-54-54.jpg",
    scan:           "./test/data/2013 02 11 20 24 33 jasmine 1.jpg" 
  }

  def test_imagesExists
    MetadataTestImages.each do |nature, filename|
      assert(File::exists?(filename))
    end
  end

  def test_landscape
    meta = ImagePrep::MetaData.new(MetadataTestImages[:landscape])
    dto = Date.new(2013,1,15)
    assert_equal(dto.year, meta.date_time_original.year)
    assert_equal(dto.month, meta.date_time_original.month)
    assert_equal(dto.day, meta.date_time_original.day)

    assert_equal(meta.exposureTime, "1/125")
    assert_equal(meta.focal_length, 40)
    assert_equal(100, meta.iso)
    assert_equal("Canon EOS 5D Mark III", meta.camera)

    assert_equal(["Libby Eick", "libby", "studio"], meta.keywords)
    assert_equal("\u00A9 2013 Andrew Eick, all rights reserved.", meta.copyright)  # '\u00A9' is copyright symbol (c)
    assert_equal(nil, meta.caption)
    assert_equal("Lazy Saturday", meta.headline)
    assert_equal("landscape-big-enough-2895x1930.jpg", meta.name)
    assert_equal("McLean", meta.city)
    assert_equal("VA", meta.state)
    assert_equal("USA", meta.country)
    assert_equal("landscape-big-enough-2895x1930.jpg", meta.name)
    assert_equal("landscape-big-enough-2895x1930", meta.strip_extension)

    assert_equal(2895, meta.width)
    assert_equal(1930, meta.height)
    assert_equal(MetadataTestImages[:landscape], meta.file_name)
    assert_equal(File.basename(MetadataTestImages[:landscape]), meta.name)
  end

  def test_notbigenough
    meta = ImagePrep::MetaData.new(MetadataTestImages[:notbigenough])
    dto = Date.new(2006,12,29)
    assert_equal(dto.year, meta.date_time_original.year)
    assert_equal(dto.month, meta.date_time_original.month)
    assert_equal(dto.day, meta.date_time_original.day)

    assert_equal(meta.exposureTime, "1/30")
    assert_equal(meta.focal_length, 52)
    assert_equal(800, meta.iso)
    assert_equal("Canon EOS 5D", meta.camera)

    # assert_equal(["christmas", "libby", "present"], meta.keywords)  # This is a flickr keyworded thing, space delimeted
    assert_equal("\u00A9 2006 Andrew Eick, all rights reserved.", meta.copyright)  # '\u00A9' is copyright symbol (c)
    assert_equal(nil, meta.caption)
    assert_equal("Libby opens a present", meta.headline)
    assert_equal(nil, meta.city)
    assert_equal(nil, meta.state)
    assert_equal(nil, meta.country)
    assert_equal("not-big-enough-1333x2000", meta.strip_extension)
    assert_equal("not-big-enough-1333x2000", meta.strip_space_extension)

    assert_equal(1333, meta.width)
    assert_equal(2000, meta.height)
    assert_equal(MetadataTestImages[:notbigenough], meta.file_name)
    assert_equal(File.basename(MetadataTestImages[:notbigenough]), meta.name)
  end

  def test_portrait
    meta = ImagePrep::MetaData.new(MetadataTestImages[:portrait])
    dto = Date.new(2013,1,11)
    assert_equal(dto.year, meta.date_time_original.year)
    assert_equal(dto.month, meta.date_time_original.month)
    assert_equal(dto.day, meta.date_time_original.day)

    assert_equal(meta.exposureTime, "1/200")
    assert_equal(meta.focal_length, 40)
    assert_equal(100, meta.iso)
    assert_equal("Canon EOS 5D Mark III", meta.camera)

    assert_equal(["Libby Eick", "aedc", "libby", "studio"], meta.keywords)
    assert_equal("\u00A9 2013 Andrew Eick, all rights reserved.", meta.copyright)  # '\u00A9' is copyright symbol (c)
    assert_equal("Libby reading her book", meta.caption)
    assert_equal("Libby reading a book", meta.headline)
    assert_equal("McLean", meta.city)
    assert_equal("VA", meta.state)
    assert_equal("USA", meta.country)
    assert_equal("portrait-big-enough-3840x5760.jpg", meta.name)
    assert_equal("portrait-big-enough-3840x5760", meta.strip_extension)
    assert_equal("portrait-big-enough-3840x5760", meta.strip_space_extension)

    assert_equal(3840, meta.width)
    assert_equal(5760, meta.height)
    assert_equal(MetadataTestImages[:portrait], meta.file_name)
    assert_equal(File.basename(MetadataTestImages[:portrait]), meta.name)
  end

  def test_strip
    meta = ImagePrep::MetaData.new(MetadataTestImages[:needstrip])
  
    dto = DateTime.new(2013,1,19) 
    assert_equal(dto.year, meta.date_time_original.year)
    assert_equal(dto.month, meta.date_time_original.month)
    assert_equal(dto.day, meta.date_time_original.day)
    assert_equal(meta.exposureTime, "1/125")
    assert_equal(meta.focal_length, 30)
    assert_equal(100, meta.iso)
    assert_equal("Canon EOS 5D Mark III", meta.camera)

    assert_equal(["Jasmine Eick", "black background", "jasmine", "studio"], meta.keywords)
    assert_equal("\u00A9 2013 Andrew Eick, all rights reserved.", meta.copyright)  # '\u00A9' is copyright symbol (c)
    assert_equal("Jasmine showing her new shirt", meta.caption)
    assert_equal("Jasmine trying to pose", meta.headline)
    assert_equal("McLean", meta.city)
    assert_equal("VA", meta.state)
    assert_equal("United States of America", meta.country)
    assert_equal("USA", meta.countryISO)
    assert_equal("2013-01-19 at 10-54-54.jpg", meta.name)
    assert_equal("2013-01-19 at 10-54-54", meta.strip_extension)
    assert_equal("2013-01-19-at-10-54-54.jpg", meta.strip_space)
    assert_equal("2013-01-19-at-10-54-54", meta.strip_space_extension)

    assert_equal(3840, meta.width)
    assert_equal(5760, meta.height)
    assert_equal(MetadataTestImages[:needstrip], meta.file_name)
    assert_equal(File.basename(MetadataTestImages[:needstrip]), meta.name)
  end

  def test_scan
    meta = ImagePrep::MetaData.new(MetadataTestImages[:scan])

    dto = DateTime.new(2013,04,23)
    assert_equal(dto.year, meta.date_time_original.year)
    assert_equal(dto.month, meta.date_time_original.month)
    assert_equal(dto.day, meta.date_time_original.day)
    assert_equal("", meta.exposureTime)
    assert_equal(nil, meta.focal_length)
    assert_equal(nil, meta.iso)
    assert_equal("", meta.camera)
    assert_equal([], meta.keywords)
    assert_equal(2199, meta.width)
    assert_equal(1699, meta.height)

    assert_equal("2013 02 11 20 24 33 jasmine 1.jpg", meta.name)
    assert_equal("2013 02 11 20 24 33 jasmine 1", meta.strip_extension)
    assert_equal("2013-02-11-20-24-33-jasmine-1.jpg", meta.strip_space)
    assert_equal("2013-02-11-20-24-33-jasmine-1", meta.strip_space_extension)
  end

  def test_to_frac
    assert_equal(2.8, "28/10".to_frac)
    assert_equal(2, "2/1".to_frac)
    assert_equal(2, "2".to_frac)
    assert_equal(0, "0".to_frac)
    assert_equal(nil, "".to_frac)
  end

  def test_write_pyaml
    Dir.mktmpdir {|dir|
      MetadataTestImages.each { |image_type, image_name|
        md = ImagePrep::MetaData.new(image_name)
        filename = md.write_pyaml(dir)
        assert(File::exists?(filename), "Yaml file #{filename} does not exist")
      }
    } #delete temporary directory
  end

  def test_yaml
    # the gsub statement is to [format the HEREDOC statement](http://rubyquicktips.com/post/4438542511/heredoc-and-indent)
    portraitPYaml = <<-PORTRAIT_METADATA_YAML.gsub(/^ {6}/, '')
      name: portrait-big-enough-3840x5760.jpg
      original_name: portrait-big-enough-3840x5760.jpg
      path: original/2013/2013-01-11/portrait-big-enough-3840x5760.jpg
      height: 5760
      width: 3840
      date_time_original: 2013-01-11T18:04:00+00:00
      categories:
      - Libby Eick
      - aedc
      - libby
      - studio
      copyright: © 2013 Andrew Eick, all rights reserved.
      headline: "Libby reading a book"
      caption: "Libby reading her book"
      city: McLean
      state: VA
      country: USA
      countryISO: 
      aperture: 5.6
      exposureTime: 1/200
      focal_length: 40
      iso: 100
      camera: Canon EOS 5D Mark III
    PORTRAIT_METADATA_YAML

    notbigenoughYaml = <<-NOTBIGENOUGH_YAML.gsub(/^ {6}/, '')
      name: not-big-enough-1333x2000.jpg
      original_name: not-big-enough-1333x2000.jpg
      path: original/2006/2006-12-29/not-big-enough-1333x2000.jpg
      height: 2000
      width: 1333
      date_time_original: 2006-12-29T18:38:08+00:00
      categories:
      - christmas libby present
      copyright: © 2006 Andrew Eick, all rights reserved.
      headline: "Libby opens a present"
      caption: ""
      city: 
      state: 
      country: 
      countryISO: 
      aperture: 2.8
      exposureTime: 1/30
      focal_length: 52
      iso: 800
      camera: Canon EOS 5D
    NOTBIGENOUGH_YAML

    landscapeYaml = <<-LANDSCAPE_YAML.gsub(/^ {6}/, '')
      name: landscape-big-enough-2895x1930.jpg
      original_name: landscape-big-enough-2895x1930.jpg
      path: original/2013/2013-01-15/landscape-big-enough-2895x1930.jpg
      height: 1930
      width: 2895
      date_time_original: 2013-01-15T20:01:55+00:00
      categories:
      - Libby Eick
      - libby
      - studio
      copyright: © 2013 Andrew Eick, all rights reserved.
      headline: "Lazy Saturday"
      caption: ""
      city: McLean
      state: VA
      country: USA
      countryISO: 
      aperture: 5.6
      exposureTime: 1/125
      focal_length: 40
      iso: 100
      camera: Canon EOS 5D Mark III
    LANDSCAPE_YAML

# touch -mt 201303231644 test/data/2013\ 02\ 11\ 20\ 24\ 33\ jasmine\ 1.jpg
    scan_yaml = <<-SCAN_YAML.gsub(/^ {6}/, '')
      name: 2013-02-11-20-24-33-jasmine-1.jpg
      original_name: 2013 02 11 20 24 33 jasmine 1.jpg
      path: original/2013/2013-02-11/2013 02 11 20 24 33 jasmine 1.jpg
      height: 1699
      width: 2199
      date_time_original: 2013-03-23T16:44:16-04:00
      categories:
      copyright: © 2013 Andrew Eick, all rights reserved.
      headline: ""
      caption: ""
      city: 
      state: 
      country: 
      countryISO: 
      aperture: 
      exposureTime: 
      focal_length: 
      iso: 
      camera: 
    SCAN_YAML

    meta = ImagePrep::MetaData.new(MetadataTestImages[:portrait])
    assert_equal(portraitPYaml, meta.to_yaml)

    meta = ImagePrep::MetaData.new(MetadataTestImages[:notbigenough])
    assert_equal(notbigenoughYaml, meta.to_yaml)

    meta = ImagePrep::MetaData.new(MetadataTestImages[:landscape])
    assert_equal(landscapeYaml, meta.to_yaml)

    # meta = ImagePrep::MetaData.new(MetadataTestImages[:scan])
    # assert_equal(scan_yaml, meta.to_yaml)
  end
end
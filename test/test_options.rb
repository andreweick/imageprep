#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'test/unit'

require_relative '../lib/imageprep/options'

class TestOptions < Test::Unit::TestCase
  def test_alloutputdirectory
    opts = ImagePrep::Options.new(["-o", "/tmp-image", "-d", "/tmp-draft", "image1", "image2"])
    assert_equal(["image1", "image2"], opts.images_to_load)
    assert_equal("/tmp-image", opts.out_dir_images)
    assert_equal("/tmp-draft", opts.out_dir_draft)
    assert_equal(false, opts.quiet)
    assert_equal(false, opts.verbose)
    assert_equal(nil, opts.logfile)
    assert_equal(false, opts.generate_json)
  end

  def test_outputdirectory
    opts = ImagePrep::Options.new(["-o", "/tmp", "image1", "image2"])
    assert_equal(["image1", "image2"], opts.images_to_load)
    assert_equal("/tmp", opts.out_dir_images)
    assert_equal(false, opts.quiet)
  	assert_equal(false, opts.verbose)
  	assert_equal(nil, opts.logfile)
    assert_equal(false, opts.generate_json)
  end

  def test_quiet
  	opts = ImagePrep::Options.new(["-q", "image1"])
  	assert_equal(true, opts.quiet)
  	assert_equal(false, opts.verbose)
    assert_equal(["image1"], opts.images_to_load)
  	assert_equal(nil, opts.logfile)
    assert_equal(false, opts.generate_json)
  end

  def test_verbose
  	opts = ImagePrep::Options.new(["-v", "image1"])
  	assert_equal(true, opts.verbose)
    assert_equal(["image1"], opts.images_to_load)
  	assert_equal(nil, opts.logfile)
    assert_equal(false, opts.generate_json)
  end

  def test_logfile
  	opts = ImagePrep::Options.new(["-l", "logfileName", "image1"])
  	assert_equal(false, opts.quiet)
  	assert_equal(false, opts.verbose)
    assert_equal(["image1"], opts.images_to_load)
  	assert_equal("logfileName", opts.logfile)
    assert_equal(false, opts.generate_json)
  end

  def test_generate_json
    opts = ImagePrep::Options.new(["-j", "image1"])
    assert_equal(false, opts.quiet)
    assert_equal(false, opts.verbose)
    assert_equal(["image1"], opts.images_to_load)
    assert_equal(nil, opts.logfile)
    assert_equal(true, opts.generate_json)
  end

end
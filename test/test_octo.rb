#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'bundler/setup'

require 'test/unit'
require 'date'
require 'fileutils'

require_relative '../lib/imageprep/octo'

class TestOcto < Test::Unit::TestCase
  def setup
    @test_images ||= YAML.load_file('./test/data/test_images.yaml')
  end

  def test_images_exists
    @test_images.each do |nature,filename|
      assert(File::exists?(filename), "#{filename} does not exist")
    end
  end

  def test_to_octo
    assert(File::exists?("./test/data/octo_test_1.md"), "./test/data/octo_test_1.md does not exist")
    test1 = File.open("./test/data/octo_test_1.md", "r") {|f| f.read }
    assert(!test1.empty?, "nothing in file")

    s = ImagePrep::Octo.new(@test_images.values).to_octopress

    assert_equal(s, test1)
  end

  def test_generate_octo
    assert(File::exists?("./test/data/octo_test_1.md"), "./test/data/octo_test_1.md does not exist")
    test1 = File.open("./test/data/octo_test_1.md", "r") {|f| f.read }
    assert(!test1.empty?, "nothing in file")
    Dir.mktmpdir {|dir|
      written_file = ImagePrep::Octo.new(@test_images.values).write_octopress(dir)
      assert(File::exists?(written_file), "Did not create file #{written_file}")
      assert(FileUtils::compare_file(written_file,"./test/data/octo_test_1.md"), "File generated does not match test data")
    }
  end

end
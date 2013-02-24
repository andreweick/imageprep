#!/usr/bin/ruby

require 'rubygems'
require 'bundler/setup'

require 'test/unit'

require_relative '../lib/imageprep/imagedata'

class TestOptions < Test::Unit::TestCase
	def test_construct
		assert_equal(false,true)
	end
end
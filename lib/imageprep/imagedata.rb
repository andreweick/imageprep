#!/usr/bin/ruby

require 'rubygems'
require 'bundler/setup'

require_relative 'metadata'

module ImagePrep
	class ImageData
		attr_reader :filename, :url, :md
		
		def initialize(imageFileName)
			@imb = MetaData(imageFileName)
		end

	end
end
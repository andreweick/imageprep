#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require_relative 'metadata'

module ImagePrep
  class Octo
  	attr_reader :image_list, :out_directory

  	def initialize(image_list, out_directory)
  		@image_list = image_list
  		@out_directory = out_directory
  	end

  	def to_octopress
  		metadata_list = Array.new
  		# Emit the octo-yaml
			puts "---"
			puts "layout: post"
			puts "title: "
			puts "date: "
			puts "comments: false"
			puts "published: false"
			puts "categories: " 
			puts "photographs: "

			image_list.each { |image|
				metadata = ImagePrep::MetaData.new(image)
				metadata_list.push(metadata)				# save the metadata

				puts "- url: http://media.eick.us/#{metadata.path}"
				puts "  headline: \"#{metadata.headline}\""
				puts "  caption: \"#{metadata.caption}\""
				puts "  date_time_original: #{metadata.date_time_original}"
				puts "  copyright: #{metadata.copyright}"
				puts "  city: #{metadata.city}"
				puts "  state: #{metadata.state}"
				puts "  country: #{metadata.country}"
				puts "  exposure_time: #{metadata.exposure_time}"
				puts "  focal_length: #{metadata.focal_length}"
				puts "  aperture: #{metadata.aperture}"
				puts "  iso: #{metadata.iso}"
				puts "  camera: #{metadata.camera}"
				puts "  markdown: ![#{metadata.headline}](http://media.eick.us/images/#{metadata.path})"
			}
			puts "---"

			# and now write out each image in the body 
			metadata_list.each { |md|
				puts "{% photo2 http://media.eick.us/images/#{md.path} \"#{md.headline}\" %}"
				puts
			}
		end
  end
end
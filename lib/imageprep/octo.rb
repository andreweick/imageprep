#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'


module ImagePrep
  class Octo
  	attr_reader :image_list, :out_directory 
  	def initialize(image_list, out_directory)
  		@image_list = image_list
  		@out_directory = out_directory
  	end

  	def to_octopress
  		# Emit the octo-yaml
			puts "---"
			puts "layout: post"
			puts "title: "
			puts "date: "
			puts "comments: false"
			puts "published: false"
			puts "categories: " 
			puts "photographs: "

			imgs_yaml.each { |yaml|
				metadata = YAML.load_file(yaml)
				puts "- url: http://media.eick.us/#{metadata["path"]}"
				puts "  headline: \"#{metadata["headline"]}\""
				puts "  caption: \"#{metadata["caption"]}\""
				puts "  date_time_original: #{metadata["dateTimeOriginal"]}"
				puts "  copyright: #{metadata["copyright"]}"
				puts "  city: #{metadata["city"]}"
				puts "  state: #{metadata["state"]}"
				puts "  country: #{metadata["country"]}"
				puts "  exposure_time: #{metadata["exposureTime"]}"
				puts "  focal_length: #{metadata["focalLength"]}"
				puts "  aperture: #{metadata["aperture"]}"
				puts "  iso: #{metadata["iso"]}"
				puts "  camera: #{metadata["camera"]}"
				puts "  markdown: ![#{metadata["headline"]}](http://media.eick.us/images/#{metadata["path"]})"
			}
			puts "---"

			# and now write out each image in the body 
			imgs_yaml.each { |yaml|
				metadata = YAML.load_file(yaml)
				puts "{% photo2 http://media.eick.us/images/#{metadata["path"]} \"#{metadata["headline"]}\" %}"
				puts
			}
		}
  end
end

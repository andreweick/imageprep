#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require_relative 'metadata'

module ImagePrep
  class Octo
  	attr_reader :image_list

  	def initialize(image_list)
  		@image_list = image_list
  	end

  	def to_octopress
  		metadata_list = Array.new
			s = "---\n"
			s += "layout: post\n"
			s += "title:\n"
			s += "date:\n"
			s += "comments: false\n"
			s += "published: false\n"
			s += "categories:\n" 
			s += "photographs:\n"

			image_list.each { |image|
				metadata = ImagePrep::MetaData.new(image)
				metadata_list.push(metadata)				# save the metadata

				s += "- url: http://media.eick.us/#{metadata.path}\n"
				s += "  headline: \"#{metadata.headline}\"\n"
				s += "  caption: \"#{metadata.caption}\"\n"
				s += "  date_time_original: #{metadata.date_time_original}\n"
				s += "  copyright: #{metadata.copyright}\n"
				s += "  city: #{metadata.city}\n"
				s += "  state: #{metadata.state}\n"
				s += "  country: #{metadata.country}\n"
				s += "  exposure_time: #{metadata.exposure_time}\n"
				s += "  focal_length: #{metadata.focal_length}\n"
				s += "  aperture: #{metadata.aperture}\n"
				s += "  iso: #{metadata.iso}\n"
				s += "  camera: #{metadata.camera}\n"
				s += "  markdown: ![#{metadata.headline}](http://media.eick.us/images/#{metadata.path})\n"
			}
			s += "---\n"

			# and now write out each image in the body 
			metadata_list.each { |md|
				s += "\n{% photo2 http://media.eick.us/images/#{md.path} \"#{md.headline}\" %}\n"
			}

			s #return the string as the result
		end

		def write_octopress(out_directory)
			FileUtils.mkpath(out_directory)
			dest_octo = File.join(out_directory, Time.now.strftime("%Y-%m-%d-%H-%M.markdown"))
 	    File.open(dest_octo, 'w'){ |f| 
        f.write(to_octopress) 
      }

      dest_octo
 		end
  end
end
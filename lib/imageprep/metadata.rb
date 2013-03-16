#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'mini_magick'
require 'date'
require 'fileutils'
require 'erb'

module ImagePrep
	class MetaData
		attr_reader :keywords, :copyright, :caption, :headline, :dateTimeOriginal
		attr_reader :city, :state, :country, :countryISO
		attr_reader :exposureTime, :focalLength, :iso, :camera
		attr_reader :heigth, :width, :name, :fileName

		#[IPTC code chart](http://www.imagemagick.org/script/escape.php)
		
		# To interogate the EXIF data for an image: 
    #   identify -format "%[exif:*]" not-big-enough-1333x2000.jpg

    # To interogate the IPTC data
    #  identify -format "%[IPTC:2:05]" landscape-big-enough-2895x1930.jpg 

		EXIF_DATE_TIME_ORIGINAL = "EXIF:DateTimeOriginal"
		EXIF_EXPOSURE_TIME = "EXIF:ExposureTime"
		EXIF_FOCAL_LENGTH = "EXIF:FocalLength"
		EXIF_ISO = "EXIF:ISOSpeedRatings"
		EXIF_CAMERA = "EXIF:Model"

		IPTC_KEYWORD = "%[IPTC:2:25]"
		IPTC_COPYRIGHT = "%[IPTC:2:116]"
		IPTC_CAPTION = "%[IPTC:2:120]"
		IPTC_TITLE = "%[IPTC:2:05]"
		IPTC_HEADLINE = "%[IPTC:2:105]"
		IPTC_CITY = "%[IPTC:2:90]"
    IPTC_STATE = "%[IPTC:2:95]"
    IPTC_COUNTRY = "%[IPTC:2:101]"
    IPTC_COUNTRY_ISO = "%[IPTC:2:100]"

    WIDTH = "%w"
    HEIGTH = "%h"

		def initialize(imageFileName)
			image = MiniMagick::Image.open(imageFileName)
			@dateTimeOriginal = DateTime.strptime(image[EXIF_DATE_TIME_ORIGINAL], '%Y:%m:%d %H:%M:%S')
			@keywords = image[IPTC_KEYWORD].split(/;/)		# Aperture semicolon delimits keywords.     
			@copyright = image[IPTC_COPYRIGHT] || "\u00A9 #{dateTimeOriginal.year} Andrew Eick, all rights reserved."
			@headline = image[IPTC_HEADLINE] || image[IPTC_TITLE]
			@caption = image[IPTC_CAPTION]
			@city = image[IPTC_CITY]
			@state = image[IPTC_STATE]
			@country = image[IPTC_COUNTRY]
			@countryISO = image[IPTC_COUNTRY_ISO]
			@exposureTime = image[EXIF_EXPOSURE_TIME]
			@focalLength = eval(image[EXIF_FOCAL_LENGTH])			# This is stored as 40/1
			@iso = eval(image[EXIF_ISO])
			@camera = image[EXIF_CAMERA]
			
			@heigth = image[HEIGTH].to_i											# This is returend as a string
			@width = image[WIDTH].to_i												# This is returned as a string

			@name = File.basename(imageFileName)
			@fileName = imageFileName
		end

		def stripExtension
			File.basename(name,".*")
		end

		def stripSpace
			name.gsub(' ', '_')
		end

		def stripSpaceExtension
			File.basename(name,".*").gsub(' ', '_')
		end

		def to_octopress
			# Not crazy about the syntax in the heredoc around the looping of 'keyword', but 
			# if I don't put it on the same line then the spacing is wrong in the string
			# The following statement -- delete the first four tabs in the HEREDOC to [format](http://rubyquicktips.com/post/4438542511/heredoc-and-indent)
			s = ERB.new(<<-OCTOYAML.gsub(/^\t{4}/, '')).result(binding)
				name: #{name}
				fileName: #{fileName}
				heigth: #{heigth}
				width: #{width}
				dateTimeOriginal: #{dateTimeOriginal}
				categories:<% keywords.each do |word| %>
				- <%= word %><% end %>
				copyright: #{copyright}
				headline: #{headline}
				caption: #{caption}
				city: #{city}
				state: #{state}
				country: #{country}
				countryISO: #{countryISO}
				exposureTime: #{exposureTime}
				focalLength: #{focalLength}
				iso: #{iso}
				camera: #{camera}
			OCTOYAML
		end
	end
end

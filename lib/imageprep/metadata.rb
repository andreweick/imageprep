#!/usr/bin/ruby

require 'rubygems'
require 'bundler/setup'

require 'mini_magick'
require 'date'

module ImagePrep
	class MetaData
		attr_reader :keywords, :copyright, :caption, :headline, :dateOriginal, :city, :state, :country
		attr_reader :exposureTime, :focalLength, :iso, :camera

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

		def initialize(imageFileName)
			image = MiniMagick::Image.open(imageFileName)
			@dateOriginal = DateTime.strptime(image[EXIF_DATE_TIME_ORIGINAL], '%Y:%m:%d %H:%M:%S')
			@keywords = image[IPTC_KEYWORD]     
			@copyright = image[IPTC_COPYRIGHT] || "(c) Andrew Eick"
			@headline = image[IPTC_HEADLINE] || image[IPTC_TITLE]
			@caption = image[IPTC_CAPTION]
			@city = image[IPTC_CITY]
			@state = image[IPTC_STATE]
			@country = image[IPTC_COUNTRY]
			@exposureTime = image[EXIF_CAMERA]
			@focalLength = image[EXIF_FOCAL_LENGTH]
			@iso = image[EXIF_ISO]
			@camera = image[EXIF_CAMERA]
		end
	end
end

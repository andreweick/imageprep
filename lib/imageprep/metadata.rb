#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'mini_magick'
require 'date'
require 'fileutils'
require 'json'

require_relative 'JSONable'

class String
  def to_frac
    unless self.empty?
      numerator, denominator = split('/').map(&:to_f)
      denominator ||= 1
      numerator/denominator
    end
  end

  def to_slug
    value = self.gsub(/[^\x00-\x7F]/n, '').to_s
    value.gsub!(/[']+/, '')
    value.gsub!(/\W+/, ' ')
    value.strip!
    value.downcase!
    value.gsub!(' ', '-')
    value
  end
end

module ImagePrep
  class MetaData < JSONable
    attr_reader :keywords, :copyright, :caption, :headline, :date_time_original
    attr_reader :city, :state, :country, :countryISO
    attr_reader :exposure_time, :focal_length, :aperture, :iso, :camera
    attr_reader :height, :width, :name, :source_file_name
    attr_reader :slug_name, :root, :ext

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
    EXIF_APERTURE = "EXIF:FNumber"

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
    HEIGHT = "%h"

    def initialize(image_file_name)
      image = MiniMagick::Image.open(image_file_name)
      @date_time_original = (!image[EXIF_DATE_TIME_ORIGINAL].empty? ? DateTime.strptime(image[EXIF_DATE_TIME_ORIGINAL], '%Y:%m:%d %H:%M:%S') : File.ctime(image_file_name).to_datetime )
      @keywords = image[IPTC_KEYWORD] ? image[IPTC_KEYWORD].split(/;/) : []     # Aperture semicolon delimits keywords.     
      @copyright = image[IPTC_COPYRIGHT] || "\u00A9 #{date_time_original.year} Andrew Eick, all rights reserved."
      @headline = image[IPTC_HEADLINE] || image[IPTC_TITLE]
      @caption = image[IPTC_CAPTION]
      @city = image[IPTC_CITY]
      @state = image[IPTC_STATE]
      @country = image[IPTC_COUNTRY]
      @countryISO = image[IPTC_COUNTRY_ISO]
      @exposure_time = image[EXIF_EXPOSURE_TIME]
      @focal_length = "#{image[EXIF_FOCAL_LENGTH].chomp('/1')}mm" unless image[EXIF_FOCAL_LENGTH].empty?  # This is stored as 40/1
      @aperture = "f/#{image[EXIF_APERTURE].to_frac}" unless image[EXIF_APERTURE].empty?               # this is returned as 28/10 for f2.8
      @iso = eval(image[EXIF_ISO])
      @camera = image[EXIF_CAMERA]
      
      @height = image[HEIGHT].to_i                          # This is returend as a string
      @width = image[WIDTH].to_i                            # This is returned as a string

      @name = File.basename(image_file_name)
      @root = File.join("#{@date_time_original.year}",@date_time_original.strftime('%Y-%m-%d'))
      @ext = File.extname(image_file_name)
      @slug_name = File.basename(image_file_name, ".*").to_slug
    end

    def json_file_name
      "#{File.dirname(image_file_name)}/#{File.basename(image_file_name,'.*')}.json"
    end
    
    # Write the JSON file to the same directory as the image with the .json extension 
    def write_json(image_file_name)
      File.open(json_file_name,'w'){ |file| 
        file.write(to_json) 
      }
      json_file_name
    end

  end
end

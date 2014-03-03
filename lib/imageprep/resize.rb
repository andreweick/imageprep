#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'mini_magick'
require 'fileutils'
require 'date'

require_relative 'metadata'     # Need to get the EXIF date so I can put the file in the correct directory

module ImagePrep
  class Resize    

    # Constant Widths define the sizes that we need the images created at for 
    # picturefill [retina](http://duncandavidson.com/blog/2012/08/retina_ready/)
    
    WIDTHS = [ 320, 480, 768, 900, 640, 960, 1536, 500, 1800 ]
    JPEG_COMPRESSION_QUALITY = "75"    # Need to pass the compression quality as a string to mini_magic, hence the quotes

    attr_reader :dest_root, :metadata, :image_file_name

    def initialize(image_file_name, dest_root)
      @metadata = ImagePrep::MetaData.new(image_file_name)
      @dest_root = dest_root
      @image_file_name = image_file_name
    end

    def resize_images
      resized_image_names = Array.new
      resized_image_path_partial = File.join(@dest_root, "generated", @metadata.root, @metadata.slug_name)
      WIDTHS.each do |width|
        # Need to keep reloading image because we are resizing it
        image = MiniMagick::Image.open(image_file_name)
        
        image.resize("#{width}")         # need to pass "width" as a string to the mini_magick resize gem
        image.quality(JPEG_COMPRESSION_QUALITY)

        sized_image_name = resized_image_path_partial + "-#{width}x#{width}" + @metadata.ext
        FileUtils.mkpath(File.dirname(sized_image_name))

        image.write(sized_image_name)
        resized_image_names << sized_image_name
      end

      resized_image_names
    end
  end
end
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

    attr_reader :root, :resized_names

    def initialize(root)
      @resized_names = Array.new
      @root = root

      Dir.glob("#{@root}/original/*.jpg") do |jpg_file|
        resize_image jpg_file
      end
    end

    def resize_image(jpg_file)
      md = ImagePrep::MetaData.new(jpg_file)
      resized_image_path_partial = File.join(@root, "generated", md.root, md.slug_name)
      FileUtils.mkpath(File.dirname(resized_image_path_partial))

      WIDTHS.each do |width|
        # Need to keep reloading image because we are resizing it
        sized_image_name = resized_image_path_partial + "-#{width}x#{width}" + md.ext
        resized_names << sized_image_name

        next if File::exists?(sized_image_name)

        image = MiniMagick::Image.open(jpg_file)
        
        image.resize("#{width}")         # need to pass "width" as a string to the mini_magick resize gem
        image.quality(JPEG_COMPRESSION_QUALITY)

        image.write(sized_image_name)
      end
    end
  end
end
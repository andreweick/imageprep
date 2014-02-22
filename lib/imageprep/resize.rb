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

    def path_original_dir
      File.join(
                  @dest_root,
                  "original", 
                  "#{@metadata.date_time_original.year}", 
                  @metadata.date_time_original.strftime('%Y-%m-%d')
               )
    end

    def path_generated_dir
      File.join(
                  @dest_root, 
                  "generated", 
                  "#{@metadata.date_time_original.year}", 
                  @metadata.date_time_original.strftime('%Y-%m-%d')
                )
    end

    def original_image
      path = File.join(@dest_root, "original", @metadata.root, @metadata.slug_name + @metadata.ext)

      FileUtils.mkpath(File.dirname(path))
      FileUtils.cp(@image_file_name, path)
      
      path
    end

    def generated_images
      WIDTHS.each do |width|
        # Need to keep reloading image because we are resizing it
        image = MiniMagick::Image.open(@metadata.file_name)
        
        image.resize("#{width}")         # need to pass "width" as a string to the mini_magick resize gem
        image.quality(JPEG_COMPRESSION_QUALITY)

        sized_image_name = File.join(path_generated_dir, "#{width}", @metadata.to_slug)
        FileUtils.mkpath(File.dirname(sized_image_name))

        image.write(sized_image_name)
      end
    end

    # This function generates the images in the correct place
    def do_work
      # generated_images
      copy_original        # Copy the file last so that the return value is the original name
    end

  end
end
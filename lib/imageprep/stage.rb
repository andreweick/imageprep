#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'mini_magick'
require 'fileutils'
require 'date'
require 'mini_exiftool_vendored'

require_relative 'metadata'     # Need to get the EXIF date so I can put the file in the correct directory

module ImagePrep
  class Stage    
    attr_reader :dest_root, :metadata, :image_file_name

    def initialize(image_file_name, dest_root)
      @metadata = ImagePrep::MetaData.new(image_file_name)
      @dest_root = dest_root
      @image_file_name = image_file_name
    end

    # Path is *full* name (path + imagename)
    def path
      @path ||= File.join(@dest_root, "original", @metadata.root, @metadata.slug_name + @metadata.ext)
    end

    def stage_original
      FileUtils.mkpath(File.dirname(path))    # create directory path in case doesn't exist
      FileUtils.cp(@image_file_name, path)

      #If the date is specified in EXIF data, then write the 'staged' date instead
      unless @metadata.declared_date
        photo = MiniExiftool.new path
        photo.DateTimeOriginal = @metadata.date_time_original
        photo.save        
      end
      
      @metadata.write_json(path)

      path
    end

    def write_json
      json_file_name = "#{File.dirname(path)}/#{File.basename(path,'.*')}.json"
      File.open(json_file_name,'w'){ |file| 
        file.write(@metadata.to_json) 
      }
      json_file_name
    end
  end
end
#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'mini_magick'
require 'fileutils'
require 'date'
require 'erb'

require_relative 'metadata'

module ImagePrep
  class ImageManips    
    # Constant Widths define the sizes that we need the images created at for 
    # picturefill [retina](http://duncandavidson.com/blog/2012/08/retina_ready/)
    
    WIDTHS = [ 320, 480, 768, 900, 640, 960, 1536, 500, 1800 ]
    JPEG_COMPRESSION_QUALITY = "75"    # Need to pass as a string

    attr_reader :destRoot, :metadata, :emitedImages

    def initialize(image_file_name, destRoot)
      @metadata = ImagePrep::MetaData.new(image_file_name)
      @destRoot = destRoot
    end

    def path_original_dir
      File.join(
                  @destRoot,
                  originalDir
               )
    end

    def originalDir
      @originalDir ||
      File.join(  
                  "original", 
                  "#{@metadata.date_time_original.year}", 
                  @metadata.date_time_original.strftime('%Y-%m-%d')
                )
    end

    def originalDir=( new_value )
      @originalDir = new_value
    end

    def generatedDir
      @generatedDir || 
      File.join(
                  @destRoot, 
                  "generated", 
                  "#{@metadata.date_time_original.year}", 
                  @metadata.date_time_original.strftime('%Y-%m-%d')
                )
    end

    def generatedDir=( new_value )
      @generatedDir = new_value
    end

    def copyOriginal
      dest = File.join(path_original_dir,@metadata.strip_space)
      FileUtils.mkpath(path_original_dir)
      FileUtils.cp(@metadata.file_name, dest)
      
      dest
    end

    def generateYamlMeta
      destYamlName = File.join(path_original_dir, @metadata.strip_space_extension + ".yaml")
      FileUtils.mkpath(path_original_dir)
      File.open(destYamlName, 'w'){ |f| 
        f.write("path: #{originalDir}/#{@metadata.strip_space}\n")
        f.write(@metadata.to_octopress) 
      }

      destYamlName
    end

    def regenerate_images
      @emitedImages = Hash.new
      # figure out what directory
      Pathname.new(@metadata.file_name).ascend {|v|
        
      }
    end

    def generateSized
      @emitedImages = Hash.new

      WIDTHS.each do |width|
        # Need to keep reloading image because we are resizing it
        image = MiniMagick::Image.open(@metadata.file_name)
        
        image.resize("#{width}")         # need to pass "width" as a string to the mini_magick resize gem
        image.quality(JPEG_COMPRESSION_QUALITY)

        sizedImageName = File.join(generatedDir, "#{width}", @metadata.strip_space)
        FileUtils.mkpath(File.dirname(sizedImageName))

        image.write(sizedImageName)
        @emitedImages[width] = sizedImageName
      end
    end

  end
end
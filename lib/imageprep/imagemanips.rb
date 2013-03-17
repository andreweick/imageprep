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
    JPEG_COMPESSION_QUALITY = "75"    # Need to pass as a string

    attr_reader :destRoot, :metadata, :emitedImages

    def initialize(imageFileName, destRoot)
      @metadata = ImagePrep::MetaData.new(imageFileName)
      @destRoot = destRoot
    end

    def originalDir
      File.join(  
                  @destRoot, 
                  "original", 
                  "#{@metadata.dateTimeOriginal.year}", 
                  @metadata.dateTimeOriginal.strftime('%Y-%m-%d')
                )
    end

    def generatedDir
      @generatedDir || 
      File.join(
                  @destRoot, 
                  "generated", 
                  "#{@metadata.dateTimeOriginal.year}", 
                  @metadata.dateTimeOriginal.strftime('%Y-%m-%d')
                )
    end

    def generatedDir=( new_value )
      @generatedDir = new_value
    end

    def copyOriginal
      dest = File.join(originalDir,@metadata.stripSpace)
      FileUtils.mkpath(originalDir)
      FileUtils.cp(@metadata.fileName, dest)
      
      dest
    end

    def generateYamlMeta
      destYamlName = File.join(originalDir, @metadata.stripSpaceExtension + ".yaml")
      FileUtils.mkpath(originalDir)
      File.open(destYamlName, 'w'){ |f| f.write(@metadata.to_octopress) }

      destYamlName
    end

    def generateSized
      @emitedImages = Hash.new

      # Save source image 
      imageOriginal = MiniMagick::Image.open(@metadata.fileName)

      WIDTHS.each do |width|
        # Need to keep reloading image because we are resizing it
        image = MiniMagick::Image.open(@metadata.fileName)
        
        image.resize("#{width}")         # need to pass "width" as a string to the mini_magick resize gem
        image.quality(JPEG_COMPESSION_QUALITY)

        sizedImageName = File.join(generatedDir, "#{width}", @metadata.stripSpace)
        FileUtils.mkpath(File.dirname(sizedImageName))

        image.write(sizedImageName)
        @emitedImages[width] = sizedImageName
      end
    end

  end
end
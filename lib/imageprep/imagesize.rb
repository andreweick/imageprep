#!/usr/bin/ruby

require 'rubygems'
require 'bundler/setup'

require 'mini_magick'
require 'fileutils'
require 'date'
require 'erb'

require_relative 'metadata'

module ImagePrep
  class ImageSize    
    # Constant Widths define the sizes that we need the images created at for 
    # picturefill [retina](http://duncandavidson.com/blog/2012/08/retina_ready/)
    
    WIDTHS = [ 320, 480, 768, 900, 640, 960, 1536, 500, 1800 ]
    JPEG_COMPESSION_QUALITY = "75"    # Need to pass as a string

    attr_reader :sourceDir, :sizedDir, :metadata, :emitedImages

    def initialize(imageFileName, sizedDir)
      @metadata = ImagePrep::MetaData.new(imageFileName)
      @sizedDir = sizedDir

      emitSizedImages
    end

    def emitSizedImages
      @emitedImages = Hash.new

      puts "Processing #{metadata.imageFileName}"
      
      # Save source image 
      imageOriginal = MiniMagick::Image.open(@metadata.imageFileName)

      @sizedDirOrignal = File.join(@sizedDir, "original", "#{@metadata.dateTimeOriginal.year}", @metadata.dateTimeOriginal.strftime('%Y-%m-%d'))
      @sizedDirGenerated = File.join(@sizedDir, "generated", "#{@metadata.dateTimeOriginal.year}", @metadata.dateTimeOriginal.strftime('%Y-%m-%d'))

      dest = File.join(@sizedDirOrignal, File.basename(@metadata.imageFileName))
      FileUtils.mkpath File.dirname(dest)
      FileUtils.cp(@metadata.imageFileName, dest)
      
      @emitedImages[@metadata.width] = dest

      WIDTHS.each do |width|
        # Need to keep reloading image because we are resizing it
        image = MiniMagick::Image.open(@metadata.imageFileName)
        
        # I need to pass these two methods strings, so I convert the number to a string
        image.resize("#{width}")
        image.quality(JPEG_COMPESSION_QUALITY)

        sizedImageName = File.join(@sizedDirGenerated, "#{width}", File.basename(@metadata.imageFileName))
        FileUtils.mkpath(File.dirname(sizedImageName))

        image.write(sizedImageName)
        @emitedImages[width] = sizedImageName
      end
    end

    def to_octopress
      "imageName: #{@metadata.imageName}\n" +
      "dateTimeOriginal: #{@metadata.dateTimeOriginal}\n" +
      "headline: #{@metadata.headline}\n" +
      "caption: #{@metadata.caption}\n" 
    end

    # def doWork()
    #   FileUtils.mkpath(File.join(@outDir,"/original/"))  
    #   Dir.glob('test/data/**/*.jpg').each do |file|
    #     puts "File: #{file}"
    #   end
    # end    
  end
end
#!/usr/bin/ruby

require 'rubygems'
require 'bundler/setup'

require 'mini_magick'
require 'fileutils'
require 'date'

require_relative 'metadata'

module ImagePrep
  class ImageSize    
    # Constant Widths define the sizes that we need the images created at for picturefill
    Widths = [ 320, 480, 768, 900, 640, 960, 1536, 500, 1800 ]

    def initialize(outDir)
       @outDir = outDir
    end

    def emitSizedImages(imageList)
      @emitedImages = Hash.new

      imageList.each do |imageFileName|
        puts "Processing #{imageFileName}"
        
        meta = ImagePrep::MetaData.new(imageFileName)
        # Save source image 
        imageOriginal = MiniMagick::Image.open(imageFileName)

        @outDirOrignal = File.join(@outDir, "original", "#{meta.dateTimeOriginal.year}", meta.dateTimeOriginal.strftime('%Y-%m-%d'))
        @outDirGenerated = File.join(@outDir, "generated", "#{meta.dateTimeOriginal.year}", meta.dateTimeOriginal.strftime('%Y-%m-%d'))

        dest = File.join(@outDirOrignal, File.basename(imageFileName))
        FileUtils.mkpath File.dirname(dest)
        FileUtils.cp(imageFileName, dest)
        
        @emitedImages[0] = dest

        Widths.each do |width|
          # Need to keep reloading image because we are resizing it
          image = MiniMagick::Image.open(imageFileName)
          
          # I need to pass these two methods strings, so I convert the number to a string
          image.resize("#{width}")
          image.quality("75")

          sizedImageName = File.join(@outDirGenerated, "#{width}", File.basename(imageFileName))
          FileUtils.mkpath File.dirname(sizedImageName)

          image.write(sizedImageName)
          @emitedImages[width] = sizedImageName
        end
      end

      return @emitedImages
    end

    # def doWork()
    #   FileUtils.mkpath(File.join(@outDir,"/original/"))  
    #   Dir.glob('test/data/**/*.jpg').each do |file|
    #     puts "File: #{file}"
    #   end
    # end    
  end
end
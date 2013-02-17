#!/usr/bin/ruby

require 'rubygems'
require 'bundler/setup'

require 'mini_magick'
require 'fileutils'

module ImagePrep
  class ImageSize
    # Constant Widths define the sizes that we need the images created at for picturefill
    Widths = [ 320, 480, 768, 900, 640, 960, 1536, 500, 1800 ]

    def initialize(outDir, imageList)
      today = Time.new
      @outDirOrignal = File.join(outDir, "original", "#{today.year}", today.strftime('%Y-%m-%d'))
      @outDirGenerated = File.join(outDir, "generated", "#{today.year}", today.strftime('%Y-%m-%d'))

      imageList.each do |imageName|
        emitSizedImages(imageName)
      end
    end

    def emitSizedImages(imageFileName)
      emitedImages = Hash.new

      # Save source image
      dest = File.join(@outDirOrignal, File.basename(imageFileName))
      FileUtils.mkpath File.dirname(dest)
      FileUtils.cp imageFileName, dest
      
      emitedImages[0] = dest

      Widths.each do |width|
        image = MiniMagick::Image.open(imageFileName)
        
        # I need to pass these two methods strings, so I convert the number to a string
        image.resize("#{width}")
        image.quality("75")

        sizedImageName = File.join(@outDirGenerated, "#{width}", File.basename(imageFileName))
        FileUtils.mkpath(File.dirname(sizedImageName))

        image.write(sizedImageName)
        emitedImages[width] = sizedImageName
      end

      return emitedImages
    end

    def doWork()
      FileUtils.mkpath(File.join(@outDir,"/original/"))  
      Dir.glob('test/data/**/*.jpg').each do |file|
        puts "File: #{file}"
      end
    end    
  end
end
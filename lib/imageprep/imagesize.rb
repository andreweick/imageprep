#!/usr/bin/ruby

require 'rubygems'
require 'bundler/setup'

require 'mini_magick'
require 'fileutils'

# Widths that we need the images created at for picturefill
widths = [ 320, 480, 768, 900, 640, 960, 1536, 500, 1800 ]

class ImageSize
  def initialize()
  end

  def deriveName()
  end

  def scaleImage()
  end

  def doWork()  
    Dir.glob('test/data/**/*.jpg').each do |file|
      puts "File: #{file}"

      widths.each do |width|
        image = MiniMagick::Image.open(file)
        
        # regex to get the new file name -- note the double backslash in the capture groups.  This
        # is because I wanted to use the double quotes so that I get variable 
        # replacement with the hash notation.
        #
        newfile = file.gsub(/original\/(.*)\/(.*)/m, "generated/\\1/#{width}/\\2")

        image.resize("#{width}")
        image.quality("75")

        FileUtils.mkpath(File.dirname(newfile))

        image.write(newfile)
        
      end
    end
  end
  
end
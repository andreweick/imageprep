#!/usr/bin/ruby

require 'rubygems'
require 'bundler/setup'

require 'optparse'

options = {}

optparse = OptionParser.new do|opts|
  opts.banner = "Usage: imageprep.rb [options] file1 file2 ..."

  options[:verbose] = false
  opts.on('-v', '--verbose', 'Output more information') do
    options[:verbose] = true
  end

  options[:quick] = false
  opts.on('-q', '--quick', 'Perform the task quickly') do
    options[:quick] = true
  end

  options[:logfile] = nil
  opts.on('-l', '--logfile FILE', 'Write log to FILE') do|file|
    options[:logfile] = file
  end

  opts.on( '-h', '--help', 'Display this screen') do
    puts opts
    exit
  end
end

# Parse the command-line. Remember there are two forms
# of the parse method. The 'parse' method simply parses
# ARGV, while the 'parse!' method parses ARGV and removes
# any options found there, as well as any parameters for
# the options. What's left is the list of files to resize.
optparse.parse!

puts "Being verbose" if options[:verbose]
puts "Being quick" if options[:quick]
puts "Logging to file #{options[:logfile]}" if options[:logfile]

ARGV.each do|f|
  puts "Image #{f}"
end
require 'optparse'

module ImagePrep
  class options

    def initialize(argv)
      parse(argv)
    end

    private
      def parse(argv)
        options = {}

        optparse = OptionParser.new do|opts|
          opts.banner = "Usage: imageprep.rb [options] file1 file2 ..."

          options[:verbose] = false
          opts.on('-v', '--verbose', 'Output more information') do
            options[:verbose] = true
          end

          options[:quiet] = false
          opts.on('-q', '--quietly', 'Perform the task quietly') do
            options[:quiet] = true
          end

          options[:outDir] = nil
          opts.on('-o', '--outDir directory', 'Output directory') do|output_directory|
            options[:outDir] = output_directory
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

        mandatory = [:outDir]
        missing = mandatory.select{ |param| options[param].nil? }
        if not missing.empty?
          puts "Missing options: #{missing.join(', ')}"
          puts optparse
          exit
        end

      end
    end
  end
end
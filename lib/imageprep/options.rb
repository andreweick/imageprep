require 'optparse'

module ImagePrep
  class Options

    attr_reader :images_to_load
    attr_reader :quiet
    attr_reader :verbose
    attr_reader :outDir
    attr_reader :logfile

    def initialize(argv)
      parse(argv)
      @images_to_load = argv
    end

    private
    def parse(argv)
      optparse = OptionParser.new do|opts|
        opts.banner = "Usage: imageprep.rb [options] file1 file2 ..."

        @verbose = false
        opts.on('-v', '--verbose', 'Output more information') do
          @verbose = true
        end

        @quiet = false
        opts.on('-q', '--quietly', 'Perform the task quietly') do
          @quiet = true
        end

        @outDir = nil
        opts.on('-o', '--outDir directory', 'Output directory') do|output_directory|
          @outDir = output_directory
        end

        @logfile = nil
        opts.on('-l', '--logfile FILE', 'Write log to FILE') do|file|
          @logfile = file
        end

        opts.on( '-h', '--help', 'Display this screen') do
          puts opts
          exit
        end

        # Parse the command-line. Remember there are two forms
        # of the parse method. The 'parse' method simply parses
        # ARGV, while the 'parse!' method parses ARGV and removes
        # any options found there, as well as any parameters for
        # the options. What's left is the list of files to resize.
        begin
          argv = ["-h"] if argv.empty?
          opts.parse!(argv)
        rescue OptionParser::ParseError => e
          STDERR.puts e.message, "\n", opts
          exit(-1)
        end

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
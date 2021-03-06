module RSpec::Core
  class Parser
    def self.parse!(args)
      new.parse!(args)
    end

    class << self
      alias_method :parse, :parse!
    end

    def parse!(args)
      if args.include?("--formatter")
        args[args.index("--formatter")] = "--format"
        RSpec.deprecate("the --formatter option", "-f or --format")
      end
      options = {}
      parser(options).parse!(args)
      options
    end

    alias_method :parse, :parse!

    def parser(options)
      OptionParser.new do |parser|
        parser.banner = "Usage: rspec [options] [files or directories]"

        parser.on('-b', '--backtrace', 'Enable full backtrace') do |o|
          options[:full_backtrace] = true
        end

        parser.on('-c', '--[no-]color', '--[no-]colour', 'Enable color in the output') do |o|
          options[:color_enabled] = o
        end
        
        parser.on('-d', '--debug', 'Enable debugging') do |o|
          options[:debug] = true
        end

        parser.on('-e', '--example PATTERN', "Run examples whose full descriptions match this pattern",
                "(PATTERN is compiled into a Ruby regular expression)") do |o|
          options[:full_description] = /#{o}/
        end

        parser.on('-f', '--format FORMATTER', 'Choose a formatter',
                '  [p]rogress (default - dots)',
                '  [d]ocumentation (group and example names)',
                '  custom formatter class name') do |o|
          options[:formatter] = o
        end

        parser.on_tail('-h', '--help', "You're looking at it.") do 
          puts parser
          exit
        end

        parser.on('-I DIRECTORY', 'specify $LOAD_PATH directory (may be used more than once)') do |dir|
          options[:libs] ||= []
          options[:libs] << dir
        end

        parser.on('-l', '--line_number LINE', 'Specify the line number of a single example to run') do |o|
          options[:line_number] = o
        end

        parser.on('-o', '--options PATH', 'Read configuration options from a file path.  (Defaults to .rspec)') do |o|
          options[:options_file] = o || local_options_file
        end
        
        parser.on('-p', '--profile', 'Enable profiling of examples with output of the top 10 slowest examples') do |o|
          options[:profile_examples] = o
        end

        parser.on('-r', '--require PATH', 'Require a file') do |path|
          options[:requires] ||= []
          options[:requires] << path
        end

        parser.on('-v', '--version', 'Show version') do
          puts RSpec::Core::Version::STRING
          exit
        end

        parser.on('-X', '--drb', 'Run examples via DRb') do |o|
          options[:drb] = true
        end

        parser.on('--drb-port [PORT]', 'Port to connect to on the DRb server') do |o|
          options[:drb_port] = o.to_i
        end

      end
    end
  end
end

require 'tempfile'
require 'optparse'

module PuppetGraph
  class CLI
    def self.run
      options = {
        :modulepath => 'modules',
      }
      parser = OptionParser.new do |opts|
        opts.banner = 'Usage: puppet-graph [options]'

        opts.on '-c', '--code CODE', 'Code to generate a graph of' do |val|
          options[:code] = val
        end

        opts.on '-f', '--fact FACT=VALUE', 'Override a Facter fact' do |val|
          key, value = val.split('=')
          (options[:fact] ||= {})[key] = value
        end

        opts.on '-m', '--modulepath PATH', 'The path to your Puppet modules' do |val|
          options[:modulepath] = value
        end

        opts.on '-o', '--output FILE', 'The file to save the graph to' do |val|
          options[:output_file] = val
          if options[:format].nil?
            options[:format] = File.extname(options[:output_file])[1..-1].to_sym
          end
        end

        opts.on '-r', '--format FORMAT', 'Output format (png or dot)' do |val|
          options[:format] = val.to_sym
        end

        opts.on_tail '-h', '--help', 'Show this help output' do
          puts opts
          exit
        end

        opts.on_tail '-v', '--version', 'Show the version' do
          puts "puppet-graph v#{PuppetGraph::VERSION}"
          exit
        end
      end

      parser.parse!

      if options[:code].nil?
        puts "Error: No Puppet code provided to be graphed."
        puts parser
        exit 1
      end

      unless [:dot, :png].include?(options[:format])
        puts "Error: Invalid format specified. Valid formats are: dot, png"
        puts parser
        exit 1
      end

      g = PuppetGraph::Grapher.new
      g.fact_overrides = options[:fact]
      g.modulepath = options[:modulepath]
      g.code = options[:code]
      g.draw(options[:format], options[:output_file])
    end
  end
end

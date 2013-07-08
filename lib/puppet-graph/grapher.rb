module PuppetGraph
  class Grapher
    attr_accessor :fact_overrides
    attr_accessor :modulepath
    attr_accessor :code

    def draw(format, output_file)
      graph = catalogue.to_ral.relationship_graph
      graph.vertices.select { |r| r.to_s == 'Class[Settings]' }.each do |vertex|
        graph.remove_vertex! vertex
      end

      dot_graph = graph.to_dot('label' => code)

      if format == :dot
        File.open(output_file, 'wb') do |f|
          f.puts dot_graph
        end
      elsif format == :png
        tmp_dot_file = Tempfile.new('puppet-graph')
        begin
          tmp_dot_file.write dot_graph
          tmp_dot_file.flush
          `dot -o#{output_file} -Tpng #{tmp_dot_file.path}`
        ensure
          tmp_dot_file.close
          tmp_dot_file.unlink
        end
      end
    end

    def catalogue
      with_tmpdir do |dir|
        Puppet[:modulepath] = modulepath
        Puppet[:vardir] = dir
        Puppet[:confdir] = dir
        Puppet[:logdir] = dir
        Puppet[:rundir] = dir
        Puppet[:code] = code

        if fact_overrides.nil?
          facts = default_facts
        else
          facts = default_facts.merge(fact_overrides)
        end

        facts.each do |key, value|
          Facter.add(key) { setcode { value } }
        end

        node.merge(facts)
        Puppet::Resource::Catalog.indirection.find(node.name, :use_node => node)
      end
    end

    def default_facts
      @default_facts ||= {
        'hostname' => node.name.split('p').first,
        'fqdn'     => node.name,
        'domain'   => node.name.split('.').last,
      }
    end

    def with_tmpdir
      dir = Dir.mktmpdir
      begin
        yield dir
      ensure
        FileUtils.remove_entry_secure dir
      end
    end

    def node
      @node ||= Puppet::Node.new('testnode')
    end
  end
end

require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

begin
  # Load library
  require 'graphviz'

  def font
    (RUBY_PLATFORM =~ /darwin/) ? 'ArialMT' : 'Arial'
  end

  class GraphDefaultTest < MiniTest::Test
    def setup
      @graph = EnumStateMachine::Graph.new('test')
    end

    def test_should_have_a_default_font
      assert_equal font, @graph.font
    end
    
    def test_should_use_current_directory_for_filepath
      assert_equal './test.png', @graph.file_path
    end
    
    def test_should_have_a_default_file_format
      assert_equal 'png', @graph.file_format
    end
    
    def test_should_have_a_default_orientation
      assert_equal 'TB', @graph[:rankdir].source
    end
  end
  
  class GraphNodesTest < MiniTest::Test
    def setup
      @graph = EnumStateMachine::Graph.new('test')
      @node = @graph.add_nodes('parked', :shape => 'ellipse')
    end
    
    def test_should_return_generated_node
      refute_nil @node
    end
    
    def test_should_use_specified_name
      assert_equal @node, @graph.get_node('parked')
    end
    
    def test_should_use_specified_options
      assert_equal 'ellipse', @node['shape'].to_s.gsub('"', '')
    end
    
    def test_should_set_default_font
      assert_equal font, @node['fontname'].to_s.gsub('"', '')
    end
  end
  
  class GraphEdgesTest < MiniTest::Test
    def setup
      @graph = EnumStateMachine::Graph.new('test')
      @graph.add_nodes('parked', :shape => 'ellipse')
      @graph.add_nodes('idling', :shape => 'ellipse')
      @edge = @graph.add_edges('parked', 'idling', :label => 'ignite')
    end
    
    def test_should_return_generated_edge
      refute_nil @edge
    end
    
    def test_should_use_specified_nodes
      assert_equal 'parked', @edge.node_one(false)
      assert_equal 'idling', @edge.node_two(false)
    end
    
    def test_should_use_specified_options
      assert_equal 'ignite', @edge['label'].to_s.gsub('"', '')
    end
    
    def test_should_set_default_font
      assert_equal font, @edge['fontname'].to_s.gsub('"', '')
    end
  end
  
  class GraphOutputTest < MiniTest::Test
    def setup
      @graph_name = "test_#{rand(1000000)}"
      @graph = EnumStateMachine::Graph.new(@graph_name)
      @graph.add_nodes('parked', :shape => 'ellipse')
      @graph.add_nodes('idling', :shape => 'ellipse')
      @graph.add_edges('parked', 'idling', :label => 'ignite')
      @graph.output
    end
    
    def test_should_save_file
      assert File.exist?("./#{@graph_name}.png")
    end
    
    def teardown
      FileUtils.rm Dir["./#{@graph_name}.png"]
    end
  end
rescue LoadError
  $stderr.puts 'Skipping GraphViz EnumStateMachine::Graph tests. `gem install ruby-graphviz` >= v0.9.17 and try again.'
end unless ENV['TRAVIS']

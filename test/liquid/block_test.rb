require 'test_helper'

class BlockTest < Test::Unit::TestCase
  include Liquid

  def test_blankspace
    template = Liquid::Template.parse("  ")
    assert_equal ["  "], template.root.nodelist
  end

  def test_variable_beginning
    template = Liquid::Template.parse("{{funk}}  ")
    assert_equal 2, template.root.nodelist.size
    assert_equal Variable, template.root.nodelist[0].class
    assert_equal StringSlice, template.root.nodelist[1].class
  end

  def test_variable_end
    template = Liquid::Template.parse("  {{funk}}")
    assert_equal 2, template.root.nodelist.size
    assert_equal StringSlice, template.root.nodelist[0].class
    assert_equal Variable, template.root.nodelist[1].class
  end

  def test_variable_middle
    template = Liquid::Template.parse("  {{funk}}  ")
    assert_equal 3, template.root.nodelist.size
    assert_equal StringSlice, template.root.nodelist[0].class
    assert_equal Variable, template.root.nodelist[1].class
    assert_equal StringSlice, template.root.nodelist[2].class
  end

  def test_variable_many_embedded_fragments
    template = Liquid::Template.parse("  {{funk}} {{so}} {{brother}} ")
    assert_equal 7, template.root.nodelist.size
    assert_equal [StringSlice, Variable, StringSlice, Variable, StringSlice, Variable, StringSlice],
                 block_types(template.root.nodelist)
  end

  def test_with_block
    template = Liquid::Template.parse("  {% comment %} {% endcomment %} ")
    assert_equal [StringSlice, Comment, StringSlice], block_types(template.root.nodelist)
    assert_equal 3, template.root.nodelist.size
  end

  def test_with_custom_tag
    Liquid::Template.register_tag("testtag", Block)

    assert_nothing_thrown do
      template = Liquid::Template.parse( "{% testtag %} {% endtesttag %}")
    end
  end

  private
    def block_types(nodelist)
      nodelist.collect { |node| node.class }
    end
end # VariableTest

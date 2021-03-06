require File.dirname(__FILE__) + "/test_helper"

class StaticMatic::RescueTest < Test::Unit::TestCase
  def setup
    setup_staticmatic
  end
  
  should "catch haml template errors" do
    output = @staticmatic.generate_html_with_layout("page_with_error")
    assert_match /StaticMatic::TemplateError/, output 
  end
  
  should "catch sass template errors" do
    output = @staticmatic.generate_css("css_with_error")
    assert_match /StaticMatic::TemplateError/, output 
  end
  
  should "re-raise and catch partial errors" do
    begin
      @staticmatic.generate_html("page_with_partial_error")
    rescue StaticMatic::TemplateError => template_error
      assert_match /partials\/partial_with_error/, template_error.filename
    end
  end
  
  should "handle non-template errors" do
    begin
      raise Exception.new("This is an exception")
    rescue Exception => e
      output = @staticmatic.render_rescue_from_error(e)
    end
    
    assert_match /Exception/, output
    assert_match /This is an exception/, output
  end
end
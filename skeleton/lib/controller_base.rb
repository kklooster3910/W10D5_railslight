require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
    @already_built_response = false
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    # raise if @already_built_response
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    unless @already_built_response
      @res.set_header('Location', url)
      @res.status = 302
      @already_built_response = true
    else
      raise "double render error"
      # @res.render_content 
    end
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    # @res.content = content 
    # @res.content_type = content_type
    # @res[content_type] = content
    # @already_built_response = false   
    if @already_built_response == false
      @res.set_header('Content-Type', content_type)
      @res.write(content)
      @already_built_response = true
    else
      raise "double render error"
    end

  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    file_path = File.dirname(__FILE__)
    path_to_template = File.join(file_path,
    "..", "views", self.class.name.underscore,
     "#{template_name}.html.erb")
    #  puts path_to_template
    # debugger
    #file.dirname, pass in argument __filename__ -- file.join with return value ("..") to go one level up and then pass in the view
    file = File.read(path_to_template) # we want to read when we have the path to the correct file
    erb_code = ERB.new(file).result(binding)
    # puts file
    # puts erb_code
    render_content(erb_code, 'text/html')
  end

  # method exposing a `Session` object
  def session
    
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end


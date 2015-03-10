class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  protect_from_forgery with: :exception

	before_filter do
  	resource = controller_name.singularize.to_sym
  	method = "#{resource}_params"
  	params[resource] &&= send(method) if respond_to?(method, true)
	end

 	private
 
  	def record_not_found
    	render :text => "<h1>Record not found.</h1>", :status => 404
  	end
end

module Finder
  def set_curent_class(curent_class)
  	if params[:id].blank?
  		render inline: "<h1>Record not found.</h1>"
  	else
       @subject = curent_class.find(params[:id]) 
     end
  end
end
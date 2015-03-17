module Finder
  def set_curent_class(curent_class)
	@subject = curent_class.find(params[:id]) 
  end
end
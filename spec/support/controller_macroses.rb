module ControllerMacros

	def self.included(base)
		base.extend(ClassMethods)
	end

	module ClassMethods
	
	#	def it_should_require_admin_for_actions(*actions)
  #    actions.each do |action|
  #      it "#{action} action should require admin" do
  #        get action, :id => 1
  #        response.should redirect_to(login_url)
  #        flash[:error].should == "Unauthorized Access"
  #      end
  #    end
  #  end

		def it_renders_404_page_if_switch_was_not_found(*actions)
			actions.each do |action|
				it "#{action} renders 404 page if switch was not found" do
					verb = if action == :update
						"PATCH"
					elsif action == :destroy
						"DELETE"
					else
						"GET"
					end
					process action, verb, {id: 0}
					response.status.should == 404
				end
			end
		end

	end

end

require 'spec_helper'


describe UsersController do
	 before do
   @admin = create(:admin)
   sign_in @admin
  end

	it_renders_404_page_if_switch_was_not_found :show, :update, :destroy


	describe "index switches" do
		it "show a list of all users" do
    get :index
    assigns(:users).should eq([@admin])
    end
	
		it "renders the :index view" do
    get :index
    expect(response).to render_template('index')
    end
  end

  describe "update user" do

    before do
     @user = create(:manager)
     @role = "admin"
    end

  	it "redirects to index" do
    put :update, role: {user_role:@role}, id: @user.id
    expect(response).to redirect_to(users_path)
    end

    it "check corect add/chenge role" do
    put :update, role: {user_role:@role}, id: @user.id
    assigns(:subject).roles.first.name.should eq @role
    end
  end

  describe "destroy user" do

    it "redirects to index when an switch is destroy" do
    @user = create(:manager)
    delete :destroy, id: @user.id
    expect(response).to redirect_to(users_path)
    end

  end

end
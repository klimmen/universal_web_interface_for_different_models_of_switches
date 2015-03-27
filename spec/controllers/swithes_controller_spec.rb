require 'spec_helper'

describe SwitchesController do

 before do
     @attr = {id: "1", name: "swithc", ip: "1.1.1.1", login: "admin", pass: "password", snmp: "q1w2e3"}
     @switch = create(:switch)
     @user = create(:admin)
    sign_in @user
  end

 
  it_renders_404_page_if_switch_was_not_found :show, :edit, :update, :destroy

    describe "index switches" do

      it "show a list of all switches" do
      get :index
      assigns(:switches).should eq([@switch])
      end

      it "renders the :index view" do
      get :index
      expect(response).to render_template('index')
      end       
    end
    
 	  describe "new switch" do

 		  it "renders new page" do
 		  get :new
      expect(response).to render_template('new')
 	    end

      it "assign a new switch to subject" do
      get :new
      expect(assigns(:subject)).to be_a_new(Switch)
     end
 		end

    describe "create switch" do

      it "creates a new switch" do
      expect{
      post :create, switch: @attr}.to change(Switch,:count).by(1)
      end

      it "redirects to show if valodations pass" do
      post :create, switch: @attr
      expect(response).to redirect_to(switch_path(assigns(:subject)))
      end

      it "renders new page again if valodations fail" do
      post :create, switch: {id: "1", name: "swithc", ip: nil, login: "admin", pass: "password", snmp: "q1w2e3"}    
      expect(response).to render_template('new')
      end
    end
    
    describe "destroy switch" do

      it "redirects to index when an switch is destroy" do
      delete :destroy, id: @switch.id
      expect(response).to redirect_to(switches_path)
      end
    end

    describe "update switch" do

      it "allows a switch to be updated" do
      put :update, id: @switch.id, switch: @attr
      expect(response).to have_http_status(302)
      end

      it "redirects to show if valodations pass" do
      put :update, id: @switch.id, switch: @attr
      expect(response).to redirect_to(switch_path(assigns(:subject)))
      end

      it "renders edit page again if valodations fail" do
      put :update, id: @user.id, switch: {id: "1", name: "swithc", ip: nil, login: "admin", pass: "password", snmp: "q1w2e3"}    
      expect(response).to render_template('edit')
      end

    end

    describe "destroy user" do

    it "redirects to index when an switch is destroy" do
    delete :destroy, id: @switch.id
    expect(response).to redirect_to(switches_path)
    end
  end

end

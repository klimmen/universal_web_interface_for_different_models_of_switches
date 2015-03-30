require 'spec_helper'

describe MibsController do

 before do
     @attr = {name: "name", value_oid_id: "1.2.3.4.5.5"}
     @firmware = create(:firmware)
 		 @mib = create(:mib)
     @model = create(:switch_model)
     @user = create(:admin)
    sign_in @user
  end



  describe "index mibs" do
  
      it "show a list of all mibs" do
      get :index, switch_model_id: @model.id, firmware_id: @firmware.id  
      assigns(:subjects).should eq(@firmware.mibs)
      end

     it "renders the :index view" do
      get :index, switch_model_id: @model.id, firmware_id: @firmware.id  
      expect(response).to render_template('index')
      end       
    end

  describe "new mib" do
  
 		it "renders new page" do
 		get :new, switch_model_id: @model.id, firmware_id: @firmware.id 
    expect(response).to render_template('new')
 	  end

    it "assign a new mib to subject" do
    get :new, switch_model_id: @model.id, firmware_id: @firmware.id 
    expect(assigns(:subject)).to be_a_new(Mib)
   end 
 end

 describe "create mib" do

      it "creates a new mib" do
      expect{
      post :create, mib: @attr, switch_model_id: @model.id, firmware_id: @firmware.id }.to change(Mib,:count).by(1)
      end

      it "renders new page again if valodations fail" do
      post :create, mib: {name: "", value_oid_id: "1.2.3.4.5.5"}, switch_model_id: @model.id, firmware_id: @firmware.id   
      expect(response).to render_template('new')
      end
    end


  describe "update mib" do
        
      it "allows a mib to be updated" do
      put :update, mib: {name: "getModel"}, switch_model_id: @model.id, firmware_id: @firmware.id, id: @mib.id
      expect(response).to have_http_status(302)
      end

      it "redirects to index if valodations pass" do
      put :update, mib: {name: "getModel"}, switch_model_id: @model.id, firmware_id: @firmware.id, id: @mib
      expect(response).to redirect_to(switch_model_firmware_mibs_path(@model.id, @firmware.id, @mib))
      end
    end

    describe "destroy mib model" do

      it "redirects to index when an mib is destroy" do
      delete :destroy, switch_model_id: @model.id, firmware_id: @firmware.id, id: @mib
      expect(response).to redirect_to(switch_model_firmware_mibs_path(@model.id, @firmware.id, @mib))
      end
    end

end
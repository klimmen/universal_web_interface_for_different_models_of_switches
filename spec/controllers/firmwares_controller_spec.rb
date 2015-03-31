require 'spec_helper'

describe FirmwaresController do

 before do
     @model = create(:switch_model)
     @user = create(:admin)
    sign_in @user
  end


  	describe "new frimeware" do
  
 		  it "renders new page" do
 		  get :new, :switch_model_id => @model.id
      expect(response).to render_template('new')
 	    end

      it "assign a new frimeware to subject" do
      get :new, :switch_model_id => @model.id
      expect(assigns(:subject)).to be_a_new(Firmware)
     end 
 		end

 		describe "create firmware" do

      it "creates a new firmware" do
      expect{
      post :create, firmware: {name: "V4.02"}, clone_firmware: { firmware_id: "" }, switch_model_id: @model.id}.to change(Firmware,:count).by(1)
      end
	
      it "creates a new firmware through cloning" do
      firmware_old = create(:firmware) 
      firmware_old.mibs << create(:mib)
      post :create, firmware: {name: "V4.03"}, clone_firmware: { firmware_id: firmware_old.id }, switch_model_id: @model.id
      assigns(:subject).mibs.should eq firmware_old.mibs
      end
   
      it "redirects to swithc model index if valodations pass" do
      post :create, firmware: {name: "V4.02"}, clone_firmware: { firmware_id: "" }, switch_model_id: @model.id
      expect(response).to redirect_to(switch_models_path)
      end

      it "renders new page again if valodations fail" do
      post :create, firmware: {name: nil}, clone_firmware: { firmware_id: "" }, switch_model_id: @model.id
      expect(response).to render_template(:new)
      end
    end

    describe "update firmware" do
      before do
        @firmware_exemple = create(:firmware)
      end
        
      it "allows a firmware to be updated" do
      put :update, firmware: {name: "V4.02"}, switch_model_id: @model.id, id: @firmware_exemple
      expect(response).to have_http_status(302)
      end

      it "redirects to index if valodations pass" do
      put :update, firmware: {name: "V4.02"}, switch_model_id: @model.id, id: @firmware_exemple
      expect(response).to redirect_to(switch_models_path)
      end
    end

    describe "destroy switch model" do

      it "redirects to index when an switch is destroy" do
      @firmware_exemple = create(:firmware)
      delete :destroy, id: @firmware_exemple.id, switch_model_id: @model.id
      expect(response).to redirect_to(switch_models_path)
      end
    end

 end

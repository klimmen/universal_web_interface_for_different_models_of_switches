describe SwitchModelsController do

 before do
     @attr = {name: "zte2928"}
     @model = create(:switch_model)
     @user = create(:admin)
    sign_in @user
  end

 
  it_renders_404_page_if_switch_was_not_found :edit, :update, :destroy

    describe "index switches models" do

      it "show a list of all switch models" do
      get :index
      assigns(:subjects).should eq([@model])
      end

      it "renders the :index view" do
      get :index
      expect(response).to render_template('index')
      end       
    end

    describe "new switch model" do

      it "renders new page" do
      get :new
      expect(response).to render_template('new')
      end

      it "assign a new switch model to subject" do
      get :new
      expect(assigns(:subject)).to be_a_new(SwitchModel)
     end
    end

    describe "create switch model" do

      it "creates a new switch" do
      expect{
      post :create, switch_model: @attr}.to change(SwitchModel,:count).by(1)
      end

      it "redirects to index if valodations pass" do
      post :create, switch_model: @attr
      expect(response).to redirect_to(switch_models_path)
      end
    end

    describe "update switch model" do

      it "allows a switch model to be updated" do
      put :update, id: @model.id, switch_model: @attr
      expect(response).to have_http_status(302)
      end

      it "redirects to index if valodations pass" do
      put :update, id: @model.id, switch_model: @attr
      expect(response).to redirect_to(switch_models_path)
      end

    end
    
    describe "destroy switch model" do

      it "redirects to index when an switch is destroy" do
      delete :destroy, id: @model.id
      expect(response).to redirect_to(switch_models_path)
      end
    end
end
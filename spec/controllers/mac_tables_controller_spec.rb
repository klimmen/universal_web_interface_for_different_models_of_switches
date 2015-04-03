require 'rails_helper'
describe MacTablesController do
  before do
    @user = User.find_by_email("root@mail.ru")
    sign_in @user
  end

  describe "index" do

     it "returns http success" do
      get :index, ip: '172.24.24.240'
      expect(response).to have_http_status(:success)
     end

     it "render the view" do
       get :index, ip: '172.24.24.240'
       expect(response).to render_template('index')
     end

  end

  describe "search" do
    it "returns http success" do
      post :search, ip: '172.24.24.240', search_param: {search_type: "all"}, :format => 'js'
      expect(response).to have_http_status(:success)
    end
    it "render search view with param - port" do
      post :search, ip: '172.24.24.240', search_param: {search_type: "port", search_value: "27"}, :format => 'js'
      expect(response).to render_template('search')
    end

    it "render search view with param - vid" do
      post :search, ip: '172.24.24.240', search_param: {search_type: "vid", search_value: "1"}, :format => 'js'
      expect(response).to render_template('search')
    end

    it "render search view with param - mac" do
      post :search, ip: '172.24.24.240', search_param: {search_type: "mac", search_value: " 00:d0:b7:b0:b5:05"}, :format => 'js'
      expect(response).to render_template('search')
    end

    it "render search view with param - all" do
      post :search, ip: '172.24.24.240', search_param: {search_type: "all"}, :format => 'js'
      expect(response).to render_template('search')
    end

  end

end


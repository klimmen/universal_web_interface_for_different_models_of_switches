require 'rails_helper'
describe MacTablesController do
  before do
    @user = User.find_by_email("root@mail.ru")
    sign_in @user
  end

    it "renders the :index view" do
      get :index, ip: "172.24.24.240", param: :ip
      expect(response).to render_template('index')
    end


end

#RSpec.describe MacTablesController, type: :controller do
  #before do
  #  @user = create(:admin)
  #  sign_in @user
  #end



  #describe "GET #index" do
   #it "returns http success" do
   #  get :index, {ip: '172.24.24.24'}
   #   #expect(response).to have_http_status(:success)
   # end
  #end

#end

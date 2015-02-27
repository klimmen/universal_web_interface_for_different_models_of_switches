require 'test_helper'

class SwitchModelsControllerTest < ActionController::TestCase
  setup do
    @switch_model = switch_models(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:switch_models)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create switch_model" do
    assert_difference('SwitchModel.count') do
      post :create, switch_model: { name: @switch_model.name }
    end

    assert_redirected_to switch_model_path(assigns(:switch_model))
  end

  test "should show switch_model" do
    get :show, id: @switch_model
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @switch_model
    assert_response :success
  end

  test "should update switch_model" do
    patch :update, id: @switch_model, switch_model: { name: @switch_model.name }
    assert_redirected_to switch_model_path(assigns(:switch_model))
  end

  test "should destroy switch_model" do
    assert_difference('SwitchModel.count', -1) do
      delete :destroy, id: @switch_model
    end

    assert_redirected_to switch_models_path
  end
end

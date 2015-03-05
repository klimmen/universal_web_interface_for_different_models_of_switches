require 'test_helper'

class ValueOidsControllerTest < ActionController::TestCase
  setup do
    @value_oid = value_oids(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:value_oids)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create value_oid" do
    assert_difference('ValueOid.count') do
      post :create, value_oid: { name: @value_oid.name }
    end

    assert_redirected_to value_oid_path(assigns(:value_oid))
  end

  test "should show value_oid" do
    get :show, id: @value_oid
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @value_oid
    assert_response :success
  end

  test "should update value_oid" do
    patch :update, id: @value_oid, value_oid: { name: @value_oid.name }
    assert_redirected_to value_oid_path(assigns(:value_oid))
  end

  test "should destroy value_oid" do
    assert_difference('ValueOid.count', -1) do
      delete :destroy, id: @value_oid
    end

    assert_redirected_to value_oids_path
  end
end

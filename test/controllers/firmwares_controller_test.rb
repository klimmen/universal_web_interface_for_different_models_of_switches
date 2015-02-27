require 'test_helper'

class FirmwaresControllerTest < ActionController::TestCase
  setup do
    @firmware = firmwares(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:firmwares)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create firmware" do
    assert_difference('Firmware.count') do
      post :create, firmware: { name: @firmware.name, switch_model_id: @firmware.switch_model_id }
    end

    assert_redirected_to firmware_path(assigns(:firmware))
  end

  test "should show firmware" do
    get :show, id: @firmware
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @firmware
    assert_response :success
  end

  test "should update firmware" do
    patch :update, id: @firmware, firmware: { name: @firmware.name, switch_model_id: @firmware.switch_model_id }
    assert_redirected_to firmware_path(assigns(:firmware))
  end

  test "should destroy firmware" do
    assert_difference('Firmware.count', -1) do
      delete :destroy, id: @firmware
    end

    assert_redirected_to firmwares_path
  end
end

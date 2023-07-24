require "test_helper"

class ManipulatorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @manipulator = manipulators(:one)
  end

  test "should get index" do
    get manipulators_url
    assert_response :success
  end

  test "should get new" do
    get new_manipulator_url
    assert_response :success
  end

  test "should create manipulator" do
    assert_difference("Manipulator.count") do
      post manipulators_url, params: { manipulator: { 名称: @manipulator.名称, 密码: @manipulator.密码, 性别: @manipulator.性别, 类型: @manipulator.类型 } }
    end

    assert_redirected_to manipulator_url(Manipulator.last)
  end

  test "should show manipulator" do
    get manipulator_url(@manipulator)
    assert_response :success
  end

  test "should get edit" do
    get edit_manipulator_url(@manipulator)
    assert_response :success
  end

  test "should update manipulator" do
    patch manipulator_url(@manipulator), params: { manipulator: { 名称: @manipulator.名称, 密码: @manipulator.密码, 性别: @manipulator.性别, 类型: @manipulator.类型 } }
    assert_redirected_to manipulator_url(@manipulator)
  end

  test "should destroy manipulator" do
    assert_difference("Manipulator.count", -1) do
      delete manipulator_url(@manipulator)
    end

    assert_redirected_to manipulators_url
  end
end

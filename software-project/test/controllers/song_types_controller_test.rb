require "test_helper"

class SongTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @song_type = song_types(:one)
  end

  test "should get index" do
    get song_types_url
    assert_response :success
  end

  test "should get new" do
    get new_song_type_url
    assert_response :success
  end

  test "should create song_type" do
    assert_difference("SongType.count") do
      post song_types_url, params: { song_type: { 名称: @song_type.名称 } }
    end

    assert_redirected_to song_type_url(SongType.last)
  end

  test "should show song_type" do
    get song_type_url(@song_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_song_type_url(@song_type)
    assert_response :success
  end

  test "should update song_type" do
    patch song_type_url(@song_type), params: { song_type: { 名称: @song_type.名称 } }
    assert_redirected_to song_type_url(@song_type)
  end

  test "should destroy song_type" do
    assert_difference("SongType.count", -1) do
      delete song_type_url(@song_type)
    end

    assert_redirected_to song_types_url
  end
end

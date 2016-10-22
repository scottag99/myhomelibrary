require 'test_helper'

class Admin::WishlistsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_wishlists_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_wishlists_show_url
    assert_response :success
  end

  test "should get update" do
    get admin_wishlists_update_url
    assert_response :success
  end

  test "should get new" do
    get admin_wishlists_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_wishlists_create_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_wishlists_destroy_url
    assert_response :success
  end

end

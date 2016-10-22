require 'test_helper'

class Admin::WishlistEntriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_wishlist_entries_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_wishlist_entries_show_url
    assert_response :success
  end

  test "should get update" do
    get admin_wishlist_entries_update_url
    assert_response :success
  end

  test "should get new" do
    get admin_wishlist_entries_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_wishlist_entries_create_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_wishlist_entries_destroy_url
    assert_response :success
  end

end

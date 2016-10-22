require 'test_helper'

class CatalogEntriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get catalog_entries_index_url
    assert_response :success
  end

  test "should get show" do
    get catalog_entries_show_url
    assert_response :success
  end

  test "should get update" do
    get catalog_entries_update_url
    assert_response :success
  end

  test "should get new" do
    get catalog_entries_new_url
    assert_response :success
  end

  test "should get create" do
    get catalog_entries_create_url
    assert_response :success
  end

  test "should get destroy" do
    get catalog_entries_destroy_url
    assert_response :success
  end

end

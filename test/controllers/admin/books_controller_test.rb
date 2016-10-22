require 'test_helper'

class Admin::BooksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_books_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_books_show_url
    assert_response :success
  end

  test "should get update" do
    get admin_books_update_url
    assert_response :success
  end

  test "should get new" do
    get admin_books_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_books_create_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_books_destroy_url
    assert_response :success
  end

end

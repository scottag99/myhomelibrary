require 'test_helper'

class Admin::OrganizationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_organizations_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_organizations_show_url
    assert_response :success
  end

  test "should get update" do
    get admin_organizations_update_url
    assert_response :success
  end

  test "should get create" do
    get admin_organizations_create_url
    assert_response :success
  end

  test "should get delete" do
    get admin_organizations_delete_url
    assert_response :success
  end

end

require 'test_helper'

class OrganizationFlowTest < ActionDispatch::IntegrationTest
  test "can see the list of orgs" do
    get admin_organizations_url
    assert_select "h3", "Organization Management"
  end

  test "can create an organization" do
    get new_admin_organization_url
    assert_response :success

    post admin_organizations_url,
      params: { organization: { name: "Test Create", slug: "test-create" } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h3", "Organization Detail"
  end

  test "can edit an organization" do
    get edit_admin_organization_url(organizations(:one))
    assert_response :success

    put admin_organization_url(organizations(:one)),
      params: { organization: { name: "Test Edit", slug: "test-edit" } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h3", "Organization Management"
  end

  test "can delete an organization" do
    delete admin_organization_url(organizations(:two))
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h3", "Organization Management"
  end

  test "can add a volunteer" do
    get admin_organization_url(organizations(:one))
    assert_response :success
    assert_select "h3", "Volunteers"

    get new_admin_organization_partner_url(organizations(:one))
    assert_response :success

    post admin_organization_partners_url(organizations(:one)),
      params: { partner: { name: "Test Volunteer", email: "volunteer@example.com", active: true, is_coordinator: false } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h3", "Volunteers"
  end
end

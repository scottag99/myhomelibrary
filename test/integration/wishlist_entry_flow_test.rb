require 'test_helper'

class WishlistEntryFlowTest < ActionDispatch::IntegrationTest
  test "can add book to wishlist as admin" do
    post admin_organization_campaign_wishlist_wishlist_entries_url(organizations(:one), campaigns(:one), wishlists(:one)),
      params: { wishlist_entry: { catalog_entry_id: catalog_entries(:one).id } }, xhr: true, headers: {'Accept' => 'application/json, text/javascript, */*; q=0.01'}
    assert_equal catalog_entries(:one).price.to_s, JSON.parse(@response.body)['price']
    assert_equal "application/json", @response.content_type
  end

  test "can add book to wishlist as volunteer" do
    post partner_organization_campaign_wishlist_wishlist_entries_url(organizations(:one), campaigns(:one), wishlists(:one)),
      params: { wishlist_entry: { catalog_entry_id: catalog_entries(:one).id } }, xhr: true, headers: {'Accept' => 'application/json, text/javascript, */*; q=0.01'}
    assert_equal catalog_entries(:one).price.to_s, JSON.parse(@response.body)['price']
    assert_equal "application/json", @response.content_type
  end

  test "can remove book to wishlist as admin" do
    post admin_organization_campaign_wishlist_wishlist_entries_url(organizations(:one), campaigns(:one), wishlists(:one)),
      params: { wishlist_entry: { catalog_entry_id: catalog_entries(:one).id } }, xhr: true, headers: {'Accept' => 'application/json, text/javascript, */*; q=0.01'}
    added_id = JSON.parse(@response.body)['id']
    delete admin_organization_campaign_wishlist_wishlist_entry_url(organizations(:one), campaigns(:one), wishlists(:one), added_id), xhr: true, headers: {'Accept' => 'application/json, text/javascript, */*; q=0.01'}
    assert_equal false, JSON.parse(@response.body).nil?
    assert_equal "application/json", @response.content_type
  end

  test "can remove book to wishlist as volunteer" do
    post partner_organization_campaign_wishlist_wishlist_entries_url(organizations(:one), campaigns(:one), wishlists(:one)),
      params: { wishlist_entry: { catalog_entry_id: catalog_entries(:one).id } }, xhr: true, headers: {'Accept' => 'application/json, text/javascript, */*; q=0.01'}
    added_id = JSON.parse(@response.body)['id']
    delete admin_organization_campaign_wishlist_wishlist_entry_url(organizations(:one), campaigns(:one), wishlists(:one), added_id), xhr: true, headers: {'Accept' => 'application/json, text/javascript, */*; q=0.01'}
    assert_equal false, JSON.parse(@response.body).nil?
    assert_equal "application/json", @response.content_type
  end

  test "cannot add book to wishlist that is at limit" do
    assert_raise ActiveRecord::RecordInvalid do
      post admin_organization_campaign_wishlist_wishlist_entries_url(organizations(:one), campaigns(:two), wishlists(:two)),
      params: { wishlist_entry: { catalog_entry_id: catalog_entries(:one).id } }, xhr: true, headers: {'Accept' => 'application/json, text/javascript, */*; q=0.01'}
    end
  end
end

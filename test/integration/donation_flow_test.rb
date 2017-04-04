require 'test_helper'

class DonationFlowTest < ActionDispatch::IntegrationTest
  test "can load wishlist search page" do
    get search_url
    assert_select "h2", "Home Libraries"
  end

  test "can load donation page" do
    get donate_url
    assert_response :success
  end
end

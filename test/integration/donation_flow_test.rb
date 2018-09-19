require 'test_helper'

class DonationFlowTest < ActionDispatch::IntegrationTest
  
  test "can load donation page" do
    get donate_url
    assert_response :success
  end
end

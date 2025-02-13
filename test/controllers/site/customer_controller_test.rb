require "test_helper"

class Site::CustomerControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get site_customer_show_url
    assert_response :success
  end
end

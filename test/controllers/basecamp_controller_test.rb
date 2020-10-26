require 'test_helper'

class BasecampControllerTest < ActionDispatch::IntegrationTest
  test "should get oauth" do
    get basecamp_oauth_url
    assert_response :success
  end

  test "should get callback" do
    get basecamp_callback_url
    assert_response :success
  end

end

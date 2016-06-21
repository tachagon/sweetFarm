require 'test_helper'

class AnalyticsControllerTest < ActionController::TestCase

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should redirect announcements analytics shen not logged in" do
    get :announcement_analytics, last_days: 7
    assert_redirected_to login_url
  end

end

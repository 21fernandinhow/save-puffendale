require "test_helper"

class VillageControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get village_index_url
    assert_response :success
  end
end

require 'test_helper'

class FragmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recipe = recipes(:feijoada)
  end

  test "should get fragments for a recipe" do
    get recipe_fragments_url(recipe_id: @recipe, format: :json)
    assert_response :success
  end
end

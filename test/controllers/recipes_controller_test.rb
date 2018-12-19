require 'test_helper'

class RecipesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recipe = recipes(:feijoada)
  end

  test "it loads recipe show page" do
    get recipe_url(@recipe, format: "text/html")
    assert_response :success
  end

  test "it loads recipe edit page" do
    get edit_recipe_url(@recipe, format: "text/html")
    assert_response :success
  end
end

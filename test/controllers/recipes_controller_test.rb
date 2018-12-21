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

  test "it can update multiple fragment positions" do
    fragment_one = @recipe.fragments.create(fragment_type: "header", position: 1)
    fragment_two = @recipe.fragments.create(fragment_type: "header", position: 2)

    patch recipe_update_fragments_positions_url(@recipe, format: :json),
      params: {
        fragments: {
          fragment_one.id => { position: 2 },
          fragment_two.id => { position: 1 }
        }
      }

    assert_equal fragment_one.reload.position, 2
    assert_equal fragment_two.reload.position, 1
  end
end

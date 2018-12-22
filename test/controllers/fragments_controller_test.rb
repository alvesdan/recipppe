require 'test_helper'

class FragmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recipe = recipes(:feijoada)
    @fragment = @recipe.fragments.create(fragment_type: "header")
  end

  test "should get fragments for a recipe" do
    get recipe_fragments_url(@recipe, format: :json)
    assert_response :success
  end

  test "it can create a title fragment" do
    post recipe_fragments_url(@recipe, format: :json),
      params: { fragment: { fragment_type: "header", html_content: "Feijoada" } }

    assert_equal @recipe.fragments.where(html_content: "Feijoada").first.html_content, "Feijoada"
  end

  test "it can update a title fragment" do
    patch recipe_fragment_url(@recipe, @fragment, format: :json),
      params: { fragment: { html_content: "Feijoada da Boa!" } }

    assert_equal @fragment.reload.html_content, "Feijoada da Boa!"
  end

  test "it can delete a fragment" do
    delete recipe_fragment_url(@recipe, @fragment, format: :json)
    assert_response :success
  end
end

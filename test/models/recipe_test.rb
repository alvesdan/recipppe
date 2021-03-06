require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  test "cannot save recipe without name" do
    recipe = Recipe.new
    assert_not recipe.save
  end

  test "can save recipe with name" do
    recipe = Recipe.new(name: "Feijoada")
    assert recipe.save
  end

  test "it can load fragments" do
    recipe = Recipe.create(name: "Feijoada")
    fragment = recipe.fragments.create(
      fragment_type: "header",
      html_content: "Feijoada"
    )

    assert_equal recipe.fragments.first.html_content, "Feijoada"
  end
end

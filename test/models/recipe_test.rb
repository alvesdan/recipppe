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
    fragment = recipe.fragments.create(fragment_type: "Recipe::Title")
    fragment.create_title(text: "Feijoada")

    assert_equal recipe.fragments.first.title.text, "Feijoada"
  end
end

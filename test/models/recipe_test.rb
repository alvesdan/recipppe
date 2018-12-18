require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "cannot save recipe without name" do
    recipe = Recipe.new
    assert_not recipe.save
  end

  test "can save recipe with name" do
    recipe = Recipe.new(name: "Feijoada")
    assert recipe.save
  end
end

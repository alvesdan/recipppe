require 'test_helper'

class Recipe::TitleTest < ActiveSupport::TestCase
  setup do
    recipe = recipes(:feijoada)
    @fragment = recipe.fragments.create(fragment_type: "Recipe::Title")
  end

  test "it can create a title fragment" do
    title = @fragment.create_title(text: "Feijoada")
    assert title
  end
  
  test "it can access fragment" do
    title = @fragment.create_title(text: "Feijoada")
    assert_equal title.fragment, @fragment
  end
end

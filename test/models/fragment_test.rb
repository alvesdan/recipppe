require 'test_helper'

class FragmentTest < ActiveSupport::TestCase
  setup do
    @recipe = recipes(:feijoada)
  end

  test "it cannot create a fragment without a type" do
    fragment = @recipe.fragments.new
    assert_not fragment.save
  end

  test "it can create fragment with type" do
    fragment = @recipe.fragments.new(fragment_type: "header")
    assert fragment.save
  end
end

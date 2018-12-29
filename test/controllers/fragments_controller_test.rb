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

  test "it can upload an image" do
    file = fixture_file_upload(Rails.root.join('test/fixtures/files/Feijoada.jpg'), 'image/jpeg')
    fragment = @recipe.fragments.create(fragment_type: "image")
    post recipe_fragment_add_image_url(@recipe, fragment, format: :json),
      params: { fragment_image: file }

    assert fragment.images.first
  end

  test "it cannot upload more than 3 images" do
    file = fixture_file_upload(Rails.root.join('test/fixtures/files/Feijoada.jpg'), 'image/jpeg')
    fragment = @recipe.fragments.create(fragment_type: "image")
    3.times { fragment.images.attach(file) }

    post recipe_fragment_add_image_url(@recipe, fragment, format: :json),
      params: { fragment_image: file }
    assert_response :error
  end

  test "it can remove a fragment image" do
    file = fixture_file_upload(Rails.root.join('test/fixtures/files/Feijoada.jpg'), 'image/jpeg')
    fragment = @recipe.fragments.create(fragment_type: "image")
    fragment.images.attach(file)
    image_id = fragment.images.last.id

    delete recipe_fragment_remove_image_url(@recipe, fragment, format: :json),
      params: { image_id: image_id }
    assert_equal fragment.images.size, 0
  end
end

class FragmentsController < ApplicationController
  before_action :load_recipe
  before_action :load_fragment, only: [:update, :add_image, :remove_image, :destroy]

  def index
    @fragments = @recipe.fragments

    respond_to do |format|
      format.json { render json: @fragments }
    end
  end

  def create
    fragment = @recipe.fragments.create!(fragment_params)

    respond_to do |format|
      format.json { render json: fragment }
    end
  end

  def update
    @fragment.update!(fragment_params)

    respond_to do |format|
      format.json { render json: @fragment }
    end
  end

  def add_image
    if @fragment.images.size >= 3
      render json: { error: "You can upload up to 3 images" }, status: 500
      return
    end

    @fragment.images.attach(fragment_image_param)

    respond_to do |format|
      format.json { render json: @fragment }
    end
  end

  def remove_image
    @fragment.images.find(params[:image_id]).purge

    respond_to do |format|
      format.json { render json: @fragment }
    end
  end

  def destroy
    @fragment.destroy!

    respond_to do |format|
      format.json { render json: @fragment }
    end
  end

  protected

  def load_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end

  def load_fragment
    @fragment = @recipe.fragments.find(params[:id] || params[:fragment_id])
  end

  def fragment_params
    params.require(:fragment).permit(:fragment_type, :html_content, :position)
  end

  def fragment_image_param
    params.require(:fragment_image)
  end
end

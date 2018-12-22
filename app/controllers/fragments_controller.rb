class FragmentsController < ApplicationController
  before_action :load_recipe
  before_action :load_fragment, only: [:update, :destroy]

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
    @fragment = @recipe.fragments.find(params[:id])
  end

  def fragment_params
    params.require(:fragment).permit(:fragment_type, :html_content, :position)
  end
end

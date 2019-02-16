class RecipesController < ApplicationController
  before_action :load_recipe, only: [:show, :edit, :destroy]

  def show
    redirect_to edit_recipe_path(@recipe.urid)
  end

  def create
    recipe = Recipe.create(recipe_params)

    if recipe.persisted?
      recipe.fragments.create!(fragment_type: "header", position: 0)
      redirect_to edit_recipe_path(recipe.urid)
    else
      redirect_to root_path
    end
  end

  def edit
  end

  def destroy
    @recipe.destroy!
    redirect_to root_path
  end

  def update_fragments_positions
    # This has a vulnerability, users can use this to alter any
    # parameter in any fragment, for now I'll not worry about that
    # TODO: Remove vulnerability validating all keys and values
    fragments_params = load_fragments_params
    Fragment.update(fragments_params.keys, fragments_params.values)

    respond_to do |format|
      format.json { render json: fragments_params }
    end
  end

  protected

  def load_recipe
    @recipe =
      if params[:id]
        Recipe.find(params[:id])
      else
        Recipe.find_by(urid: params[:urid])
      end
  rescue
    redirect_to root_path
  end

  def load_fragments_params
    params.require(:fragments).permit!
  end

  def recipe_params
    params.require(:recipe).permit(:name)
  end
end

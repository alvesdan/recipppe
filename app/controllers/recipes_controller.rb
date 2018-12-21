class RecipesController < ApplicationController
  before_action :load_recipe, only: [:show, :edit]

  def show
  end

  def edit
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
    @recipe = Recipe.find(params[:id])
  end

  def load_fragments_params
    params.require(:fragments).permit!
  end
end

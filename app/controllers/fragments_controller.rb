class FragmentsController < ApplicationController
  before_action :load_recipe

  def index
    @fragments = @recipe.fragments
  end

  protected

  def load_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end
end

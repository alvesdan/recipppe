class RecipesController < ApplicationController
  before_action :load_recipe, only: [:show, :edit]

  def show
  end

  def edit
  end

  protected

  def load_recipe
    @recipe = Recipe.find(params[:id])
  end
end

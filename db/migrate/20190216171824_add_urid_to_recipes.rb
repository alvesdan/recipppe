class AddUridToRecipes < ActiveRecord::Migration[5.2]
  def change
    add_column :recipes, :urid, :string, limit: 32
  end
end

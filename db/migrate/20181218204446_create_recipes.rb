class CreateRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :published, default: false
      t.timestamps
    end
  end
end

class CreateRecipeTitles < ActiveRecord::Migration[5.2]
  def change
    create_table :recipe_titles do |t|
      t.belongs_to :fragment
      t.string :text
      t.timestamps
    end
  end
end

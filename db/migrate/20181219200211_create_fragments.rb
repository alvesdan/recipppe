class CreateFragments < ActiveRecord::Migration[5.2]
  def change
    create_table :fragments do |t|
      t.belongs_to :recipe
      t.string :fragment_type, null: false
      t.integer :position
      t.timestamps
    end
  end
end

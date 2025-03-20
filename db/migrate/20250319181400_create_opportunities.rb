class CreateOpportunities < ActiveRecord::Migration[8.0]
  def change
    create_table :opportunities do |t|
      t.integer :salary, null: false
      t.string :title, null: false
      t.text :description, null: false
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
    add_index :opportunities, :salary
  end
end

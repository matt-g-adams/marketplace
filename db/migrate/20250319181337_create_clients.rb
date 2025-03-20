class CreateClients < ActiveRecord::Migration[8.0]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.string :email, null: false

      t.timestamps
    end
    add_index :clients, :name
    add_index :clients, :email
  end
end

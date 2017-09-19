class CreateWumembers < ActiveRecord::Migration[5.1]
  def change
    create_table :wumembers do |t|
      t.string :name, null: false
      t.integer :artist_id, null: false

      t.timestamps
    end
  end
end

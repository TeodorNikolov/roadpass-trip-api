class CreateTrips < ActiveRecord::Migration[8.1]
  def change
    create_table :trips do |t|
      t.string :name
      t.string :image_url
      t.text :short_description
      t.text :long_description
      t.integer :rating

      t.timestamps
    end

    add_index :trips, :name
    add_index :trips, :rating
  end
end

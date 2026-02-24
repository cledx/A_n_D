class CreateCharacters < ActiveRecord::Migration[8.1]
  def change
    create_table :characters do |t|
      t.string :name
      t.string :character_class
      t.string :race
      t.text :bio
      t.string :gender

      t.timestamps
    end
  end
end

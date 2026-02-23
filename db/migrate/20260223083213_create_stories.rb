class CreateStories < ActiveRecord::Migration[8.1]
  def change
    create_table :stories do |t|
      t.integer :health_points
      t.integer :level
      t.string :setting
      t.string :mood
      t.string :title
      t.text :summary
      t.references :character, null: false, foreign_key: true

      t.timestamps
    end
  end
end

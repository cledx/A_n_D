class CreateStorySamples < ActiveRecord::Migration[8.1]
  def change
    create_table :story_samples do |t|
      t.string :mood
      t.string :setting
      t.string :summary
      t.text :context

      t.timestamps
    end
  end
end

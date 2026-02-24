class AddContextToStory < ActiveRecord::Migration[8.1]
  def change
    add_column :stories, :context, :text
  end
end

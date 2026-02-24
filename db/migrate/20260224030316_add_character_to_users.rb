class AddCharacterToUsers < ActiveRecord::Migration[8.1]
  def change
    add_reference :characters, :user, null: false, foreign_key: true
  end
end

class AddOptionsToMessages < ActiveRecord::Migration[8.1]
  def change
    add_column :messages, :option_1, :string
    add_column :messages, :option_2, :string
    add_column :messages, :dice_roll, :string
  end
end

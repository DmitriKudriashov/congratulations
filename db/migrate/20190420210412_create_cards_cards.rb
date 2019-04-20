class CreateCardsCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards_cards do |t|

      t.timestamps
    end
  end
end

class CreateTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :types do |t|
      t.string :name, default: '', null: false, index: unique
      t.timestamps
    end
  end
end

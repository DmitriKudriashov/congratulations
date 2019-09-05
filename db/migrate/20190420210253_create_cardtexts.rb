# frozen_string_literal: true

class CreateCardtexts < ActiveRecord::Migration[5.2]
  def change
    create_table :cardtexts do |t|
      t.string :filename
      t.text :text
      t.timestamps
    end
  end
end

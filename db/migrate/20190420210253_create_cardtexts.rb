class CreateCardtexts < ActiveRecord::Migration[5.2]
  def change
    create_table :cardtexts do |t|
      t.string :filename, default: ''
      t.text :text, default: ''
      t.timestamps
    end
  end
end

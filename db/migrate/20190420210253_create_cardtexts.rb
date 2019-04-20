class CreateCardtexts < ActiveRecord::Migration[5.2]
  def change
    create_table :cardtexts do |t|

      t.timestamps
    end
  end
end

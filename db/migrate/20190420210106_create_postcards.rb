class CreatePostcards < ActiveRecord::Migration[5.2]
  def change
    create_table :postcards do |t|

      t.timestamps
    end
  end
end

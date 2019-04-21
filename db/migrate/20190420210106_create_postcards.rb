class CreatePostcards < ActiveRecord::Migration[5.2]
  def change
    create_table :postcards do |t|
      t.string :filename, default: ''
      t.binary :image, limit: 16777216
      t.timestamps
    end
  end
end

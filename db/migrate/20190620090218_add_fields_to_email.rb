class AddFieldsToEmail < ActiveRecord::Migration[5.2]
  def change
    add_column :emails, :checkit, :integer
    add_column :emails, :sent_date, :datetime
  end
end

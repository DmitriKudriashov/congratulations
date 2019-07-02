class AddYearToEmail < ActiveRecord::Migration[5.2]
  def change
     add_column :emails, :year, :integer, default: 0
  end
end

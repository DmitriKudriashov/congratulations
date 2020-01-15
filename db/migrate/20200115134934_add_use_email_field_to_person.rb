class AddUseEmailFieldToPerson < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :this_email_use, :integer
  end
end

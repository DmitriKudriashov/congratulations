class AddPersonToEmail < ActiveRecord::Migration[5.2]
  def change
    add_column :emails, :person_id, :integer, default: 0
  end
end

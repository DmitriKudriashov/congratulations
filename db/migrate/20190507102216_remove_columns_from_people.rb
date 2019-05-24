class RemoveColumnsFromPeople < ActiveRecord::Migration[5.2]
  def change
    remove_column :people, :company_id
    remove_column :people, :country_id
  end
end

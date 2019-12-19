class AddFieldEmailToCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :email, :string, default: ''
    add_index :companies, :email
  end
end

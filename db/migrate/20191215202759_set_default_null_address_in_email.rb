class SetDefaultNullAddressInEmail < ActiveRecord::Migration[5.2]
  def change
    change_column_default :emails, :address, nil
  end
end

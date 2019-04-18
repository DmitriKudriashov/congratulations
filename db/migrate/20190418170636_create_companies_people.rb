class CreateCompaniesPeople < ActiveRecord::Migration[5.2]
  def change
    create_table :companies_people do |t|

      t.timestamps
    end
  end
end

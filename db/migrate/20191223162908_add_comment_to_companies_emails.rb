class AddCommentToCompaniesEmails < ActiveRecord::Migration[5.2]
  def change
    add_column :companies_emails, :comment, :string, default: ''
  end
end

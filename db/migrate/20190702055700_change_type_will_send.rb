class ChangeTypeWillSend < ActiveRecord::Migration[5.2]
  def self.up
    change_column :emails, :will_send, :date
    change_column :emails, :sent_date, :datetime
  end

  def self.down
    change_column :emails, :will_send, :datetime
    change_column :emails, :sent_date, :date
  end

end

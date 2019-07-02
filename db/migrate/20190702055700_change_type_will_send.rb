class ChangeTypeWillSend < ActiveRecord::Migration[5.2]
  def self.up
    change_column :emails, :will_send, :date
  end

  def self.down
    change_column :emails, :will_send, :datetime
  end

end

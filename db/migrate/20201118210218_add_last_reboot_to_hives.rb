class AddLastRebootToHives < ActiveRecord::Migration[6.0]
  def change
    add_column :hives, :last_reboot, :datetime, default: Time.current
  end
end

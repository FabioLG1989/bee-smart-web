class AddLastRebootToHives < ActiveRecord::Migration[6.0]
  def change
    add_column :hives, :last_reboot, default: Time.current
  end
end

class CreateUsersApiariesJoinTable < ActiveRecord::Migration[6.0]
  def change
    create_join_table :users, :apiaries do |t|
      t.index :user_id
      t.index :apiary_id
    end
  end
end

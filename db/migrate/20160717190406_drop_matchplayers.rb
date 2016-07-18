class DropMatchplayers < ActiveRecord::Migration[5.0]
  def change
    drop_table :matchplayers
  end
end

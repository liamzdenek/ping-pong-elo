class CreateMatchplayers < ActiveRecord::Migration[5.0]
  def change
    create_table :matchplayers do |t|
      t.boolean :is_winner

      t.timestamps
    end
  end
end

class CreateElos < ActiveRecord::Migration[5.0]
  def change
    create_table :elos do |t|
      t.integer :day
      t.integer :elo
      t.float :uncertainty

      t.timestamps
    end
  end
end

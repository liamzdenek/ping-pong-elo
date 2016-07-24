class AddMatchBatches < ActiveRecord::Migration[5.0]
  def change
    create_table :batches do |t|
        t.timestamps
    end
    change_table :elos do |t|
        t.integer :player_id, after: :id
        t.integer :batch_id, after: :id
    end
  end
end

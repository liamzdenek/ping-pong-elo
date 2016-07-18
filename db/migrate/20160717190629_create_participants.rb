class CreateParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :participants do |t|
      t.integer :match_id
      t.integer :player_id
      t.boolean :is_winner
    end
  end
end

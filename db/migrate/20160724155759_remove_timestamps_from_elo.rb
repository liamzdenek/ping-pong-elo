class RemoveTimestampsFromElo < ActiveRecord::Migration[5.0]
  def change
    remove_column :elos, :created_at, :string
    remove_column :elos, :updated_at, :string
  end
end

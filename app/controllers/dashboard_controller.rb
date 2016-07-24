class DashboardController < ApplicationController
    before_action :hlogged_in

    def index
        @batch = Batch.last
        @elos = Elo.where(batch_id: Batch.last).order(elo: "DESC", day: "DESC").group(:player_id).limit(100)
        @players = Player.find(@elos.pluck(:player_id))
    end
end

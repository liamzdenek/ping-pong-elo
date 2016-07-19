class DashboardController < ApplicationController
    before_action :hlogged_in

    def index
	    @matches = Match.last(20).reverse()
        @participants = Participant.where(match_id: @matches)
        @players = Player.find(@participants.pluck(:player_id))        
    end
end

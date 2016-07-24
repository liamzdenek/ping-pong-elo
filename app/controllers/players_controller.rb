class PlayersController < ApplicationController
    #before_action :hlogged_in
	
    def index
		
		# root route
	end

    def show
        @player = Player.find(params[:id])
        @participations = Participant.where(player_id: @player)
        match_ids = @participations.pluck(:match_id)
        @opponents = Participant.where(match_id: match_ids)
        @opponents = @opponents.select {|o| !@participations.pluck(:id).include? o.id }
        @matches = Match.find(match_ids)
        @players = Player.find(@opponents.pluck(:player_id))
        batch = Batch.last
        @elos = Elo.where(batch_id: batch, player_id: @player).order(day: "DESC").limit(100)
    end

	def create
		@player = Player.new(create_params)
				
		if @player.valid? && @player.save
			session[:logged_in_as] = @player.id
			redirect_to "/dashboard"
		else
			flash[:register_errors] = @player.errors.full_messages.to_sentence
			redirect_back(fallback_location: "/")
		end
	end

	private
	def create_params
		params.require(:player).permit(:real_name, :email, :password)
	end
end

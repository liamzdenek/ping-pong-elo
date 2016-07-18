class PlayersController < ApplicationController
    before_action :halready_logged_in
	
    def index
		
		# root route
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

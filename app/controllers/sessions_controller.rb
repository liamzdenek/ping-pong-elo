class SessionsController < ApplicationController

	#def new
		# ordinarily show login page, unnecessary here
	#end

	#logout 
	def create
		@player = Player.find_by_email(params[:player][:email])

		error_msg = "Invalid email or password"

		if !@player
			flash[:login_errors] = error_msg 
			redirect_back(fallback_location: "/")
			return
		end

		if !@player.authenticate(params[:player][:password])
			flash[:login_errors] = error_msg 
			redirect_back(fallback_location: "/")
			return
		end

		session[:logged_in_as] = @player.id
		redirect_to "/dashboard"
	end

	# logout
	def destroy
        session.delete(:logged_in_as)
        redirect_to "/"
	end

end

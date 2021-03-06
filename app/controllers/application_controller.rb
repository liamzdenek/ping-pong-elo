class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    private
    def logged_in?
        session.key?(:logged_in_as)
    end

    def hlogged_in
        if !logged_in?
            flash[:login_errors] = "Please log in or register"
            redirect_to "/"
            return true
        end
        return false
    end

    def halready_logged_in
        if logged_in?
            redirect_to "/dashboard"
            return true
        end
        return false
    end
end

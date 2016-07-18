Rails.application.routes.draw do
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	root "players#index"
	resource :players
    resource :sessions
    resource :matches
	
	get "/dashboard", to: "dashboard#index"
end

Rails.application.routes.draw do
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	root "players#index"
	resources :players

    resources :sessions
    resources :matches
    #get '/matches/:match_id' => 'matches#view'
    #get '/matches/:match_id/edit' => 'matches#edit'
     
	get "/dashboard", to: "dashboard#index"
end

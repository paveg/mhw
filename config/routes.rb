Rails.application.routes.draw do
  get 'home/index'

  get 'home/authentication'

  devise_for :users, :controllers => {
      :sessions       => "users/sessions",
      :registrations  => "users/registrations",
      :passwords      => "users/passwords",
      :omniauth_callbacks => "users/omniauth_callbacks"
  }
end

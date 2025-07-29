Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resource "weather", to: "weather#show"
  root "home#index"
end

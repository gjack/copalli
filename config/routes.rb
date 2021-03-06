Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "user/registrations" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
  resources :teams do
    resources :team_members, only: [:new, :create, :show]
  end

  get "/meeting_schedules/:meeting_schedule_id/reschedule_previews", to: "reschedule_previews#index"
  post "/team_members/:team_member_id/meeting_schedules", to: "meeting_schedules#create"
end

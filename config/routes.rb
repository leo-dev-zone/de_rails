Rails.application.routes.draw do
  
  root to: 'visitors#home'
  
  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions'}

  get '/provinces', to: 'provinces#get_by_country', as: 'provinces'

  get '/company', to: 'companies#dashboard', as: 'company_dashboard'

  get '/student', to: 'students#dashboard', as: 'student_dashboard'
  post '/student/update_profile', to: 'students#update_profile', as: 'update_student_profile'
  post '/student/experience', to: 'students#create_experience', as:'create_student_experience'
  delete '/student/:id/experience', to: 'students#destroy_experience', as: 'destroy_student_experience'
  get '/student/company', to: 'students#company_profile', as: 'student_company_profile'
  post '/student/skill', to: 'students#create_skill', as:'create_student_skill'
  post '/student/verify', to: 'students#verify_skills', as: 'verify_student_skills'
  delete '/student/:id/skill', to: 'students#destroy_skill', as: 'destroy_student_skill'
  get '/student/interview/:id/accept', to: 'students#accept_interview', as: 'accept_interview'
  get '/student/interview/:id/deny', to: 'students#deny_interview', as: 'deny_interview'
  delete '/student/:id/interview', to: 'students#destroy_interview', as: 'destroy_student_interview'

  get '/company/profile', to: 'companies#profile', as: 'company_profile'
  post '/company/profile', to: 'companies#update_profile', as: 'company_profile_update'
  post '/company/position', to: 'companies#position', as: 'company_position'
  delete '/company/:id/position', to: 'companies#destroy_position', as: 'company_position_destroy'
  get '/company/candidate', to: 'candidates#new', as: 'company_candidate'
  get '/company/candidate/student', to: 'candidates#get_student', as: 'candidate_profile'
  post '/company/candidate/request-interview', to: 'candidates#request_interview', as: 'request_interview'

  get '/company/interview', to: 'interviews#interview_sent', as: 'interview_sent'
  get '/company/interview-scheduled', to: 'interviews#interview_scheduled', as: 'interview_scheduled'
  get '/company/interview-denied', to: 'interviews#interview_denied', as: 'interview_denied'
  delete '/company/:id/interview', to: 'interviews#destroy', as: 'destroy_interview'
  get '/company/:id/interview', to: 'interviews#view', as: 'view_interview'

end

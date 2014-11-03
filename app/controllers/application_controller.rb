class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  

  # def after_sign_in_path_for(resource)
  #   if resource.first_name.blank?
  #     profile_path
  #   else
  #     dashboard_path
  #   end
  # end
  def get_basedata
    @countries = Country.includes(:provinces).all
    @study_fields = StudyField.all
  end

end

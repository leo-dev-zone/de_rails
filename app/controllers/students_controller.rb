class StudentsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :get_basedata

  def dashboard
    @student = current_user
    @interviews = @student.student_interviews.sent
    @interviews_scheduled = @student.student_interviews.scheduled

    @experience = Experience.new
    @experiences = @student.experiences

    @skill = Skill.new
    @skills = @student.skills
  end

  def update_profile

    @student = current_user
    if @student.update_attributes permit_params
      redirect_to student_dashboard_path, :notice => "Profile is successfully updated."
    else
      redirect_to student_dashboard_path, :alert => "Failed to update profile."
    end

  end

  def create_experience
    @experience = current_user.experiences.build permit_experience_params

    if @experience.save
      redirect_to student_dashboard_path, :notice => "Experience is successfully saved."
    else
      redirect_to student_dashboard_path, :alert => "Failed to save experience."
    end
  end

  def destroy_experience
    @exp = current_user.experiences.find params[:id]

    if @exp.destroy
      redirect_to student_dashboard_path, notice: "Experience was successfully deleted."
    else
      redirect_to student_dashboard_path, alert: "Failed to delete experience."
    end
  end

  def create_skill
    @skill = current_user.skills.build permit_skill_params

    if @skill.save
      redirect_to student_dashboard_path, :notice => "Skill is successfully saved."
    else
      redirect_to student_dashboard_path, :alert => "Failed to save skill."
    end
  end

  def destroy_skill
    @sk = current_user.skills.find params[:id]

    if @sk.destroy
      redirect_to student_dashboard_path, notice: "Skill was successfully deleted."
    else
      redirect_to student_dashboard_path, alert: "Failed to delete skill."
    end
  end
  
  def verify_skills
    current_user.skills.each do |skill|
      skill_list = SkillList.find_by_name(skill.skill)
      student_test = StudentTest.find_or_create_by(
        :user_id       => current_user.id,
        :skill_list_id => skill_list.id
      )

      if student_test.result.nil? || student_test.result < 80.0
        student_test.result = 100.00
        student_test.save
      end
    end
    
    if true
      redirect_to student_dashboard_path, notice: "Skills successfully verified."
    else
      redirect_to student_dashboard_path, alert: "Failed to verify skills."
    end
  end

  def company_profile
    company = User.find(params[:id])
    interview = Interview.find(params[:interview_id])

    if company.nil?
      render :json => {errors: "Could not retrieve company profile."}, status: :unprocessible_entity and return
    else
      company_json = {
        :company_id     => company.id,
        :company_name   => company.company_name,
        :name           => company.name,
        :email          => company.email,
        :country        => company.country_id.nil? ? '' : Country.find(company.country_id).name,
        :position       => company.position,
        :phone_number   => company.phone_number,
        :website        => company.website,
        :photo          => company.photo.url,
        :interview_id   => interview.id,
        :interview_date => interview.interview_datetime.strftime("%Y-%m-%d %I:%M %p"),
        :interview_desc => interview.description
      }.to_json

      render :json => {
        :success => true, 
        :company => company_json
      }, status: :created and return
    end
  end

  def accept_interview
    interview = Interview.find(params[:id])
    interview.update_attributes :status => Interview::ACCEPTED

    redirect_to student_dashboard_path
  end

  def deny_interview
    interview = Interview.find(params[:id])
    interview.update_attributes :status => Interview::DENIED

    redirect_to student_dashboard_path
  end

  def destroy_interview
    interview = Interview.find(params[:id])
    interview.destroy

    redirect_to student_dashboard_path
  end

  private

  def permit_params
    if params[:user][:password].blank?
      params[:user].delete :password
      params[:user].delete :password_confirmation
    end

    if params[:user][:photo].blank?
      params[:user].delete :photo
    end

    params.require(:user).permit :email, :password, :name, :phone_number, :birth_year, :photo,
                                 :academic_status, :study_field_id, :school, :major
  end

  def permit_experience_params
    params.require(:experience).permit :experience, :date_from, :date_to
  end

  def permit_skill_params
    params.require(:skill).permit :skill
  end
end
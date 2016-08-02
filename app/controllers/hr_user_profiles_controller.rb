class HrUserProfilesController < ApplicationController
  before_filter :find_user
  before_filter :find_user_profile, :only => [:edit, :update, :destroy]
  before_filter :update_selected_only, :only => :update

  def edit
    @profiles = HrProfilesCategory.all

    respond_to do |format|
      format.js
    end
  end

  def create
    @user_profile = HrUserProfile.new(user_profile_params)
    if @user_profile.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to edit_user_path(@user.id, :tab => 'profile_history')
    else
      flash[:error] = @user_profile.errors.full_messages.join('<br>')
      redirect_to edit_user_path(@user.id, :tab => 'profile_history', :hr_user_profile => params[:hr_user_profile], :onwards => params[:onwards])
    end
  end

  def update
    @message = ""
    if @user_profile.update_attributes(user_profile_params)
      @flash = 'notice'
      @message = l(:notice_successful_update)
    else
      @flash = 'error'
      @message = @user_profile.errors.full_messages.join('<br>')
      @user_profile.reload
    end

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @message = ""
    begin
      @user_profile.destroy
      @flash = 'notice'
      @message = l(:notice_successful_delete)
    rescue
      @flash = 'error'
      @message = @user_profile.errors.full_messages.join('<br>')
    end

    respond_to do |format|
      format.js
    end
  end

  private
  def find_user
    @user = User.find(params[:user_id])
  end

  def find_user_profile
    @user_profile = HrUserProfile.find(params[:id])
  end

  def update_selected_only
    params[:hr_user_profile] = 
      (@user_profile.present? and params[:hr_user_profile] and params[:hr_user_profile][@user_profile.id.to_s]) ? 
      params[:hr_user_profile][@user_profile.id.to_s] :
      []
    params[:onwards] = 
      (@user_profile.present? and params[:onwards] and params[:onwards][@user_profile.id.to_s]) ?
      params[:onwards][@user_profile.id.to_s] :
      [] 
  end

  def user_profile_params
    params[:hr_user_profile][:user_id] = @user.id
    params[:hr_user_profile][:end_date] = nil if params[:onwards].present?
    params.require(:hr_user_profile).permit(:user_id, :hr_profile_id, :start_date, :end_date)
  end
end
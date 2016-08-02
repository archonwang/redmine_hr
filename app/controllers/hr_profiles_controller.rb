class HrProfilesController < ApplicationController
  layout 'admin'
  before_filter :require_admin

  def index
    @profiles = HrProfile.all.order(:id)
    @categories = HrProfilesCategory.all.order(:id)
  end

  def new
    @profile = HrProfile.new
    @categories = HrProfilesCategory.all
  end

  def create
    @profile = HrProfile.new(profile_params)
    if @profile.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to hr_profiles_path
    else
      @categories = HrProfilesCategory.all
      render :action => 'new'
    end
  end

  def edit
    @profile = HrProfile.find(params[:id])
    @categories = HrProfilesCategory.all
  end

  def update
    @profile = HrProfile.find(params[:id])
    if @profile.update_attributes(profile_params)
      flash[:notice] = l(:notice_successful_update)
      redirect_to hr_profiles_path(:page => params[:page])
    else
      render :action => 'edit'
    end
  end

  def destroy
    HrProfile.find(params[:id]).destroy
    redirect_to hr_profiles_path
  rescue
    flash[:error] = l(:"hr.error_unable_delete_profile")
    redirect_to hr_profiles_path
  end

  private
  def profile_params
    params.require(:hr_profile).permit(:name, :hr_profiles_category_id)
  end
end
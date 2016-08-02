class HrProfilesCategoriesController < ApplicationController
	layout 'admin'
	before_filter :require_admin
  
  def new
    @category = HrProfilesCategory.new
  end

  def create
    @category = HrProfilesCategory.new(profiles_category_params)
    if @category.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to hr_profiles_path
    else
      render :action => 'new'
    end
  end

  def edit
    @category = HrProfilesCategory.find(params[:id])
  end

  def update
    @category = HrProfilesCategory.find(params[:id])
    if @category.update_attributes(profiles_category_params)
      flash[:notice] = l(:notice_successful_update)
      redirect_to hr_profiles_path(:page => params[:page])
    else
      render :action => 'edit'
    end
  end

  def destroy
    HrProfilesCategory.find(params[:id]).destroy
    redirect_to hr_profiles_path
  rescue
    flash[:error] = l(:error_unable_delete_profiles_category)
    redirect_to hr_profiles_path
  end

  private
  def profiles_category_params
    params.require(:hr_profiles_category).permit(:name)
  end
end
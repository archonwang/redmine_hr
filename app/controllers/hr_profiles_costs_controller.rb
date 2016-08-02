class HrProfilesCostsController < ApplicationController
  layout 'admin'
  before_filter :find_profiles, :only => [:index, :edit_year, :update_year]
  before_filter :require_admin
  

  def index
    @year_costs = HrProfilesCost.includes(:profile).where("hr_profile_id IN (?)", @profiles.map(&:id)).group_by(&:year)

    if @year_costs.present?
      @years = @year_costs.keys.sort.reverse
      @next_year = @years.first+1
      @year_options = ((@years.last-5)..(@next_year+5))
    else
      @years = []
      @next_year = Date.today.year
      @year_options = ((@next_year-5)..(@next_year+5))
    end
  end 

  def edit_year
    @year = params[:year]
    @profile_costs = HrProfilesCost.includes(:profile).where(year: @year)

    respond_to do |format|
      format.js
    end
  end

  def update_year
    @year = params[:year]
    @profile_costs = HrProfilesCost.includes(:profile).where(year: @year)
    @message = ""

    HrProfilesCost.transaction do
      errors = HrProfilesCost.update(params[:hr_profiles_cost].keys, params[:hr_profiles_cost].values).map(&:get_errors).flatten

      if errors.present?
        @flash = 'error'
        @message = errors.join('<br>').html_safe
        raise ActiveRecord::Rollback, @message
      else
        @flash = 'notice'
        @message = l(:notice_successful_update)
      end
    end

    respond_to do |format|
      format.js
    end
  end

  def create_year
    data = []

    params[:values].each do |k,v|
      element = {}
      element[:year] = params[:year]
      element[:hr_profile_id] = k
      element[:hourly_cost] = v.present? ? v : HrProfilesCost::DEFAULT_HOURLY_COST
      data << element
    end

    HrProfilesCost.transaction do
      errors = HrProfilesCost.create(data).map(&:get_errors).flatten

      if errors.present?
        message = errors.join('<br>').html_safe
        flash['error'] = message
        raise ActiveRecord::Rollback, message
      else
        flash['notice'] = l(:notice_successful_create)
      end
    end

    redirect_to :action => 'index'
  end

  def destroy_year
    HrProfilesCost.transaction do
      errors = HrProfilesCost.destroy_all(year: params[:year]).map(&:get_errors).flatten

      if errors.present? or HrProfilesCost.where(year: params[:year]).present?
        message = errors.present? ? errors.join('<br>').html_safe : l(:"hr.error_unable_destroy")
        flash['error'] = message
        raise ActiveRecord::Rollback, message
      else
        flash['notice']= l(:notice_successful_delete)
      end
    end
    
    redirect_to :action => 'index'
  end

  private
  def find_profiles
    @profiles = params[:profile_category].present? ? HrProfile.category(params[:profile_category]).order(:id) : HrProfile.all.order(:id)
  end
end
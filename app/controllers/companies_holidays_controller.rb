# frozen_string_literal: true

class CompaniesHolidaysController < AuthenticatedController
  before_action :set_companies_holidays, only: %i[index]
  before_action :find_companies_holiday, only: %i[show edit update destroy]
  before_action :find_holiday, only: %i[new] # create]
  # before_action :find_company, only: %i[new create]

  def index; end

  def new
    if @holiday.nil?
      @companies_holiday = CompaniesHoliday.new
      @companies_holiday.holiday_id = Holiday.first
      @companies_holiday.company_id = Company.first
    else
      @companies_holiday = @holiday.companies_holidays.new
    end
  end

  def new_company_holiday
    @companies_holiday = CompaniesHoliday.new
  end

  def edit; end

  def update
    if @companies_holiday.update(companies_holiday_params)
      redirect_to redirect_after, notice: 'Companies-Holiday was successfully updated.'
    else
      render :edit
    end
  end

  def show; end

  def redirect_after
    companies_holidays_path #edit_holiday_path(@companies_holiday.holiday_id)
  end

  def create
    @companies_holiday = @holiday.nil? ? CompaniesHoliday.new(companies_holiday_params) : @holiday.companies_holidays.new(companies_holiday_params)
    if @companies_holiday.save
      redirect_to redirect_after, notice: 'Successully created!'
    else
      render :new
    end
  end

  def destroy
    destroy_common(@companies_holiday)
    redirect_to redirect_after
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")
  end

  private

  def find_holiday
    # byebug
    @holiday = Holiday.find(params[:holiday_id]) unless params[:holiday_id].nil?
  end

  def find_company
    @company = Company.find(params[:company_id])
  end

  def set_companies_holidays
    @companies_holidays = CompaniesHoliday.joins(:company, :holiday).order('companies.name', 'holidays.name') #.paginate(page: params[:page])
  end

  def find_companies_holiday
    @companies_holiday = CompaniesHoliday.find(params[:id])
  end

  def companies_holiday_params
    params.require(:companies_holiday).permit(:company_id, :holiday_id)
  end

  def rescue_with_companies_holiday_not_found
    render plain: 'CompaniesHoliday record was not found!'
  end
end

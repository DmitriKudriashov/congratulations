class CompaniesHolidaysController < ApplicationController

  before_action :set_companies_holidays, only: %i[index]
  before_action :find_companies_holiday, only: %i[show edit update destroy]
  before_action :find_holiday, only: %i[new] #create]
  # before_action :find_company, only: %i[new create]

  def index; end

  def new
    @companies_holiday =  @holiday.nil? ? CompaniesHoliday.new : @holiday.companies_holidays.new
    @companies_holiday.holiday_id = 1
    @companies_holiday.company_id = 1
  end

  def new_company_holiday
    @companies_holiday =  CompaniesHoliday.new
  end

  def edit; end

  def update

    if @companies_holiday.update(companies_holiday_params)
      redirect_to holiday_path(@companies_holiday.holiday), notice: 'Date was successfully updated.'
    else
      render :edit
    end
  end

  def show; end

  def create
    # byebug
    @companies_holiday = CompaniesHoliday.new(companies_holiday_params)#@holiday.companies_holidays.new(companies_holiday_params)
    # byebug
    if @companies_holiday.save
      # byebug
      redirect_to holiday_companies_holidays_path(@companies_holiday.holiday_id), notice: 'Successully created!'
    else
      render :new
    end
  end

  def destroy
    if @companies_holiday.destroy  # надо бы проверить на успешность удаления
      redirect_to holiday_path(@companies_holiday.holiday_id), notice: 'Date was successfully Destroy!'
    end
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")
  end

  private

  def find_holiday
    @holiday = Holiday.find(params[:holiday_id]) unless params[:holiday_id].nil?
  end

  def find_company
    @company = Company.find(params[:company_id])
  end

  def set_companies_holidays
    @companies_holidays = CompaniesHoliday.all
  end

  def find_companies_holiday
    @companies_holiday = CompaniesHoliday.find(params[:id])
  end

  def companies_holiday_params
    params.require(:companies_holiday).permit(:company_id, :holiday_id)
  end

  def rescue_with_companies_holiday_not_found
    render plain: 'Dates Holiday record was not found!'
  end
end

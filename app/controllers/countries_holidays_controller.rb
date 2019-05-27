class CountriesHolidaysController < ApplicationController
  before_action :set_countries_holidays, only: %i[index]
  before_action :find_countries_holiday, only: %i[show edit update destroy]
  before_action :find_holiday, only: %i[new] #create]
  # before_action :find_country, only: %i[new create]

  def index; end

  def new
    @countries_holiday =  @holiday.nil? ? CountriesHoliday.new : @holiday.countries_holidays.new
    @countries_holiday.holiday_id = 1
    @countries_holiday.country_id = 1
  end

  def new_country_holiday
    @countries_holiday =  CountriesHoliday.new
  end

  def edit; end

  def update

    if @countries_holiday.update(countries_holiday_params)
      redirect_to holiday_path(@countries_holiday.holiday), notice: 'CountriesHoliday was successfully updated.'
    else
      render :edit
    end
  end

  def show; end

  def create
    @countries_holiday = CountriesHoliday.new(countries_holiday_params)  # @holiday.countries_holidays.new(countries_holiday_params)
    if @countries_holiday.save
      redirect_to holiday_countries_holidays_path(@countries_holiday.holiday_id), notice: 'Successully created!'
    else
      render :new
    end
  end

  def destroy
    if @countries_holiday.destroy  # надо бы проверить на успешность удаления
      redirect_to holiday_path(@countries_holiday.holiday_id), notice: 'CountriesHoliday was successfully Destroy!'
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

  def find_country
    @country = Company.find(params[:country_id])
  end

  def set_countries_holidays
    @countries_holidays = CountriesHoliday.all
  end

  def find_countries_holiday
    @countries_holiday = CountriesHoliday.find(params[:id])
  end

  def countries_holiday_params
    params.require(:countries_holiday).permit(:country_id, :holiday_id)
  end

  def rescue_with_countries_holiday_not_found
    render plain: 'CountriesHoliday record was not found!'
  end
end

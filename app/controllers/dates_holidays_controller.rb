class DatesHolidaysController < ApplicationController
  # before_action :set_dates_holidays, only: %i[index]
  before_action :find_dates_holiday, only: %i[show edit update destroy]
  before_action :find_holiday, only: %i[new create]

  def index
    find_holiday
    @dates_holidays = @holiday.nil? ? DatesHoliday.all : @holiday.dates_holidays
  end

  def new
    # byebug
    @dates_holiday = @holiday.nil? ? DatesHoliday.new : @holiday.dates_holidays.new

    # byebug
  end

  def edit; end

  def update
    if @dates_holiday.update(dates_holiday_params)
      redirect_to dates_holiday_path(@dates_holiday), notice: 'Date was successfully updated.'
    else
      render :edit
    end
  end

  def show; end

  def create

    @dates_holiday = @holiday.nil? ?  DatesHoliday.new(dates_holiday_params) : @holiday.dates_holidays.new(dates_holiday_params)
    if @dates_holiday.save
      if @holiday.nil?
        redirect_to dates_holidays_path, notice: 'Successully created!'
      else
        redirect_to dates_holiday_path(@dates_holiday), notice: 'Successully created!'
      end
    else
      render :new
    end
  end

  def destroy
    if @dates_holiday.destroy  # надо бы проверить на успешность удаления
      if @holiday.nil?
        redirect_to dates_holidays_path, notice: 'Date was successfully Destroy!'
      else
        redirect_to holiday_path(@dates_holiday.holiday_id), notice: 'Date was successfully Destroy!'
      end

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

  def set_dates_holidays
    @dates_holidays = DatesHoliday.all
  end

  def find_dates_holiday
    @dates_holiday = DatesHoliday.find(params[:id])
  end

  def dates_holiday_params
    params.require(:dates_holiday).permit(:day, :month, :year, :holiday_id)
  end

  def rescue_with_dates_holiday_not_found
    render plain: 'DateHoliday record was not found!'
  end
end

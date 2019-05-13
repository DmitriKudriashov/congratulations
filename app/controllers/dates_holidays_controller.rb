class DatesHolidaysController < ApplicationController
  before_action :set_dates_holidays, only: %i[index]
  before_action :find_dates_holiday, only: %i[show edit update destroy]
  before_action :find_holiday, only: %i[new create]

  def index; end

  def new
    @dates_holiday =  @holiday.dates_holidays.new
  end

  def edit; end

  def update
    if @dates_holiday.update(dates_holiday_params)
      redirect_to holiday_path(@dates_holiday.holiday), notice: 'Date was successfully updated.'
    else
      render :edit
    end
  end

  def show; end

  def create
    @dates_holiday = @holiday.dates_holidays.new(dates_holiday_params) # DatesHoliday.new(dates_holiday_params)
    if @dates_holiday.save
      redirect_to dates_holiday_path(@dates_holiday.holiday), notice: 'Successully created!'
    else
      render :new
    end
  end

  def destroy
    if @dates_holiday.destroy  # надо бы проверить на успешность удаления
      redirect_to holiday_path(@dates_holiday.holiday_id), notice: 'Date was successfully Destroy!'
    end
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")
  end

  private

  def find_holiday
    @holiday = Holiday.find(params[:holiday_id])
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
    render plain: 'Dates Holiday record was not found!'
  end
end

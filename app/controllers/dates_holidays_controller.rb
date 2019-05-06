class DatesHolidaysController < ApplicationController
  before_action :set_dates_holidays, only: %i[index]
  before_action :find_dates_holiday, only: %i[show edit update destroy]

  def index;  end

  def new
    @dates_holiday = Dates_holiday.new
  end

  def edit; end

  def update
    if @dates_holiday.update(dates_holiday_params)
      redirect_to dates_holiday_path(@dates_holiday)
    else
      render :edit
    end
  end


  def show; end

  def create
    @dates_holiday = Dates_holiday.new(dates_holiday_params)
    if @dates_holiday.save
      redirect_to dates_holiday_path(@dates_holiday), notice: 'Success!'
    else
      render :new
    end
  end

  def destroy
    @dates_holiday.destroy
    redirect_to dates_holidays_path, notice: 'Destroy !'
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")
  end

  private

  def set_dates_holidays
    @dates_holidays = Dates_holiday.all
  end

  def find_dates_holiday
    @dates_holiday = Dates_holiday.find(params[:id])
  end

  def dates_holiday_params
    params.require(:dates_holiday).permit(:day, :month, :year, :holiday_id)
  end

  def rescue_with_dates_holiday_not_found
    render plain: 'Dates Holiday record was not found!'
  end
end

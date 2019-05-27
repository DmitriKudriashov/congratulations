class HolidaysController < ApplicationController
  # before_action :set_holidays, only: %i[index]
  before_action :find_holiday, only: %i[show update destroy]
  before_action :set_holiday_companies, only: %i[show edit]

  def index
    set_holidays
  end

  def new
    @holiday = Holiday.new
  end

  def edit; end

  def update
    if @holiday.update(holiday_params)
      redirect_to holiday_path(@holiday)
    else
      render :edit
    end
  end


  def show; end

  def create
    @holiday = Holiday.new(holiday_params)
    if @holiday.save
      # redirect_to holiday_path(@holiday), notice: 'Success!'
      redirect_to holidays_path, notice: 'Success!'
    else
      render :new
    end
  end

  def destroy
    @holiday.destroy
    redirect_to holidays_path, notice: 'Destroy !'
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")
  end

  private

  def set_holidays
    @holidays = Holiday.all
  end

  def find_holiday
    @holiday = Holiday.find(params[:id])
  end

  def set_holiday_companies
    @companies_holidays = find_holiday.companies_holidays
  end
  def holiday_params
    params.require(:holiday).permit(:name, :type_id)
  end

  def rescue_with_holiday_not_found
    render plain: 'Holiday was not found!'
  end
end

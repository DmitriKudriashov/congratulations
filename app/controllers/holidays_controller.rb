# frozen_string_literal: true

class HolidaysController < AuthenticatedController
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
      redirect_to holidays_path
    else
      render :edit
    end
  end

  def show; end

  def create
    @holiday = Holiday.new(holiday_params)
    if @holiday.save
      redirect_to holidays_path, notice: 'Saved Successfully!'
    else
      render :new
    end
  end

  def destroy
    destroy_common(@holiday)
    redirect_to holidays_path
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")
  end

  private

  def set_holidays
    @holidays = Holiday.order(:name) #.paginate(page: params[:page])
  end

  def find_holiday
    @holiday = Holiday.find(params[:id])
  end

  def set_holiday_companies
    @companies_holidays = find_holiday.companies_holidays
  end

  def holiday_params
    params.require(:holiday).permit(:name, :type_id, :calc)
  end

  def rescue_with_holiday_not_found
    render plain: 'Holiday was not found!'
  end
end

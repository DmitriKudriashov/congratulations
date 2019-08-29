# frozen_string_literal: true

class DatesHolidaysController < AuthenticatedController
  before_action :find_dates_holiday, only: %i[show edit update destroy]
  before_action :find_holiday, only: %i[new create index]

  def index
    @dates_holidays = @holiday.nil? ? set_dates_holidays : @holiday.dates_holidays
    @dates_holidays = @dates_holidays.order(:month, :day)
    view_left unless params[:logsign].present?
  end

  def view_left
    today = Time.now
    month = today.month
    day = today.day
    @dates_holidays = @dates_holidays.where("month > ? or (month = ? and day >= ?)", month, month, day)
  end

  def new
    @dates_holiday = @holiday.nil? ? DatesHoliday.new : @holiday.dates_holidays.new
  end

  def edit; end

  def update
    render :edit unless dates_holiday_params[:date].present?
    if @dates_holiday.update(dates_holiday_params)
      redirect_after('Date was successfully updated.!')
    else
      render :edit
    end
  end

  def show; end

  def redirect_after(notice)
    if @holiday.nil?
      redirect_to dates_holidays_path, notice: notice
    else
      redirect_to dates_holidays_path, notice: notice
     end
  end

  def create
    @dates_holiday = @holiday.nil? ? DatesHoliday.new(dates_holiday_params) : @holiday.dates_holidays.new(dates_holiday_params)
    render :new unless dates_holiday_params[:date].present?
    if @dates_holiday.save
      redirect_after('Successully created!')
    else
      render :new
    end
  end

  def destroy
    redirect_after('Date was successfully Destroy!') if @dates_holiday.destroy
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")
  end

  private

  def find_holiday
    @holiday = Holiday.find(params[:holiday_id]) if params[:holiday_id].present?
  end

  def set_dates_holidays
    @dates_holidays = DatesHoliday.paginate(page: params[:page])
  end

  def find_dates_holiday
    @dates_holiday = DatesHoliday.find(params[:id])
  end

  def dates_holiday_params
    params[:dates_holiday][:day] = params[:dates_holiday][:date].to_date.day
    params[:dates_holiday][:month] = params[:dates_holiday][:date].to_date.month
    holiday = Holiday.find(params[:dates_holiday][:holiday_id])
    params[:dates_holiday][:year] = holiday.calc.present? ? params[:dates_holiday][:date].to_date.year : 0
    params.require(:dates_holiday).permit(:holiday_id, :date, :day, :month, :year)
  end

  def rescue_with_dates_holiday_not_found
    render plain: 'DateHoliday record was not found!'
  end
end

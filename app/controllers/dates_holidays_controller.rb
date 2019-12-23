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
    @dates_holidays = @dates_holidays.where('(month > ? or (month = ? and day >= ?) ) or (? > 9 and month = 1 ) ', month, month, day, month)
  end

  def new
    @dates_holiday = @holiday.nil? ? DatesHoliday.new : @holiday.dates_holidays.new
  end

  def edit; end

  def update
    if already_exists?
      error_message
      render :edit
    else
      @dates_holiday.update(dates_holiday_params)
      redirect_after('Date was successfully updated.!')
    end
  end

  def show; end

  def create
    @dates_holiday = @holiday.nil? ? DatesHoliday.new(dates_holiday_params) : @holiday.dates_holidays.new(dates_holiday_params)
    if @dates_holiday.save
      set_date_year_holiday
      @dates_holiday.save
      redirect_after('Successully created!')
    else
      error_message
      render :new
    end
  end

  def destroy
    if @dates_holiday.destroy
      redirect_to dates_holidays_path, notice: 'Date was successfully Destroy!'
    end
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")
  end

  private

  def set_date_year_holiday
    @date = dates_holiday_params[:date].to_date
    @new_holiday = Holiday.find(dates_holiday_params[:holiday_id])
    @year = @new_holiday.calc.to_i.zero? ? 0 : @date.year

    @dates_holiday.year = @year
  end

  def already_exists?
    set_date_year_holiday
    date_holiday_existing = DatesHoliday.holiday_to_date(@new_holiday.id, @date.day, @date.month, @year).first
    date_holiday_existing.present? ? check_exists_id_with_current_id(date_holiday_existing) : false
  end

  def check_exists_id_with_current_id(date_holiday_existing)
    date_holiday_existing.id.eql?(@dates_holiday.id) ? false : true
  end

  def error_message
    set_date_year_new_holiday
    flash[:alert] = "On this date ( #{@date.day} / #{@date.strftime('%B')} ) this is holiday: #{@new_holiday.name} -> Already Exist !"
  end

  def redirect_after(notice)
    redirect_to dates_holidays_path, notice: notice
  end

  def find_holiday
    @holiday = Holiday.find(params[:holiday_id]) unless params[:holiday_id].to_i.eql?(0)
  end

  def set_dates_holidays
    @dates_holidays = DatesHoliday.paginate(page: params[:page])
  end

  def find_dates_holiday
    @dates_holiday = DatesHoliday.find(params[:id])
  end

  def dates_holiday_params
    params.require(:dates_holiday).permit(:holiday_id, :date, :day, :month, :year)
  end

  def rescue_with_dates_holiday_not_found
    render plain: 'DateHoliday record was not found!'
  end
end

class DatesHolidaysController < AuthenticatedController
  # before_action :set_dates_holidays, only: %i[index]
  before_action :find_dates_holiday, only: %i[show edit update destroy]
  before_action :find_holiday, only: %i[new create]

  def index
    find_holiday
    @dates_holidays = @holiday.nil? ? DatesHoliday.all : @holiday.dates_holidays
    @dates_holidays = @dates_holidays.order(:month, :day)
    today = Time.now()
    month = today.month
    day = today.day
    @dates_holidays = @dates_holidays.where("month > ? or (month = ? and day >= ?)", month, month, day)
  end

  def new
    @dates_holiday = @holiday.nil? ? DatesHoliday.new : @holiday.dates_holidays.new
  end

  def edit; end

  def update
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
    @dates_holiday = @holiday.nil? ?  DatesHoliday.new(dates_holiday_params) : @holiday.dates_holidays.new(dates_holiday_params)
    if @dates_holiday.save
      redirect_after('Successully created!')
    else
      render :new
    end
  end

  def destroy
    if @dates_holiday.destroy
       redirect_after('Date was successfully Destroy!')
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

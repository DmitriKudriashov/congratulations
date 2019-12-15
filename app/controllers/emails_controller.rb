# frozen_string_literal: true

class EmailsController < AuthenticatedController
  before_action :find_email, only: %i[show update destroy]
  before_action :set_email_cards, only: %i[show edit]
  before_action :set_email_texts, only: %i[show edit]
  before_action :set_companies_emails, only: %[show edit]

  def index
    year = Time.now.year
    @emails = Email.all.order(will_send: :desc).paginate(page: params[:page]) # where(year: year)
  end

  def new
    @email = Email.new
  end

  def edit
    set_companies_emails
    # binding.pry
  end

  def update
    email_previous = Email.find(params[:id])
    # unless already_exists?(holiday_id: email_params[:holiday_id].to_i, person_id: email_previous.person_id, year: email_params[:will_send].to_date.year, id:  email_previous.id)
    unless already_exists?(holiday_id: email_params[:holiday_id].to_i, year: email_params[:will_send].to_date.year, id:  email_previous.id)
      begin
        @email.update(email_params)

      rescue ActiveRecord::RecordNotUnique => e
        flash[:alert] = 'Emails Already Exist !'
        render :edit
        return
      end
      @email.year = @email.will_send.year
      @email.save
      flash[:notice] = 'Update SUCCESSFULY !'
      redirect_to emails_path
    else
      flash[:alert] = "The Email for this Holiday in #{email_previous.year} Already Exist !"
      render :edit
    end
  end

  def send_e
    find_email
    if @email.checkit.to_i.eql?(0)
      flash[:alert] = ' This is NOT CHECKED Email yet ! '
    elsif @email.will_send > Date.today
      flash[:alert] = " Will be send #{@email.will_send} ! "
    else
      retvalue = @email.send_now(current_user)
      if retvalue.nil?
        flash[:alert] = "Don't sended message to: #{@email.address}! "
      elsif @email.error_sent.present?
        flash[:alert] = " ERROR SEND EMAIL ! #{@email.error_sent.message} "
      else
        flash[:notice] = ' This is Email Sent SUCCESSFULY ! '
      end
    end
    redirect_to emails_path
  end

  def show; end

  def create_emails
    date_from = Date.today
    date_to = date_from + 30

    (date_from..date_to).each do |will_send_date|
      set_holiday(will_send_date)
    end
    redirect_to emails_path
  end

  def create
    @email = Email.create(email_params)
    @email.year = @email.will_send.year
    begin
      @email.save
    rescue ActiveRecord::RecordNotUnique => e
      flash[:alert] = 'Emails Already Exist !'
      render :new
      return
    end
    redirect_to emails_path, notice: 'Crete New Email Successfully!'
  end

  def destroy
    redirect_to emails_path if destroy_common(@email)
  end

  def destroy_unchecked
    Email.where(checkit: 0).each do |email|
      @email = email
      email.destroy
    end
    redirect_to emails_path
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")
  end

  private

  def set_holiday(date)

    # 1) Holidays w/o calc option Holiday
    holidays_in_date = DatesHoliday.holidays_to_date(date.day, date.month, 0).joins(:holiday)
    process_by_dates(holidays_in_date, date, 0) if holidays_in_date.present?

    # # 2) Holidays with calc option Holiday
    # holidays_in_date = DatesHoliday.holidays_to_date(date.day, date.month, date.year).joins(:holiday)
    # process_by_dates(holidays_in_date, date, date.year) if holidays_in_date.present?

    # # Birthday's
    # list_companies_id = []
    # people_birthdays = Person.birthdays_to_date(date.day, date.month)
    # people_birthdays.each do |person|
    #   list_companies_id = loop_by_mail_addresses(person, list_companies_id)
    # end

    # return unless list_companies_id.present?

    # holiday = Holiday.where(name: 'Birthday').first
    # holiday_date = DatesHoliday.create_date_holiday(date, holiday)

    # create_emails_for_date(holiday_date, date, list_companies_id)
  end


  def process_by_dates(holidays_in_date, date, year)
    holidays_in_date.each do |holiday_date|
      holiday = Holiday.find(holiday_date.holiday_id)
      if holiday.name.upcase == "BIRTHDAY"
        list_companies_id = create_list_companies_id_birthday(holiday, date, year)
        create_emails_for_date(holiday_date, date, list_companies_id)
      else
        list_companies_id = create_list_emails(date, year)
        create_emails_for_date(holiday_date, date, list_companies_id)
      end
    end
  end

  def create_list_emails(date, year)
    # list_emails = MailAddress.left_outer_joins(companies_person: [company: [
    #     {country: [countries_holidays: [holiday: :dates_holidays]]},
    #     {companies_holidays: [holiday: :dates_holidays]}
    #   ]]).where(
    #   "(dates_holidays.holiday_id=? or dates_holidays_holidays.holiday_id=?) and companies_people.company_id=? "
    #   ,holiday.id, holiday.id, ).distinct

      list_emails_holiday = Company.joins(companies_holidays: [holiday: :dates_holidays])
        .where("dates_holidays.day=? and dates_holidays.month=? and dates_holidays.year=?", date.day, date.month, year.to_i)
      list_emails_country = Company.joins(country: [countries_holidays: [holiday: :dates_holidays]])
        .where("dates_holidays.day=? and dates_holidays.month=? and dates_holidays.year=?", date.day, date.month, year.to_i)

      array_id_companies_holidays = []
      list_emails_holiday.each {|x| array_id_companies_holidays << x.id}
      array_companies_countries = []
      list_emails_country.each {|x| array_companies_countries << x.id }
      (array_id_companies_holidays + array_companies_countries).uniq.sort!

      # list_companies_id = []
      # list_emails_holiday.each {|x| list_companies_id << x.id}
      # list_emails_country.each {|x| list_companies_id << x.id}
      # list_companies_id.uniq!.sort!
  end

  # def filter
  #   "(dates_holidays.holiday_id=? or dates_holidays_holidays.holiday_id=?) and companies.id=?"
  # end

  def create_list_companies_id_birthday(holiday, date, year)
    # нужен список людей и имайлов для компаний, которых нужно поздравить с этим праздником
    # MailAddress.joins([{companies_person: [:person, {company: [{companies_holidays: [holiday: :dates_holidays]},{country: :countries_holidays }]}]}], :emails).select('emails.id').order('dates_holidays.id')

    people_holiday =  Person.left_outer_joins(companies_people: [company: [{companies_holidays: [holiday: :dates_holidays]}, {country: :countries_holidays}]])
      .where("(countries_holidays.holiday_id = ? or companies_holidays.holiday_id = ?)
      and dates_holidays.day = ? and dates_holidays.month=? and dates_holidays.year=?",
      holiday.id, holiday.id, date.day, date.month, year ).uniq

    list_companies_id = []
    people_holiday.each do |person|
      list_companies_id = loop_by_mail_addresses(person, list_companies_id)
    end

     list_companies_id
  end

  def loop_by_mail_addresses(person, list_companies_id)
    person.companies_people.each do |companies_person|
      mail_address = MailAddress.where(companies_person_id: companies_person.id).first
      mail_address = MailAddress.create([{ email: person.email, companies_person_id: companies_person.id }]).first unless mail_address.present?
      list_companies_id << companies_person.company_id
    end
    list_companies_id
  end

  def create_emails_for_date(holiday_date, will_send_date, list_companies_id)
    return if holiday_date.nil?
    for_holiday = Holiday.find(holiday_date.holiday_id)

    subject = for_holiday.name.upcase == 'BIRTHDAY' ? 'HAPPY BIRTHDAY!' : "#{for_holiday.name.upcase} GREETINGS!"
    address = ''
    return unless list_companies_id.present?
    i = 0
    person_name = 'Dear colleagues'
    person_id = 0
    # list_companies_id.each do |data_hash|
    #   i += 1
    #   if i == 1
    #     person = Person.find(data_hash[:person_id])
    #     person_name  =  person.name
    #     person_id = person.id
    #   end
    #   address += "#{MailAddress.find(data_hash[:mail_address_id]).email}, "
    # end
    # address = address[0..(address.size - 3)] if address[-2] == ','
    # binding.pry

    @email_new = create_new_email(
      name: person_name,
      subject: subject,
      holiday_id: for_holiday.id,
      address: '' ,
      mail_address_id: 0,
      # person_id: 0,
      checkit: 0,
      will_send: will_send_date,
      year: will_send_date.year,
      message: add_cardtext(for_holiday).to_s
    )
    if @email_new.present?
      add_postcard(@email_new)
      create_list_mail_recipient(@email_new, list_companies_id)
     end
  end


  def already_exists?(opt = {})
    email = Email.where(holiday_id: opt[:holiday_id], year: opt[:year])
    if email.present?
      if opt[:id].present?
        return email.first.id.to_i == opt[:id].to_i ? false : true
      else
        return true
      end
    else
      return false
    end
  end

  def create_new_email(opt = {})
    @email_new = Email.new
    @email_new.set_email_fields(opt)
    unless already_exists?(opt)
      return @email_new if @email_new.save
    end

  end

  def create_list_mail_recipient(email, list_companies_id)
    list_companies_id.each do |company_id|
      company_email = CompaniesEmail.create([{email_id: email.id, company_id: company_id}])
    end
  end

  def add_postcard(email)
    cards_no_using_id = free_postcard(email)
    # binding.pry
    return unless cards_no_using_id.present?
    begin
      new_link_email_card = EmailCard.create([{email_id: email.id, postcard_id: cards_no_using_id}])
    rescue ActiveRecord::RecordNotUnique => e
      flash[:alert] = "This postcard: #{Postcard.find(cards_no_using_id).nane} Already Attached  !"
      return
    end
  end

  def free_postcard(email)
    postcards_for_holiday = Postcard.where(holiday_id: email.holiday_id)
    unless postcards_for_holiday.present?
      holiday = Holiday.find(email.holiday_id)
      flash[:alert] = "Not found Postcards for Holiday: #{holiday.name} "
      return
    end
    array_postcards_ids = free_card_ids_array(email)
    # binding.pry
    array_postcards_ids.present? ? array_postcards_ids.sort[0] : nil
  end

  def free_card_ids_array(email)
    holiday_postcards_all = Postcard.where(holiday_id: email.holiday_id).select(:id)
    # person_cards_used = Postcard.left_outer_joins(email_cards: :email).where(postcards: {holiday_id: email.holiday_id}, emails: {person_id: email.person_id}).select(:id).uniq
    holiday_cards_used = Postcard.joins(email_cards: :email).where(postcards: {holiday_id: email.holiday_id}).select(:id).uniq
    # binding.pry
    make_array(holiday_postcards_all) - make_array(holiday_cards_used)
  end

  def make_array(array_objects)
    ids = []
    array_objects.each { |object| ids << object.id }
    ids
  end


  def add_cardtext(holiday)
    texts = Cardtext.where(holiday_id: holiday.id).order(updated_at: :desc).first.text.to_s
    # return '' unless texts.present?
    # texts.order(updated_at: :desc).first.text
  end

  def set_emails
    year = Time.now.year
    @emails = Email.where(year: year).order(updated_at: :desc)
  end

  def find_email
    @email = Email.find(params[:id])
  end

  def set_email_cards
    @email_cards = find_email.email_cards
  end

  def set_companies_emails
    # binding.pry
    @companies_emails = find_email.companies_emails #CompaniesEmail.where(email_id: params[:id])
  end

  def set_email_texts
    @email_texts = find_email.email_texts
  end

  def email_params
    params.require(:email).permit(:name, :subject, :address, :mail_address_id, :sent_date, :checkit, :holiday_id, :will_send, :message, :year)
  end

  def rescue_with_email_not_found
    render plain: 'Email was not found!'
  end
end

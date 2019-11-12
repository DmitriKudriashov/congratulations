# frozen_string_literal: true

class EmailsController < AuthenticatedController
  before_action :find_email, only: %i[show update destroy]
  before_action :set_email_cards, only: %i[show edit]
  before_action :set_email_texts, only: %i[show edit]

  def index
    year = Time.now.year
    @emails = Email.all.order(will_send: :desc).paginate(page: params[:page]) # where(year: year)
  end

  def new
    @email = Email.new
  end

  def edit; end

  def update
    email_previous = Email.find(params[:id])
    unless already_exists?(holiday_id: email_params[:holiday_id].to_i, person_id: email_previous.person_id, year: email_params[:will_send].to_date.year, id:  email_previous.id)
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

    # dates_holidays = DatesHoliday.holidays_in_period(date_from, date_to)
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
    destroy_related_texts_cards(@email)
    destroy_common(@email)
    redirect_to emails_path
  end

  def destroy_related_texts_cards(email)
    email_texts = EmailText.where(email_id: email.id)
    email_texts.each(&:destroy) if email_texts.present?

    email_cards = EmailCard.where(email_id: email.id)
    email_cards.each(&:destroy) if email_cards.present?
  end

  def destroy_unchecked
    Email.all.where(checkit: 0).each do |email|
      # byebug
      @email = email
      destroy_related_texts_cards(email)
      email.destroy
    end
    redirect_to emails_path
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")
  end

  private

  def process_by_dates(holiday_dates, date)
    holiday_dates.each do |holiday_date|
      holiday = Holiday.find(holiday_date.holiday_id)
      list_people_mails = create_list_people_mails(holiday)
      create_emails_for_date(holiday_date, date, list_people_mails)
    end
  end

  def set_holiday(date)

    # 1) Holidays w/o calc option Holiday
    holiday_dates = DatesHoliday.holidays_to_date(date.day, date.month, 0).joins(:holiday)
    process_by_dates(holiday_dates, date) if holiday_dates.present?

    # 2) Holidays with calc option Holiday
    holiday_dates = DatesHoliday.holidays_to_date(date.day, date.month, date.year).joins(:holiday)
    process_by_dates(holiday_dates, date) if holiday_dates.present?

    # Birthday's
    list_people_mails = []
    people_birthdays = Person.birthdays_to_date(date.day, date.month)
    people_birthdays.each do |person|
      list_people_mails = loop_by_mail_addresses(person, list_people_mails)
    end

    return unless people_birthdays.present?

    holiday = Holiday.where(name: 'Birthday').first
    holiday_date = DatesHoliday.create_date_holiday(date, holiday)

    create_emails_for_date(holiday_date, date, list_people_mails)
  end

  def create_list_people_mails(holiday)
    # нужен список людей и имайлов для компаний, которых нужно поздравить с этим праздником
    # MailAddress.joins([{companies_person: [:person, {company: [{companies_holidays: [holiday: :dates_holidays]},{country: :countries_holidays }]}]}], :emails).select('emails.id').order('dates_holidays.id')

    people_holiday =  Person.joins(companies_people: [company: [companies_holidays: :holiday]])
                            .left_outer_joins(companies_people: [company: [country: [countries_holidays: :holiday]]])
                            .where("holidays.id = ? ", holiday.id).order(:name).uniq

    list_people_mails = []
    people_holiday.each do |person|
      list_people_mails = loop_by_mail_addresses(person, list_people_mails)
    end

     list_people_mails
  end

  def loop_by_mail_addresses(person, list_people_mails)
    person.companies_people.each do |companies_person|
      mail_address = MailAddress.where(companies_person_id: companies_person.id).first # .order(updated_at: :desc)
      mail_address = MailAddress.create([{ email: person.email, companies_person_id: companies_person.id }]).first unless mail_address.present?
      list_people_mails << hash_for_mail(person, mail_address, companies_person)
    end
    list_people_mails
  end

  def hash_for_mail(person, mail_address, companies_person)
    data_hash = {}
    data_hash[:person_id] = person.id
    data_hash[:mail_address_id] = mail_address.id
    data_hash[:companies_id] = companies_person.company_id
    data_hash
  end

  def create_emails_for_date(holiday_date, will_send_date, list_people_mails)
    return if holiday_date.nil?
    for_holiday = Holiday.find(holiday_date.holiday_id)

    subject = for_holiday.name.upcase == 'BIRTHDAY' ? 'HAPPY BIRTHDAY!' : "#{for_holiday.name.upcase} GREETINGS!"
    list_people_mails.each do |data_hash|
      person = Person.find(data_hash[:person_id])
      create_new_email(
        name: " #{person.name}",
        subject: subject,
        holiday_id: for_holiday.id,
        address: person.email,
        mail_address_id: data_hash[:mail_address_id],
        will_send: will_send_date,
        person_id: person.id,
        checkit: 0,
        year: will_send_date.year,
        message: add_cardtext(for_holiday).to_s
      )
    end
  end

  def set_email_fields(email, opt = {})
    email.name = opt[:name]
    email.holiday_id = opt[:holiday_id]
    email.address = opt[:address]
    email.mail_address_id = opt[:mail_address_id]
    email.checkit = opt[:checkit]
    email.will_send = opt[:will_send]
    email.message = opt[:message]
    email.person_id = opt[:person_id]
    email.year = opt[:will_send].year
    email.subject = opt[:subject]
  end

  def already_exists?(opt = {})
    email = Email.where(holiday_id: opt[:holiday_id], year: opt[:year], person_id: opt[:person_id])
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
    set_email_fields(@email_new, opt)
    unless already_exists?(opt)
      @email_new.save
      add_postcard(@email_new)
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
    array_postcards_ids.present? ? array_postcards_ids.sort[0] : nil
  end

  def free_card_ids_array(email)
    holiday_cards = all_cards_for_holiday(email.holiday_id)
    person_cards_used = already_used_card_person_for_holiday(email.holiday_id, email.person_id)
    make_array(holiday_cards) - make_array(person_cards_used)
  end

  def make_array(array_objects)
    ids = []
    array_objects.each { |object| ids << object.id }
    ids
  end

  def already_used_card_person_for_holiday(holiday_id, person_id)
    Postcard.all.left_outer_joins(email_cards: :email).where(postcards: {holiday_id: holiday_id}, emails: {person_id: person_id}).select(:id).uniq
  end

  def all_cards_for_holiday(holiday_id)
    Postcard.all.where(holiday_id: holiday_id).select(:id)
  end

  def add_postcard(email)
    cards_no_using_id = free_postcard(email)
    return unless cards_no_using_id.present?

    begin
      new_link_email_card = EmailCard.create(
        email_id: email.id,
        postcard_id: cards_no_using_id
      )
    rescue ActiveRecord::RecordNotUnique => e
      flash[:alert] = "This postcard: #{Postcard.find(cards_no_using_id).nane} Already Attached  !"
      return
    end
  end

  def add_cardtext(holiday)
    texts = Cardtext.where(holiday_id: holiday.id)
    return '' unless texts.present?

    texts.order(updated_at: :desc).first.text
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

  def set_email_texts
    @email_texts = find_email.email_texts
  end

  def email_params
    params.require(:email).permit(:name, :subject, :address, :mail_address_id, :sent_date, :checkit, :holiday_id, :will_send, :message, :person_id, :year)
  end

  def rescue_with_email_not_found
    render plain: 'Email was not found!'
  end
end

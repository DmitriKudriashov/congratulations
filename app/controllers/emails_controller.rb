# frozen_string_literal: true

class EmailsController < AuthenticatedController
  # before_action :set_emails, only: %i[index]
  before_action :find_email, only: %i[show update destroy]
  before_action :set_email_cards, only: %i[show edit]
  before_action :set_email_texts, only: %i[show edit]

  def index
    year = Time.now.year
    @emails = Email.where(year: year).order(updated_at: :desc).paginate(page: params[:page]) # set_emails
  end

  def new
    @email = Email.new
  end

  def edit; end

  def update
    begin
      @email.update(email_params)
    rescue ActiveRecord::RecordNotUnique => e
      flash[:alert] = 'Emails Already Exist !'
      render :edit
      return
    end
    @email.year = @email.will_send.year
    if already_exists?(holiday_id: @email.holiday_id, person_id: @email.person_id, year: @email.year)
      @email.save
      flash[:notice] = 'Update SUCCESSFULY !'
      redirect_to emails_path
    else
      flash[:alert] = "The Email for this Holiday in #{@email.year} Already Exist !"
      render :edit
    end
  end

  def send_e
    find_email
    if @email.checkit.to_i.eql?(0)
      flash[:alert] = ' This is NOT CHECKED Email yet ! '
    else
      GreetingsMailer.send_message(@email, current_user).deliver_now
      flash[:notice] = ' This is Email Sent SUCCESSFULY ! '
    end
    redirect_to emails_path
  end

  def show; end

  def create_emails
    set_holiday(Time.now)
    redirect_to emails_path
  end

  def create
    @email = Email.create(email_params)
    @email.year = @email.will_send.year
    # set_email_fields(@email, email_params) #
    begin
      @email.save
    rescue ActiveRecord::RecordNotUnique => e
      flash[:alert] = 'Emails Already Exist !'
      render :new
      return
    end
    # redirect_to email_path(@email), notice: 'Success!'
    redirect_to emails_path, notice: 'Crete New Email Successfully!'
  end

  def destroy
    email_texts = EmailText.where(email_id: @email.id)
    email_texts.each(&:destroy) if email_texts.present?

    email_cards = EmailCard.where(email_id: @email.id)
    email_cards.each(&:destroy) if email_cards.present?

    @email.destroy

    redirect_to emails_path # , notice: 'Destroy !'
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")
  end

  private

  def set_year(date)
    date.year # DatesHoliday.where(holiday_id: params[:holiday_id]).order(year: :desc)
  end

  def set_holiday(date)
    d = date.day
    m = date.month
    y = date.year

    holiday_dates = DatesHoliday.holidays_to_date(d, m, 0).joins(:holiday)
    # byebug

    holiday_dates.each do |holiday_date|
      holiday = Holiday.find(holiday_date.holiday_id)
      list_people_mails = create_list_people_mails(holiday)

      createemails(holiday, list_people_mails)
    end

    # Birthday's
    list_people_mails = []
    people_birthdays = Person.birthday(date)
    people_birthdays.each do |person|
      list_people_mails = loop_by_mail_addreses(person, list_people_mails)
    end
    return unless people_birthdays.present?

    holiday = Holiday.where(name: 'Birthday').first
    DatesHoliday.create_date_holiday(date, holiday)

    createemails(holiday, list_people_mails)
  end

  def create_list_people_mails(holiday)
    # нужен список людей и имайлов для компаний, которых нужно поздравить с этим праздником
    # MailAddress.joins([{companies_person: [:person, {company: [{companies_holidays: [holiday: :dates_holidays]},{country: :countries_holidays }]}]}], :emails).select('emails.id').order('dates_holidays.id')

    people_holiday = Person.joins(companies_people: [company: [companies_holidays: :holiday]]).where("holidays.id = #{holiday.id}").order(:name)

    list_people_mails = []
    people_holiday.each do |person|
        list_people_mails = loop_by_mail_addreses(person, list_people_mails)
    end
    list_people_mails
  end

  def loop_by_mail_addreses(person, list_people_mails)
    person.companies_people.each do |companies_person|
      MailAddress.where(companies_person_id: companies_person.id).each do |m|
        data_hash = {}
        data_hash[:person_id] = person.id
        data_hash[:mail_address_id] = m.id
        data_hash[:companies_id] = companies_person.company_id
        list_people_mails << data_hash
      end
    end
    list_people_mails
  end

  def createemails(for_holiday, list_people_mails)
    holiday_date = DatesHoliday.where(holiday_id: for_holiday.id).first
    return if holiday_date.nil?
    month = holiday_date.month
    day = holiday_date.day
    year = Time.now.year #holiday_date.year == 0 ? Time.now.year : holiday_date.year
    will_send = Date.new(year, month, day)

    list_people_mails.each do |data_hash|
      person = Person.find(data_hash[:person_id])
      # mail_address = MailAddress.find(data_hash[:mail_address_id])

      create_new_email({
                         name: " #{person.name},  #{for_holiday.name}",
                         holiday_id: for_holiday.id,
                         address: person.email,
                         mail_address_id: data_hash[:mail_address_id],
                         will_send: will_send,
                         person_id: person.id,
                         checkit: 0,
                         year: will_send.year,
                         message: "Conratulations! Happy: #{for_holiday.name} \n #{add_cardtext(for_holiday)}"
                       })
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
  end

  def already_exists?(opt = {})
    Email.where(holiday_id: opt[:holiday_id], year: opt[:year], person_id: opt[:person_id]).present?
  end

  def create_new_email(opt = {})
    @email_new = Email.new
    set_email_fields(@email_new, opt)

    unless Email.where(holiday_id: opt[:holiday_id], year: opt[:year], person_id: opt[:person_id]).present?
      @email_new.save

      add_postcard(@email_new)
      # add_cardtext(email_new)

      # flash[:notice] = " Created New Emails ! "
      # else
      # flash[:alert] = "Emails Already Exist! "
    end
  end

  def free_postcard(email)
    holiday = Holiday.find(email.holiday_id)
    postcards_for_holiday = Postcard.for_holiday_id(holiday.id)
    unless postcards_for_holiday.present?
      flash[:alert] = "Not found Postcards for Holiday: #{holiday.name} "
      return
    end

    already_using_cards = postcards_for_holiday.joins(email_cards: :email).where(emails: {year: Date.today.year})

    if already_using_cards.present?
      return already_using_cards.first.id #select_year(Date.today.year).first.id
    else
      return  postcards_for_holiday.first.id
    end

    # cards_for_holiday = postcards_for_holiday.left_outer_joins(email_cards: [email: :person])
    # unless cards_for_holiday.present?
    #   flash[:alert] = "Not found Postcards for Holiday: #{holiday.name} "
    #   return
    # end

    # cards_ids = cards_for_holiday.select(:id)

    # cards_for_holiday.where('people.id = ?', email.person_id)

    # only_null = cards_ids.where('people.id is null')
    # unless cards_ids.present?
    #   flash[:alert] = "Not found FREE Postcards for Holiday: #{holiday.name}  "

    #   return
    # end

    # if only_null.first.nil?
    #   flash[:alert] = "Not found NEW Postcards for Holiday: #{holiday.name}  "
    #   return

    # end

    # only_null.order(updated_at: :desc).first.id
  end

  def add_postcard(email)
    cards_no_using_id = free_postcard(email)
    return if cards_no_using_id.nil?

    begin
      new_link_email_card = EmailCard.create(
        email_id: email.id,
        postcard_id: cards_no_using_id
      )
    rescue ActiveRecord::RecordNotUnique => e
      flash[:alert] = "This postcard: #{Postcard.find(cards_no_using_id).nane} Already Attached  !"
      return
    end
    # flash[:notice] =   "Successfully Added  Post Card "
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
    params.require(:email).permit(:name, :address, :mail_address_id, :sent_date, :checkit, :holiday_id, :will_send, :message, :person_id, :year)
  end

  def rescue_with_email_not_found
    render plain: 'Email was not found!'
  end
end

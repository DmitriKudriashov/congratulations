class EmailsController < AuthenticatedController
  # before_action :set_emails, only: %i[index]
  before_action :find_email, only: %i[show update destroy]
  before_action :set_email_cards, only: %i[show edit]
  before_action :set_email_texts, only: %i[show edit]

  def index
    set_emails
  end

  def new
    @email = Email.new
  end

  def edit; end

  def update
    begin
      @email.update(email_params)
    rescue ActiveRecord::RecordNotUnique => e
      flash[:alert] =   "Emails Already Exist !"
      render :edit
      return
    end
    flash[:notice] = 'Update SUCCESSFULY !'
    redirect_to emails_path
  end

  def send_e
    find_email
    if @email.checkit == 0
      flash[:alert] = " This is NOT CHECKED Email yet ! "
    else
      GreetingsMailer.send_message(@email).deliver_now
      flash[:notice] = " This is Email Sent SUCCESSFULY ! "
    end
      redirect_to emails_path
  end

  def show; end

  def create_emails

      set_holiday(Time.now)

      redirect_to emails_path
  end

  def create
    @email = Email.new(email_params)
    begin
      @email.save
    rescue ActiveRecord::RecordNotUnique => e
      flash[:alert] =   "Emails Already Exist !"
      render :new
      return
    end
      # redirect_to email_path(@email), notice: 'Success!'
      redirect_to emails_path, notice: 'Crete New Email Successfully!'
  end

  def destroy
    @email.destroy
    redirect_to emails_path, notice: 'Destroy !'
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")
  end

  private

  def set_holiday(date)
    d = date.day
    m = date.month
    y = date.year

    holiday_dates = DatesHoliday.holidays_to_date(d, m, 0).joins(:holiday)
    holiday_dates.each do |holiday_date|
      holiday = Holiday.find(holiday_date.holiday_id)
      createemails(holiday)
    end
    # ps = Postcard.joins(:email_cards).joins(:emails)
  end

  def create_list_people_mails(holiday)
    # нужен список людей и имайлов для компаний, которых нужно поздравить с этим праздником
    # MailAddress.joins([{companies_person: [:person, {company: [{companies_holidays: [holiday: :dates_holidays]},{country: :countries_holidays }]}]}], :emails).select('emails.id').order('dates_holidays.id')

    people_holiday = Person.joins(companies_people: [company: [companies_holidays: :holiday]] ).
                            where("holidays.id = #{holiday.id}").order(:name)

    list_people_mails = []
    people_holiday.each do |person|
      person.companies_people.each do |companies_person|
        MailAddress.where(companies_person_id: companies_person.id).each do |m|
          data_hash = {}
          data_hash[:person_id] = person.id
          data_hash[:mail_address_id] = m.id
          data_hash[:companies_id] = companies_person.company_id
          list_people_mails << data_hash
        end
      end
    end
    list_people_mails
  end

# pc = Postcard.left_outer_joins(:email_cards).select(:id).distinct.where('email_cards.id is null')
# pc = Postcard.left_outer_joins(email_cards: [ email: [ mail_address: [companies_person: [ :person, {company: [companies_holidays: :holiday]}]]]]).select(:id).distinct.where('email_cards.id is null')
# pc_company_id = Postcard.left_outer_joins(email_cards: [ email: [ mail_address: [companies_person: [ :person, {company: [companies_holidays: :holiday]}]]]]).select('postcards.id, postcards.filename').where('people.id is null')


  def createemails(for_holiday)
    list_people_mails = create_list_people_mails(for_holiday)
    holiday_date = DatesHoliday.where(holiday_id: for_holiday.id).first
    will_send = Date.new(Time.now.year, holiday_date.month, holiday_date.day)
    list_people_mails.each do |data_hash|
        person = Person.find(data_hash[:person_id])
        mail_address = MailAddress.find(data_hash[:mail_address_id])

        create_new_email({
          name: " #{person.name},  #{for_holiday.name}",
          holiday_id: for_holiday.id,
          address: person.email,
          mail_address_id: data_hash[:mail_address_id],
          will_send: will_send,
          person_id: person.id,
          message: "Conratulations! Happy: #{for_holiday.name} "
        })
    end
  end


    # MailAddress.joins([{
    #   companies_person:
    #     [ :person,
    #       {company:
    #         [{companies_holidays:
    #           [holiday: :dates_holidays]
    #         },
    #         {country: :countries_holidays}
    #         ]
    #       }
    #     ]
    #   }], :emails).select('dates_holidays.id,dates_holidays.day, dates_holidays.month').order('dates_holidays.id')

    # найти почтовые открытки для этого праздника, и не использовавшиеся ранее для этого человека
  def create_new_email(opt = {})
    email_new = Email.new
    email_new.name = opt[:name]
    email_new.holiday_id = opt[:holiday_id]
    email_new.address = opt[:address]
    email_new.mail_address_id = opt[:mail_address_id]
    email_new.checkit = 0
    email_new.will_send = opt[:will_send]
    email_new.message = opt[:message]
    email_new.person_id = opt[:person_id]
    unless Email.where(holiday_id: opt[:holiday_id], will_send: opt[:will_send], person_id: opt[:person_id]).present?
      email_new.save
      add_postcard(email_new)
      # add_cardtext(email_new)
       flash[:notice] = " Created New Emails ! "
    else
      # flash[:alert] = " For #{Holiday.find( opt[:holiday_id])/.name} to #{opt[:will_send]} Email Already Exist! "
      flash[:alert] = "Emails Already Exist! "
    end
  end

  def add_postcard(email)

    # ps = Postcard.joins(:email_cards).where(holiday_id: 2).joins(:emails).count
    # ems = Email.all
    # ems.joins(mail_address: :companies_person)
    # Person.where(email: "name1@gmail.com").joins(:companies).select('people.id, people.name, companies.name')
    # ems.joins(:email_cards, mail_address: [{companies_person: :person}]).select('email_cards.id').where('email_cards.id = 15')
    #  ems.joins([{email_cards: :postcard}], mail_address: [{companies_person: :person}]).select('postcards.id').distinct
    # ems.joins([{email_cards: :postcard}], mail_address: [{companies_person: :person}]).select('people.id').where('postcards.id = 2')

    #  people_ids = Postcard.joins(email_cards: [{email: [{mail_address: [companies_person: :person]}]}]).select('people.id').distinct
  end

  def add_cardtext(email)

  end

  def postcard_not_using(email)
    # ps = Postcard.
  end



  def unvalid?
    Email.where(holiday_id: params[:holiday_id], will_send: params[:will_send], person_id: params[:person_id]).present? ? true : false
  end

  def set_emails
    @emails = Email.all
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
    params.require(:email).permit(:name, :address, :mail_address_id, :sent_date, :checkit, :holiday_id, :will_send, :message, :person_id)
  end

  def rescue_with_email_not_found
    render plain: 'Email was not found!'
  end
end

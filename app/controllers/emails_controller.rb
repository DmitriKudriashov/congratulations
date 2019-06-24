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
    if @email.update(email_params)
      # redirect_to email_path(@email)
      redirect_to emails_path
    else
      render :edit
    end
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

  def create
    @email = Email.new(email_params)
    if @email.save
      # redirect_to email_path(@email), notice: 'Success!'
      redirect_to emails_path, notice: 'Success!'
    else
      render :new
    end
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
    params.require(:email).permit(:name, :address, :mail_address_id, :sent_date, :checkit)
  end

  def rescue_with_email_not_found
    render plain: 'Email was not found!'
  end
end

class MailAddressesEmailController < ApplicationController
  before_action :set_mail_addresses_emails, only: %i[index]
  before_action :find_mail_addresses_email, only: %i[show edit update destroy]
  # before_action :find_mail_address, only: %i[new] # create]
  before_action :find_email, only: %i[new create]

  def index; end

  def new
    if @email.nil?
      @mail_addresses_email = MailAddressEmail.new
      # @mail_addresses_email.mail_address_id = 1
      # @mail_addresses_email.email_id = 1
    else
      @mail_addresses_email = @email.mail_addresses_emails.new
    end
  end

  def new_mail_address_email
    @mail_addresses_email = MailAddressEmail.new
  end

  def edit; end

  def update
    if @mail_addresses_email.update(mail_addresses_email_params)
      redirect_to redirect_after, notice: 'MailAddress-Email  was successfully updated.'
    else
      render :edit
    end
  end

  def show; end

  def redirect_after
    mail_addresses_emails_path
  end

  def create
    @mail_addresses_email = @email.nil? ? MailAddressEmail.new(mail_addresses_email_params) : @email.mail_addresses_emails.new(mail_addresses_email_params)
    if @mail_addresses_email.save
      redirect_to redirect_after, notice: 'Successully created!'
    else
      render :new
    end
  end

  def destroy
    destroy_common(@mail_addresses_email)
    redirect_to redirect_after
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")
  end

  private

  def find_mail_address
    @mail_address = mail_address.find(params[:mail_address_id]) unless params[:mail_address_id].nil?
  end

  def find_email
    @email = email.find(params[:email_id])
  end

  def set_mail_addresses_emails
    @mail_addresses_emails = MailAddressEmail.order(:email_id).paginate(page: params[:page]) # .all
  end

  def find_mail_addresses_email
    @mail_addresses_email = MailAddressEmail.find(params[:id])
  end

  def mail_addresses_email_params
    params.require(:mail_addresses_email).permit(:email_id, :mail_address_id)
  end
end

# frozen_string_literal: true

class MailAddressesController < AuthenticatedController
  before_action :set_mail_addresses, only: %i[index]
  before_action :find_mail_address, only: %i[show edit update destroy]

  def index; end

  def new
    @mail_address = MailAddress.new
  end

  def edit; end

  def update
    if @mail_address.update(mail_address_params)
      redirect_to mail_addresses_path, notice: 'Success!'
    else
      render :edit
    end
  end

  def show; end

  def create
    @mail_address = MailAddress.new(mail_address_params)
    if @mail_address.save
      redirect_to mail_addresses_path, notice: 'Success!'
    else
      render :new
    end
  end

  def destroy
    destroy_common(@mail_address)
    redirect_to mail_addresses_path
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")
  end

  private

  def set_mail_addresses
    @mail_addresses = MailAddress.order(:companies_person_id, updated_at: :desc) #.paginate(page: params[:page])
  end

  def find_mail_address
    @mail_address = MailAddress.find(params[:id])
  end

  def mail_address_params
    params.require(:mail_address).permit(:email, :companies_person_id)
  end

  def rescue_with_mail_address_not_found
    render plain: 'MailAddress was not found!'
  end
end

class CompaniesEmailsController < ApplicationController
  before_action :set_companies_emails, only: %i[index]
  before_action :find_companies_email, only: %i[show edit update destroy]
  # before_action :find_company, only: %i[new] # create]
  before_action :find_email, only: %i[new create]

  def index; end

  def new
    if @email.nil?
      @companies_email = CompaniesEmail.new
      # @companies_email.company_id = 1
      # @companies_email.email_id = 1
    else
      @companies_email = @email.companies_emails.new
    end
  end

  def new_companies_email
    @companies_email = CompaniesEmail.new
  end

  def edit; end

  def update
    if @companies_email.update(companies_email_params)
      redirect_to redirect_after, notice: 'Company-Email  was successfully updated.'
    else
      render :edit
    end
  end

  def show; end

  def redirect_after
    companies_emails_path
  end

  def create
    @companies_email = @email.nil? ? CompaniesEmail.new(companies_email_params) : @email.companies_emails.new(companies_email_params)
    if @companies_email.save
      redirect_to redirect_after, notice: 'Successully created!'
    else
      render :new
    end
  end

  def destroy
    destroy_common(@companies_email)
    redirect_to redirect_after
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")
  end

  private

  def find_company
    @company = Company.find(params[:company_id]) unless params[:company_id].nil?
  end

  def find_email
    @email = email.find(params[:email_id])
  end

  def set_companies_emails
    @companies_emails = CompaniesEmail.order(:email_id).paginate(page: params[:page]) # .all
  end

  def find_companies_email
    @companies_email = CompaniesEmail.find(params[:id])
  end

  def companies_email_params
    params.require(:companies_email).permit(:email_id, :company_id)
  end
end

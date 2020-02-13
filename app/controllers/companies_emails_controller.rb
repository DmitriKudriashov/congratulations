class CompaniesEmailsController < ApplicationController
  before_action :set_companies_emails, only: %i[index]
  before_action :find_companies_email, only: %i[show edit update]
  before_action :find_company, only: %i[new update create] # create]
  before_action :find_email, only: %i[new update create destroy]

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
      redirect_after
    else
      render :edit
    end
  end

  def show; end

  def redirect_after
    if @email.present?
      redirect_to edit_email_path(@email.id), notice: 'Company-Email  was successfully updated.'
    else
      redirect_to companies_emails_path
    end
  end

  def create
    @companies_email = @email.nil? ? CompaniesEmail.new(companies_email_params) : @email.companies_emails.new(companies_email_params)
    if @companies_email.save
      if @email.present?
        redirect_to edit_email_path(@email.id), notice: 'Successully created!'
      else
        redirect_to companies_emails_path
      end
    else
      render :new
    end
  end

  def destroy

    if destroy_common(@companies_email)
      if @email.present?
        redirect_to edit_email_path(@email.id), notice: 'Company-Email  was successfully deleted !.'
      else
        redirect_to companies_emails_path
      end
    else
      redirect_to companies_emails_path
    end
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")
  end

  private

  def find_company
    if params[:id].present?
      @company = find_companies_email.company
    end
  end

  def find_email
    if  params[:id].present?
      @email = find_companies_email.email
    end
  end

  def set_companies_emails
    @companies_emails = CompaniesEmail.order(:email_id) #.paginate(page: params[:page])
  end

  def find_companies_email
    @companies_email = CompaniesEmail.find(params[:id])
  end

  def companies_email_params
    params.require(:companies_email).permit(:email_id, :company_id, :comment)
  end
end

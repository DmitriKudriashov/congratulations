# frozen_string_literal: true

class CompaniesController < AuthenticatedController
  before_action :set_companies, only: %i[index]
  before_action :find_company, only: %i[show edit update destroy]

  def index; end

  def new
    @company = Company.new
  end

  def edit; end

  def update
    if @company.update(company_params)
      # redirect_to company_path(@company), notice: 'Success!'
      redirect_to companies_path, notice: 'Success!'
    else
      render :edit
    end
  end

  def show; end

  def create
    @company = Company.new(company_params)
    if @company.save
      # redirect_to company_path(@company), notice: 'Success!'
      redirect_to companies_path, notice: 'Create new Company Successfully!'
    else
      render :new
    end
  end

  def destroy
    destroy_common(@company)
    redirect_to companies_path, notice: 'Destroy Successfully!'
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")
  end

  private

  def set_companies
    @companies = Company.order(:name)
  end

  def find_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name, :country_id, :email)
  end

  def rescue_with_company_not_found
    render plain: 'Company was not found!'
  end
end

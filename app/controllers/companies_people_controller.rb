# frozen_string_literal: true

class CompaniesPeopleController < AuthenticatedController
  before_action :set_companies_people, only: %i[index]
  before_action :find_companies_person, only: %i[show edit update destroy]
  # before_action :find_person, only: %i[new]

  def index; end

  def new
    @companies_person = @person.nil? ? CompaniesPerson.new : @person.companies_people.new
    # @companies_person.person_id = 1
    # @companies_person.company_id = 1
  end

  def edit; end

  def update
    if @companies_person.update(companies_person_params)
      redirect_to companies_person_path(@companies_person), notice: 'CompaniesPerson was successfully updated.'
    else
      render :edit
    end
  end

  def show; end

  def create
    @companies_person = CompaniesPerson.new(companies_person_params)
    # byebug

    if @companies_person.save
      # redirect_to companies_person_path(@companies_person.person_id), notice: 'Successully created!'
      redirect_to companies_people_path, notice: 'Successully created!'
    else
      render :new
    end
  end

  def destroy
    if @companies_person.destroy
      # redirect_to person_path(@companies_person.person_id), notice: 'CompaniesPerson was successfully Destroy!'
      redirect_to companies_people_path, notice: 'CompaniesPerson was successfully Destroy!'
    end
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")
  end

  private

  def find_person
    @person = Person.find(params[:person_id]) unless params[:person_id].nil?
  end

  def find_company
    @company = Company.find(params[:company_id])
  end

  def set_companies_people
    @companies_people = CompaniesPerson.paginate(page: params[:page]) # .all
  end

  def find_companies_person
    @companies_person = CompaniesPerson.find(params[:id])
  end

  def companies_person_params
    params.require(:companies_person).permit(:company_id, :person_id)
  end

  def rescue_with_companies_person_not_found
    render plain: 'CompaniesPerson record was not found!'
  end
end

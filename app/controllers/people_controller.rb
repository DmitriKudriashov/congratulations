class PeopleController < AuthenticatedController
  before_action :set_people, only: %i[index]
  before_action :find_person, only: %i[show edit update destroy]

  def index;  end

  def new
    @person = Person.new
  end

  def edit; end

  def update
    if @person.update(person_params)
#      redirect_to person_path(@person)
      redirect_to people_path
    else
      render :edit
    end
  end


  def show; end

  def create
    @person = Person.new(person_params)
    if @person.save
      # redirect_to person_path(@person), notice: 'Success!'
      redirect_to people_path, notice: 'Success!'
    else
      render :new
    end
  end

  def destroy
    @person.destroy
    redirect_to people_path, notice: 'Destroy !'
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")
  end

  private

  def set_people
    @people = Person.paginate(page: params[:page]) # .all
  end

  def find_person
    @person = Person.find(params[:id])
  end

  def person_params
    params.require(:person).permit(:name, :email, :country_id, :company_id, :birthday )
  end

  def rescue_with_person_not_found
    render plain: 'Person was not found!'
  end
end

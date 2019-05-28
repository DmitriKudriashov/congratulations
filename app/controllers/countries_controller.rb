class CountriesController < ApplicationController
  before_action :set_countries, only: %i[index]
  before_action :find_country, only: %i[show edit update destroy]

  def index;  end

  def new
    @country = Country.new
  end

  def edit; end

  def update
    if @country.update(country_params)
      # redirect_to country_path(@country), notice: 'Success!'
      redirect_to countries_path, notice: 'Success!'
    else
      render :edit
    end
  end


  def show; end

  def create
    @country = Country.new(country_params)
    if @country.save
      # redirect_to country_path(@country), notice: 'Success!'
      redirect_to countries_path, notice: 'Success!'
    else
      render :new
    end
  end

  def destroy
    @country.destroy
  # rescue StandardError => err
  #   raise err.message
    redirect_to countries_path, notice: 'Destroy !'
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")
  end

  private

  def set_countries
    @countries = Country.all
  end

  def find_country
    @country = Country.find(params[:id])
  end

  def country_params
    params.require(:country).permit(:name, :code)
  end

  def rescue_with_country_not_found
    render plain: 'Country was not found!'
  end
end

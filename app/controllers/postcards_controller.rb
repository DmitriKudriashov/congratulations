# frozen_string_literal: true

class PostcardsController < AuthenticatedController
  before_action :set_postcards, only: %i[index]
  before_action :find_postcard, only: %i[show edit update destroy]

  def index; end

  def new
    @postcard = Postcard.new
  end

  def edit; end

  def update
    if @postcard.update(postcard_params)
      # redirect_to postcard_path(@postcard), notice: 'Success!'
      redirect_to postcards_path
    else
      render :edit
    end
  end

  def show; end

  def create
    @postcard = Postcard.new(postcard_params)
    if @postcard.save
      redirect_to postcards_path
    else
      render :new
    end
  end

  def destroy
    destroy_common(@postcard)
    redirect_to postcards_path
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")
  end

  private

  def set_postcards
    @postcards = Postcard.order(:holiday_id).paginate(page: params[:page]) # .all
  end

  def find_postcard
    @postcard = Postcard.find(params[:id])
  end

  def postcard_params
    params.require(:postcard).permit(:filename, :image, :holiday_id)
  end

  def rescue_with_postcard_not_found
    render plain: 'Postcard was not found!'
  end
end

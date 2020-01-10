# frozen_string_literal: true

class CardtextsController < AuthenticatedController
  before_action :set_cardtexts, only: %i[index]
  before_action :find_cardtext, only: %i[show edit update destroy]

  def index; end

  def new
    @cardtext = Cardtext.new
  end

  def edit; end

  def update
    if @cardtext.update(cardtext_params)
      # redirect_to cardtext_path(@cardtext), notice: 'Success!'
      redirect_to cardtexts_path
    else
      render :edit
    end
  end

  def show; end

  def create
    @cardtext = Cardtext.new(cardtext_params)
    if @cardtext.save
      # redirect_to cardtext_path(@cardtext), notice: 'Success!'
      redirect_to cardtexts_path
    else
      render :new
    end
  end

  def destroy
    destroy_common(@cardtext)
    redirect_to cardtexts_path
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")
  end

  private

  def set_cardtexts
    @cardtexts = Cardtext.order(:filename).paginate(page: params[:page])
  end

  def find_cardtext
    @cardtext = Cardtext.find(params[:id])
  end

  def cardtext_params
    params.require(:cardtext).permit(:filename, :text, :holiday_id)
  end

  def rescue_with_cardtext_not_found
    render plain: 'Cardtext was not found!'
  end
end

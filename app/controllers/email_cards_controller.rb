# frozen_string_literal: true

class EmailCardsController < AuthenticatedController
  # before_action :set_email_cards, only: %i[index]
  before_action :find_email_card, only: %i[show edit update destroy]
  before_action :find_card, only: %i[edit create index]
  before_action :find_email, only: %i[new create edit update destroy]

  def index
    @email_cards = @email.nil? ? set_email_cards : EmailCard.where(email_id: params[:email_id])
  end

  def new
    @email_card =  @email.nil? ? EmailCard.new : @email.email_cards.new
  end

  def edit; end

  def update
    if @email_card.update(email_card_params)
      redirect_to edit_email_path(@email_card.email_id), notice: 'EmailCard was successfully updated.'
    else
      render :edit
    end
  end

  def show; end

  def create
    @email_card = EmailCard.new(email_card_params)

    if @email_card.save
      redirect_to edit_email_path(@email_card.email_id), notice: 'Successully created!'
    else
      render :new
    end
  end

  def destroy
    if destroy_common(@email_card)
      redirect_to edit_email_path(@email_card.email_id)
    end
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")
  end

  private

  def set_path_after_action(email)
    email.nil? ? email_cards_path : edit_email_path(email)
  end

  def find_card
    @card = card.find(params[:card_id]) unless params[:card_id].nil?
  end

  def find_email
    if params[:email_card].present?
       @email = Email.find(params[:email_card][:email_id]) if params[:email_card].present?
    end
  end

  def set_email_cards
    @email_cards = EmailCard.all #.paginate(page: params[:page])
  end

  def find_email_card
    @email_card = EmailCard.find(params[:id])
  end

  def email_card_params
    params.require(:email_card).permit(:email_id, :postcard_id)
  end

  def rescue_with_email_card_not_found
    render plain: 'Email-Card record was not found!'
  end
end

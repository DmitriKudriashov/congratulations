# frozen_string_literal: true

class EmailTextsController < AuthenticatedController
  before_action :set_email_texts, only: %i[index]
  before_action :find_email_text, only: %i[show edit update destroy]
  before_action :find_cardtext, only: %i[new create]
  before_action :find_email, only: %i[new create update]

  def index; end

  def new
    @email_text =  @email.nil? ? EmailText.new : @email.email_texts.new
  end

  def new_email_text
    @email_text =  EmailText.new
  end

  def edit; end

  def update
    if @email_text.update(email_text_params)
      redirect_to email_email_texts_path(@email_text.email_id), notice: 'EmailText was successfully updated.'
    else
      render :edit
    end
  end

  def show; end

  def create
    @email_text = EmailText.new(email_text_params)
    if @email_text.save
      redirect_to email_email_texts_path(@email_text.email_id), notice: 'Successully created!'
    else
      render :new
    end
  end

  def destroy
    if destroy_common(@email_text)
      redirect_to email_email_texts_path(@email_text.email_id)
    end
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")
  end

  private

  def find_cardtext
    @cardtext = Cardtext.find(params[:cardtext_id]) unless params[:cardtext_id].nil?
  end

  def find_email
    @email = Email.find(params[:email_id])
  end

  def set_email_texts
    @email_texts = EmailText.paginate(page: params[:page])
  end

  def find_email_text
    @email_text = EmailText.find(params[:id])
  end

  def email_text_params
    params.require(:email_text).permit(:email_id, :cardtext_id)
  end

  def rescue_with_email_text_not_found
    render plain: 'Email-Text record was not found!'
  end
end

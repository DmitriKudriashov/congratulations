# frozen_string_literal: true

class TypesController < AuthenticatedController
  before_action :set_types, only: %i[index]
  before_action :find_type, only: %i[show edit update destroy]

  def index; end

  def new
    @type = Type.new
  end

  def edit; end

  def update
    if @type.update(type_params)
      redirect_to type_path(@type)
    else
      render :edit
    end
  end

  def show; end

  def create
    @type = Type.new(type_params)
    if @type.save
      redirect_to type_path(@type), notice: 'Success!'
    else
      render :new
    end
  end

  def destroy
    destroy_common(@type)
    redirect_to types_path
  end

  def search
    result = ["Class: #{params.class}", "Parameters: #{params.inspect}"]
    render plain: result.join("\n")
  end

  private

  def set_types
    @types = Type.order(:name).paginate(page: params[:page]) # .all
  end

  def find_type
    @type = Type.find(params[:id])
  end

  def type_params
    params.require(:type).permit(:name)
  end

  def rescue_with_type_not_found
    render plain: 'Type was not found!'
  end
end

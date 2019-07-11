# frozen_string_literal: true

class AuthenticatedController < ApplicationController
  before_action :my_authenticate_user!

  private

  def my_authenticate_user!
    # byebug
    authenticate_user!
  end
end

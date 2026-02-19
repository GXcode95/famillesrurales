# frozen_string_literal: true

class Sidebar::Component < ViewComponent::Base
  include IconsHelper

  def initialize(current_user: nil)
    @current_user = current_user
    @categories = Category.includes(:activities).order(:name)
    @events = Event.order(date: :asc)
  end

  private

  attr_reader :current_user

  def user_signed_in?
    current_user.present?
  end
end

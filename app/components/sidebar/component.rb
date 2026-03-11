# frozen_string_literal: true

class Sidebar::Component < ViewComponent::Base
  include IconsHelper

  def initialize(current_user: nil, current_path: "")
    @current_user = current_user
    @current_path = current_path
    @categories = Category.includes(:activities).order(:name)
    @events = Event.order(date: :asc)
  end

  def nav_link_classes(path, exact: false, sub_item: false)
    base = "flex items-center px-4 py-2 text-sm rounded-md"
    base += " font-normal" if sub_item
    base += " font-medium" unless sub_item
    active = "bg-indigo-100 text-indigo-900"
    inactive = sub_item ? "text-gray-600 hover:bg-indigo-50 hover:text-indigo-700" : "text-gray-700 hover:bg-indigo-50 hover:text-indigo-700"

    if active?(path, exact: exact)
      "#{base} #{active}"
    else
      "#{base} #{inactive}"
    end
  end

  def active?(path, exact: false)
    return false if path.blank?

    if exact
      @current_path == path
    else
      @current_path == path || @current_path.start_with?("#{path}/")
    end
  end

  private

  attr_reader :current_user

  def user_signed_in?
    current_user.present?
  end
end

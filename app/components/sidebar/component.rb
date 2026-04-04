# frozen_string_literal: true

class Sidebar::Component < ViewComponent::Base
  include IconsHelper

  def initialize(current_user: nil, request_path: nil)
    @current_user = current_user
    @request_path = (request_path.presence || "/").to_s
    @categories = Category.includes(:activities).order(:name)
    @events = Event.order(date: :asc)
  end

  def nav_item_classes(url, exact: false)
    base = "flex items-center rounded-xl px-3 py-2.5 text-sm transition "
    if nav_active?(url, exact: exact)
      base + "bg-blue-50 font-semibold text-blue-900"
    else
      base + "font-medium text-zinc-700 hover:bg-blue-50 hover:text-blue-900"
    end
  end

  def nav_subitem_classes(url)
    base = "flex items-center rounded-lg px-3 py-2 text-sm transition "
    if nav_active?(url, exact: true)
      base + "bg-blue-50 font-semibold text-blue-900"
    else
      base + "text-zinc-600 hover:bg-blue-50 hover:text-blue-900"
    end
  end

  def category_button_classes(category)
    active = category.activities.any? { |a| nav_active?(helpers.activity_path(a), exact: true) }
    base = "w-full flex items-center justify-between rounded-xl px-3 py-2.5 text-sm transition "
    if active
      base + "bg-blue-50 font-semibold text-blue-900"
    else
      base + "font-medium text-zinc-700 hover:bg-blue-50 hover:text-blue-900"
    end
  end

  def brand_link_classes
    if nav_active?(helpers.root_path, exact: true)
      "text-base font-semibold tracking-tight text-blue-900 transition hover:text-blue-950"
    else
      "text-base font-semibold tracking-tight text-zinc-900 transition hover:text-blue-700"
    end
  end

  def nav_active?(url, exact: false)
    path = url.to_s
    cur = @request_path

    if exact
      return home_request? if path == "/" || path == helpers.root_path

      return cur == path
    end

    return home_request? if path == "/" || path == helpers.root_path

    cur == path || cur.start_with?("#{path}/")
  end

  private

  attr_reader :current_user

  def home_request?
    ["/", ""].include?(@request_path)
  end

  def user_signed_in?
    current_user.present?
  end
end

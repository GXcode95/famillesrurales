# frozen_string_literal: true

class FlashComponent < ViewComponent::Base
  def initialize(notice: nil, alert: nil)
    @notice = notice
    @alert = alert
  end

  private

  attr_reader :notice, :alert

  def has_flash?
    notice.present? || alert.present?
  end
end

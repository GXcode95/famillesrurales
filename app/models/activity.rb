class Activity < ApplicationRecord
  belongs_to :category, dependent: :destroy

  validate :end_date_not_before_start_date, if: -> { start_date.present? && end_date.present? }

  private

  def end_date_not_before_start_date
    return if end_date >= start_date

    errors.add(:end_date, "doit être le même jour ou après la date de début")
  end
end

# frozen_string_literal: true

module CalendarHelper
  MONTH_NAMES_FR = %w[
    Janvier Février Mars Avril Mai Juin Juillet Août Septembre Octobre Novembre Décembre
  ].freeze

  WEEKDAY_LABELS_FR = %w[Lun Mar Mer Jeu Ven Sam Dim].freeze

  def calendar_month_options
    (1..12).map { |m| [MONTH_NAMES_FR[m - 1], m] }
  end

  def calendar_year_options
    y = Time.current.year
    ((y - 5)..(y + 5)).map { |yr| [yr.to_s, yr] }
  end
end

# frozen_string_literal: true

class CalendarController < ApplicationController
  def index
    @month = parse_month(params[:month])
    @year = parse_year(params[:year])
    @month_start = Date.new(@year, @month, 1)
    @month_end = @month_start.end_of_month

    zone = Time.zone
    range_start = zone.local(@year, @month, 1).beginning_of_day
    range_end = zone.local(@year, @month, @month_end.day).end_of_day

    events = Event.where.not(date: nil).where(date: range_start..range_end).order(:date)
    @events_by_day = events.group_by { |e| e.date.in_time_zone(zone).to_date }

    @calendar_weeks = build_calendar_weeks(@month_start, @month_end)

    prev = @month_start.prev_month
    @prev_month = prev.month
    @prev_year = prev.year
    nxt = @month_start.next_month
    @next_month = nxt.month
    @next_year = nxt.year
  end

  private

  def parse_month(raw)
    m = raw.present? ? raw.to_i : Time.current.month
    m.clamp(1, 12)
  end

  def parse_year(raw)
    y = raw.present? ? raw.to_i : Time.current.year
    y.clamp(2000, 2100)
  end

  def build_calendar_weeks(month_start, month_end)
    start_d = month_start.beginning_of_week(:monday)
    end_d = month_end.end_of_week(:monday)
    (start_d..end_d).to_a.each_slice(7).to_a
  end
end

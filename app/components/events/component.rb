# frozen_string_literal: true

module Events
  class Component < ApplicationComponent
    def initialize(event:, editable: false, link_to_show: false)
      @event = event
      @editable = editable
      @link_to_show = link_to_show
    end
  end
end

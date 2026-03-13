# frozen_string_literal: true

module Events
  class Component < ApplicationComponent
    def initialize(event:, editable: false, link_to_show: false, show_comments: true, signed_in: false, comment: nil)
      @event = event
      @editable = editable
      @link_to_show = link_to_show
      @show_comments = show_comments
      @signed_in = signed_in
      @comment_param = comment
    end

    def comment
      @comment_param || @event.comments.build
    end
  end
end

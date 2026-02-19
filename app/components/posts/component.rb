# frozen_string_literal: true

module Posts
  class Component < ApplicationComponent
    include IconsHelper

    def initialize(post:, editable: false)
      @post = post
      @editable = editable
    end
  end
end
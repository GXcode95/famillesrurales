# frozen_string_literal: true

module Posts
  class Component < ApplicationComponent
    include IconsHelper

    def initialize(post:, editable: false, show_comments: true, signed_in: false, comment: nil)
      @post = post
      @editable = editable
      @show_comments = show_comments
      @signed_in = signed_in
      @comment_param = comment
    end

    def comment
      @comment_param || @post.comments.build
    end
  end
end
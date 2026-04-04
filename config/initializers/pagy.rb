# frozen_string_literal: true

require "pagy"

Pagy::I18n.load(locale: "fr")

Pagy::DEFAULT[:limit] = 20

Pagy::DEFAULT.freeze

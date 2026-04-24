# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "securerandom"

class ActiveSupport::TestCase
  parallelize(workers: :number_of_processors)
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActionDispatch::TestProcess::FixtureFile

  private

  def create_user(email: "test-#{SecureRandom.hex(4)}@example.com", password: "Password123!")
    User.create!(email:, password:, password_confirmation: password)
  end
end

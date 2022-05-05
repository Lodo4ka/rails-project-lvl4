# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    # parallelize(workers: :number_of_processors)

    setup do
      queue_adapter.perform_enqueued_jobs = true
    end
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    def config_omniauth(user)
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
        {
          info: {
            email: user.email,
            nickname: user.nickname
          },
          credentials: {
            token: user.token
          }
        }
      )
      # Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
    end

    def sign_in(user)
      config_omniauth(user)
      post auth_request_path(:github)
      follow_redirect!
    end
  end
end

# frozen_string_literal: true

require 'test_helper'

module Api
  class ChecksControllerTest < ActionDispatch::IntegrationTest
    test 'should create new check' do
      repository = repositories(:javascript)
      post api_checks_path, params: { repository: { full_name: repository.full_name } }

      assert { Repository::Check.last.repository == repository }

      assert_response :success
    end
  end
end

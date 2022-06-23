# frozen_string_literal: true

require 'test_helper'

module Web
  module Repositories
    class ChecksControllerTest < ActionDispatch::IntegrationTest
      include ActiveJob::TestHelper

      setup do
        sign_in(users(:one))
      end

      test 'should open check page' do
        check = repository_checks(:finished)
        get repository_check_path(check.repository, check)

        assert_response :success
      end

      test 'should check javascript repository' do
        repository = repositories(:javascript)
        assert_difference 'Repository::Check.count' do
          post repository_checks_path(repository)
        end

        check = Repository::Check.last
        assert { check.repository == repository }
        assert { check.finished? }
        assert { check.passed }
        assert { check.issues_count.eql? 0 }
        assert_redirected_to repository
      end

      test 'should check ruby repository' do
        repository = repositories(:ruby)
        assert_difference 'Repository::Check.count' do
          post repository_checks_path(repository)
        end

        check = Repository::Check.last
        assert { check.repository == repository }
        assert { check.finished? }
        assert { !check.passed }
        assert { check.issues_count.eql? 2 }
      end
    end
  end
end

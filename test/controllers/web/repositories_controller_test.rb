# frozen_string_literal: true

require 'test_helper'

module Web
  class RepositoriesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:one)
      sign_in(@user)
    end

    test 'should open index page' do
      get repositories_path

      assert_response :success
    end

    test 'should open show repository page' do
      get repository_path(repositories(:javascript))

      assert_response :success
    end

    test 'should open new repository page' do
      get new_repository_path

      assert_response :success
    end

    test 'should create new repository' do
      github_id = Faker::Number.number(digits: 9)
      assert_difference 'Repository.count' do
        post repositories_path, params: { repository: { github_id: github_id } }
      end

      repository = Repository.find_by(github_id: github_id)
      assert { repository }
      assert { repository.name }
      assert { repository.language }
      assert_redirected_to repositories_path
    end
  end
end

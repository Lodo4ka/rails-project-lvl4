# frozen_string_literal: true

class GithubApiService
  def self.fetch_last_commit(token, github_id)
    commits = client(token).commits(github_id)
    { reference_url: commits.first['html_url'], reference_sha: commits.first['sha'] }
  end

  def self.list_repositories(token)
    client(token).repos
  end

  def self.fetch_repository_info(token, github_id)
    client(token).repo(github_id)
  end

  def self.create_hook(token, github_id)
    client(token).create_hook(
      github_id,
      'web',
      {
        url: Rails.application.routes.url_helpers.api_checks_url,
        content_type: 'json'
      },
      {
        events: %w[push pull_request],
        active: true
      }
    )
  end

  def self.client(token)
    Octokit::Client.new access_token: token, per_page: 100
  end
end

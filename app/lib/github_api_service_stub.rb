# frozen_string_literal: true

class GithubApiServiceStub
  def self.fetch_last_commit(_token, _github_id)
    { reference_url: Faker::Internet.url, reference_sha: Faker::Crypto.sha1 }
  end

  def self.list_repositories(_token)
    JSON.parse(File.read('test/fixtures/files/repositories.json'))
  end

  def self.fetch_repository_info(_token, _github_id)
    JSON.parse(File.read('test/fixtures/files/repository.json'))
  end

  def self.create_hook(_token, _github_id)
    JSON.parse(File.read('test/fixtures/files/webhook_response.json'))
  end
end

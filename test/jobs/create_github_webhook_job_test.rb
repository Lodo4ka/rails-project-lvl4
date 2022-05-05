# frozen_string_literal: true

require 'test_helper'

class CreateGithubWebhookJobTest < ActiveJob::TestCase
  test 'should create webhook for repo' do
    repository = repositories(:ruby)
    stub_request(:post, 'https://api.github.com/repositories/1/hooks')
      .with(
        body: '{"name":"web","config":{"url":"https://916e-89-239-162-176.eu.ngrok.io/api/checks","content_type":"json"},"events":["push","pull_request"],"active":true}',
        headers: {
          'Accept' => 'application/vnd.github.v3+json',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'token MyString',
          'Content-Type' => 'application/json',
          'User-Agent' => 'Octokit Ruby Gem 4.22.0'
        }
      )
      .to_return(status: 201, body: '', headers: {})
    CreateGithubWebhookJob.perform_now(repository)
    assert_performed_jobs(1)
  end
end

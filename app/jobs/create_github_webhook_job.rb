# frozen_string_literal: true

class CreateGithubWebhookJob < ApplicationJob
  queue_as :default

  def perform(repository)
    ApplicationContainer[:api_service].create_hook(repository.user.token, repository.github_id)
  end
end

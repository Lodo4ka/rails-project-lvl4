# frozen_string_literal: true

class RepositoryInfoJob < ApplicationJob
  queue_as :default

  def perform(repository)
    repository_info = ApplicationContainer[:api_service]
                      .fetch_repository_info(repository.user.token, repository.github_id)
    repository.name = repository_info['name']
    repository.full_name = repository_info['full_name']
    language = repository_info['language'] || repository_info['source']['language']
    repository.language = language&.downcase
    repository.clone_url = repository_info['clone_url']
    repository.save!
  end
end

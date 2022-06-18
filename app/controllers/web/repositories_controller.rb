# frozen_string_literal: true

module Web
  class RepositoriesController < ApplicationController
    def index
      authorize(Repository)
      @repositories = policy_scope(Repository)
    end

    def show
      @repository = Repository.find(params[:id])
      authorize(@repository)
    end

    def new
      authorize Repository
      @repository = current_user.repositories.build
      repositories = ApplicationContainer[:api_service].list_repositories(current_user.token)
      permitted_languages = Repository.language.values
      @permitted_repositories = repositories.select do |repository|
        repository if repository['language']&.downcase.in?(permitted_languages) &&
                      !Repository.find_by(github_id: repository['id'])
      end
    end

    def create
      authorize Repository
      @repository = current_user.repositories.build(repository_params)
      if @repository.save
        RepositoryInfoJob.perform_later(@repository)
        CreateGithubWebhookJob.perform_later(@repository)
        redirect_to repositories_path, notice: t('repository_creation.successfull')
      else
        render :new, alert: t('repository_creation.failed')
      end
    end

    private

    def repository_params
      params.require(:repository).permit(:github_id)
    end
  end
end

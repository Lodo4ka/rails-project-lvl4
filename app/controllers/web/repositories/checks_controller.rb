# frozen_string_literal: true

module Web
  module Repositories
    class ChecksController < ApplicationController
      def show
        @check = Repository::Check.find(params[:id])
        authorize @check
      end

      def create
        @repository = Repository.find(params[:repository_id])
        if @repository.language.nil?
          redirect_to @repository, alert: t('check_creation.language_error')
        end
        @check = @repository.checks.build
        authorize @check
        if @check.save
          CheckRepositoryJob.perform_later(@check)
          redirect_to @repository, notice: t('check_creation.successfull')
        else
          redirect_to @repository, alert: t('check_creation.failed')
        end
      end
    end
  end
end

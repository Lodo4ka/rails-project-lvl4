# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :default

  def perform(check)
    RepositoryCheckService.run_check(check)
  end
end

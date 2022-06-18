# frozen_string_literal: true

class RepositoryCheckService
  def self.run_check(check)
    check.check!
    repository_manager = ApplicationContainer[:repository_manager]
    prepare_repository(check, repository_manager)
    repository_checker = ApplicationContainer[:repository_checker]
    repository = check.repository
    output = repository_checker.run_check(repository)
    parse_output(check, output)
    check.finish!
    mail(check).report_errors_found.deliver_later unless check.issues_count.zero?
    repository_manager.remove_tmp_repository(repository)
  rescue StandardError
    check.mark_as_failed!
    mail(check).report_failed_check.deliver_later
  end

  def self.mail(check)
    RepositoryCheckMailer.with(check: check)
  end

  def self.prepare_repository(check, repository_manager)
    api_service = ApplicationContainer[:api_service]
    repository = check.repository
    last_commit = api_service.fetch_last_commit(repository.user.token, repository.github_id)
    check.update(last_commit)
    repository_manager.clone_repository(repository)
  end

  def self.parse_output(check, output)
    parser = "#{check.repository.language}_output_parser".classify.constantize
    check.output = parser.parse_linter_output(output)
    check.issues_count = parser.count_issues(output)
    check.passed = true if check.issues_count.zero?
    check.save
  end
end

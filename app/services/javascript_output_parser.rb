# frozen_string_literal: true

class JavascriptOutputParser
  def self.parse_linter_output(output)
    return output if output.blank?

    errors_info = {}
    JSON.parse(output).each do |offenses_in_file|
      next if offenses_in_file['messages'].empty?

      messages = []
      offenses_in_file['messages'].each do |offense|
        messages << error_description(offense)
      end
      errors_info[offenses_in_file['filePath']] = messages
    end
    errors_info
  end

  def self.error_description(offense)
    { rule_id: offense['ruleId'], message: offense['message'],
      location: "#{offense['line']}:#{offense['column']}" }
  end

  def self.count_issues(output)
    issues_count = 0
    JSON.parse(output).each do |offences_in_file|
      issues_count += offences_in_file['messages'].size
    end
    issues_count
  end
end

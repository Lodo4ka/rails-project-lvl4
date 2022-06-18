# frozen_string_literal: true

class RepositoryManager
  def self.clone_repository(repository)
    Open3.capture3("git clone #{repository.clone_url} #{repository_storage(repository)}")
  end

  def self.remove_tmp_repository(repository)
    Open3.capture3("rm -rf #{repository_storage(repository)}")
  end

  def self.repository_storage(repository)
    Rails.root.join("tmp/repos/#{repository.full_name}")
  end
end

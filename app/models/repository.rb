# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  enumerize :language, in: %i[javascript ruby]
  belongs_to :user
  has_many :checks, dependent: :destroy
end

class Lesson < ApplicationRecord
  validates :topic, :dialogue, :phrases, :language, presence: true
  enum :language, { english: 0, japanese: 1 }
end

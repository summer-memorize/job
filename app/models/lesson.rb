class Lesson < ApplicationRecord
  validates :topic, :content, :language, presence: true
  enum :language, { english: 0, japanese: 1 }
end

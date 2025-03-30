class Lesson < ApplicationRecord
  enum language: {
    english: 0,
    japanese: 1
  }
end

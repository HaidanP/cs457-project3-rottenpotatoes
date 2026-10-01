class Movie < ApplicationRecord
  RATINGS = %w[G PG PG-13 R NC-17 NR].freeze

  normalizes :title, with: ->(title) { title.strip }
  validates :title, presence: true, length: { maximum: 200 }
  validates :rating, inclusion: { in: RATINGS }
  validates :release_date, presence: true
  validates :description, length: { maximum: 10000 }
end

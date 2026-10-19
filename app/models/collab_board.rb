class CollabBoard < ApplicationRecord
  belongs_to :user

  scope :filter_by_search, ->(query) { where("title ILIKE :q OR description ILIKE :q", q: "%#{query}%") if query.present? }
end

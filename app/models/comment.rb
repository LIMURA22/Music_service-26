class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user, optional: true

  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  def deleted?
    deleted_at.present?
  end
end
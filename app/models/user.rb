class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :nullify
  has_many :comments, dependent: :nullify
  mount_uploader :avatar, AvatarUploader

  def display_name
    name.presence || email.split('@').first
  end
end
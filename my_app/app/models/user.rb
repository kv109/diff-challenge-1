class User < ApplicationRecord
  attr_accessor :password_confirmation

  before_validation :generate_token, on: :create

  has_and_belongs_to_many :groups
  has_and_belongs_to_many :orders

  validates :email, uniqueness: true
  validates :access_token, presence: true

  def generate_token
    self.access_token = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
  end
end

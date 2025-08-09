class User < ApplicationRecord
  has_secure_password

  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  before_validation :downcase_email

  private

  def downcase_email
    self.email = email.to_s.downcase.strip
  end
end

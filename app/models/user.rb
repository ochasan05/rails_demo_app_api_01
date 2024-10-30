class User < ApplicationRecord
  require "validator/email_validator" 

  before_validation :downcase_email

  has_secure_password

  validates :name, presence: true,
                   length: { maximum: 30, allow_blank: true}

  validates :email, presence: true, email: { allow_blank: true }

  #VALID_PASSWORD_REGEX = /\A[\w\-]+\z/
  validates :password, presence: true,
                       length: { minimum: 8, allow_blank: true },
                       format: {
                         with: /\A[\w\-]+\z/,
                         message: I18n.t('errors.messages.invalid_password'),
                         allow_blank: true
                       },
                       allow_nil: true

  class << self
    # emailからアクティブなユーザーを返す
    def find_by_activated(email)
      find_by(email: email, activated: true)
    end
  end

  def email_activated?
    users = User.where.not(id: id)
    users.find_by_activated(email).present?
  end

  private
  def downcase_email
    self.email.downcase! if email
  end
 
end

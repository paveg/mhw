class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  class << self
    def find_for_facebook_oauth(auth, signed_in_resources = nil)
      user = User.find(provider: auth.provide, uid: auth.uid)
      unless user
        user = User.create!(
            name: auth.extra.raw_info.name,
            provide: auth.provide,
            uid: auth.uid,
            email: auth.info.email,
            password: Devise.friendly_token[0, 20],
        )
      end
      user
    end

    def create_unique_string
      SecureRandom.uuid
    end

    def create_unique_email
      User.create_unique_string + "@example.com"
    end
  end
end
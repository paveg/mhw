class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: %i[facebook twitter]

  class << self

    def new_with_session(_, session)
      super.tap do |user|
        if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"]
        end
      end
    end

    def find_for_oauth(auth)
      binding.pry
      user = User.find(provider: auth.provider, uid: auth.uid)

      user = create_user_by_provider(auth) unless user

      user
    end

    def create_unique_string
      SecureRandom.uuid
    end

    def create_unique_email
      User.create_unique_string + "@example.com"
    end

    def dummy_email(auth)
      "#{auth.uid}-#{auth.provider}@example.com"
    end

    private

    def create_user_by_provider(auth)
      provider = auth.provider

      extra_info = case provider
                   when :facebook
                     { name: auth.extra.raw_info.name }
                   when :twitter
                     { name: auth.info.nickname }
                   end

      User.create(
          { uid: auth.uid,
            provider: auth.provider,
            email: User.dummy_email(auth),
            password: Devise.friendly_token[0, 20], }.merge(extra_info)
      )
    end
  end
end
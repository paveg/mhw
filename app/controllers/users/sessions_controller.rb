class Users::SessionsController < Devise::SessionsController
  def new
    session.delete('devise.omniauth_data')
    super
  end

  def create
    super
  end

  def destroy
    super
  end
end

class AuthenticationsController < ApplicationController
  skip_before_action :authenticate_user!

  def router
    redirect_to params[:auth_provider_url]
  end
end

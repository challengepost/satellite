require "spec_helper"

describe HighVoltage::PagesController, :omniauth do
  let(:warden) { double(Warden::Proxy, set_user: nil) }

  before do
    allow(Satellite.configuration).to receive(:enable_auto_login?) { true }

    # allow(warden).to receive(:authenticate!) { create(:user) }
    allow(warden).to receive(:authenticate) { create(:user) }
    request.env['warden'] = warden
    request.env['omniauth.auth'] = mock_auth

    allow(controller).to receive(:user_signed_in?).and_return(false)
  end

  context "configured domain (proxy configuration)" do
    before do
      request.host = "application.herokuapp.com"
      allow(Rails.application.config.action_controller).to receive(:default_url_options).and_return({ host: "application.com" })
    end

    it "redirects to the configured domain" do
      get :show, id: "about"
      expect(URI.parse(session[:return_to]).host).to eq "application.com"
    end
  end

  context "no configured domain" do
    before do
      request.host = "application.herokuapp.com"
    end

    it "redirects to the request domain" do
      get :show, id: "about"
      expect(URI.parse(session[:return_to]).host).to eq "application.herokuapp.com"
    end
  end
end

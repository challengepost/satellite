require "spec_helper"

describe Satellite::SessionsController, :omniauth do
  let(:warden) { double(Warden::Proxy, set_user: nil) }

  routes { Satellite::Engine.routes }

  before do
    allow(Satellite.configuration).to receive(:enable_auto_login?) { false }

    allow(warden).to receive(:authenticate!) { create(:user) }
    request.env['warden'] = warden
    request.env['omniauth.auth'] = mock_auth
  end

  describe "#create" do
    it "creates a user" do
      expect {post :create, provider: :devpost}.to change{ User.count }.by(1)
    end

    it "redirects the user to the root" do
      post :create, provider: :devpost
      expect(response).to redirect_to "/"
    end
  end

  describe "#destroy" do
    before do
      post :create, provider: :devpost
    end

    it "resets the session" do
      expect(controller).to receive(:reset_session)
      delete :destroy
    end

    it "redirects to the home page" do
      delete :destroy
      expect(response).to redirect_to "/"
    end
  end

  describe "#failure" do
    render_views

    it "renders template when not redirecting offsire" do
      allow(warden).to receive(:authenticate) { nil }
      allow(Satellite.configuration).to receive(:provider_root_url) { nil }

      get :failure

      expect(response.code.to_i).to eq 200
      expect(response.body).to match %r{Whoa}
    end

    it "renders to provider root url when configured" do
      allow(Satellite.configuration).to receive(:provider_root_url) { "http://devpost.com" }

      get :failure

      expect(response.code.to_i).to eq 302
      expect(response).to redirect_to "http://devpost.com"
    end
  end

  describe "#refresh" do
    it "clears the user_uid cookie and redirects to the return_to url stored in the session" do
      return_to_url = "http://devpost.com/teams/devpost"

      session = double
      allow(controller).to receive(:session) { session }
      allow(session).to receive(:delete).with(:return_to) { return_to_url }

      cookies = double(:delete)
      allow(controller).to receive(:cookies) { cookies }
      expect(cookies).to receive(:delete).with(:user_uid, domain: :all, httponly: true)

      get :refresh

      expect(response).to redirect_to "//devpost.com/teams/devpost"
    end
  end
end

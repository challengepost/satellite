require "spec_helper"

describe Satellite::SessionsController, :omniauth do
  let(:warden) { double(Warden::Proxy, set_user: nil) }

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
      expect(response).to redirect_to root_path
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
      expect(response).to redirect_to root_url
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
end

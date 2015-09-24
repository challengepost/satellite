require "spec_helper"

describe Satellite::User do
  before(:each) { @user = User.new(email: 'user@example.com') }

  subject { @user }

  describe "self.find_or_create_with_omniauth" do
    let(:existing_user) { create(:devpost_user) }

    def auth(options = {})
      options.reverse_merge({
        'provider' => 'devpost',
        'uid' => generate(:uid),
        'info' => {}
      })
    end

    it "finds existing user by provider and uid" do
      omniauth_user = User.find_or_create_with_omniauth(auth('uid' => existing_user.uid))

      expect(omniauth_user).to eq(existing_user)
    end

    it "does not create new user by with existing provider and uid" do
      user = existing_user
      expect {User.find_or_create_with_omniauth(auth('uid' => user.uid))}.not_to change{ User.count }
    end

    it "creates new user with new provider and uid" do
      expect {User.find_or_create_with_omniauth(auth)}.to change{ User.count }.by(1)
    end

    it "assigns given credentials for new user" do
      info = {
        'first_name' => 'Missy',
        'last_name' => 'Wednesday',
        'email' => 'missy@example.com'
      }
      user = User.find_or_create_with_omniauth(auth('info' => info))
      expect(user.name).to eq('Missy Wednesday')
      expect(user.email).to eq('missy@example.com')
    end
  end
end

require "spec_helper"

describe Satellite::Configuration do
  it { expect(subject.user_class).to eq(Satellite::Configuration::User) }
  it { expect(subject.anonymous_user_class).to eq(Satellite::Configuration::AnonymousUser) }

  describe "provider" do
    it { expect { subject.provider }.to raise_error }

    it "must be set" do
      subject.provider = 'devpost'
      expect(subject.provider).to eq 'devpost'
    end
  end

  describe "settings" do
    describe "default to" do
      it { expect{subject.provider}.to raise_error(Satellite::ConfigurationError) }
      it { expect(subject.omniauth_args).to eq [] }
      it { expect(subject.warden_config_blocks).to eq [] }
      it { expect(subject.enable_auto_login).to be true }
      it { expect(subject.user_class).to eq Satellite::Configuration::User }
      it { expect(subject.anonymous_user_class).to eq Satellite::Configuration::AnonymousUser }
    end

    describe "configured" do

      it "provider" do
        subject.provider = :devpost
        expect(subject.provider).to eq :devpost
      end

      it "omniauth_args" do
        subject.omniauth_args = %w[key secret]
        expect(subject.omniauth_args).to eq %w[key secret]
      end

      it "warden_config_blocks" do
        @count = 1
        subject.warden_config_blocks << Proc.new { @count += 1 }
        subject.warden_config_blocks.each(&:call)
        expect(@count).to eq 2
      end

      it "enable_auto_login" do
        subject.enable_auto_login = false
        expect(subject.enable_auto_login?).to be false
      end

      it "user_class" do
        user_class = Class.new
        subject.user_class = user_class
        expect(subject.user_class).to eq user_class
      end

      it "anonymous_user_class" do
        anon_class = Class.new
        subject.anonymous_user_class = anon_class
        expect(subject.anonymous_user_class).to eq anon_class
      end

      it "provider_root_url" do
        expect{subject.provider_root_url = "invalid url"}.to raise_error(Satellite::ConfigurationError)

        subject.provider_root_url = "http://devpost.com"
        expect(subject.provider_root_url).to eq "http://devpost.com"
      end

    end
  end

end

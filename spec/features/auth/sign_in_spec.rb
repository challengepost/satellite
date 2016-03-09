require "spec_helper"

feature 'Sign in', :omniauth do
  context "Manual login", satellite: :manual_login do
    scenario "user can sign in with valid account" do
      sign_in
      expect(page).to have_content("bob@example.com")
      expect(page).to have_content("Sign out")
    end

    scenario 'user cannot sign in with invalid account' do
      mock_auth :invalid_credentials

      visit root_path
      click_link "Sign in"
      expect(page).not_to have_content("bob@example.com")
      expect(page).not_to have_content("Sign out")
    end
  end

  context "Auto login", satellite: :auto_login do
    background { mock_sso_auth }

    scenario "user with valid account is logged in automatically" do
      visit page_path('about')
      expect(page).to have_content("About the Warehouse")
      expect(page).to have_content("bob@example.com")
      expect(page).to have_content("Sign out")
    end

    scenario 'user cannot sign in with invalid account' do
      mock_auth :invalid_credentials

      visit page_path('about')
      expect(page).not_to have_content("About the Warehouse")
      expect(page).not_to have_content("bob@example.com")
    end

  end
end

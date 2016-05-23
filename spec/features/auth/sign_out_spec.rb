require "spec_helper"

feature 'Sign out', :omniauth do
  context "Manual login", satellite: :manual_login do
    scenario 'user signs out successfully' do
      sign_in
      click_link 'Sign out'
      expect(page).to have_content 'Signed out'
    end
  end

  context "Auto login", satellite: :auto_login do
    background { mock_sso_auth }

    scenario 'user signs out successfully' do
      visit page_path('about')
      click_link 'Sign out'
      expect(page).not_to have_content 'Sign out'
      expect(page).to have_content 'Sign in'
    end
  end
end

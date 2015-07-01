require 'spec_helper'
require 'rails_helper'

RSpec.describe "User", type: :request do


  describe "New" do
    it "Edit profile and display the results" do
      visit root_path
      click_link 'Register'
      fill_in 'user_username', with: "Tato"
      fill_in 'user_email', with: "tato@example.com"
      fill_in 'user_password', with: "12345678"
      fill_in 'user_password_confirmation', with: "12345678"
      click_button "Sign up"
      page.should have_content "Welcome! You have signed up successfully."

      click_link 'Edit Profile'
      fill_in 'profile_first_name', with: "Tato"
      fill_in 'profile_last_name', with: "Molina"
      fill_in 'profile_date_of_birth', with: "11/16/1991"
      click_button "Update"
      page.should have_content "Your profile has been updated."
      page.should have_content "Basic Information"
      page.should have_content "Username"
      page.should have_content "Email"
      page.should have_content "First name"
      page.should have_content "Last name"
      page.should have_content "Age"
      page.should have_content "Languages"
      page.should have_content "Tato"
      page.should have_content "tato@example.com"
      page.should have_content "Tato"
      page.should have_content "Molina"
      page.should have_content "Languages not specified"

    end
  end
end

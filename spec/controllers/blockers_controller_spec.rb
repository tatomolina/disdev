require 'rails_helper'

RSpec.describe BlockersController, :type => :controller do
  let(:user) {
    User.create!(username: "user",email: "user@example.com",
     password: "12345678", password_confirmation: "12345678")
  }

  before(:each) do
      sign_in user
    end
=begin
  describe 'GET show' do
    it "returns 200 (ok) response code" do
      @blocker = Blocker.create!(title: "super blocker", description: "I'm a super blocker")
      get blocker_path(@blocker)
      expect(response).to have_http_status(:ok)
    end

    it "renders the show template" do
      get blocker_path(@blocker)
      expect(response).to render_template("show")
    end
  end
=end

end

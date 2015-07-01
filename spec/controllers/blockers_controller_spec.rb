require 'rails_helper'

RSpec.describe BlockersController, :type => :controller do
  let(:user) {
    User.create!(username: "user",email: "user@example.com",
     password: "12345678", password_confirmation: "12345678")
  }

  let(:blocker) do
    blocker = Blocker.create!(title: "super blocker", description: "I'm a super blocker")
    blocker.stand_up = stand_up
    blocker
  end

  let(:stand_up) do
    stand_up = StandUp.create!()
    stand_up.project = project
    stand_up.user = user
    stand_up
  end

  let(:project) do
    project = Project.create!(name: "Project")
    project.work_group = group
    project.add! user
    project
  end

  let(:group) { WorkGroup.create!(name: "Group")}



  before(:each) do
      sign_in user
    end

=begin
  describe 'GET show' do
    it "returns 200 (ok) response code" do
      get :show, id: blocker
      expect(response).to have_http_status(:ok)
    end

    it "renders the show template" do
      get :show, id: blocker
      expect(response).to render_template("show")
    end

    it "assigns active project with show" do
      get :show, id: blocker
      assigns(:active_project).should eq(:show)
    end

  end

  describe 'POST updte' do
    let(:attr) do
      { title: "I'm a title", description: "I'm a super duper description"}
    end
    let(:invalid_attr) do
      { title: "title", description: "description"}
    end
    context "Valid attributes" do
      before(:each) do
        @blocker = FactoryGirl.create(:blocker)
        post :update, id: @blocker.id, :blocker => attr
        @blocker.reload
      end
      it "if the update is okay it should redirect to show" do
        expect(response).to redirect_to(@blocker)
      end

      it "if it update should change" do
        expect(@blocker.title).to eql(attr[:title])
        expect(@blocker.description).to eql(attr[:description])
      end

    end

    context "InValid attributes" do
      before(:each) do
        @blocker = FactoryGirl.create(:blocker)
        post :update, id: @blocker.id, :blocker => invalid_attr
        @blocker.reload
      end

      it "locates the requested @blocker" do
        assigns(:blocker).should eq(@blocker)
      end

      it "if the update has any error should render edit" do
        expect(response).to render_template :edit
      end

      it "does not change @blocker attributes" do
        expect(@blocker.title).should_not eq(invalid_attr[:title])
        expect(@blocker.description).should_not eq(invalid_attr[:description])
      end

    end
  end


  describe "DELETE destroy" do
    before(:each) do
      @blocker = FactoryGirl.create(:blocker)
      @blocker.stand_up = stand_up
    end

    it "deletes the blocker" do
      expect{
        delete :destroy, id: @blocker
      }.to change(Blocker, :count).by(-1)
    end

    it "redirect to stand_up#show" do
      delete :destroy, id: @blocker
      response.should redirect_to stand_up_path(stand_up)
    end

  end
=end
end

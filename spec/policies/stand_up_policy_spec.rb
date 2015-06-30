require 'rails_helper'

RSpec.describe StandUpPolicy, :type => :model do
  subject {StandUpPolicy}

  let(:group) {WorkGroup.create!(name: "group")}

  let(:project) do
    project = Project.create!(name: "project")
    project.work_group = group
    project
  end

  let(:stand_up) do
    stand_up = StandUp.create!()
    stand_up.project = project
    stand_up.user = user_in_project
    stand_up
  end

  let(:stand_up_2) do
    stand_up = StandUp.create!()
    stand_up.created_at = DateTime.new(2012, 8, 24, 22, 35, 0)
    stand_up.project = project
    stand_up.user = user_in_project
    stand_up
  end

  let(:user) {User.create!(username: "user",
     email: "user@example.com", password: "12345678",
    password_confirmation: "12345678")}

  let(:user_in_work_group) do
    user = User.create!(username: "user in work group",
    email: "user_in_work_group@example.com", password: "12345678",
    password_confirmation: "12345678")
    group.add! user
    user
  end

  let(:user_in_project) do
    user = User.create!(username: "user in project",
     email: "user_in_project@example.com", password: "12345678",
    password_confirmation: "12345678")
    group.add! user
    project.add! user
    user
  end

  let(:user_in_project_2) do
    user = User.create!(username: "user in project 2",
     email: "user_in_project_2@example.com", password: "12345678",
    password_confirmation: "12345678")
    group.add! user
    project.add! user
    user
  end

  let(:admin) do
    user = User.create!(username: "admin", email: "admin@example.com", password: "12345678",
    password_confirmation: "12345678")
    user.add_role :admin
    user
  end

  permissions :show? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, stand_up)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, stand_up)
    end

    it "is denied to users members of group" do
      expect(subject).not_to permit(user_in_work_group, stand_up)
    end

    it "is permited to users members of project" do
      expect(subject).to permit(user_in_project, stand_up)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, stand_up)
    end

  end

  permissions :new? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, StandUp)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, StandUp)
    end

    it "is denied to users members of group" do
      expect(subject).not_to permit(user_in_work_group, StandUp)
    end

    it "is permited to users members of project" do
      expect(subject).to permit(user_in_project, StandUp)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, StandUp)
    end

  end

  permissions :create? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, stand_up)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, stand_up)
    end

    it "is denied to users members of group" do
      expect(subject).not_to permit(user_in_work_group, stand_up)
    end

    it "is permited to users members of project" do
      expect(subject).to permit(user_in_project, stand_up)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, stand_up)
    end
  end

  permissions :edit? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, stand_up)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, stand_up)
    end

    it "is denied to users members of group" do
      expect(subject).not_to permit(user_in_work_group, stand_up)
    end

    it "is denied to users members of project and but the user is not the author of the standUp" do
      expect(subject).not_to permit(user_in_project_2, stand_up)
    end

    it "is denied to users members of project and standUp was created 24 hs or more" do
      expect(subject).not_to permit(user_in_project, stand_up_2)
    end

    it "is permited to users members of project and standUp was created with in 24 hs from now" do
      expect(subject).to permit(user_in_project, stand_up)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, stand_up)
    end
  end

  permissions :update? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, stand_up)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, stand_up)
    end

    it "is denied to users members of group" do
      expect(subject).not_to permit(user_in_work_group, stand_up)
    end

    it "is denied to users members of project and but the user is not the author of the standUp" do
      expect(subject).not_to permit(user_in_project_2, stand_up)
    end

    it "is denied to users members of project and standUp was created 24 hs or more" do
      expect(subject).not_to permit(user_in_project, stand_up_2)
    end

    it "is permited to users members of project and standUp was created with in 24 hs from now" do
      expect(subject).to permit(user_in_project, stand_up)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, stand_up)
    end
  end

  permissions :destroy? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, stand_up)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, stand_up)
    end

    it "is denied to users members of group" do
      expect(subject).not_to permit(user_in_work_group, stand_up)
    end

    it "is denied to users members of project and but the user is not the author of the standUp" do
      expect(subject).not_to permit(user_in_project_2, stand_up)
    end

    it "is denied to users members of project and standUp was created 24 hs or more" do
      expect(subject).not_to permit(user_in_project, stand_up_2)
    end

    it "is permited to users members of project and standUp was created with in 24 hs from now" do
      expect(subject).to permit(user_in_project, stand_up)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, stand_up)
    end
  end

end

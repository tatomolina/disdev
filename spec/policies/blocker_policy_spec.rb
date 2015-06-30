require 'rails_helper'

RSpec.describe BlockerPolicy, :type => :model do
  subject {BlockerPolicy}

  let(:group) {WorkGroup.create!(name: "group")}

  let(:project) do
    project = Project.create!(name: "project")
    project.work_group = group
    project
  end

  let(:stand_up) do
    stand_up = StandUp.create!()
    stand_up.project = project
    stand_up.user = owner_of_stand_up
    stand_up
  end

  let(:stand_up_2) do
    stand_up = StandUp.create!()
    stand_up.created_at = DateTime.new(2012, 8, 24, 22, 35, 0)
    stand_up.project = project
    stand_up.user = owner_of_stand_up
    stand_up
  end

  let(:blocker) do
    blocker = Blocker.create!(title: "this is a title", description: "This is the description")
    blocker.stand_up = stand_up
    blocker
  end

  let(:blocker_2) do
    blocker = Blocker.create!(title: "this is a title", description: "This is the description")
    blocker.stand_up = stand_up_2
    blocker
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

  let(:owner_of_stand_up) do
    user = User.create!(username: "owner of stand_up",
     email: "owner_of_stand_up@example.com", password: "12345678",
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
      expect(subject).not_to permit(nil, blocker)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, blocker)
    end

    it "is denied to users members of group" do
      expect(subject).not_to permit(user_in_work_group, blocker)
    end

    it "is permited to users members of project and the user is not the author of the standUp" do
      expect(subject).to permit(user_in_project, blocker)
    end

    it "is permited to the owner of the standUp" do
      expect(subject).to permit(owner_of_stand_up, blocker)
    end

    it "is permited to the admin" do
      expect(subject).to permit(admin, blocker)
    end
  end

  permissions :edit? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, blocker)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, blocker)
    end

    it "is denied to users members of group" do
      expect(subject).not_to permit(user_in_work_group, blocker)
    end

    it "is denied to users members of project and the user is not the author of the standUp" do
      expect(subject).not_to permit(user_in_project, blocker)
    end

    it "is denied to the author of the stand_up and it was created 24 hs ago or more" do
      expect(subject).not_to permit(owner_of_stand_up, blocker_2)
    end

    it "is permited to the user who created the standUp and it was created with in 24 hs from now" do
      expect(subject).to permit(owner_of_stand_up, blocker)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, blocker)
    end
  end

  permissions :update? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, blocker)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, blocker)
    end

    it "is denied to users members of group" do
      expect(subject).not_to permit(user_in_work_group, blocker)
    end

    it "is denied to users members of project and the user is not the author of the standUp" do
      expect(subject).not_to permit(user_in_project, blocker)
    end

    it "is denied to the author of the stand_up and it was created 24 hs ago or more" do
      expect(subject).not_to permit(owner_of_stand_up, blocker_2)
    end

    it "is permited to the user who created the standUp and it was created with in 24 hs from now" do
      expect(subject).to permit(owner_of_stand_up, blocker)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, blocker)
    end
  end

  permissions :destroy? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, blocker)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, blocker)
    end

    it "is denied to users members of group" do
      expect(subject).not_to permit(user_in_work_group, blocker)
    end

    it "is denied to users members of project and the user is not the author of the standUp" do
      expect(subject).not_to permit(user_in_project, blocker)
    end

    it "is denied to the author of the stand_up and it was created 24 hs ago or more" do
      expect(subject).not_to permit(owner_of_stand_up, blocker_2)
    end

    it "is permited to the user who created the standUp and it was created with in 24 hs from now" do
      expect(subject).to permit(owner_of_stand_up, blocker)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, blocker)
    end
  end

end

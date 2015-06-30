require 'rails_helper'

RSpec.describe WorkGroupPolicy, :type => :model do
  subject {WorkGroupPolicy}

  let(:group) do
    group = WorkGroup.create!(name: "group")
    group.add! user_in_work_group
    group.add! user_in_work_group_2
    group
  end

  let(:user) {User.create!(username: "user",
     email: "user@example.com", password: "12345678",
    password_confirmation: "12345678")}

  let(:user_in_work_group) do
    user = User.create!(username: "user in work group",
    email: "user_in_work_group@example.com", password: "12345678",
    password_confirmation: "12345678")
    user
  end

  let(:user_in_work_group_2) do
    user = User.create!(username: "user in project",
     email: "user_in_project@example.com", password: "12345678",
    password_confirmation: "12345678")
    user
  end

  let(:admin) do
    user = User.create!(username: "admin", email: "admin@example.com", password: "12345678",
    password_confirmation: "12345678")
    user.add_role :admin
    user
  end

  permissions :index? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, group)
    end

    it "is permited to logged in users" do
      expect(subject).to permit(user, group)
    end
  end

  permissions :show? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, group)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, group)
    end

    it "is permited to users members of group" do
      expect(subject).to permit(user_in_work_group, group)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, group)
    end

  end

  permissions :show_projects? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, group)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, group)
    end

    it "is permited to users members of group" do
      expect(subject).to permit(user_in_work_group, group)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, group)
    end

  end

  permissions :show_manage? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, group)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, group)
    end

    it "is denied to users members of group" do
      expect(subject).not_to permit(user_in_work_group_2, group)
    end

    it "is permited to users members of group with role owner" do
      expect(subject).to permit(user_in_work_group, group)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, group)
    end

  end

  permissions :new? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, group)
    end

    it "is permited to logged in users" do
      expect(subject).to permit(user, group)
    end

    it "is permited to users members of others groups" do
      expect(subject).to permit(user_in_work_group, group)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, group)
    end

  end

  permissions :create? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, group)
    end

    it "is permited to logged in users" do
      expect(subject).to permit(user, group)
    end

    it "is permited to users members of others groups" do
      expect(subject).to permit(user_in_work_group, group)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, group)
    end

  end

  permissions :edit? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, group)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, group)
    end

    it "is denied to users members of group" do
      expect(subject).not_to permit(user_in_work_group_2, group)
    end

    it "is permited to the owner of the group" do
      expect(subject).to permit(user_in_work_group, group)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, group)
    end
  end

  permissions :update? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, group)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, group)
    end

    it "is denied to users members of group" do
      expect(subject).not_to permit(user_in_work_group_2, group)
    end

    it "is permited to the owner of the group" do
      expect(subject).to permit(user_in_work_group, group)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, group)
    end
  end

  permissions :destroy? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, group)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, group)
    end

    it "is denied to users members of group" do
      expect(subject).not_to permit(user_in_work_group_2, group)
    end

    it "is permited to the owner of the group" do
      expect(subject).to permit(user_in_work_group, group)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, group)
    end
  end

  permissions :add_user? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, group)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, group)
    end

    it "is denied to users members of group" do
      expect(subject).not_to permit(user_in_work_group_2, group)
    end

    it "is permited to the owner of the group" do
      expect(subject).to permit(user_in_work_group, group)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, group)
    end
  end

  permissions :remove_user? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, group)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, group)
    end

    it "is denied to users members of group" do
      expect(subject).not_to permit(user_in_work_group_2, group)
    end

    it "is permited to the owner of the group" do
      expect(subject).to permit(user_in_work_group, group)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, group)
    end
  end

  permissions :request_for_join? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, group)
    end

    it "is permited to logged in users" do
      expect(subject).to permit(user, group)
    end

    it "is denied to users members of group" do
      expect(subject).not_to permit(user_in_work_group_2, group)
    end

    it "is denied to the owner of the group" do
      expect(subject).not_to permit(user_in_work_group, group)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, group)
    end
  end


  permissions :assign_roles? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, group)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, group)
    end

    it "is denied to users members of group" do
      expect(subject).not_to permit(user_in_work_group_2, group)
    end

    it "is permited to the owner of the group" do
      expect(subject).to permit(user_in_work_group, group)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, group)
    end
  end

end

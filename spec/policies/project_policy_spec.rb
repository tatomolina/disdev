require 'rails_helper'

RSpec.describe ProjectPolicy, :type => :model do
  subject {ProjectPolicy}

  let(:group) do
    group = WorkGroup.create!(name: "group")
    group.add! user_in_work_group
    group.add! user_in_project
    group
  end

  let(:project) do
    project = Project.create!(name: "Project")
    project.add! user_in_project
    project.add! user_in_project_2
    project.add! scrum_master
    scrum_master.add_role :scrum_master, project
    project.work_group = group
    project
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

  let(:user_in_project) do
    user = User.create!(username: "user in project",
     email: "user_in_project@example.com", password: "12345678",
    password_confirmation: "12345678")
    user
  end

  let(:user_in_project_2) do
    user = User.create!(username: "user in project 2",
     email: "user_in_project_2@example.com", password: "12345678",
    password_confirmation: "12345678")
    user
  end

  let(:scrum_master) do
    user = User.create!(username: "scrum master",
     email: "scrum_master@example.com", password: "12345678",
    password_confirmation: "12345678")
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
      expect(subject).not_to permit(nil, project)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, project)
    end

    it "is denied to users members of project" do
      expect(subject).not_to permit(user_in_work_group, project)
    end

    it "is permited to users members of project" do
      expect(subject).to permit(user_in_project, project)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, project)
    end

  end

  permissions :show_activities? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, project)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, project)
    end

    it "is denied to users members of work group" do
      expect(subject).not_to permit(user_in_work_group, project)
    end

    it "is permited to users members of project" do
      expect(subject).to permit(user_in_project, project)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, project)
    end

  end

  permissions :show_blockers? do

    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, project)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, project)
    end

    it "is denied to users members of work group" do
      expect(subject).not_to permit(user_in_work_group, project)
    end

    it "is denied to users members of project" do
      expect(subject).not_to permit(user_in_project_2, project)
    end

    it "is permited to the manager" do
      expect(subject).to permit(user_in_project, project)
    end

    it "is permited to the scrum_master" do
      expect(subject).to permit(scrum_master, project)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, project)
    end

  end

  permissions :show_manage? do

    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, project)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, project)
    end

    it "is denied to users members of work group" do
      expect(subject).not_to permit(user_in_work_group, project)
    end

    it "is denied to users members of project" do
      expect(subject).not_to permit(user_in_project_2, project)
    end

    it "is permited to the manager" do
      expect(subject).to permit(user_in_project, project)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, project)
    end

  end
  permissions :new? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, project)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, project)
    end

    it "is permited to users members of groups" do
      expect(subject).to permit(user_in_work_group, project)
    end

    it "is permited to users members of others projects" do
      expect(subject).to permit(user_in_project, project)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, project)
    end

  end

  permissions :create? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, project)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, project)
    end

    it "is permited to users members of others projects" do
      expect(subject).to permit(user_in_project, project)
    end

    it "is permited to users members of group" do
      expect(subject).to permit(user_in_work_group, project)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, project)
    end

  end

  permissions :edit? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, project)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, project)
    end

    it "is denied to users members of project" do
      expect(subject).not_to permit(user_in_project_2, project)
    end

    it "is permited to the manager of the project" do
      expect(subject).to permit(user_in_project, project)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, project)
    end
  end

  permissions :update? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, project)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, project)
    end

    it "is denied to users members of project" do
      expect(subject).not_to permit(user_in_project_2, project)
    end

    it "is permited to the manager of the project" do
      expect(subject).to permit(user_in_project, project)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, project)
    end
  end

  permissions :destroy? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, project)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, project)
    end

    it "is denied to users members of project" do
      expect(subject).not_to permit(user_in_project_2, project)
    end

    it "is permited to the manager of the project" do
      expect(subject).to permit(user_in_project, project)
    end

    it "is permited to the owner of the group where the project is holded" do
      expect(subject).to permit(user_in_work_group, project)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, project)
    end
  end

  permissions :join? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, project)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, project)
    end

    it "is denied to users members of project" do
      expect(subject).not_to permit(user_in_project_2, project)
    end

    it "is permited to members of groups but they arent in the project yet" do
      expect(subject).to permit(user_in_work_group, project)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, project)
    end
  end

  permissions :leave? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, project)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, project)
    end

    it "is permited to users members of project" do
      expect(subject).to permit(user_in_project_2, project)
    end

    it "is denied to members of groups but they arent in the project yet" do
      expect(subject).not_to permit(user_in_work_group, project)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, project)
    end
  end

  permissions :assign_roles? do
    it "is denied to non-logged users" do
      expect(subject).not_to permit(nil, project)
    end

    it "is denied to logged in users" do
      expect(subject).not_to permit(user, project)
    end

    it "is denied to users members of project" do
      expect(subject).not_to permit(user_in_project_2, project)
    end

    it "is permited to the manager of the project" do
      expect(subject).to permit(user_in_project, project)
    end

    it "is permited to user with role admin" do
      expect(subject).to permit(admin, project)
    end
  end
end

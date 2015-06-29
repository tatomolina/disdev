require 'rails_helper'

RSpec.describe Project, :type => :model do

  let(:project) { Project.create!( name: "project")}

  let(:user) do
    user = User.create!(username: "user",
     email: "user@example.com", password: "12345678",
    password_confirmation: "12345678")
    project.add! user
    user
  end

  let(:all_roles) do
    all_roles = User.create!(username: "all_roles",
     email: "all_roles@example.com", password: "12345678",
    password_confirmation: "12345678")
    all_roles.add_role :manager, project
    all_roles.add_role :scrum_master, project
    all_roles.add_role :developer, project
    all_roles.add_role :product_owner, project
    all_roles
  end

  let(:manager) do
    manager = User.create!(username: "manager",
     email: "manager@example.com", password: "12345678",
    password_confirmation: "12345678")
    manager.add_role :manager, project
    manager
  end

  let(:scrum_master) do
    scrum_master = User.create!(username: "scrum_master",
     email: "scrum_master@example.com", password: "12345678",
    password_confirmation: "12345678")
    scrum_master.add_role :scrum_master, project
    scrum_master
  end

  let(:developer) do
    developer = User.create!(username: "developer",
     email: "developer@example.com", password: "12345678",
    password_confirmation: "12345678")
    developer.add_role :developer, project
    developer
  end

  let(:product_owner) do
    product_owner = User.create!(username: "product_owner",
     email: "product_owner@example.com", password: "12345678",
    password_confirmation: "12345678")
    product_owner.add_role :product_owner, project
    product_owner
  end

  let(:user_not_in_project) do
    user = User.create!(username: "user_not_in_project",
     email: "user_not_in_project@example.com", password: "12345678",
    password_confirmation: "12345678")
    user
  end

  let(:user_not_in_project_2) do
    user = User.create!(username: "user_not_in_project_2",
     email: "user_not_in_project_2@example.com", password: "12345678",
    password_confirmation: "12345678")
    user
  end

  describe "::member?" do
    it "return false is the user is not member" do
      expect(project.member? user_not_in_project).to be false
    end

    it "return true is the user is member" do
      expect(project.member?(user)).to be true
    end
  end

  describe "::add!" do
    before(:each) do
      project.add! user_not_in_project
    end
    it "return true is the user is addded corretcly" do
      expect(project.member? user_not_in_project).to be true
    end

    it "return true if the user has the role manager when he is the first one to be added to the project" do
      expect(user_not_in_project.has_role? :manager, project).to be true
    end

    it "return false if the user has not the role manager when he is not the first to be added to the project" do
      project.add! user_not_in_project_2
      expect(user_not_in_project_2.has_role? :manager, project).to be false
    end
  end

  describe "::remove!" do
    before(:each) do
      project.remove! user
    end
    it "return true is the user is addded corretcly" do
      expect(project.member? user).to be false
    end
  end

  describe "::remove_roles(user)" do

    it "return false if the user has not the manager role" do
      project.remove_roles(manager)
      expect(manager.has_role? :manager, project).to be false
    end

    it "return false if the user has not the scrum_master role" do
      project.remove_roles(scrum_master)
      expect(manager.has_role? :scrum_master, project).to be false
    end

    it "return false if the user has not the developer role" do
      project.remove_roles(developer)
      expect(manager.has_role? :developer, project).to be false
    end

    it "return false if the user has not the product_owner role" do
      project.remove_roles(product_owner)
      expect(manager.has_role? :product_owner, project).to be false
    end

    it "return false if the user has not any of the roles" do
      project.remove_roles(all_roles)
      expect(all_roles.has_role? :manager, project).to be false
      expect(all_roles.has_role? :developer, project).to be false
      expect(all_roles.has_role? :scrum_master, project).to be false
      expect(all_roles.has_role? :product_owner, project).to be false
    end
  end

  describe "::assign_manager" do
    before(:each) do
      scrum_master
      developer
      product_owner
    end
    it "return true when scrum master is assigned with role manager" do
      project.assign_manager
      expect(scrum_master.has_role? :manager, project).to be true
    end

    it "return true when scrum master is assigned with role manager" do
      project.remove_roles scrum_master
      project.assign_manager
      expect(developer.has_role? :manager, project).to be true
    end

    it "return true when product_owner is assigned with role manager" do
      project.remove_roles scrum_master
      project.remove_roles developer
      project.assign_manager
      expect(product_owner.has_role? :manager, project).to be true
    end

    it "return false when there is no one with role manager" do
      project.remove_roles scrum_master
      project.remove_roles developer
      project.remove_roles product_owner
      project.assign_manager
      expect(User.with_role(:manager, project).any?).to be false
    end
  end

end

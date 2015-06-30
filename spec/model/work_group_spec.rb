require 'rails_helper'

RSpec.describe WorkGroup, :type => :model do

  let(:work_group) { WorkGroup.create!( name: "work_group")}

  let(:user) do
    user = User.create!(username: "user",
     email: "user@example.com", password: "12345678",
    password_confirmation: "12345678")
    work_group.add! user
    user
  end

  let(:all_roles) do
    all_roles = User.create!(username: "all_roles",
     email: "all_roles@example.com", password: "12345678",
    password_confirmation: "12345678")
    all_roles.add_role :owner, work_group
    all_roles.add_role :member, work_group
    all_roles
  end

  let(:owner) do
    owner = User.create!(username: "owner",
     email: "owner@example.com", password: "12345678",
    password_confirmation: "12345678")
    owner.add_role :owner, work_group
    owner
  end

  let(:member) do
    member = User.create!(username: "member",
     email: "member@example.com", password: "12345678",
    password_confirmation: "12345678")
    member.add_role :member, work_group
    member
  end

  let(:user_not_in_work_group) do
    user = User.create!(username: "user_not_in_work_group",
     email: "user_not_in_work_group@example.com", password: "12345678",
    password_confirmation: "12345678")
    user
  end

  let(:user_not_in_work_group_2) do
    user = User.create!(username: "user_not_in_work_group_2",
     email: "user_not_in_work_group_2@example.com", password: "12345678",
    password_confirmation: "12345678")
    user
  end

  describe "::member?" do
    it "return false is the user is not member" do
      expect(work_group.member? user_not_in_work_group).to be false
    end

    it "return true is the user is member" do
      expect(work_group.member?(user)).to be true
    end
  end
  describe "::add!" do
    before(:each) do
      work_group.add! user_not_in_work_group
    end
    it "return true is the user is addded corretcly" do
      expect(work_group.member? user_not_in_work_group).to be true
    end

    it "return true if the user has the role owner when he is the first one to be added to the work_group" do
      expect(user_not_in_work_group.has_role? :owner, work_group).to be true
    end

    it "return false if the user has not the role owner when he is not the first to be added to the work_group" do
      work_group.add! user_not_in_work_group_2
      expect(user_not_in_work_group_2.has_role? :owner, work_group).to be false
    end
  end

  describe "::remove!" do
    before(:each) do
      work_group.remove! user
    end
    it "return true is the user is addded corretcly" do
      expect(work_group.member? user).to be false
    end
  end

  describe "::remove_roles(user)" do

    it "return false if the user has not the owner role" do
      expect(owner.has_role? :owner, work_group).to be true
      work_group.remove_roles(owner)
      expect(owner.has_role? :owner, work_group).to be false
    end

    it "return false if the user has not the member role" do
      expect(member.has_role? :member, work_group).to be true
      work_group.remove_roles(member)
      expect(member.has_role? :member, work_group).to be false
    end

    it "return false if the user has not any of the roles" do
      expect(all_roles.has_role? :owner, work_group).to be true
      expect(all_roles.has_role? :member, work_group).to be true
      work_group.remove_roles(all_roles)
      expect(all_roles.has_role? :owner, work_group).to be false
      expect(all_roles.has_role? :member, work_group).to be false
    end
  end

  describe "::assign_owner" do

    before(:each) do
      member
    end

    it "return true when member is assigned with role manager" do
      work_group.assign_owner
      expect(member.has_role? :owner, work_group).to be true
    end

  end
end

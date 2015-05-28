class User < ActiveRecord::Base
  # Class user respresents the users and the members of the workGroups
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :work_group
  has_many :stand_ups, foreign_key: "user_id"
end

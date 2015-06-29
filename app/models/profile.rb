class Profile < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :languages
  validates :first_name, presence: true
  validates :last_name, presence: true
end

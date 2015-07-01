class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :blocker
  validates :answer, presence: true
end

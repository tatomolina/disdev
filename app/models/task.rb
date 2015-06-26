class Task < ActiveRecord::Base
  #Tasks are the principal issues the users are going to acomplish in their StandUps
  #Here I validates the contents of the instance variables
  #And set the realtionship Between standUp and Tasks
  validates :description, presence: true, length: {
    minimum: 1,
    maximum: 20,
    tokenizer: lambda { |str| str.scan(/\w+/) },
    too_short: "must have at least %{count} words",
    too_long: "must have at most %{count} words"
  }
  belongs_to :stand_up
end

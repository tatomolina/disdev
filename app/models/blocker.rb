class Blocker < ActiveRecord::Base
  #Blockers are the problems that the user may encounter developing their apps
  # and they will describe them in here
  #Here I validates the contents of the instance variables
  #And set the realtionship Between standUp and Blockers
  validates :title, presence: true, length: {minimum: 5}
  validates :description, presence: true, length: {
    minimum: 3,
    maximum: 400,
    tokenizer: lambda { |str| str.scan(/\w+/) },
    too_short: "must have at least %{count} words",
    too_long: "must have at most %{count} words"
  }
  belongs_to :stand_up
end

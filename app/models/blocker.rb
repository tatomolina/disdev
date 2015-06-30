class Blocker < ActiveRecord::Base
  #Blockers are the problems that the user may encounter developing their apps
  # and they will describe them in here
  
  # Do this to track blocker as an activity to show it as a notification.
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

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

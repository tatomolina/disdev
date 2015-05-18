class Task < ActiveRecord::Base
  validates :title, presence: true, length: {minimum: 5}
  validates :description, presence: true, length: {
    minimum: 3,
    maximum: 400,
    tokenizer: lambda { |str| str.scan(/\w+/) },
    too_short: "must have at least %{count} words",
    too_long: "must have at most %{count} words"
  }
  belongs_to :stand_up
  validates :stand_up, presence: true
end

FactoryGirl.define do  factory :answer do
    user nil
blocker nil
  end

  factory :blocker do
    title "I'm a blocker title"
    description "I'm a super description"
  end
end

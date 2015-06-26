group = WorkGroup.create!(:name => "Example")

tatoUser = User.create!(
  :username              => "Tato",
  :email                 => "tato@example.com",
  :password              => "12345678",
  :password_confirmation => "12345678"
)

project = Project.create!(name: "Example", work_group: group)

tatoUser.add_role :manager, project
tatoUser.add_role :owner, group
tatoUser.add_role :admin
group.add! tatoUser
project.add! tatoUser


for i in 1..5
  stand = StandUp.create!(user: tatoUser, project: project);
  if i == 5
    i = i + 1;
  end
  stand.created_at = DateTime.new(2012, 8, i, 22, 35, 0);
  stand.save!;

  Blocker.create!(title: 'First Blocker ' + i.to_s,   description: 'First Super Block! ' + i.to_s,   stand_up: stand);
  Blocker.create!(title: 'Second Blocker ' + i.to_s,  description: 'Second Super Block! ' + i.to_s,  stand_up: stand);
  Task.create!(description: 'First Super Task! ' + i.to_s,  stand_up: stand);
  Task.create!(description: 'Second Super Task! ' + i.to_s, stand_up: stand);
end

activities = PublicActivity::Activity.all
activities.each do |activity|
  activity.owner = tatoUser
  activity.save!
end

group = WorkGroup.new(:name => "Example")

tatoUser = User.new(
  :email                 => "tato@example.com",
  :password              => "12345678",
  :password_confirmation => "12345678"
)

tatoUser.add_role :admin
tatoUser.join! group
tatoUser.save!


for i in 1..5
  stand = StandUp.create!(user: tatoUser, work_group: group);
  if i == 5
    i = i + 1;
  end
  stand.created_at = DateTime.new(2012, 8, i, 22, 35, 0);
  stand.save!;

  Blocker.create!(title: 'First Blocker ' + i.to_s,   description: 'First Super Block! ' + i.to_s,   stand_up: stand);
  Blocker.create!(title: 'Second Blocker ' + i.to_s,  description: 'Second Super Block! ' + i.to_s,  stand_up: stand);
  Task.create!(title: 'First Task ' + i.to_s,  description: 'First Super Task! ' + i.to_s,  stand_up: stand);
  Task.create!(title: 'Second Task ' + i.to_s, description: 'Second Super Task! ' + i.to_s, stand_up: stand);
end

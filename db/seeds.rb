tatoUser = User.new(
  :email                 => "tato@example.com",
  :password              => "12345678",
  :password_confirmation => "12345678"
)
tatoUser.save!


firstStand = StandUp.new(user: tatoUser);
firstStand.save!;
Blocker.create!(title: 'First Blocker',   description: 'My first Block!',   stand_up: firstStand);
Blocker.create!(title: 'Second Blocker',  description: 'My second Block!',  stand_up: firstStand);
Task.create!(title: 'First Task',  description: 'My first Task!',  stand_up: firstStand);
Task.create!(title: 'Second Task', description: 'My second Task!', stand_up: firstStand);
yesterdayTask1 = Task.create!(title: 'First Task from Yesterday', description: 'My second Task from Yesterday!', stand_up: firstStand);
yesterdayTask2 = Task.create!(title: 'Second Task from Yesterday', description: 'My second Task from Yesterday!', stand_up: firstStand);
yesterdayBlocker = Blocker.create!(title: 'Blocker from Yesterday',  description: 'My Blocker from Yesterday!',  stand_up: firstStand);
yesterdayTask1.created_at = DateTime.yesterday
yesterdayTask2.created_at = DateTime.yesterday
yesterdayBlocker.created_at = DateTime.yesterday
yesterdayTask1.save!
yesterdayTask2.save!
yesterdayBlocker.save!

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

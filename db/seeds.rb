firstStand = StandUp.new;
firstStand.save!;
Blocker.create!(title: 'First Blocker',   description: 'My first Block!',   stand_up: firstStand);
Blocker.create!(title: 'Second Blocker',  description: 'My second Block!',  stand_up: firstStand);
Task.create!(title: 'First Task',  description: 'My first Task!',  stand_up: firstStand);
Task.create!(title: 'Second Task', description: 'My second Task!', stand_up: firstStand);

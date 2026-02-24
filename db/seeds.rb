CLASSES = ["Warrior", "Knight", "Mage", "Sorcerer", "Wizard", "Thief", "Archer", "Ranger", "Barbarian", "Cleric"]
NAMES = ["Aelwyn", "Thalara", "Bromrik", "Kaelis", "Myrra", "Dornath", "Elowen", "Varek", "Sylpha", "Korrin", "Faelar", "Braska", "Lirien", "Torvek", "Nyssa"]
GENDER = ["Male", "Female", "Other"]
RACES = ["Elf", "Orc", "Dwarf", "Gnome", "Human", "Half-Elf", "Kobold", "Goblin"]
MOOD = ["Dark", "Lighthearted", "Wacky", "Serious", "Uplifting", "Tragic"]
SETTING = ["Forest", "City", "Desert", "Castle", "Dragon's Lair", "High Seas"]
THEME = ["Fantasy", "High Fantasy", "Low Fantasy", "Pirate", "Sci-fi", "Modern", "Magical"]
EMAIL = ["carlos@gmail.com", "koji@gmail.com", "glau@gmail.com", "katherine@gmail.com"]
SPACER = 30

puts "Cleaning DB..."
Character.destroy_all
Story.destroy_all
User.destroy_all

puts "Seeding DB..."


4.times do |i|
  user = User.new({
    email: EMAIL[i],
    password: "123456"
  })
  puts "*" * SPACER
  puts "User: #{user.email}"
  puts "*" * SPACER
  user.save!
  2.times do
    character = Character.new({
    user_id: user.id,
    character_class: CLASSES.sample,
    gender: GENDER.sample,
    name: NAMES.sample,
    race: RACES.sample,
    bio: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."
    })
    puts "^" * SPACER
    puts "Character: #{character.name}"
    puts "Race: #{character.race}"
    puts "Class :#{character.character_class}"
    puts "v" * SPACER
    character.save!
    story = Story.new({
      character_id: character.id,
      health_points: 20,
      level: rand(1..10),
      mood: MOOD.sample,
      setting: SETTING.sample,
      summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
      title: "#{character.name}'s Story"
    })
    puts "Story: #{story.title}"
    puts "Setting: #{story.setting}."
    puts "Tone: #{story.mood}"
    story.save!
    Message.create!({
      story_id: story.id,
      content: "This is the only message for #{story.title}"
    })
    puts "Message added"
  end
end

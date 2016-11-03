require 'faker'

3.times do
    User.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password: Faker::Internet.password,
        role: "admin"
    )
end

5.times do
    User.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password: Faker::Internet.password,
        role: "premium"
    )
end

5.times do
    User.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password: Faker::Internet.password,
        role: "standard"
    )
end

users = User.all

25.times do
    Wiki.create!(
        user: users.sample,
        title: Faker::Lorem.sentence,
        body: Faker::Lorem.paragraph
    )
end

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"

    

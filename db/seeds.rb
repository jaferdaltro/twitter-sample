
# Create a main sample user.
User.create!(name:  "User Example",
  email: "example@example.com",
  password:              "foobar",
  password_confirmation: "foobar",
  admin: true,
  activated: true,
  activated_at: Time.zone.now)

# Generate a bunch of additional users.
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  # email = Faker::Internet.unique.email
  password = "password"
  User.create!(name:  name,
      email: email,
      password:              password,
      password_confirmation: password,
      activated: true,
      activated_at: Time.zone.now)
end

users = User.order(:created_at).take(7)
55.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each  {|user| user.microposts.create!(content: content)}
end

user = User.first 
users = User.all
following = users[2..50]
followers = users[3..40]
following.each{|followed| user.follow(followed)}
followers.each{|follower| follower.follow(user)}
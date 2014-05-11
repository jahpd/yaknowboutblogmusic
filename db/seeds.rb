# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email

post = Post.create(id: 1, author: user.name, title:"Hello World", doc:"#This is a seeded post, why?\n\na simple markdown code to embeed database\n\n```\n\tconsole.log \'hello world!\'\n```")
puts "CREATED POST: " << post.title

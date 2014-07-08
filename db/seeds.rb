# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email

[
{id: 0, author: user.name, title:"Hello World I", doc: """#Hello World!

this is a default post write with [Markdown](). If you want learn all, see the link;
some notes about coding.

In future I will add some more notes
""" },
{id: 1, author: user.name, title:"Hello World II", doc:"#This is a seeded post, why?\n\na simple markdown code to embeed database\n\n```\n\terminal.type \'hello world!\'\n```"},
{id: 2, author: user.name, title:"Some DSP basics I", doc:"""Lets start use gac (Gibberish Audio Client); it's a simplification from Gibberish (well, its like, but with some helpers that build musical structures); think as - if possible - as a musical grammar.

Here you can control DSP's, initialization time after 100ms, then start a DSP task after another 100ms:

    INIT 0, -> GEN \"Sine\", amp: 0.71, freq: 440

"""},
{id: 3, author: user.name, title:"Some DSP basics II", doc:"""You can use audio callbacks to create your own post-processing:

    INIT 0, ->
        TASK 100, 1000, ->
            GEN \"Sine\", amp: 0.71, freq: 440, (sine) -> 
                #=> do some post-processing

Or use variable assignement:

    INIT 0, ->
        TASK 100, 1000, ->
            sine = GEN \"Sine\", amp: 0.71, freq: 440
            #=> do something awesome

You can add more tasks:

    INIT 0, ->
        TASK 0, 1000 -> GEN \"Sine\", amp: 0.71, freq: 440
        TASK 800, 2000, -> GEN \"Sine\", amp: 0.35, freq: 880

""" }
].each{|e|
  post = Post.create(e)
  puts "CREATED POST: " << post.title
}

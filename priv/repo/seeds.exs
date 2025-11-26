# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     FilmChecklist.Repo.insert!(%FilmChecklist.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# priv/repo/seeds.exs
alias FilmChecklist.Repo
alias FilmChecklist.Checklists.ChecklistItem

# Clear existing items
Repo.delete_all(ChecklistItem)

# Define sections with their items and point values
checklist_data = [
  # Main tropes - 0.25 points each
  %{section: "tropes", point_value: 0.25, response_type: "checkbox", items: [
    "Actor playing a character with his/her own first name",
    "Adapted from a stage musical",
    "Adapted into a stage musical",
    "Airport or train station scene of any kind",
    "Bad date/bad date montage (blind or otherwise)",
    "Based on a book (written by someone other than Jane Austen, Terry McMillan, or Nicholas Sparks)",
    "Character reading and/or referring to a self-help book(s)",
    "Character(s) watching a chick flick",
    "Chase scene that does not feature explosions or cars rolling over",
    "Christmas and/or New Year's Day is instrumental to the plot",
    "Corsets",
    "Directed by the late, great Garry Marshall",
    "Dudes having heart-to-heart chats about how infatuated they are with particular women",
    "Dudes physically fighting over a girl",
    "Enlisting the help of friends/strangers to help the character win their love",
    "Falling in love montage",
    "Fashion/hair/makeup montage",
    "Female director",
    "Female producer", 
    "Female screenwriter",
    "Feminist under-/overtones",
    "Focus on female relationship",
    "Gay best friend",
    "Kissing in front of a crowd",
    "Knicks game",
    "Letter writing",
    "Lighthearted time travel",
    "Love triangle",
    "Makeover montage",
    "Male eye-candy",
    "Male nudity",
    "Meryl Streep singing",
    "More than eight lead characters",
    "Mother-daughter storyline",
    "Movie is generally derided by men",
    "Movie was suggested by Netflix after you streamed Leap Year",
    "Musical/dance numbers",
    "New York/Los Angeles/London as a character",
    "Numerals in title; not a sequel",
    "One or more characters with alliterative full names",
    "One or more scenes featuring a rowboat or canoe",
    "On-screen sex partially or completely obscured by bedsheets/blankets",
    "Piss-poor soundtrack",
    "Pivotal scene in women's restroom",
    "Pivotal scene involving answering machine",
    "Primary love interests clumsily falling on each other in romantically convenient ways",
    "Primary love interests lying to each other/keeping a major secret(s) from each other",
    "Previously straight/predictable hair style becomes curlyish/wild as character falls in love",
    "Protagonist works for an ad agency",
    "Protagonist works for a magazine",
    "Road Trip",
    "Sage advice delivered by parent, best friend, token black character, boss, landlord/lady, homeless person",
    "School dance",
    "Sexy precipitation",
    "Sisterhood",
    "Shopping montage",
    "Single dad trying desperately to relate to daughter as she blossoms into a young woman",
    "Song written for movie was nominated for an Academy Award for Best Original Song",
    "Strong female protagonist(s)",
    "Takes place at least 15 years in the past",
    "Terrible girlfriend/boyfriend/fiance(e)/spouse",
    "Uncomfortably sincere declaration of love",
    "Weak female protagonist(s)",
    "Wedding or Bride in the title",
    "Wedding(s)/wedding planning/wedding crashing",
    "Widower character",
    "Woman makes a fool of herself at work"
  ]},
  
  # "None of the above" - 0 points
  %{section: "tropes", point_value: 0, response_type: "checkbox", items: [
    "None of the above"
  ]},
  
  # Actors section - 0.25 points each
  %{section: "actors", point_value: 0.25, response_type: "checkbox", items: [
    "Amanda Seyfried",
    "Josh Duhamel",
    "Amy Adams",
    "Julia Roberts",
    "Andie MacDowell",
    "Julia Stiles",
    "Anna Kendrick",
    "Kate Hudson",
    "Ben Stiller",
    "Kate Winslet",
    "Bette Midler",
    "Katherine Heigl",
    "Bradley Cooper",
    "Kirsten Dunst",
    "Cameron Diaz",
    "Kristen Stewart",
    "Dakota Johnson",
    "Kristen Wiig",
    "Debra Winger",
    "Liam Hemsworth",
    "Dermot Mulroney",
    "Matthew McConaughey",
    "Diane Keaton",
    "Meg Ryan",
    "Elizabeth Banks",
    "Paul Rudd",
    "Gerard Butler",
    "Rachel McAdams",
    "Hugh Grant",
    "Renee Zellweger",
    "James Marsden",
    "Richard Gere",
    "Jennifer Aniston",
    "Ryan Reynolds",
    "Jennifer Lawrence",
    "Sandra Bullock",
    "Jennifer Lopez",
    "Sarah Jessica Parker",
    "John Cusack",
    "Tom Hanks",
    "Joseph Gordon-Levitt",
    "Zooey Deschanel"
  ]},
  
  # Jane Austen/Terry McMillan/Nicholas Sparks question - radio button
  %{section: "special_authors", point_value: 1, response_type: "radio", items: [
    "Adapted from Jane Austen, Terry McMillan, or Nicholas Sparks?"
  ]},
  
  # Reverse Bechdel test - radio button
  %{section: "reverse_bechdel", point_value: 1, response_type: "radio", items: [
    "Passes reverse Bechdel test?"
  ]}
]

# Insert all items with order positions
order_position = 0
for section_data <- checklist_data do
  for item_name <- section_data.items do
    order_position = order_position + 1
    
    %ChecklistItem{
      name: item_name,
      section: section_data.section,
      point_value: Decimal.new("#{section_data.point_value}"), 
      response_type: section_data.response_type,
      order_position: order_position
    }
    |> Repo.insert!()
  end
end

IO.puts "Seeded #{order_position} checklist items!"
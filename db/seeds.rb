User.create!(name: "Tim", email: "tjmee90@gmail.com")
User.create!(name: "Mike", email: "mike@example.com")
User.create!(name: "Josh", email: "josh@example.com")
User.create!(name: "Tess", email: "tess@example.com")

InviteSet.create!(title: "Mastermind",
                 groups: "Sally MacNicholas & Morgan Miller
                          Margarett Ly & Max Tedford
                          Whitney Hiemstra & Brett Grigsby
                          Justin Holmes & Drew Reynolds")

InviteSet.create!(title: "Store Engine",
                 groups: "Regis Boudinot & David Stinnette & Jerrod Paul Junker
                          Mary Beth Burch & George Hudson & Chris Cenatiempo
                          Bret Doucette & Justin Holzmann & Justin Pease
                          Travis Haby & Matt Hecker & Adam Jensen
                          Jeff Ruane & Alon Waisman & Michael Wong & Mimi Schatz")

InviteSet.create!(title: "VPSmasher",
                 groups: "Tim, Mike")

InviteSet.create!(title: "Game Time",
                 groups: "Tim, Mike, Josh")

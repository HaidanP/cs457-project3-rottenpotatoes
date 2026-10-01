movies = [
  { title: "Aladdin", rating: "G", release_date: "1992-11-25" },
  { title: "When Harry Met Sally", rating: "R", release_date: "1989-07-21" },
  { title: "The Help", rating: "PG-13", release_date: "2011-08-10" },
  { title: "Raiders of the Lost Ark", rating: "PG", release_date: "1981-06-12" }
]

movies.each do |attributes|
  Movie.find_or_create_by!(title: attributes.fetch(:title)) do |movie|
    movie.rating = attributes.fetch(:rating)
    movie.release_date = attributes.fetch(:release_date)
  end
end

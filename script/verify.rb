# Run with: RAILS_ENV=test bin/rails runner script/verify.rb
abort "Use RAILS_ENV=test" unless Rails.env.test?

def check(condition, message)
  raise message unless condition
end

Movie.transaction do
  Movie.delete_all
  load Rails.root.join("db/seeds.rb")
  load Rails.root.join("db/seeds.rb")
  check(Movie.count == 4, "Seeds must be repeatable")
  client = ActionDispatch::Integration::Session.new(Rails.application)
  client.host! "localhost"
  client.get "/"
  check(client.response.redirect? && client.response.location.end_with?("/movies"), "Root redirect")
  client.get "/movies"
  check(client.response.status == 200 && client.response.body.include?("Aladdin"), "Seeded index")
  client.get "/movies/new"
  check(client.response.status == 200, "New form")
  client.post "/movies", params: { movie: { title: "Verification film", rating: "PG", release_date: "2000-01-02", description: "Original description" } }
  check(client.response.status == 303, "Create redirect")
  movie = Movie.find_by!(title: "Verification film")
  client.get "/movies/#{movie.id}"
  check(client.response.body.include?("Original description"), "Show description")
  client.get "/movies/#{movie.id}/edit"
  check(client.response.status == 200, "Edit form")
  client.patch "/movies/#{movie.id}", params: { movie: { title: "Updated film", description: "Updated description", rating: "R", release_date: "2001-02-03" } }
  check(client.response.status == 303 && movie.reload.title == "Updated film" && movie.rating == "R" && movie.release_date.to_date.iso8601 == "2001-02-03", "Update persistence")
  client.patch "/movies/#{movie.id}", params: { movie: { title: "", rating: "invalid" } }
  check(client.response.status == 422 && movie.reload.title == "Updated film", "Invalid update must preserve record")
  client.post "/movies", params: { movie: { title: "", rating: "invalid", release_date: "" } }
  check(client.response.status == 422 && Movie.count == 5, "Invalid create")
  client.delete "/movies/#{movie.id}"
  check(client.response.status == 303 && !Movie.exists?(movie.id), "Delete persistence")
  client.get "/movies/99999999"
  check(client.response.status == 404, "Missing movie")
  Movie.delete_all
  client.get "/movies"
  check(client.response.status == 200 && client.response.body.include?("No movies yet."), "Empty state")
  client.get "/up"
  check(client.response.status == 200, "Health check")
  raise ActiveRecord::Rollback
end
puts "PASS: seeds, routes, CRUD, validation, missing records, empty state, and health check"

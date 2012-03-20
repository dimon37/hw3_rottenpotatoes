# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    if Movie.find_by_title(movie[:title]) == nil
      Movie.new(movie).save!
      #puts movie[:title]
    end
  end
  ##Movie.all().save!
  #puts Movie.all()
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  index1 = page.body.index(e1)
  index2 = page.body.index(e2)
  assert (index1 != -1 and index2 != -1 and index1 < index2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  part1 = %Q&I &
  part3 = %Q&check "ratings[&
  part2 = ""
  part4 = %Q&]"&
  if uncheck
    part2 = "un"
  end
  rating_list.split(%r{,\s*}).each do |rating|
    step part1+part2+part3+rating+part4
  end
end

Then /I should see all of the movies/ do
  assert page.has_css?("table#movies tbody tr", :count => Movie.count), "Movie count does not match"
end

Then /I should see (\d*) movies/ do |count|
  if count != "0"
    assert page.has_css?("table#movies tbody tr", :count => count), "Movie count does not match"
  else
    assert page.has_no_css?("table#movies tbody tr"), "Found unexpected movie"
  end
end

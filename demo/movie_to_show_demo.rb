 require_relative 'movie_to_show'

 record = CSV.read('..\src\movies.txt', col_sep: '|')[0]
    
 movieshow = MovieToShow.new(record)

 puts movieshow.year
 puts movieshow.period
 puts movieshow.to_s
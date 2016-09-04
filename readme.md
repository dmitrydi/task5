MoviePack
=========

## DESCRIPTION

The Movie Pack library consists of two main parts:

 * Two cinema classes: Netflix and Theatre. Netflix shows movies with desirable filters, Theatre is used for
   scheduling cinema and selling tickets.
 * WebFetcher module which has the following features:
  - fetching data of IMDB TOP-250 chart movies
  - formatting movies data to .html - file

## INSTALL

  gem install movie_pack

## USE

###Theatre class

 To use `Theatre` class it is nessessary to create an instance.
  ```ruby
    require 'movie_pack'

    # initialize in ruby module
      theatre = Theatre.new( [[movie_array]], [&block] )

    # default initialize for use
      theatre = Theatre.read => #initialized from 'data\movie_pack\movies.txt' with default parameters
  ```
 where `[movie_array]` is an array of instances of `Movie` class which is internal utility class of the lib. When omitted initialization is made from 'data\movie_pack\movies.txt' file.

 The instance created has its cash desk for money storage and safe encashment operations.

  User can specify the schedule of the theatre using proc `&block`:

  ```ruby
    theatre =
      Theatre.new do
        hall :red, title: 'Red Hall', places: 100
        hall :blue, title: 'Blue Hall', places: 50

        period '09:00'..'11:00' do
          description 'Morning'
          filters genre: 'Comedy', year: 1900..1980
          price 20
          hall :red, :blue
        end
      end
  ```
  This defines a `theatre` instance with two halls `:red, :blue` and one period `'09:00'..'11:00'`.
  `#description` method sets a name of the period
  `#filters` method sets filters for movies that may be shown during the period
  `#price` method sets the price for tickets for the period
  `#hall` method specifies halls that work for the period. Halls used in `#periods` must be defined first with `#hall` method, as shown in the example.

  Theatre class provides some useful methods for work with the theatre.

  `#check_schedule`
  Checks whether a `theatre` defined with a block has any crissings in schedule

  `#time_for(movie_title)`
  Returnes time of showing movie _movie_title_

  `#buy_ticket(time)`
  Sells a ticket for a movie in accordance with the period that includes _time_. If there is no period that may include _time_, retunes `ScheduleError`. Returnes the name of the movie, hall name and puts amount of money equal to ticket price to the cash desk.

  `#cash`
  Returnes the amount of money in the cash desk.

  `#take(who)`
  Empties the cash desk if `who == 'Bank'`. Otherwise, returnes `EncashmentError` and calls the police.

###Netflix class
 Netflix class can be used for creation of online cinema theatre. It provides methods for filtering movies for showing in accordance with user's preferences and working with built-in cash desk.

 Initialization
 ```ruby
   #initialize with array of movies
   netflix = Netflix.new([[movie_array]])

   #default initialize from .txt-file
   netflix = Netflix.read
 ```
 In the latter case `netflix` is initialized from file 'data\movie_pack\movies.txt' (see Theatre class initialization).

 `#show(filter = {}, &block)
 Shows a random movie according to filters specified by _filter_ or _&block_ parameters.

 `filter` can be defined in multiple ways:

 ```ruby
   #plain filter
   netflix.show(period: 'ancient', genre: 'Comedy') #=> shows ancient movie of comedy genre

   #block filter
   netflix.show { |m| m.period == 'ancient' } #=> shows ancient movie

   #pre-defined filter
   netflix.define_filter(:new_sci_fi) { |m| m.genre.include?('Sci-Fi') && m.period == 'new' }
   netflix.show(new_sci_fi: true) #=> shows new movie of sci-fi genre
 ```

 `#define_filter`

 `#define_filter` method can be used for defining filters for movies to show. One example is shown above. This method also allows user to define new filters from previously defined filters:

 ```ruby
 netflix.define_filter(:new_sci_fi) { |year, movie| movie.year > year && movie.genre.include?('Sci-Fi') }
 netflix.define_filter(:newest_sci_fi, from: :new_sci_fi_2, arg: 2010)

 netflix.show(new_sci_fi: 2005) #=> shows movie later than 2005 year of production
 netflix.show(newest_sci_fi: true) #=> shows movie later than 2010 year of production
 ```

 `#pay`

 Before using `#show` method some amount of money should be paid first:

 ```ruby
   netflix = Netflix.red
   netflix.show #=> "Error: you don't have enough money"
   netflix.pay(10)
   netflix.cash #=> 10
   netflix.show #=> 'Now showing: ....'
   netflix.money #=> 10 - movie.price
 ```
 method `#price_for(movie_title)` allows user to know how much a certain film costs:

 ```ruby
 netflix.price_for('The Terminator') #=> price of the movie
 ```

 `#by_genre`, `#by_country`
 Netflix allows to output an array of movies filtered by _genre_ and _country_ attributes:

 ```ruby
 netflix.by_genre.comedy #=> an array of comedy movies
 netflix.by_country.usa #=> an array of movies produced in the USA
 ```















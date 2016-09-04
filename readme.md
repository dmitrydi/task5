MoviePack

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

    # initialize
      theatre = Theatre.new( [[movie_array]], [&block] )

    #default initialize
      theatre = Theatre.read => #initialized instance with default parameters
  ```
 where `[movie_array]` is an array of instances of `Movie` class which is internal utility class of the lib.
 As manual definition of `[movie_array]` is impracical, for simple use this argument may be omitted. In this
 case `[movie_array]` is automatically created from file 'data\movie_pack\movies.txt'.

 `[movie_array]` is stored in `@collection` variable available for read.

 `theatre` instance has internal variables - `@halls` and `@periods` that are available for read
 using `#halls` and `#periods` methods. `@periods` stores the periods of working time of the theatre
 with specified parameters: halls, ticket price, filters for movies shown in this period and description.
 Halls for periods are stored in `@halls` variable.
 The instance created has its cash desk for money storage and safe encashment operations.

  Proc `&block` is used for specifying `@halls` and `@periods` variables.
  Example use:
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








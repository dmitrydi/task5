MoviePack

## DESCRIPTION

The Movie Pack library consists of two main parts:

 * Two cinema classes - Netflix and Theatre - that can show movies
 * WebFetcher module which has the following features:
  - fetching data of IMDB TOP-250 chart movies
  - formatting movies data to .html - file

## INSTALL

  gem install movie_pack

## USE
 To use `Theatre` class it is nessessary to create an instance.
  ```ruby
    require 'movie_pack'

    # initialize
      theatre = Theatre.new( [[movie_array]], [&block] )
  ```
 where `[movie_array]` is an array of instances of `Movie` class which is internal utility class of the lib.
 As manual definition of `[movie_array]` is impracical, for simple use this argument may be omitted. In this
 case `[movie_array]` is automatically created from file 'data\movie_pack\movies.txt'. The file is parsed and
 the array is populated with instances of `Movie` class. Movie instances have the following attributes:
  - `#webaddr` (String) - link to the movie page on IMDB
  - `#title` (String) - the title of the movie
  - `#year` (Integer) - year of production
  - `#country` (String) - country of production
  - `#date` (String) - date of issue
  - `#genre` (Array of String) - genre categories
  - `#duration` (Integer) - duration in minutes
  - `#rating` (Float) - IMDB rating of the movie
  - `#producer` (String) - name of the producer
  - `#actors` (Array of String) - starring

 To wiew the collection of movies in `theatre` use
  ```ruby
    theatre.collection #=> [movie_array]
  ```

  Proc `&block` is used for specifying for `Theatre` `@halls` and `@periods` variables.
  Example use:
    



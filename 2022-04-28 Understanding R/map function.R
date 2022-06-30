# map -------------------------------------------------------------------

library(purrr)


# map is a function that applies the same action to every element of an object, suchs as vectors, lists and data.frames.

# map is an easier way to 'apply' and all of its various forms.

# The map forms are below, noting the prefix shows the OUTPUT you want.

# map(.x, .f) is the main mapping function and returns a list
# 
# map_df(.x, .f) returns a data frame
# 
# map_dbl(.x, .f) returns a numeric (double) vector
# 
# map_chr(.x, .f) returns a character vector
# 
# map_lgl(.x, .f) returns a logical vector


# The input of a map is the object you want to iterate over. 
# vectors - self explanatory
# list - on each element
# data.frame - over the columns which we know is a set of named lists so is like previously.


## Simple example

square <- function(x){
  return(x * x)
}

map(c(1:3), square)  

map_dbl(c(1:3), square)

map_chr(c(1:3), square)

map_df(c(1:3), square)


# map_df doesn't work, it requires in each data.frame you're returning to have consistent column names. map_df will then bind each iteration

square_named <- function(x){
  return(data.frame(
    y = x * x))
}


map_df(c(1:3), square_named)

is_it_df <- map_df(c(1:3), square_named)

class(is_it_df)

# Since the first argument to a map is data, it works well with pipes and the tidyverse.

library(dplyr)

cars <- mtcars

cars %>%
  map_dbl(n_distinct)



# Anonymous functions, ones that are not named and can be shortened use the tilda.

cars %>%
  map_df(~{.x +1})



# More complicated example

cars %>%
  map_df(~(data.frame(distinct = n_distinct(.x), 
                      class = class(.x))))


# Since we have lost our variables names (not given by default) we can add them in.

cars %>%
  map_df(~(data.frame(distinct = n_distinct(.x), 
                      class = class(.x))),
         .id = "variable")




### Two inputs - map2

# map2 is an extension of map but you can input two objects to iterate over.

# map2(.x = object1, # the first object to iterate over
#      .y = object2, # the second object to iterate over
#      .f = function(.x, .y))


# The important thing to note is that it doesn't do a full combination it will do it for each pair.
# So,

names <- c("John", "Lucy", "Mike")
fav_fruit <- c("apple","pear","orange")

map2(names, fav_fruit, ~{paste0(.x,"'s favourite fruit is a ",.y)})

# Here we get 3 combinations, each numbered element from each is paired, rather than 9 combinations would be if we had
# John apple, John pear, John orange.. etc.


### pmap() also allowed multiple inputs - as many as you like!

# colours <- c("red","green","orange")
# 
# pmap(.l=list(names, fav_fruit,colours), .f = ~{paste0(names,"'s favourite fruit is a ",fav_fruit," which is ",colours)})








library(rlang)
library(dplyr)
library(magrittr)



# ### Non-standard evaluation and !! bang-bang ------------------------------------------------------------------

## SE and NSE

# Before we start, we need a rough understanding of Non-standard evaluation.
# Parts of R utilise Non-standard evaluation (NSE), which roughly lets you
# modify an expression or its meaning after it has been issued but before it is executed. 
# For instance

subset(mtcars, hp > 250) 

# the function subset interrupts hp > 250 before it is run,instead it looks for a column called hp in mtcars
# rather than look for an object hp in the workspace. If we were to use standard evaluation it would be

mtcars[mtcars$hp > 250,]

# You can tell if something is quoted by running it alone in the console. 'hp' will give an error but 'mtcars$hp' will show you the data.

## NSE in tidyverse

# When we use the tidyverse, we directly refer to column names rather than directly referencing the column within an object (using NSE)

mtcars %>%
  mutate(NewColumn = 2*mpg)

# rather than (though it will work)

mtcars %>%
  mutate(NewColumn = 2*mtcars$mpg) 


## A problem encountered in using NSE in dplyr - functions

# Here is a function that creates a count of the number of rows for a grouping variable

group_func <- function(grouping_var){
  
  data %>%
    group_by(grouping_var) %>%
    summarise(n())
  
}

# If we try use that function on a small table of favourite foods and colours 

data <- data.frame(matrix(c("Fish fingers","Burgers","Purple","Green"),ncol=2,byrow = TRUE))
names(data) <- c("Favourite food","Favourite Colour")
data

group_func(`Favourite food`)


# So why doesn't this work? 

# When we run the function R is searching for 'grouping_var' within it's scope and not searching for `Favourite food`,
# it is quoting the argument 'grouping_var' and not finding it.
# When it is quoted rather than evaluated that means the function is using NSE.

# Some loose definitions
# 'Evaluated' argument - obeys R's usual evaluation rules. R passes arguments by value, they are evaluated in the calling environment and the values are passed 
#               to the function
# 'Quoted' argument - To capture an unevaluated expression - these are captured by a function and processed in a different way. As we saw with 
#                     subset(mtcars, hp > 250), hp is being captured by the function and processed to search for that column name in mtcars.
# 'Unquotation - To be able to selectively evaluate parts of an otherwise quoted expression. Unquoting a single expression will evaluate it, and inline
#                the results.

# So how do we resolve our problem?

# 1. We have to quote our argument
# 2. We have to tell dplyr it is already quoted, which is done by unquoting it

# The bang-bang !! operator in rlang will unquote it for us

group_func_fixed <- function(grouping_var){
  
  data %>%
    group_by(!!grouping_var) %>%
    summarise(n())
  
}

group_func_fixed(quo(`Favourite food`))

# Now `Favourite food` isn't being searching for in the global environment, it holds evaluation. It is now being quoted and unquoted in the function.


## Another problem - for loops

# Outside of functions we may come into an issue with say a for loop

for(i in names(data)){
  
  data %>%
    group_by(i) %>%
    summarise(n()) %>%
    print()
  
}

# This time we have gone a further step back, we are now inputting a string, and so we need to convert it to a symbol as that is what dplyr expects.
# Using rlang::sym we can do this

names(data)

rlang::sym(names(data)[1])

# Now using what we had before we can fix the for loop

for(i in names(data)){
  
  symbol_i <- rlang::sym(i)
  
  data %>%
    group_by(!!symbol_i) %>%
    summarise(n()) %>%
    print()
  
}




# The detail is more convoluted as described here, with quasiquoting and quosures. 

# For further information see: https://adv-r.hadley.nz/metaprogramming.html
#Vectors, lists, matrices, data.frames and tibbles

# Vectors comes in two ways, atomic vectors and lists.
# Atomic vectors' elements all have the same type, whereas lists can differ.

atomic_vector <- c(1,2,3)

# if we try put different types into a vector

broken_atomic_vector <- c(1,"a",as.integer(2))

# all come out as character.

list <- list(1,"a",as.integer(3))


## Atomic vectors

# Can take singular types of elements. 
# Logical - TRUE/FALSE
# Integer - .
# Double - decimal, scientific (1.1e2), hexadecimal (0xcafe), Inf, NaN
# Character


# Also
# Complex - imaginary numbers
# Raw (when handling binary data)


## Attributes

## What makes matricies, data.frames and others into what they are; are attributes. They are metadata for an object.
## You can make objects have any metadata you want.

IsTomCool <- "Yes"

attr(IsTomCool, "Truth") <- "He thinks he is"
attr(IsTomCool, "Truth")

str(attributes(IsTomCool))


a <- 1:3
attr(a, "x") <- "x label"
attr(a, "x")

attr(a, "y") <- 4:6
str(attributes(a))


# Some operations lose their attributes

str(attributes(a+1))

str(attributes(a[1]))

# Names and dimensions are routinely kept though.


x <- c(a=1, 2, c=3)
names(x)

str(attributes(x[1]))


# Dimensions are what turn a vector into a matrix or a more dimensional array.

# 2-D matrix from scratch
matrix(1:6, nrow=2, ncol=3)

# 2-D matrix from a vector
vector <- c(1:6)
attr(vector, "dim") <- c(2,3)
vector

# Changing the dimensions
dim(vector) <- c(3,2)

vector

# multi-dimensional array (the ,,1 and ,,2 are the 'depth' of the array.
dim3 <- array(1:12, c(2,3,2))
dim3

dim3[1,2,2]

# S3 Class --------------------------------------------------------------

#atomic vectors can have a 'class' attribute. Which turns an object into an S3 object and so behaves different to regular vectors.

# Some S3 classes you'll be familiar with,
# Factors (a class of integers)
# Dates/Times (a class of Doubles)


options(stringsAsFactors = FALSE) # The first line on everyone's old R code, a big change to R was when this became default.


## Lists

# Lists don't have to have the same element type as each other. This is because lists are just referencing other objects.

# Lists can also be turned into matrices and arrays

l1 <- list("character",100,"words",1:3)

dim(l1) <- c(2,2)

l1

l1[[1,1]]

l1[[2,2]]



# data.frames and tibbles -------------------------------------------------

# data.frames and tibbles are built upon lists. a data.frame is a named list of vectors with attributes (columns and rows) It has the S3 class 'data.frame'.

typeof(1)

df <- data.frame(x = c(1,2), y=c(3,4))


typeof(df)
attributes(df)


# data.frames are lists with extra constraints (like length of vectors giving it the rectangular structure). data.frames are an important concept to R
# unlike many other programming languages.

# tibbles are similar to data.frames, tibbles have more classes 

library(tibble)

tib <- tibble(df)

attributes(tib)

# $class
# [1] "tbl_df"     "tbl"        "data.frame"


# tibbles do not coerce their input as we saw before with c(1,"a",3)

t2 <- tibble(c(1,"a",3))

# names of tibbles are not changed into when non-syntactic names are used.

names(data.frame(`1` = 1))

names(tibble(`1` = 1))

# tibbles will not recycle shorter inputs.

data.frame(x = 1:4, y = 1:2)

tibble(x = 1:4, y = 1:2)

tibble(x = 1:4, y = 1)


## One thing tibbles do do that data.frames do not, is use variables being used in construction.

data.frame(
  t = 1:3,
  u = t * 2
)


tibble(
  t = 1:3,
  u = t * 2
)


#### Transposing

#data.frame can not be transposed. With a few good reasons why they can not.

# Data frames allow row names, a character vector of unique values that identify the observations in the row.

# Row names are undesirable. Metadata is data, and storing it different to how other data is stored makes it more complicated. 
# You can't manipulate rows like you can columns, the lists that comprise a data.frame. Rows don't have that same property.

# Row names must be unique, so duplicating a row will create a new row id,  and comparing the before and after will be difficult with some string surgery.

# As such tibbles do not support row names, and as such, do support transposing.

tibble2 <- tibble(
  t = 1:3,
  u = t * 2
)

t(tibble2)


## Various other differences, such as 

# printing - top 10 observations, types of columns, dimensions, shortned column widths


# tibbles do not auto-fill the column it thinks you're trying to reference.

cars$di

tibcars <- tibble(cars)

tibcars$di


## tibbles always return tibbles.

df2 <- data.frame(
  t = 1:3,
  u = 2:4
)


# This extracts a single column, and no longer has class data.frame
out <- df2[,"u"]

class(out)


out2 <- tibble2[,"u"]

class(out2)


# Further reading https://adv-r.hadley.nz/vectors-chap.html#tibble










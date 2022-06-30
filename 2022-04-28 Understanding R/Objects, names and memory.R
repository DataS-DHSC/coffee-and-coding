# ### Objects, copying, and memory usage --------------------------------------------------

# |- What is an object, it's name and how are they referenced? -----

# Starting memory
memory.size()

x <- c(1:100000)

# Memory after creating a new large vector
memory.size()

y <- x

# Memory after defining a new vector y to be the same as x
memory.size()

z <- c(1:100000)

# Memory after creating a new vector z, without referencing x/y but to be the same as x.
memory.size()

# We can now see the memory "address" for the objects we've created.
lobstr::obj_addr(x)

lobstr::obj_addr(y)

lobstr::obj_addr(z)

# x and y actually reference the same object. The object has two names.
# Z has created an entirely new object although the same as x

# So we've seen that referencing another object doesn't increase memory usage.
# The object is only saved once but we might call it by two names, x and y.


# What if we change y now? What happens to x?

memory.size()

y[[3]] <- 4

lobstr::obj_addr(x)

lobstr::obj_addr(y)

memory.size()

# Now we have two objects. One named x and one named y and as such, both are using up memory.

# R behaves by copy-on-modify. When something is modified, it is copied, and doesn't overwrite the original object.


# Note: run next lines all at once as RStudio does odd things described later.

# Lets follow what happens to the objects a and b below.

a <- c(1,2,3)

# This lets us trace when objects are copied by showing us the addresses.
cat(tracemem(a), "\n")

b <- a
b[[3]] <- 4L

lobstr::obj_addr(b)

# What if modify b again?

b[[3]] <- 5L

lobstr::obj_addr(b)

# In this case we can see that modifying the object doesn't change its address
# Further details below on how this changes and what we define as 'modifying'



# |- How about when we use lists? ----


xyList <- list(x,y)


lobstr::obj_addr(x)

lobstr::obj_addr(xyList)

lobstr::obj_addr(xyList[[1]])


# So is the list xyList still referencing the same objects as before. What happens if we copy the list?

xyList2 <- xyList

lobstr::obj_addr(xyList)
lobstr::obj_addr(xyList2)
# Copying the list behaves as we expect. Same address.


xyList2[[1]][3] <- 4

lobstr::obj_addr(y)
lobstr::obj_addr(xyList2[[2]])
# Modifying the x element of the list doesnt change that the list is referencing the y object.


lobstr::obj_addr(x)
lobstr::obj_addr(xyList2[[1]])
# Because we changed the x element, it no longer points to the x object from before. A new object has been created  (copy-on-modify)

lobstr::ref(xyList, xyList2)
# Here shows a summary of before.


## |- How about when we use data.frames ----

memory.size()

df <- data.frame(x,y)

memory.size()

# Memory hasn't increased by much. It's using the same objects as before.

lobstr::obj_addr(x)
lobstr::obj_addr(y)
lobstr::ref(df)

# Data frames are a bunch of vectors (columns)
# So changing columns will create a single new object. Changing Rows will create multiple new objects.

# Example

df2 <- df

lobstr::ref(x, y, df, df2)
# A summary of what objects addresses are and what are within df and df2

df2[, 2] <- df2[, 2] * 2
# Modifying the 'y' object in df2

lobstr::ref(x, y, df, df2)
# A new object has been created in the second column for df2




# |- Global string pool - Interesting fact about R ----

string <- c("a","a","b","c","abc")

lobstr::ref(string)

lobstr::ref(string, character = TRUE)
# Although we wrote out "a" twice, R is clever and defines them as the same object being referenced.
# This purely helps memory usage. Do not worry about it in your code.

# Example

banana <- "bananas bananas bananas"
lobstr::obj_size(banana)
lobstr::obj_size(rep(banana, 100))


lobstr::obj_size(c("a","b","c"))
lobstr::obj_size(c("a","b","c"), c("d","e","f"))
lobstr::obj_size(c("a","b","c"), c("a","a","a"))



## |- Modifying in place ----
# Objects have three 'states' of bindings/references. 0, 1 or many.

o <- c(1,2,3) # Here we are setting a single name to the vector. A single reference to the object is called 'o'.
pryr::address(o)

# If we modify this, the address won't change. objects with a single binding get a special status so that it doesn't change how often it's been referenced.
# It will stay at a single reference of 1. 
# As soon as an object is referenced 2+, it can never go back to 0 or 1. It will forever be 'many'.

# Run this part at once (see RStudio note below)
o <- c(1,2,3)
pryr::address(o)

o[[3]] <- 4
o[[3]] <- 5
o[[3]] <- 6
pryr::address(o)

# Whenever you use most functions on an object, that object gets referenced, thus increasing its number to 'many' and introducing more copies.
# primitive functions don't do this. (Functions writting in C)
# Primitive include: This includes [[<-, [<-, @<-, $<-, attr<-, attributes<-, class<-, dim<-, dimnames<-, names<-, and levels<-. 


# |- RSTUDIO AND IT'S INFLUENCE ON ADDRESSES  ----

# RStudio is odd, and actually every object has 2 references/bindings. The environment (top right box) has it's own reference.
# As such, every time you create an object via the command line it will make a copy.

# This doesnt affect code inside functions and so shouldn't affect performance. But does make this script slightly more difficult to explore.

# TODO: make this RMarkdown script

# Example - run this line by line, then all at once.

rstudio_example <- c(4,5,6)
pryr::address(rstudio_example)

rstudio_example[[3]] <- 7
pryr::address(rstudio_example)
rstudio_example[[3]] <- 8
pryr::address(rstudio_example)
rstudio_example[[3]] <- 9
pryr::address(rstudio_example)

###




# |- Why are my for loops so slow? It might be because you're making lots of copies -----

x <- data.frame(matrix(runif(5 * 1e4), ncol = 5))

# Take median across each column
medians <- vapply(x, median, numeric(1))

# For each column, minus the median from the value
cat(tracemem(x), "\n")
lobstr::ref(x)

for (i in seq_along(medians)) {
  x[[i]] <- x[[i]] - medians[[i]]
}

# We can see it's made 5 copies. This is not using primitive functions.  [[.data.frame is a regular function and increased x's referencing.

# Modifying a list uses internal C code, thus not increasing references each time. Lists are pretty great for keeping your memory down!

y <- as.list(x)

cat(tracemem(y), "\n")
lobstr::ref(y)

for (i in 1:5) {
  y[[i]] <- y[[i]] - medians[[i]]
}

lobstr::ref(y)

# If you've got memory issues, cat(tracemem(x), "\n") can help you see where you may be copying big data frames.
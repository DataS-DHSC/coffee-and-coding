# ### if, ifelse, and switch --------------------------------------------------

# What is the difference between IF and IFELSE?

# If statements can only take a single TRUE or FALSE test, if you put more in R will just take the first entry.
if (TRUE) { "output" }
if (c(TRUE, FALSE)) {"output" }
if (c(FALSE, TRUE)) { "output" }

# If else however can take a vector input, which means we can have a vector output of test results.
ifelse(TRUE,  "output", "failed")
ifelse(c(TRUE, FALSE),  "output", "failed")
ifelse(c(FALSE, TRUE),  "output", "failed")

# If else also allows missing values whereas if does not
ifelse(c(FALSE, NA, TRUE),  "output", "failed")
if (NA) { "output" }


# But, there are certain problems we may encounter.

# Problem 1: What if I have multiple conditions I want to test?
# For this we can use if () {} else 

x <- 5

if(x == 1){ "output 1"
} else if(x == 2){ "output 2"
} else if(x == 3){ "output 3"
} else if(x == 4){ "output 4"
} else {"failed"}

# But this could get tedious, especially with long pieces of code. 

# Instead we can use the switch function. This allows us multiple values that x can take in a much shorter bit of code.

switch(as.character(x),
       "1" = "output 1",
       "2" = "output 2",
       "3" = "output 3",
       "4" = "output 4",
       "Failed")


# Problem 2: What if I have vectorised input BUT - I have multiple possible outcomes?

# I think everyone will have done this at some point in their coding journey.

ifelse(FALSE,  "output", 
       ifelse(FALSE,  "output 2", 
              ifelse(FALSE,  "output 3", "failed")))

# This code can get long and looks untidy, especially if you need to reorder the ifelse statements later.

# Instead we can use case_when (familiar for those using SQL) from dplyr

x <- c(1,2,3,4)

dplyr::case_when(
  x == 1 ~ "output 1",
  x == 2 ~ "output 2",
  x == 3 ~ "output 3",
  TRUE ~ "failed"
)

# This can also replace the switch() from before. But switch is base R whereas case_when is not.
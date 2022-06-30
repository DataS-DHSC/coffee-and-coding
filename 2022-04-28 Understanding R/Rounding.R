# ### Rounding in R -----------------------------------------------------------

# In school (at least in my academic years), we were taught to round as follows;

# 0.0-0.49 rounds to 0
# 0.50-0.99 rounds to 1

# R uses a 'round-to-even' method to round. Which treats the exact value of 0.50 differently, it rounds to the nearest even number
# 0.5 -> 0
round(0.5,0)
# 1.5 -> 2
round(1.5,0)

# This is actually an international standard of rounding: IEC 60559 standard for computers

# The issues lies is that ending in .5 actually is exactly the same distance away from 0 and 1. 0.5 - 0.5 = 0, 0.5 + 0.5 = 1. 

# Rounding up as taught in school introduces a systematic bias, everything is rounded away from 0.

# This is important to note if you are rounding tables for publication.

# Here is an alternative function to R's base round() function, which rounds x.5 values to the nearest even integer

round2 = function(x, n) {
  posneg = sign(x)
  z = abs(x)*10^nS
  z = z + 0.5
  z = trunc(z)
  z = z/10^n
  z*posneg
}


round2(0.5, 0)
round2(1.5, 0)

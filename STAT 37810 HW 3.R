# Creating test data
trueA <- 5
trueB <- 0
trueSd <- 10
# model: y = A * x + B + error
# where error ~ N(0, sd ^ 2)
sampleSize <- 31

# create independent x-values 
x <- (-(sampleSize - 1) / 2): ((sampleSize - 1) / 2)
# create dependent values according to ax + b + N(0, sd ^ 2)
y <-  trueA * x + trueB + rnorm(n = sampleSize, mean = 0, sd = trueSd)

plot(x, y, main = "Test Data")

# Example: plot the likelihood profile of the slope a
slopevalues <- function(x) { return (likelihood(c(x, trueB, trueSd)))}
slopelikelihoods <- lapply(seq(3, 7, by = .05), slopevalues)
# calculate likelihoods at a sequence of points
plot(seq(3, 7, by = .05), slopelikelihoods, type = "l", xlab = "values of slope parameter a", ylab = "Log likelihood")

######################################################################
startvalue <- c(4,0,10)
chain <- run_metropolis_MCMC(startvalue, 10000)
# run Metropolis_MCMC for 10000 iterations

burnIn <- 5000
acceptance <- 1 - mean(duplicated(chain[-(1: burnIn), ]))
# remove the first 5000 iterations

summaryGraphing(chain, burnIn, c(trueA, trueB, trueSd))
# for comparison:
summary(lm(y~x))
# compared with the result of linear model

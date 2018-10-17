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

######################################################################
likelihood <- function(param){
  
# Calculation of likelyhood
  a = param[1]
  b = param[2]
  sd = param[3]
  
  pred = a * x + b
# \hat{y} = \hat{a} * x + \hat{b}
  
  singlelikelihoods = dnorm(y, mean = pred, sd = sd, log = T)
  # log density of normal distribution at point y on each dimension
  
  sumll = sum(singlelikelihoods)
  # add up the log density, which is equivalent to multiplying the likelihood together
  return (sumll)   
}

# Example: plot the likelihood profile of the slope a
slopevalues <- function(x) { return (likelihood(c(x, trueB, trueSd)))}
slopelikelihoods <- lapply(seq(3, 7, by = .05), slopevalues)
# calculate likelihoods at a sequence of points
plot(seq(3, 7, by = .05), slopelikelihoods, type = "l", xlab = "values of slope parameter a", ylab = "Log likelihood")

######################################################################

# Prior distribution
prior <- function(param){
  a = param[1]
  b = param[2]
  sd = param[3]
  # construct prior distribution
  
  aprior = dunif(a, min = 0, max = 10, log = T)
  bprior = dnorm(b, sd = 5, log = T)
  sdprior = dunif(sd, min = 0, max = 30, log = T)
  # the log density of prior distributions of a, b, and sd
  
  # add up the log density of prior distributions
  # which is equivalent to multiplying the likelyhood together
  return(aprior + bprior + sdprior)
}

######################################################################

# Posterior distribution
posterior <- function(param){
  return (likelihood(param) + prior(param))
  # add up the log-likelihood of prior and posterior distribution together
}

######################################################################

######## Metropolis algorithm ################ 

## Starting at a random parameter value
##
## Choosing a new parameter value close to the old value based on some 
## probability density that is called the proposal function
##
## Jumping to this new point with a probability p(new)/p(old), 
## where p is the target function, and p>1 means jumping as well
proposalfunction <- function(param){
  return (rnorm(3, mean = param, sd = c(0.1,0.5,0.3)))
}
# add Gaussian noise

run_metropolis_MCMC <- function(startvalue, iterations){
  chain = array(dim = c(iterations + 1, 3))
  # chain[] contains all result
  chain[1, ] = startvalue
  # initialize with the startvalue
  
  for (i in 1: iterations) {
    proposal = proposalfunction(chain[i, ])
    # a new sample based on the result of the last iteration
    
    probab = exp(posterior(proposal) - posterior(chain[i, ]))
    # calculate probability of acceptance of the new sample
    if (runif(1) < probab) # accept new sample
      chain[i + 1, ] = proposal
    else                   # reject
      chain[i + 1, ] = chain[i, ]
  }
  
  return (chain)
}

startvalue <- c(4,0,10)
chain <- run_metropolis_MCMC(startvalue, 10000)
# run Metropolis_MCMC for 10000 iterations

burnIn <- 5000
acceptance <- 1 - mean(duplicated(chain[-(1: burnIn), ]))
# remove the first 5000 iterations

######################################################################

### Summary: #######################
summaryGraphing <- function(chain, burnIn, param) {
  trueA <- param[1]
  trueB <- param[2]
  trueSd <- param[3]
  
  par(mfrow = c(2,3))
  hist(chain[-(1:burnIn),1], nclass=30, main="Posterior of a", xlab="True value = red line" )
  abline(v = mean(chain[-(1:burnIn),1]))
  # plot posterior distribution of a
  abline(v = trueA, col = "red")
  # true value of a
  
  hist(chain[-(1:burnIn),2], nclass=30, main="Posterior of b", xlab="True value = red line")
  abline(v = mean(chain[-(1:burnIn),2]))
  # plot posterior distribution of b
  abline(v = trueB, col = "red")
  # true value of b
  
  hist(chain[-(1:burnIn),3],nclass=30, main="Posterior of sd", xlab="True value = red line")
  abline(v = mean(chain[-(1:burnIn),3]) )
  # plot posterior distribution of sd
  abline(v = trueSd, col = "red")
  # true value of sd
  
  plot(chain[-(1:burnIn),1], type = "l", xlab="True value = red line" , main = "Chain values of a")
  abline(h = trueA, col="red" )
  plot(chain[-(1:burnIn),2], type = "l", xlab="True value = red line" , main = "Chain values of b")
  abline(h = trueB, col="red" )
  plot(chain[-(1:burnIn),3], type = "l", xlab="True value = red line" , main = "Chain values of sd")
  abline(h = trueSd, col="red" )
  # plot the sample values and true values of a, b, and sd in iteration 5000 ~ 10000
}

summaryGraphing(chain, burnIn, c(trueA, trueB, trueSd))
# for comparison:
summary(lm(y~x))
# compared with the result of linear model

######################################################################
likelihood <- function(param, x, y){
  
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
posterior <- function(param, x, y){
  return (likelihood(param, x, y) + prior(param))
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

run_metropolis_MCMC <- function(startvalue, iterations, x, y){
  chain = array(dim = c(iterations + 1, 3))
  # chain[] contains all result
  chain[1, ] = startvalue
  # initialize with the startvalue
  
  for (i in 1: iterations) {
    proposal = proposalfunction(chain[i, ])
    # a new sample based on the result of the last iteration
    
    probab = exp(posterior(proposal, x, y) - posterior(chain[i, ], x, y))
    
    # sometimes the posterior is too small that log(posterior) -> -INF
    # this can only happen when the proposal is bad
    # thus if this occurs, we set the probability to 0 
    # because exp(-INF) -> 0
    if (is.nan(probab)) probab <- 0
    
    # calculate probability of acceptance of the new sample
    if (runif(1) < probab) # accept new sample
      chain[i + 1, ] = proposal
    else                   # reject
      chain[i + 1, ] = chain[i, ]
  }
  
  return (chain)
}

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

compare_outcomes <- function(iteration) {
  result <- matrix(0, ncol = 10, nrow = 4)
  

  for (TestCase in 1: 10) {
    # Creating test data from the prior distrubution
    trueA = runif(1, min = 0, max = 10)
    trueB = rnorm(1, sd = 5)
    trueSd = runif(1, min = 0, max = 30)
    
    # sampling data
    sampleSize <- 31
    # create independent x-values 
    x <- (-(sampleSize - 1) / 2): ((sampleSize - 1) / 2)
    # create dependent values according to ax + b + N(0, sd^2)
    y <-  trueA * x + trueB + rnorm(n = sampleSize, mean = 0, sd = trueSd)
    
    ######################################################################
    startvalue <- c(4,0,10)
    chain <- run_metropolis_MCMC(startvalue, iteration, x, y)
    # run Metropolis_MCMC for given number of iterations
    
    burnIn <- iteration / 2
    acceptance <- 1 - mean(duplicated(chain[-(1: burnIn), ]))
    # remove the first half of the iterations
    
    # summary Without graphing
    # the distribution of A, B, and sd
    Amean  <- mean(chain[-(1: burnIn), 1])
    Bmean  <- mean(chain[-(1: burnIn), 2])
    SDmean <- mean(chain[-(1: burnIn), 3])
    stdA  <- sqrt(sum((chain[-(1: burnIn), 1] - Amean) ^ 2) / (iteration - burnIn))
    stdB  <- sqrt(sum((chain[-(1: burnIn), 2] - Bmean) ^ 2) / (iteration - burnIn))
    stdSD <- sqrt(sum((chain[-(1: burnIn), 3] - SDmean) ^ 2) / (iteration - burnIn))
    
    result[1, TestCase] <- Amean
    result[2, TestCase] <- stdA
    #cat(sprintf("Loop: %d\n", TestCase))
    #cat(sprintf("A: mean = %f, std = %f\n", Amean, stdA))
    # cat(sprintf("B: mean = %f, std = %f\n", Bmean, stdB))
    # cat(sprintf("sd: mean = %f, std = %f\n", SDmean, stdSD))
    
    
    # compared with the result of linear model
    my_lm <- lm(y ~ x)
    my_summary <- summary(my_lm)
    result[3, TestCase] <- as.numeric(my_summary$coefficients[2, 1])
    result[4, TestCase] <- as.numeric(my_summary$coefficients[2, 2])
    #print(summary$sigma)
  }
  result <- data.frame(result, row.names = c('MH_mean', 'MH_std', 'lm_mean', 'lm_std'))
  
  nms <- c(1)
  length(nms) <- 10
  for (i in 1: 10) 
    nms[i] <- paste('Loop', as.character(i))
  #print(nms)
  colnames(result) <- nms
  
  return (result)
}

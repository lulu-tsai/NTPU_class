n = 50
mu = 5
sigma = sqrt(5)
X = rnorm(n, mu, sigma)
# Plot histogram
hist(X)
# Plot histogram with probability density
hist(X, prob = TRUE)
# Plot histogram with adjusted y-axis limit
hist(X, prob = TRUE, ylim = c(0, 0.2))

# Overlay normal distribution on histogram
points(X, dnorm(X, mu, sigma))
points(X, dnorm(X, mu, sigma), type = "l")
points(sort(X), dnorm(sort(X), mu, sigma), type = "l")
qqnorm(X)
qqline(X)


###########################################################

n = 50
mu = 5
sigma = sqrt(5)
collect_X_bar = rep(NA, 100)
# do below things in "{}" in order 100 times
for (i in 1:100) {  
  X = rnorm(n, mu, sigma)
  X_s = sum(X)
  X_bar = X_s / n
  collect_X_bar[i] = X_bar - mu
}

# Plot histogram of sample mean
hist(collect_X_bar, prob = TRUE)

# Overlay theoretical distribution on histogram
points(collect_X_bar, dnorm(collect_X_bar, 0, sigma/sqrt(n)))
points(sort(collect_X_bar), dnorm(sort(collect_X_bar), 0, sigma/sqrt(n)), type = "l")

qqnorm(collect_X_bar)
qqline(collect_X_bar)

X=seq(-3.5,3.5,by=0.1)

plot(X,dnorm(X),type="l",ylim=c(-0.01,0.5))
abline(h=0)

qnorm(0.975)

abline(v=qnorm(0.975),lty=2)
abline(v=qnorm(0.025),lty=2)
abline(v=qnorm(0.5),lty=2,col=2)

qnorm(0.025)

n=50
mu=5
E_times=20
collect_X_up=rep(NA,E_times)
collect_X_down=rep(NA,E_times)
sigma=sqrt(5)

for(i in 1:E_times){
  X=rnorm(n,mu,sigma)
  X_s=sum(X)
  X_bar=X_s/n
  collect_X_up[i]=X_bar+1.96* sigma/sqrt(n)
  collect_X_down[i]=X_bar-1.96* sigma/sqrt(n)
}

plot(c(0,0),type="n",ylim=c(0,E_times),xlim=c(3.5,7),
     ylab="number of experiment",
     xlab="up and lower bounds of 95%CI" )
for(i in 1:E_times){
  points(c( collect_X_down[i],collect_X_up[i]),c(i,i),type="l",lty=1)
  points(c( collect_X_down[i],collect_X_up[i]),c(i,i))
}
abline(v=mu,col=2)
mean(collect_X_down<= mu & mu<= collect_X_up) # Calculate the rate of CP.


####################################################################################
n=50
mu=5
collect_X_bar=rep(NA,100)
sigma=sqrt(5)
X=rpois(n,5) # generate the Poisson random
hist(X)
hist(X,prob= TRUE,ylim=c(0,0.5))
points(X,dpois(X,5)) # distribution of the poisson distribution
points(sort(X),dpois(sort(X),n,5),type="l") 

for(i in 1:100){
  X=rpois(n,5)
  X_s=sum(X)
  X_bar=X_s/n
  collect_X_bar[i]=X_bar-mu
}
hist(collect_X_bar,prob= TRUE)
points(collect_X_bar,dnorm(collect_X_bar,0,sigma/sqrt(n) ))
points(sort(collect_X_bar),dnorm(sort(collect_X_bar),0,sigma/sqrt(n)),type="l")

n=50
mu=5
E_times=20
collect_X_up=rep(NA,E_times)
collect_X_down=rep(NA,E_times)
sigma=sqrt(5)

for(i in 1:E_times){
  X=rpois(n,5)
  X_s=sum(X)
  X_bar=X_s/n
  collect_X_up[i]=X_bar+1.96* sigma/sqrt(n)
  collect_X_down[i]=X_bar-1.96* sigma/sqrt(n)
}

plot(c(0,0),type="n",ylim=c(0,E_times),xlim=c(3.5,7),
     ylab="number of experiment",
     xlab="up and lower bounds of 95%CI" )
for(i in 1:E_times){
  points(c( collect_X_down[i],collect_X_up[i]),c(i,i),type="l",lty=1)
  points(c( collect_X_down[i],collect_X_up[i]),c(i,i))
}
abline(v=mu,col=2)
mean(collect_X_down<= mu & mu<= collect_X_up) # Calculate the rate of CP.
################################################################

n=500
p=0.75
mu=p
collect_X_bar=rep(NA,100)

for(i in 1:100){
  X=rbinom(n,1,p)
  X_s=sum(X)
  X_bar=X_s/n
  collect_X_bar[i]=X_bar-mu
}
hist(collect_X_bar,prob= TRUE,ylim=c(0,50))
points(collect_X_bar,dnorm(collect_X_bar,0,(p*(1-p))/sqrt(n) ))
points(sort(collect_X_bar),dnorm(sort(collect_X_bar),0,(p*(1-p))/sqrt(n)),type="l")
n=500
mu=p=0.5
sigma=sqrt(p*(1-p))
E_times=200
collect_X_up=rep(NA,E_times)
collect_X_down=rep(NA,E_times)

for(i in 1:E_times){
  X=rbinom(n,1,p)
  X_bar=mean(X)
  collect_X_up[i]=X_bar+1.96* sigma/sqrt(n)
  collect_X_down[i]=X_bar-1.96* sigma/sqrt(n)
}

plot(c(0,0),type="n",ylim=c(0,E_times),xlim=c(p-0.5,p+0.5),
     ylab="number of experiment",
     xlab="up and lower bounds of 95%CI" )
for(i in 1:E_times){
  points(c( collect_X_down[i],collect_X_up[i]),c(i,i),type="l",lty=1)
  points(c( collect_X_down[i],collect_X_up[i]),c(i,i))
}
abline(v=mu,col=2)
mean(collect_X_down<= mu & mu<= collect_X_up)



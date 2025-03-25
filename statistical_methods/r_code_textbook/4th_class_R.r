#Properties of Binomila distribution
rm(list=ls(all=TRUE))
#N=40
x=0:40

P_1=dbinom(x,40,0.5)
P_2=dbinom(x,40,0.25)
P_3=dbinom(x,40,0.75)
# P ( X = x ) x 屬於 { 1, 2, ...., 40 }

plot(x,P_1,ylab="probability",xlab="x",main="Binomial ",pch=16,xlim=c(0,50),ylim=c(0,.15))

points(x,P_2,col=2,pch=16)

points(x,P_3,col=3,pch=16)

# 最大是影響他的縱軸
# 他是離散型的分配 所以把它連載一起是沒有意義的
# 他的圖形都是對稱的
# 為什麼紅色跟綠色比較高? (因為 vars在0.5的時候比較大 n是給定的)


# ===================
# CDF
# 因為她是累計的 所以她一定是遞增的 並且她一定不會超過1
x=0:40
P_1=pbinom(x,40,0.5)
P_2=pbinom(x,40,0.25)
P_3=pbinom(x,40,0.75)

plot(x,P_1,ylab="probability",xlab="x",main="Binomial ",pch=16,xlim=c(0,50),ylim=c(0,.15))
points(x,P_2,col=2,pch=16)
points(x,P_3,col=3,pch=16)

# 紅色的資料傾向一開始就很快會發生了

# ===================

legend(40,0.12,c("p=0.5","p=0.25","p=0.75"), pch=16,col=c(1,2,3))

p=seq(0,1,by=0.01)
Ebin=40*p
Vbin=40*p*(1-p)

par(mfrow=c(2,1))
plot(p,Ebin)
plot(p,Vbin)
# p越高 期望越高

#try different N
###########################################################################

#Properties of Geometric distribution
rm(list=ls(all=TRUE))

x=0:40

P_1=dgeom(x,0.5)
P_2=dgeom(x,0.25)
P_3=dgeom(x,0.75)

plot(x,P_1,ylab="probability",xlab="x",main="Geometric ",pch=16,xlim=c(0,15),ylim=c(0,1))

points(x,P_2,col=2,pch=16)

points(x,P_3,col=3,pch=16)

legend(10,0.8,c("p=0.5","p=0.25","p=0.75"), pch=16,col=c(1,2,3))

p=seq(0,1,by=0.01)
Ebin=(1-p)/p
Vbin=(1-p)/(p^2)

par(mfrow=c(2,1))
plot(p,Ebin)
plot(p,Vbin)
###########################################################################

#Properties of Poisson distribution
rm(list=ls(all=TRUE))

x=0:40

P_1=dpois(x,1)
P_2=dpois(x,5)
P_3=dpois(x,10)

plot(x,P_1,ylab="probability",xlab="x",main="Poisson",pch=16,xlim=c(0,40),ylim=c(0,0.6))

points(x,P_2,col=2,pch=16)

points(x,P_3,col=3,pch=16)

legend(10,0.8,c("p=1","p=5","p=10"), pch=16,col=c(1,2,3))

la=seq(0,1,by=0.01)
Ebin=la
Vbin=la

par(mfrow=c(2,1))
plot(la,Ebin)
plot(la,Vbin)
###########################################################################
rm(list=ls(all=TRUE))
set.seed(37)
N=1000
p=0.005
exp_E=N*p
expriment_times=1000
X_Bin=rbinom(expriment_times,N,p)
X_poi=rpois(expriment_times,N*p)


hist(X_Bin,col=1,ylim=c(0,500),main="Binomial vs. Poisson",xlab="x_obs")
hist(X_poi,add=TRUE,col=rgb(0,0.5,0,0.5))


legend(6,400,c("Binomial","Poisson"),pch=15,col=c(1,rgb(0,0.5,0,0.5)))

###########################################################################
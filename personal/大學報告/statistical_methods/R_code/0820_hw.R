# 第一題
X_1 = read.table("D:/class/statistical_methods/take_home_exam/20240820/data/Q1.txt")
hist(X_1$x, main="Q1", xlab="破損碗/個數", ylab="次數")
summary(X_1$x)
#  [[[[[[[[[[[[ 偏度 ]]]]]]]]]]]]]]
mean((X_1$x - mean(X_1$x))^3 )/ ((var(X_1$x)^ (0.5)) ^ 3) 
# [[[[[[[[[[[[ 峰度 ]]]]]]]]]]]]]]
(mean((X_1$x - mean(X_1$x))^4 )/ ((var(X_1$x)^ (0.5)) ^ 4)) - 3
# 期望值 mu
p = mean(X_1$x) / n
n = 5
mu = n * p
print(mu)

# P(X >= 3) for X ~ Binomial(n = 5, p = 0.2052)
n = 5
p = 0.2052
1 - pbinom(2, n, p) # 預設是 <= 的機率



# 0829-----
# 計算信賴區間
x = X_1$x
Xbar = mean(x)
p_hat = Xbar / 5
c(
  (Xbar-1.96*sqrt( 5*p_hat*(1-p_hat)/1000))/5, # sqrt 是開根號  # 信賴區間的下介
  (Xbar+1.96*sqrt( 5*p_hat*(1-p_hat)/1000))/5 # 信賴區間的上介
)
# 他碗破掉的機率 落在這個中間
# 所以你百分之95 #( 再去聽一次 )

p_hat < 0.3-sqrt(0.3*0.7/1000)*1.645
# 顯著的小於她 所以這裡我們要拒絕他

# 計算它的Z
Z0 = (Xbar-5*0.3)/sqrt(5*0.3*0.7/1000)
# 這是非常顯著 因為真的很大
p_z0 = pnorm(Z0)


# t test
t.test(x, mu=5*.03, alternative = "less")  # 對立是小於
# 很小 就是很顯著



# 不同問法
m=5
n=10
X=rbinom(n, m, p=0.2)
x=X
Xbar = mean(x)
p_hat = Xbar / 5
c(
  (Xbar-1.96*sqrt( 5*p_hat*(1-p_hat)/n))/5,
  (Xbar+1.96*sqrt( 5*p_hat*(1-p_hat)/n))/5
)
p_hat < 0.3-sqrt(0.3*0.7/n)*1.645
Z0 = (Xbar-m*0.3)/sqrt(m*0.3*0.7/n)
p_z0 = pnorm(Z0)
t.test(x, mu=5*.03, alternative = "less")

# 10組在這裡太小了 我們需要多點資料
# 如果答案是0.29 我就無法回答因為她就很接近0.3 
# 理論上他們是不同的 但如果你的量做的夠多就可以看的出來
# 只要樣本數夠大 你的效果就會被看見

# 實務上的結識意義：每天洗超過30分鐘 水裡面的氯會造成你身體的危害
# 這是要數到小數點很後面才會看的到 但她是顯著的 可是沒有太大的差異



# 第二題
X_2 = read.table("D:/class/statistical_methods/take_home_exam/20240820/data/Q2.txt")
hist(X_2$x, main="Q2", xlab="每天高峰期這一小時內到達的急診患者數量/人", ylab="天數次數")
summary(X_2$x)
var(X_2$x)
#  [[[[[[[[[[[[ 偏度 ]]]]]]]]]]]]]]
mean((X_2$x - mean(X_2$x))^3 )/ ((var(X_2$x)^ (0.5)) ^ 3) 

# [[[[[[[[[[[[ 峰度 ]]]]]]]]]]]]]]
(mean((X_2$x - mean(X_2$x))^4 )/ ((var(X_2$x)^ (0.5)) ^ 4)) - 3

exp(-mean(X_2$x))


# 第三題
X_3 = read.table("D:/class/statistical_methods/take_home_exam/20240820/data/Q3.txt")
hist(X_3$x, main="Q3", xlab="故障之間的時間間隔/hr", ylab="頻率")
summary(X_3$x)

var(X_3$x)
var(X_3$x)^(0.5)
sd(X_3$x)

lamda = 1/(var(X_3$x)^(0.5))
1-exp(-1 * lamda )

# 第四題
X_41 = read.table("D:/class/statistical_methods/take_home_exam/20240820/data/Q41.txt")
X_42 = read.table("D:/class/statistical_methods/take_home_exam/20240820/data/Q42.txt")

hist(X_41$x, main="Q41")
summary(X_41$x)
mean(X_41$x)

#  [[[[[[[[[[[[ 偏度 ]]]]]]]]]]]]]]
mean((X_41$x - mean(X_41$x))^3 )/ ((var(X_41$x)^ (0.5)) ^ 3) 

# [[[[[[[[[[[[ 峰度 ]]]]]]]]]]]]]]
(mean((X_41$x - mean(X_41$x))^4 )/ ((var(X_41$x)^ (0.5)) ^ 4)) - 3

hist(X_42$x, main="Q42")
summary(X_42$x)
# [[[[[[[[[[[[ 峰度 ]]]]]]]]]]]]]]
(mean((X_42$x - mean(X_42$x))^4 )/ ((var(X_42$x)^ (0.5)) ^ 4)) - 3

par(mfrow=c(1,2))  # 分割视图
hist(X_41$x, main="Q41")
hist(X_42$x, main="Q42")

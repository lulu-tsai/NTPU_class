# 這些都是合法的路徑
# D:\\file\\北大課程\\R_code\\data
# D:/class/statistical_methods/R_code/data
# 匯入檔案
write.table(X, "D:/class/statistical_methods/R_code/data/ber7.txt") # 儲存檔案 txt
write.csv(X, "D:/class/statistical_methods/R_code/data/ber7.csv")  # 儲存檔案 csv
Y = read.table("D:/class/statistical_methods/R_code/data/ber7.txt")

names(Y)

# list 用法
S = list( A = "a", B = c( 1, 32 ), C = 1:3 )

# 清除所有變數
rm(list = ls(all = TRUE))

# 伯努利分布 Bernoulli distribution =================
# 老師會跟你說n是多少
# 讀寫資料
X = rbinom(1000, 1, 0.7)

hist(X) # 只有0跟1
summary(X) # 只有0跟1
# 可能還會問有幾個變數
p = mean(X) # 估計期望值
# 用現在的結果去推估變異數是多少
p*(1-p) # 理論上的變異術
var(X)  # 用他的公式計算變異術
# 這兩個東西在N很大的時候是一樣的
# p*(1-p) 會比較準確一點

# ? 他到底是偏左還是偏右
# 計算它的 [ 偏度 ] 
X - mean(X)  # 把所有數值都剪掉它的中心
(X - mean(X))^3  # 把所有東西都取三次方
mean((X - mean(X))^3 )  # yi全部加起來 在講義ch4-P10凸凸的框框
S2 = var(X)
S1 = S2 ^ (0.5)
S3 = S1 ^ 3

#  [[[[[[[[[[[[ 偏度 ]]]]]]]]]]]]]]
mean((X - mean(X))^3 )/ S3
# 他這裡是負號 但1其實比較多
# 因為她是要描述哪一邊的尾巴比較長 ( 這個範例尾巴比較拚像在左邊 )


# [[[[[[[[[[[[ 峰度 ]]]]]]]]]]]]]]
S4 = S1 ^ 4
mean((X - mean(X))^4 )/ S4-3
# 這裡會是負的

# 二項分配 Binomial distribution =================
X = rbinom(1000, 5, 0.7)
hist(X)
summary(X)
var(X)
n = 5 # 總次數
n_p = mean(X) 
p = n_p/5
n*p*(1-p)  # 變異數
var(X)
hist(X) # 看到這張圖可以知道他是離散型的


# 朴瓦松分配 Poisson distribution ==============================================
# 看下資料都是正整數 看起來是離散型的
# 所以我可以去驗證他是不是朴瓦松
  # 朴瓦松 # 是一個計次的過程
X = rpois(1000, 5)
summary(X)
var(X)  # 期望值和變異數差不多 就又更確定他是普瓦松
hist(X) # 從這個圖 有峰度 所以她就會是朴瓦松
# 不是超幾何 因為超幾何是一個偏向溜滑梯的形狀


# 超幾何分配 grometric distribution ================================
X = rgeom(1000, 0.1)
summary(X)
hist(X) # 這個圖比較偏向有一邊有一個高峰 然後慢慢趨近於0
p = 1 / ( mean(X) + 1 )
var(X)
# 他就是溜滑梯溜下去的一個圖形
# 越後面成功的機率會越低


# ====================連續型分配==================
# uniform distribution 均勻分配 ==================
X = runif(1000, 3, 7) 
summary(X)  # 看這個就大概可以知道他是連續型的
hist(X)  # 沒有特別的山峰 而且都平平的 就是均勻分配
# 可以看的出來牠的上下界大概是哪裡
var(X)


# exponetial distribution 指數分配 ================
X = rexp(1000, 1/7)
hist(X) # 長得有點像超幾何分配
summary(X) # 但看到這個summary就可以看的出來 他是連續型的
# 超幾何分配 和 指數分配 都很像 它們都是健忘的
# 驗證他是 exponetial distribution 看下期望值和標準差是不是有關聯的
var(X)
sd(X)
# 可以看的出來他的 var開根號就是sd了


# normal distribution 常態分配 =======================
X = rnorm(1000, 7, 1)
summary(X)
hist(X)  # 基本上看到這個就可以很明顯地看得出來他是常態了
# 還可以再來看一下 QQplot 也可以加以驗證
qqnorm(X)  # 散步圖
qqline(X)  # 會給你一條輔助線
var(X)
s = sd(X)  # 用mean去計算
mu = mean(X)
# 在很多地方都希望他是常態分配 像是回歸分析

#? 加上1.96的機率為何
pnorm(mu+1.96, mu, s)  # 因為normal左邊加上1.96 就會是他百分之97.5的數值都會在裡面





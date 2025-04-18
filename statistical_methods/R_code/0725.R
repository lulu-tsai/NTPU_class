####### ex1
X = c(1, 2, 3, 4, 5, 6) # 表示裡面只有0跟1的數值
B = sample( X, 1000, replace=TRUE )  # 從上面的隨機變數取樣結果 拿出放回
hist(B) # 觀察小x發生的比率為何


## 期望值計算
## 算法1直接計算
(1*153+2*169+3*163+4*188+5*168+6*159)/1000

## 聰明計算結果
(sum(table(B)*(1:6)))/1000

## 直接取平均就是期望值~
mean(B)

# 每一個分別出現的期望值
p=table(B)/1000

####### ex2 公司抽獎
rep(1, 10) # 1 這件事要重複10次

# R: 1, 500元 有10顆
# B: 2, 1000元 有7顆
# G: 3, 3000元 有3顆
# 共20顆球
# 大家都可以來抽獎 公司有1000人
# 每個人平均期望上可以獲得多少錢?

X = c(rep(1, 10), rep(2, 7), rep(3, 3))
hist(X)
# 全部抽球的結果
## 這個樣本所求的期望值
B = sample( X, 1000, replace=TRUE )
table(B)/1000 # 機率的部分
table(B)/1000 * c(500, 1000, 3000) # 乘上長度一樣的向量 會對應相乘 老闆所有需要付的錢
sum(table(B)/1000 * c(500, 1000, 3000))  # 期望值的概念 大家平均要得到的錢

## 理論上的期望值 
500*(10/20) + 1000*(7/20) +3000*(3/20) # 加權平均的概念



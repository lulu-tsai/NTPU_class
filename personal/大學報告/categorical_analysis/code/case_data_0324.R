### 老師要教大家怎麼畫品質管制圖 ###

# 先下載套件惹 只需要一次
# install.packages("qcc")
# 導入他
library(qcc)

# 載入你的檔案
df <- read.csv("C:/Users/NTPU/Documents/data_set/Ex6-1.csv", header = TRUE)

# 首先他想要先把sample 這個column 去除了
df <- df[, 2:6]  # 行, 列

# 用一下qcc的程式畫 xbar的管制圖
q_xbar <- qcc( data = df, type = "xbar" )
# 這樣就會畫出跟投影片一樣圖形了
# 有幫你標註上屆UCL/下屆LCL 很貼心

# 如果你想要看你剛剛的詳細資訊
# 這樣又可以看的出來了
q_xbar

# 如果你要看中心線的話
q_xbar$center
# 如果你想要看他的上下屆
q_xbar$limits
# 如果你想要看每個點
q_xbar$statistics
# 如果你想要顯示表格的重要資訊
summary(q_xbar)

# R的管制圖
q_R <- qcc( data = df, type = "R" )
summary(q_R)
# 從這張圖可以看出來所有的點並沒有觀測到不在管制內的情況。
# 管制圖的形式沒有任何的形狀(pattern) 跟期望中差不多算是random 的


# 如果不小心有不在管制內的狀態，要怎麼處理???
# 老師說刪掉 對 就是刪掉
# 用程式讓他超過界線的數據消失 但老師竟然是說找到那筆資料去把它刪掉 


######## 自己計算統計相關資訊 #########
# 老師說研究生應該自己硬刻
# 老師想要給你一個手算的感覺 你才知道套件的美好 ^^
cf <- as.matrix(df)
x_bar <- numeric(); R <- numeric()
n <- 5; m <- 25
for (i in 1:25){
  x_bar[i] <- mean(cf[i, ])
  R[i] <- range(cf[i, ])[2] - range(cf[i, ])[1]
} # 每一列都去算他的平均 

# 看一下剛剛的結果
x_bar
R
# 回到公式的本體 自己計算一下到底怎麼計算
x_barbar <- mean(x_bar)
R_bar <- mean(R)



#################################################
## 作業2
# Q1-1：繪製xbar和R的管制圖，資料T6-2製成是否有在管制內
df_t62 <- read.csv("C:/Users/NTPU/Documents/data_set/T6-2.csv", header = TRUE)
q_R_t62r <- qcc( data = df_t62, type = "R" )
# 從這張圖可以看出來並沒有觀測到不在管制內的情況。
# 這張圖看起來稍微有往下，但還在可以接受的範圍，還可以算是 random 的狀態。

# Q1-2：繪製xbar和S的管制圖，資料T6-2製成是否有在管制內





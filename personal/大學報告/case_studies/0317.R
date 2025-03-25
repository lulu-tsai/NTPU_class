install.packages("lavaan")  # SEM 分析
install.packages("semPlot") # 畫 SEM 圖
install.packages("ggplot2") # 圖形美化（可選）

library(lavaan)
library(semPlot)
library(ggplot2)

# 定義 SEM 模型
sem_model <- "
    A =~ A1 + A2 + A3 + A4 + A5
    B =~ B1 + B2 + B3
    C =~ C1 + C2 + C3
    D =~ D1 + D2 + D3
    A ~ B + C + D
"

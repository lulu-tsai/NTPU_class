# 1. 安裝與載入必要套件
#install.packages("lavaan")
#install.packages("semPlot")
#library(lavaan)
#library(semPlot)

# 2. 定義 SEM 模型（包含觀察變數）
model <- '
  # 測量模型（確認性因素分析，CFA）
  School_Management =~ X1 + X2 + X3  
  Teacher_Engagement =~ M1_1 + M1_2 + M1_3 + M1_4  
  Teaching_Support =~ M2_1 + M2_2  
  Student_Behavior =~ Y1 + Y2 + Y3 + Y4 + Y5  

  # 結構模型（SEM）
  Teacher_Engagement ~ School_Management  
  Student_Behavior ~ School_Management  
  Teaching_Support ~ School_Management  
  Student_Behavior ~ Teacher_Engagement  
  Student_Behavior ~ Teaching_Support  
'

# 3. 模擬數據（若有真實數據可替換 data）
set.seed(123)
N <- 300  # 樣本數
data <- data.frame(
  X1 = rnorm(N, mean = 3, sd = 1), X2 = rnorm(N, mean = 3, sd = 1), X3 = rnorm(N, mean = 3, sd = 1),  # 學校管理模式
  M1_1 = rnorm(N, mean = 3, sd = 1), M1_2 = rnorm(N, mean = 3, sd = 1), M1_3 = rnorm(N, mean = 3, sd = 1), M1_4 = rnorm(N, mean = 3, sd = 1),  # 教師教學投入
  M2_1 = rnorm(N, mean = 3, sd = 1), M2_2 = rnorm(N, mean = 3, sd = 1),  # 教學支援
  Y1 = rnorm(N, mean = 3, sd = 1), Y2 = rnorm(N, mean = 3, sd = 1), Y3 = rnorm(N, mean = 3, sd = 1), Y4 = rnorm(N, mean = 3, sd = 1), Y5 = rnorm(N, mean = 3, sd = 1)  # 學生偏差行為
)

# 4. 運行 SEM 分析
fit <- sem(model, data = data)

# 5. 顯示模型摘要結果
summary(fit, fit.measures = TRUE, standardized = TRUE)

# 6. 繪製 SEM 路徑圖（顯示標準化係數）
semPaths(
  fit,
  what = "path",                 # 顯示因果路徑
  whatLabels = "std",            # 顯示標準化係數
  layout = "tree2",              # 讓圖形更整齊 (可試 "tree"、"circle"、"spring")
  edge.label.cex = 1.2,          # 放大係數標籤
  nCharNodes = 5,                # 避免變數名稱重疊
  fade = FALSE,                  # 不淡化線條
  residuals = FALSE,             # 隱藏誤差項，讓圖形更簡潔
  intercepts = FALSE,            # 不顯示截距
  curvePivot = TRUE,             # 讓曲線更平滑
  title = TRUE,                  # 添加標題
  style = "lisrel",              # 使用 LISREL 風格，讓圖更專業
  optimizeLatRes = TRUE          # 自動調整潛變數位置
)


###############
# 設定變數的中文名稱
node_labels <- c(
  "學校管理模式", "教師教學投入", "教學支援", "學生偏差行為",
  "目標導向", "教學介入", "決策參與",
  "滿足需求", "不會缺課", "要求適當", "備課充足",
  "人力支援", "硬體支援",
  "逃學", "曠課", "缺乏尊師", "酒精藥物", "霸凌恐嚇"
)

# 繪製美觀的 SEM 圖形
semPaths(
  fit,
  what = "path",                 # 顯示因果路徑
  whatLabels = "std",            # 顯示標準化係數
  layout = "tree2",              # 讓圖形更整齊 (可試 "tree"、"circle"、"spring")
  edge.label.cex = 1.2,          # 放大係數標籤
  nCharNodes = 6,                # 避免變數名稱重疊
  fade = FALSE,                  # 不淡化線條
  residuals = FALSE,             # 隱藏誤差項，讓圖形更簡潔
  intercepts = FALSE,            # 不顯示截距
  curvePivot = TRUE,             # 讓曲線更平滑
  title = TRUE,                  # 添加標題
  style = "lisrel",              # 使用 LISREL 風格，讓圖更專業
  optimizeLatRes = TRUE,         # 自動調整潛變數位置
  nodeLabels = node_labels       # **顯示中文變數名稱**
)



#########
model <- '
  # 測量模型 (CFA)
  學校管理模式 =~ 教育目標 + 教學介入 + 決策參與
  教師教學投入 =~ 滿足需求 + 不會缺課 + 要求適當 + 備課充足
  教學支援 =~ 人力支援 + 硬體支援
  學生偏差行為 =~ 逃學 + 曠課 + 缺乏尊師 + 酒精藥物 + 霸凌恐嚇

  # 結構模型 (SEM)
  教師教學投入 ~ 學校管理模式  # H1
  學生偏差行為 ~ 學校管理模式  # H2
  教學支援 ~ 學校管理模式  # H3
  學生偏差行為 ~ 教師教學投入  # H4
  學生偏差行為 ~ 教學支援  # H5

  # 中介效果 (Mediation)
  學生偏差行為 ~ 學校管理模式 * 教師教學投入  # H6
  學生偏差行為 ~ 學校管理模式 * 教學支援  # H7
'

semPaths(
  fit,
  what = "path",           # 畫出因果關係箭頭
  whatLabels = "none",     # **不顯示數字**
  layout = "tree",         # **確保箭頭方向正確**
  sizeMan = 8,             # **矩形大小**
  sizeLat = 10,            # **潛變數（橢圓）大小**
  nodeLabels = c(
    "學校管理模式", "教師教學投入", "教學支援", "學生偏差行為",
    "教育目標", "教學介入", "決策參與",
    "滿足需求", "不會缺課", "要求適當", "備課充足",
    "人力支援", "硬體支援",
    "逃學", "曠課", "缺乏尊師", "酒精藥物", "霸凌恐嚇"
  ),                      # **設定變數的標籤**
  edge.label.cex = 1.2,    # **標準化係數大小**
  nCharNodes = 0,         # **顯示完整名稱**
  fade = FALSE,           # **不淡化線條**
  residuals = TRUE,       # **顯示誤差項**
  intercepts = FALSE,     # **不顯示截距**
  curvePivot = TRUE,      # **讓曲線更平滑**
  title = TRUE,           # **顯示標題**
  style = "lisrel",       # **LISREL 風格**
  #color = list(lat = "purple", man = "white", edge = "purple") # **紫色風格**
)
#######################

model <- '
  # 測量模型 (CFA)
  學校管理模式 =~ 教育目標 + 教學介入 + 決策參與
  教師教學投入 =~ 滿足需求 + 不會缺課 + 要求適當 + 備課充足
  教學支援 =~ 人力支援 + 硬體支援
  學生偏差行為 =~ 逃學 + 曠課 + 缺乏尊師 + 酒精藥物 + 霸凌恐嚇

  # 結構模型 (SEM)
  教師教學投入 ~ 學校管理模式  # H1
  學生偏差行為 ~ 學校管理模式  # H2
  教學支援 ~ 學校管理模式  # H3
  學生偏差行為 ~ 教師教學投入  # H4
  學生偏差行為 ~ 教學支援  # H5

  # 中介效果 (Mediation)
  學生偏差行為 ~ 學校管理模式 * 教師教學投入  # H6
  學生偏差行為 ~ 學校管理模式 * 教學支援  # H7
'

# 設定假設標籤
edge_labels <- c("H1", "H2", "H3", "H4", "H5", "H6", "H7")

# 設定誤差符號
error_labels <- c("ε1", "ε2", "ε3", "ε4", "ε5", "ε6", "ζ1")

# 畫出 SEM 圖
semPaths(
  fit,
  what = "path",               # **顯示變數路徑**
  whatLabels = "none",         # **不顯示數值**
  layout = "tree",             # **箭頭方向符合 H 假設**
  edgeLabels = edge_labels,    # **顯示 H1, H2, ..., H7**
  residuals = TRUE,            # **顯示誤差項**
  residScale = 1.2,            # **誤差項大小**
  style = "lisrel",            # **使用 LISREL 風格**
  nodeLabels = c(
    "學校管理模式", "教師教學投入", "教學支援", "學生偏差行為",
    "教育目標", "教學介入", "決策參與",
    "滿足需求", "不會缺課", "要求適當", "備課充足",
    "人力支援", "硬體支援",
    "逃學", "曠課", "缺乏尊師", "酒精藥物", "霸凌恐嚇"
  ),                           # **顯示中文變數名稱**
  edge.label.cex = 1.5,        # **標籤（H假設）大小**
  nCharNodes = 0,              # **顯示完整名稱**
  fade = FALSE,                # **不淡化線條**
  curvePivot = TRUE,           # **讓曲線更平滑**
  #color = list(lat = "purple", man = "white", edge = "purple") # **紫色風格**
)

################
semPaths(
  fit,
  what = "path",               # 繪製路徑
  whatLabels = "none",         # 不顯示數值
  layout = "tree2",            # 讓圖形符合假設關係
  rotation = 2,                # 讓圖形水平對齊
  sizeMan = 8,                 # 觀察變數大小
  sizeLat = 10,                # 潛變數大小
  nodeLabels = c(
    "學校管理模式", "教師教學投入", "教學支援", "學生偏差行為",
    "教育目標", "教學介入", "決策參與",
    "滿足需求", "不會缺課", "要求適當", "備課充足",
    "人力支援", "硬體支援",
    "逃學", "曠課", "缺乏尊師", "酒精藥物", "霸凌恐嚇"
  ),                           # 設定變數名稱
  edgeLabels = c("H1", "H2", "H3", "H4", "H5", "H6", "H7"),  # 顯示 H 假設標籤
  edge.label.cex = 1.5,        # H 假設標籤大小
  nCharNodes = 0,              # 顯示完整變數名稱
  fade = FALSE,                # 不淡化線條
  residuals = TRUE,            # 顯示誤差項
  residScale = 1.2,            # 誤差項大小
  intercepts = FALSE,          # 不顯示截距
  curvePivot = TRUE,           # 讓箭頭曲線更平滑
  title = TRUE,                # 顯示標題
  style = "lisrel",            # 使用 LISREL 風格
  optimizeLatRes = TRUE,       # 自動調整潛變數
  #color = list(lat = "purple", man = "white", edge = "purple") # 設定顏色
)


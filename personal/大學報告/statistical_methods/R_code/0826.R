# 想知道他到底是不是normal
X = rnorm(1000, 1, 2)
qqnorm(X)

X = rchisq(1000, 2) # 可以看出來他不是normal
qqnorm(X)

# 他需要兩個一樣才會是一個斜直線
xn = pnorm(tt, mean(X), sd(X))
plot(tt, y, type="1")
points(tt, xn , type= "1", col=2)
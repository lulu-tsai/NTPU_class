## Two-sample t-test
t.test(1:10, y = c(7:20))      # P = .00001855


x=1:10
y =7:20
st=mean(x)-mean(y)
dst=var(x)/length(x)+var(y)/length(y)

st/(dst)^0.5
df=length(x)+length(y)-2

df_w=dst^2/(var(x)^2/length(x)^2/(length(x)-1)+var(y)^2/length(y)^2/(length(y)-1))
# 自由度不一定是正整數

pt(abs(st/(dst)^0.5),df,lower.tail=FALSE)*2
pt(abs(st/(dst)^0.5),df_w,lower.tail=FALSE)*2


############################################################
#F-test


pf(var(x)/var(y),length(x)-1,length(y)-1)*2
var.test(x, y)
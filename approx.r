kf = function(q) {
    (asin(2*q-1)+pi/2)/pi
}
data = data.frame(q=x, k=kf(x), q2=x^2, q3=x^3, q4=x^4)

### train on data in [0.03, 0.5], but we only use the polynomial for
### data in [0.05, 0.5]
limit = 0.03
m = lm(k~q+q2+q3+q4, data[data$q>limit,])
data$m = 0
data[data$q>limit,]$m = predict(m)
m$coefficients

data$z = 2*data$q-1
data = cbind(data, data.frame(t2=cos(2*acos(data$z)), t3=cos(3*acos(data$z)),
    t4=cos(4*acos(data$z)),
    t5=cos(5*acos(data$z)),
    t6=cos(6*acos(data$z)),
    t7=cos(7*acos(data$z)),
    t8=cos(8*acos(data$z)),
    t9=cos(9*acos(data$z))
))
m.cheb = lm(k~z+t2+t3+t4+t5+t6+t7+t8+t9, data[data$q>limit,])

data$m.cheb = 0
data[data$q>limit,]$m.cheb = predict(m.cheb)

plot(m-k~q, data[data$q>limit,], type='l')
lines(m.cheb-k~q, data[data$q>0.05,], type='l', col='red')

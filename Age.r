args<-commandArgs(TRUE)
input<-args[1]
out <-args[2]

age<-read.table(input,header=T)
pdf(width=8, height=6,file=out)
par(mfrow=c(2,3))

plot(c(age[,3]),c(age[,5]),col="black",xlim=c(0,130),ylim=c(20000,200000),xlab="age(month)",ylab="CDR3 num",main="CDR3 num by age")
lines(lowess(c(age[,3]),c(age[,5])),col="red",cex=1.5)

a<-c("One_age","Two_age","Three_age","Four_age","Five_age")
for (i in 7:11 ){
	boxplot(CDR3_num~age[,i],data=age,outline=F,names=c(paste("down",a[i-6]) ,paste("up",a[i-6])),xlab="age",ylab="cdr3 num",ylim=c(20000,200000),main=paste("cdr3 num by", a[i-6]))
	num=table(age[,a[i-6]])
	xx=jitter(c(rep(1,num[1]),rep(2,num[2])),amount=0.3)
	age1=age[order(age[,a[i-6]]),]
	age2=cbind(age1,xx)
	age3=age2[order(age2[,a[i-6]]),]
	c<-c(1:num[1])
	b<-c(num[1]+1:num[2])
	points(age3[c,12],age3[c,5],col=4,pch=16)
	points(age3[b,12],age3[b,5],col=3,pch=16)

	x<-age3[c,5]
	y<-age3[b,5]
	p<-wilcox.test(x,y,paired=FALSE)
#	pt<- -log(p$p.value)/log(10)
#	pv<-round(pt, digit=2)
	
	if (p$p.value > 0.000001){
		pv<-round(p$p.value,4)
	}else{
		pv<-p$p.value
	}
	text(1.5,180000,labels=pv,cex=1.2)
}

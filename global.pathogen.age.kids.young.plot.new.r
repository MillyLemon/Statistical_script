require(ggplot2)
library(gridExtra)
library(grid)

a<-read.table("***.txt",head=T)
pdf("***.pdf",width=12,height=12)
vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)

geom_smooth(aes(group=1),method="lm",size=0.8,se=F)
g1<-ggplot(a,aes(x=Age,y=clone_shannon)) + theme_bw() + geom_point(col="black") +  geom_smooth(method=lm,colour="red")  + theme(legend.position="none",axis.text.x=element_blank(),axis.title.x=element_blank()) +  ylab("Shannon Index") + scale_x_continuous(breaks=seq(0,90,by=10),labels=c("","","","","","","","","","")) + annotate("text",label="r=-0.484,p<2.2e-16",x=50,y=15.1)
#cor.test(a$Age,a$clone_shannon,alternative = "two.sided",method = "spearman",conf.level = 0.95)  # -0.4845741,p-value < 2.2e-16

g2<-ggplot(a,aes(x=Age,y=clone_Gini)) + theme_bw() + geom_point(col="black") +  geom_smooth(method=lm,colour="red")  + theme(legend.position="none",axis.text.x=element_blank(),axis.title.x=element_blank()) +  ylab("Gini coefficient") + scale_x_continuous(breaks=seq(0,90,by=10),labels=c("","","","","","","","","","")) + ylim(0.47,0.92) + annotate("text",label="r=0.440,p<2.2e-16",x=50,y=0.915)
#cor.test(a$Age,a$clone_Gini,alternative = "two.sided",method = "spearman",conf.level = 0.95)  # 0.4403018, p-value < 2.2e-16

#a<-read.table("total.allergy.cq.global_stat_all.1M.new.txt",head=T)
#a<-read.table("split.child.3age.info",head=T)
a<-read.table("***.info",head=T)
b<-read.table("***.txt",head=T)
All_1<-subset(a,a$Split=="All_1")
All_2<-subset(a,a$Split=="All_2")
All_3<-subset(a,a$Split=="All_3")
All_4<-subset(a,a$Split=="All_4")
All_5<-subset(a,a$Split=="All_5")
Hea_1<-subset(a,a$Split=="Hea_1")
Hea_2<-subset(a,a$Split=="Hea_2")
Hea_3<-subset(a,a$Split=="Hea_3")
Hea_4<-subset(a,a$Split=="Hea_4")
Hea_5<-subset(a,a$Split=="Hea_5")

#cor.test(All_0_3$clone_shannon,Hea_0_3$clone_shannon)#,alternative = "two.sided",method = "spearman",conf.level = 0.95)  # p-value = 0.007437
#cor.test(All_4_5$clone_shannon,Hea_4_5$clone_shannon)#,alternative = "two.sided",method = "spearman",conf.level = 0.95)  # p-value = 1.225e-06
wilcox.test(All_1$clone_shannon,Hea_1$clone_shannon)$p.value # p = 0.4848485
wilcox.test(All_2$clone_shannon,Hea_2$clone_shannon)$p.value # p = 0.001114581
wilcox.test(All_3$clone_shannon,Hea_3$clone_shannon)$p.value # p = 0.09330712
wilcox.test(All_4$clone_shannon,Hea_4$clone_shannon)$p.value # p = 8.026157e-05
wilcox.test(All_5$clone_shannon,Hea_5$clone_shannon)$p.value # p = 0.005515182
wilcox.test(All_3$clone_shannon,Hea_4$clone_shannon)$p.value # p = 0.00434138
wilcox.test(All_2$clone_shannon,Hea_3$clone_shannon)$p.value # p = 0.000193835

wilcox.test(All_1$clone_Gini,Hea_1$clone_Gini)$p.value  # p = 0.3939394
wilcox.test(All_2$clone_Gini,Hea_2$clone_Gini)$p.value  # p = 0.044902 
wilcox.test(All_3$clone_Gini,Hea_3$clone_Gini)$p.value  # p = 0.5690834
wilcox.test(All_4$clone_Gini,Hea_4$clone_Gini)$p.value  # p = 0.01208189
wilcox.test(All_5$clone_Gini,Hea_5$clone_Gini)$p.value  # p = 0.3426794
wilcox.test(All_3$clone_Gini,Hea_4$clone_Gini)$p.value  # p = 0.03937632
wilcox.test(All_2$clone_Gini,Hea_3$clone_Gini)$p.value  # p = 0.0220045

#g3<-ggplot(a,aes(x=Split,y=clone_shannon)) + theme_bw() + geom_boxplot() + ylim(10,16)+ theme(legend.position="none",axis.text.x=element_blank(),axis.title.x=element_blank())   + ylab("Shannon Index") + annotate("text",x=1,y=Inf,label=paste("p=2.88e-06"),hjust=-.2,vjust=2) # annotate("text",x=1,y=Inf,label=paste("p=",p2),hjust=-.2,vjust=2)
g3<-ggplot(a,aes(x=Split,y=clone_shannon,colour=flag)) + theme_bw() + geom_boxplot(outlier.colour = NA)+ ylim(10,16)  + ylab("Shannon Index")  #+ annotate("text",x=1,y=Inf,label=paste("p=2.88e-06"),hjust=-.2,vjust=2) # annotate("text",x=1,y=Inf,label=paste("p=",p2),hjust=-.2,vjust=2)

#g4<-ggplot(a,aes(x=Split,y=clone_Gini)) + theme_bw() + geom_boxplot() + theme(legend.position="none",axis.text.x=element_blank(),axis.title.x=element_blank())  + ylab("Gini coefficient") + annotate("text",x=1,y=Inf,label=paste("p=0.02"),hjust=-.2,vjust=2) # annotate("text",x=1,y=Inf,label=paste("p=",p3),hjust=-.2,vjust=2)
g4<-ggplot(a,aes(x=Split,y=clone_Gini,colour=flag)) + theme_bw() + geom_boxplot(outlier.colour = NA) + ylab("Gini coefficient")#+ scale_x_discrete(limits=c("All_1","Hea_1","All_2","Hea_2","All_3","Hea_3","All_4","Hea_4","All_5","Hea_5"))  #theme(legend.position="none",axis.text.x=element_blank(),axis.title.x=element_blank())  + ylab("Gini coefficient") + annotate("text",x=1,y=Inf,label=paste("p=0.02"),hjust=-.2,vjust=2) # annotate("text",x=1,y=Inf,label=paste("p=",p3),hjust=-.2,vjust=2)

g5<-ggplot(b,aes(x=flag,y=clone_shannon)) + theme_bw() + geom_boxplot()+ylim(6,15) + theme(legend.position="none",axis.text.x=element_blank(),axis.title.x=element_blank())  + ylab("Shannon Index") + annotate("text",x=1,y=Inf,label=paste("p=0.13"),hjust=-.2,vjust=2) # annotate("text",x=1,y=Inf,label=paste("p=",p5),hjust=-.2,vjust=2)

g6<-ggplot(b,aes(x=flag,y=clone_Gini)) + theme_bw() + geom_boxplot() + theme(legend.position="none",axis.text.x=element_blank(),axis.title.x=element_blank()) + ylab("Gini coefficient") + annotate("text",x=1,y=Inf,label=paste("p=2.71e-05"),hjust=-.2,vjust=2) # annotate("text",x=1,y=Inf,label=paste("p=",p6),hjust=-.2,vjust=2)

a1<-read.table("***.txt",head=T)
b1<-read.table("***.txt",head=T)
c1<-read.table("***.txt",head=T)

All_1<-subset(b1,b1$Split=="All_1")
All_2<-subset(b1,b1$Split=="All_2")
All_3<-subset(b1,b1$Split=="All_3")
All_4<-subset(b1,b1$Split=="All_4")
All_5<-subset(b1,b1$Split=="All_5")
Hea_1<-subset(b1,b1$Split=="Hea_1")
Hea_2<-subset(b1,b1$Split=="Hea_2")
Hea_3<-subset(b1,b1$Split=="Hea_3")
Hea_4<-subset(b1,b1$Split=="Hea_4")
Hea_5<-subset(b1,b1$Split=="Hea_5")

wilcox.test(All_1$pathogen_ratio,Hea_1$pathogen_ratio)$p.value # p = 0.2402597
wilcox.test(All_2$pathogen_ratio,Hea_2$pathogen_ratio)$p.value # p = 0.08873379
wilcox.test(All_3$pathogen_ratio,Hea_3$pathogen_ratio)$p.value # p = 0.04744838
wilcox.test(All_4$pathogen_ratio,Hea_4$pathogen_ratio)$p.value # p = 0.00391561
wilcox.test(All_5$pathogen_ratio,Hea_5$pathogen_ratio)$p.value # p = 0.3863918
wilcox.test(All_3$pathogen_ratio,Hea_4$pathogen_ratio)$p.value # p = 0.04082285
wilcox.test(All_2$pathogen_ratio,Hea_3$pathogen_ratio)$p.value # p = 0.01597177



min<-subset(a1,a1$Age<=20)
max<-subset(a1,a1$Age>=35 & a1$Age<=70)
#cor.test(min$Age,min$pathogen_ratio,alternative = "two.sided",method = "spearman",conf.level = 0.95)  # r=0.3341014, p-value = 2.538e-07
#cor.test(max$Age,max$pathogen_ratio,alternative = "two.sided",method = "spearman",conf.level = 0.95) # r=-0.2650405, p-  lue = 1.516e-07
case2<-subset(b1,b1$flag=="Allergic_Kids")
control2<-subset(b1,b1$flag=="Healthy_Kids")
p2<-wilcox.test(case2$pathogen_ratio,control2$pathogen_ratio)$p.value

case3<-subset(c1,c1$flag=="Allergy")
control3<-subset(c1,c1$flag=="Health")
p3<-wilcox.test(case3$pathogen_ratio,control3$pathogen_ratio)$p.value

g7<-ggplot(a1,aes(x=Age,y=pathogen_ratio)) + theme_bw() + geom_point() + theme(legend.position="none")+ geom_smooth(method=loess,size=0.5,colour="red") + scale_x_continuous(breaks=seq(0,90,by=10)) + ylab("PKPSC") + annotate("text",x=1.5,y=1.1,label="0-20,r=0.33;35-90,r=-0.33;0-20,p=2.54e-07;35-90,p=5.764e-12")

#g8<-ggplot(b1,aes(x=flag,y=pathogen_ratio)) + theme_bw() + geom_boxplot() + theme(legend.position="none")+xlab("")  + ylab("PKPSC") + annotate("text",x=1.5,y=1.1,label="p = 0.002") + ylim(0.6,1.1) + scale_x_discrete(breaks=c("Allergy","CQ"),labels=c("Allergic_Kids","Healthy_Kids"))
g8<-ggplot(b1,aes(x=Split,y=pathogen_ratio,colour=flag)) + theme_bw() + geom_boxplot(outlier.colour = NA)+ylab("PKPSC")+ scale_x_discrete(limits=c("All_1","Hea_1","All_2","Hea_2","All_3","Hea_3","All_4","Hea_4","All_5","Hea_5")) #+ theme(legend.position="none")+xlab("")  + ylab("PKPSC") + annotate("text",x=1.5,y=1.1,label="p = 0.002") + ylim(0.6,1.1) + scale_x_discrete(breaks=c("Allergy","CQ"),labels=c("Allergic_Kids","Healthy_Kids"))

g9<-ggplot(c1,aes(x=flag,y=pathogen_ratio)) + theme_bw() + geom_boxplot()  + theme(legend.position="none") + xlab("")+ylab("PKPSC") + annotate("text",x=1.5,y=1.18,label="p = 0.66") + ylim(0.6,1.2) + scale_x_discrete(breaks=c("Allergy","Health"),labels=c("Allergic_Adults","Healthy_Adults"))

grid.newpage()
#	pushViewport(viewport(layout = grid.layout(25,24)))
	pushViewport(viewport(layout = grid.layout(3,1)))
#	print(g1, vp = vplayout(1,1:1))
#	print(g2, vp = vplayout(2,1:1))
	print(g3, vp = vplayout(1,1:1))
	print(g4, vp = vplayout(2,1:1))
#	print(g5, vp = vplayout(1,3:3))
#	print(g6, vp = vplayout(2,3:3))
#	print(g7, vp = vplayout(3,1:1))
	print(g8, vp = vplayout(3,1:1))
#	print(g9, vp = vplayout(3,3:3))

#	print(g1, vp = vplayout(1:8,1:8))
#	print(g2, vp = vplayout(9:16,1:8))
#	print(g3, vp = vplayout(1:8,9:16))
#	print(g4, vp = vplayout(9:16,9:16))
#	print(g5, vp = vplayout(1:8,17:24))
#	print(g6, vp = vplayout(9:16,17:24))
#	print(g7, vp = vplayout(17:25,1:8))
#	print(g8, vp = vplayout(17:25,9:16))
#	print(g9, vp = vplayout(17:25,17:24))

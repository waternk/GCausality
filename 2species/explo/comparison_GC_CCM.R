### CP April 2019
### We compare the results from Granger-causality and CCM on the same simulations (chaotic, stochastic, with a driver...) and try to compute a binary correlation phi.
### Note on phi : we write a function, but we can also use the library(psych) and the corresponding phi, or the sqrt(chisq.test$statistics/nsample)
### Obsolete, now computing phi in /results_StochasticCompet.R

rm(list=ls())
graphics.off()

phi=function(tableau){
	
	if(("1" %in% rownames(tableau))&("1" %in% colnames(tableau))){
		n11=tableau["1","1"]
	}else{
		n11=0
	}
        if(("1" %in% rownames(tableau))&("0" %in% colnames(tableau))){
                n10=tableau["1","0"]
        }else{
                n10=0
        }
        if(("0" %in% rownames(tableau))&("1" %in% colnames(tableau))){
                n01=tableau["0","1"]
        }else{
                n01=0
        }
        if(("0" %in% rownames(tableau))&("0" %in% colnames(tableau))){
                n00=tableau["0","0"]
        }else{
                n00=0
        }

	n1p=n11+n10
	n0p=n01+n00
	np1=n11+n01
	np0=n00+n10

	n=n11+n10+n01+n00
	
	den=1.0*n1p*n0p*np0*n1p
	if(den==0.0){den=1.0}

	phi=(n11*n00-n10*n01)/sqrt(den) #the 1.0 to avoid integer overflow

	if(is.na(phi)){
		phi=(n*n11-n1p*np1)/sqrt(n1p*np1*(n-n1p)*(n-np1))
	}

	return(phi)


}

table_inter=read.csv("results/DataCompet_CHAOS_inter_withRhoMaxSpec.csv")
#table_inter=read.csv("results/DataCompet_stochModel_inter_withRhoMaxSpec.csv") #Update. In these tables, we have to recompute 0 and 1 boolean causalities

table_inter$index_1cause2_inter_GC=(table_inter$Pval_12_inter_GC<0.1)*(table_inter$log_12_inter>0.04)
table_inter$index_2cause1_inter_GC=(table_inter$Pval_21_inter_GC<0.1)*(table_inter$log_21_inter>0.04)
table_inter$index_1cause2_inter_CCM=(table_inter$Pval_12_inter_CCM_surr<0.1)*(table_inter$RhoLMax_12_inter_v1>0.1)
table_inter$index_2cause1_inter_CCM=(table_inter$Pval_21_inter_CCM_surr<0.1)*(table_inter$RhoLMax_21_inter_v1>0.1)

#table_inter=read.csv("../twoSpecies_andDriver/DataCompet_driver_noIntersp2tempfirst100.csv")

table_inter=na.exclude(table_inter)
print("1 causes 2")
plou=table(table_inter$index_1cause2_inter_GC,table_inter$index_1cause2_inter_CCM)
print("GC")
print(sum(table_inter$index_1cause2_inter_GC==1)/nrow(table_inter))
print("CCM")
print(sum(table_inter$index_1cause2_inter_CCM==1)/nrow(table_inter))
print(phi(plou))

print("2 causes 1")
plou=table(table_inter$index_2cause1_inter_GC,table_inter$index_2cause1_inter_CCM)
print("GC")
print(sum(table_inter$index_2cause1_inter_GC==1)/nrow(table_inter))
print("CCM")
print(sum(table_inter$index_2cause1_inter_CCM==1)/nrow(table_inter))
print(phi(plou))


rm(list=ls())
library(stargazer)
library(dplyr)
library(ggplot2)
library(readxl)


cours_data.treat= read.csv("scraping/treatment.csv")
cours_data.cont = read.csv("scraping/control.csv")


cours_data.cont["group"]="Control"
cours_data.treat["group"]="Traitement"

cours_all = rbind(cours_data.cont,cours_data.treat)

cours_all["date"]=as.Date(cours_all$date)

cours_all["ets"] = as.factor(cours_all$ets)

selecteur = which(cours_all$date<"2020-03-03")

cours_all[ selecteur ,"T"]=0
cours_all[ -selecteur ,"T"]=1


cours_all["group"] =as.factor(cours_all$group)

cours_all["log_cours"] = log(cours_all[,"adj_close"])

cours_data.03_mars =  cours_all[cours_all$date=="2020-03-03",c("ets","log_cours")]

cours_data = as.data.frame(merge(cours_all,cours_data.03_mars,by = "ets",all.x =TRUE)) 

cours_data = rename(cours_data,log_ref=log_cours.y, log_cours=log_cours.x)

cours_data["delta_log"] = cours_data[,"log_cours"] - cours_data[,"log_ref"] 


cours_data.treat= cours_data[cours_data$group=="Traitement",]
cours_data.cont = cours_data[cours_data$group=="Control",]


nbre_ets.treat = length(unique(cours_data.treat$ets)) 
nbre_ets.cont= length(unique(cours_data.cont$ets)) 

#Statistiques sur toute la période 
stats_all.treat = summary(cours_data.treat[,c("delta_log")])
stats_all.cont = summary(cours_data.cont[,c("delta_log")])
stargazer(rbind(cbind(Traitement=stats_all.treat,Control=stats_all.cont), "Nb Entreprise"=c(nbre_ets.treat,nbre_ets.cont)),
          out="exports/log/stats_whole_period.tex",
          table.placement = "h",
          digits = 2,
          #type = "text" ,
          summary = FALSE,
          title = "Statistiques descriptives du 18/02/2020 au 18/03/2020")

stats_all.treat = summary(cours_data.treat[cours_data.treat$date<"2020-03-03","delta_log"])
stats_all.cont = summary(cours_data.cont[cours_data.cont$date<"2020-03-03","delta_log"])

stargazer(rbind(cbind(Traitement=stats_all.treat,Control=stats_all.cont), "Nb Entreprise"=c(nbre_ets.treat,nbre_ets.cont)),
          out="exports/log/stats_before.tex",
          table.placement = "h",
          digits = 2,
          #type = "text" ,
          summary = FALSE,
          title = "Statistiques du 18/02/2020 au 03/03/2020")



stats_all.treat = summary(cours_data.treat[cours_data.treat$date>="2020-03-03","delta_log"])
stats_all.cont = summary(cours_data.cont[cours_data.cont$date>="2020-03-03","delta_log"])

stargazer(rbind(cbind(Traitement=stats_all.treat,Control=stats_all.cont), "Nb Entreprise"=c(nbre_ets.treat,nbre_ets.cont)),
          out="exports/log/stats_after.tex",
          table.placement = "h",
          digits = 2,
          #type = "text" ,
          summary = FALSE,
          title = "Statistiques du 03/03/2020 au 18/03/2020")

cours_data%>%
  group_by(group,date)%>%
  summarise(mean=mean(delta_log))%>%
  ggplot(aes(x=date, y=mean ,group=group,color=group)) +
  geom_line() +
  geom_vline(xintercept = as.Date("2020-03-03"),color="blue")+
  geom_point()+
  ylab("delta log")

cours_data%>%
  group_by(date,ets)%>%
  summarise(mean=mean(delta_log))%>%
  ggplot(aes(x=date, y=mean,color=ets)) +
  geom_line() +
  geom_vline(xintercept = as.Date("2020-03-03"),color="blue")+
  geom_point()+
  ylab("delta log")


#Analyse de la variance
analyse_variance = summary(aov(delta_log~group,data = cours_data))
analyse_variance_ddf = data.frame(round(analyse_variance[[1]],3) )
row.names(analyse_variance_ddf) = c("Traitement","Résidus")

stargazer(analyse_variance_ddf ,
          out="exports/log/anova.txt",
          table.placement = "h",
          digits = 3,
          type = "text" ,
          summary = FALSE,
          title = "Analyse de la variance")


all_ets = unique(cours_data$ets)
ets_index = 1:length(all_ets)
for (index in ets_index){
  ets = all_ets[index]
  cours_data[paste0("f_",index)]= as.integer(cours_data$ets==ets)
}

reg.simple= lm(delta_log~.+T:group,cours_data[,c("delta_log","group","T")])
summary(reg.simple)

reg.fixed = lm(delta_log~.+T:group,cours_data[,c("delta_log","group","T",paste0("f_",all_ets[-1]))])
summary(reg.fixed)

stargazer(reg.simple,reg.fixed,
          out="exports/log/regression.tex",table.placement = "h",
          digits = 3,
          summary = FALSE,
          omit="f_*",
          covariate.labels = c("Traitement","Apres Publication","Impact"),
          dep.var.labels = "Delta log (cours boursier)",
          #type="text",
          add.lines = list(c("Effets fixes", "NON","OUI")),
          dep.var.caption = "Variable dépendante",
          keep.stat = "n",
          title = "Diff in Diff du Delta log des cours boursiers")


reg.textile = lm(delta_log~.+T:group,cours_data[cours_data$secteur=="textile",c("delta_log","group","T")])
reg.technologie = lm(delta_log~.+T:group,cours_data[cours_data$secteur=="technologie",c("delta_log","group","T")])
reg.automobile = lm(delta_log~.+T:group,cours_data[cours_data$secteur=="automobile",c("delta_log","group","T")])

reg.textile_fixed = lm(delta_log~.+T:group,cours_data[cours_data$secteur=="textile",c("delta_log","group","T",paste0("f_",ets_index))])
reg.technologie_fixed = lm(delta_log~.+T:group,cours_data[cours_data$secteur=="technologie",c("delta_log","group","T",paste0("f_",ets_index))])
reg.automobile_fixed = lm(delta_log~.+T:group,cours_data[cours_data$secteur=="automobile",c("delta_log","group","T",paste0("f_",ets_index))])

stargazer(reg.textile,reg.technologie,reg.automobile,reg.textile_fixed,reg.technologie_fixed,reg.automobile_fixed,
          out="exports/log/regression_par_secteur.tex",table.placement = "h",
          digits = 3,
          summary = FALSE,
          column.labels= rep(c(unique(cours_data$secteur)),2),
          omit="f_*",
          covariate.labels = c("Traitement","Apres Publication","Impact"),
          dep.var.labels = "Delta log (cours boursier)",
          #type="text",
          add.lines = list(c("Effets fixes", rep(c("NON","OUI"),each=3)) ),
          dep.var.caption = "Variable dépendante",
          keep.stat = "n",
          title = "Diff in Diff du Delta log des cours boursiers")

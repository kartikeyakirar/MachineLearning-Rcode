require("multiplot.R")
require("authentication.R")
require("sentiments_score.R")
library(ggplot2)
#path where you kept all dictionary word
path<-"/home/kartikeya/MachineLearning-Rcode/"



posfile<-paste(path,"positive_words.txt",sep="")
negfile<-paste(path,"negative_words.txt",sep="")
pos = readLines(posText)
neg = readLines(negText)

bjp = searchTwitter("narendra modi", n=2000,lang="en")
aap = searchTwitter("kejriwal", n=2000,lang="en")
congress = searchTwitter("rahul gandhi", n=2000,lang="en")

totaltweets<-c(length(bjp),length(aap),length(congress))
content<-c(bjp,aap,congress)
allcontents<-sapply(content,function(x) x$getText())
allcontents=str_replace_all(allcontents,"[^[:graph:]]", " ")
scores$phones = factor(rep(c("iPhone", "Nexus6", "Samsung"), totaltweets))
scores$very.pos = as.numeric(scores$score >= 2)
scores$very.neg = as.numeric(scores$score <= -2)

numpos = sum(scores$very.pos)
numneg = sum(scores$very.neg)

global_score = round( 100 * numpos / (numpos + numneg) )

meanscore = tapply(scores$score, scores$phones, mean)
df = data.frame(phones=names(meanscore), meanscore=meanscore)
df$rank <- reorder(df$phones, df$meanscore)

g1<- ggplot(df, aes(y=meanscore)) +
  geom_bar(data=df, aes(x=phones, fill=phones),stat = "identity") +
  ggtitle("Average Sentiment Score")

phone_pos = ddply(scores, .(phones), summarise, mean_pos=mean(very.pos))
phone_pos$phones <- reorder(phone_pos$phones, phone_pos$mean_pos)

g2<- ggplot(phone_pos, aes(y=mean_pos)) +
  geom_bar(data=phone_pos, aes(x=phones, fill=phones),stat = "identity") +
  ggtitle("Average Very Positive Sentiment Score")

phone_neg = ddply(scores, .(phones), summarise, mean_neg=mean(very.neg))
phone_neg$phones <- reorder(phone_neg$phones, phone_neg$mean_neg)

g3<- ggplot(phone_neg, aes(y=mean_neg)) +
  geom_bar(data=phone_neg, aes(x=phones, fill=phones),stat = "identity") +
  ggtitle("Average Very Negative Sentiment Score")


multiplot(g1, g2, g3, cols=2)



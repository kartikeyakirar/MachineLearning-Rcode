source("multiplot.R")
source("authentication.R")
source("sentiments_score.R")
library(ggplot2)
#path where you kept all dictionary word
path<-"/home/kartikeya/MachineLearning-Rcode/twitter_sentiments/"



posfile<-paste(path,"positive_words.txt",sep="")
negfile<-paste(path,"negative_words.txt",sep="")
pos = readLines(posfile)
neg = readLines(negfile)

bjp = searchTwitter("narendra modi", n=100,lang="en")
aap = searchTwitter("kejriwal", n=100,lang="en")
congress = searchTwitter("rahul gandhi", n=100,lang="en")

totaltweets<-c(length(bjp),length(aap),length(congress))
content<-c(bjp,aap,congress)
allcontents<-sapply(content,function(x) x$getText())
allcontents=str_replace_all(allcontents,"[^[:graph:]]", " ")
scores =sentiments_score(allcontents, pos, neg)
scores$party = factor(rep(c("bjp", "aap", "congress"), totaltweets))
scores$very.pos = as.numeric(scores$score >= 2)
scores$very.neg = as.numeric(scores$score <= -2)

numpos = sum(scores$very.pos)
numneg = sum(scores$very.neg)

global_score = round( 100 * numpos / (numpos + numneg) )

meanscore = tapply(scores$score, scores$party, mean)
df = data.frame(party=names(meanscore), meanscore=meanscore)
df$rank <- reorder(df$party, df$meanscore)

g1<- ggplot(df, aes(y=meanscore)) +
  geom_bar(data=df, aes(x=party, fill=party),stat = "identity") +
  ggtitle("Average Sentiment Score")

phone_pos = ddply(scores, .(party), summarise, mean_pos=mean(very.pos))
phone_pos$party <- reorder(phone_pos$party, phone_pos$mean_pos)

g2<- ggplot(phone_pos, aes(y=mean_pos)) +
  geom_bar(data=phone_pos, aes(x=party, fill=party),stat = "identity") +
  ggtitle("Average Very Positive Sentiment Score")

phone_neg = ddply(scores, .(party), summarise, mean_neg=mean(very.neg))
phone_neg$party <- reorder(phone_neg$party, phone_neg$mean_neg)

g3<- ggplot(phone_neg, aes(y=mean_neg)) +
  geom_bar(data=phone_neg, aes(x=party, fill=party),stat = "identity") +
  ggtitle("Average Very Negative Sentiment Score")


multiplot(g1, g2, g3, cols=2)



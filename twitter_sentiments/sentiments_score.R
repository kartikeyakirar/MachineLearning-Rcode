
sentiments_score<-function(sentances,pos.wrd,neg.wrd)
{
  require(plyr)
  require(stringr)
  scores =laply(sentances,function(sentance,pos.wrd,neg.wrd)
  {
    # remove all unwanted things
    remove<-c("[[:punct:]]","[[:cntrl:]]",'\\d+',"http\\w+","[\t]{2,}","^\\s+|\\s+$")
    for(i in remove)
    {
      sentance<-gsub(i,"",sentance)
    }
    tryLower<-function(sen)
    {
      y<-NA  
      err<-tryCatch(tolower(sen),error = function(e) e)
      if(!inherits(err , "error"))
        y<-tolower(sen)
      return(y)
    }
    sentance<-sapply(sentance,tryLower)
    word.list<-str_split(sentance,'\\s+')
    words<-unlist(word.list)
    pos.match<-!is.na(match(words,pos.wrd))
    neg.match<-!is.na(match(words,neg.wrd))
    score<-sum(pos.match)-sum(neg.match)
    return(score)
    
  },pos.wrd,neg.wrd)
  score.df<-data.frame(text=sentances,score= scores)
  return(score.df)
}
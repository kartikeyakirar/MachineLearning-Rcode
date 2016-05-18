#connection to twitter
library(twitteR)
library(ROAuth)
api_key <- "EE3DAAsLQy5tAYmdqCEvCDZxF"
api_secret <- "NHVBED6efdCCUa5pauADbMHw8EL6029O3kagoNac6vLR6Lu7K1"
access_token <- "89679943-EOccWIOKZsgbS46UCKklolUdts0mwfDdbXxleLfYI"
access_token_secret <- "wZWvbQAFrS6e7eFQ6X6DGl8WTUrizIHZ7GKTTbPTQrWzH"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

#for any app to execute any search query get global url of ur pc for callback url using ngrok in twitter 
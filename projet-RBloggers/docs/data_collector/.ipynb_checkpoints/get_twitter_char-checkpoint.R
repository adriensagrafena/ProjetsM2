### get_twitter_articles_cacrecteristcs
install.packages("twitteR")
library(twitteR)

# Twitter API CREDENTIALS
api_key = "0DC52d1f56m4boYmvWr1uakDg"
api_key_secret = "frE34eCGJ1wZT0xUJEhZzZAosGTfUJjZ7zgbcArskzOL2uIS5y"
a_token = "1460262472439545858-fb9ZOvbxYmlQIumzmJwC4LGedToWhT"
s_token = "wOVNrgzF0hFKONY4s0CSEFed85TgI8JvA9rMgSh6DyIAy"

setup_twitter_oauth(api_key, api_key_secret, a_token, s_token)

data = searchTwitter('Rbloggers', n = 200000, since = '2021-11-9', retryOnRateLimit = 1e3)
data = twListToDF(data)
dim(data)

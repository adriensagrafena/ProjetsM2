library(reticulate)
reticulate::py_install('pandas', pip = TRUE)
reticulate::py_install('facebook-scraper', pip = TRUE)
reticulate::py_config()



reticulate::py_run_string("
from facebook_scraper import get_posts
import pandas as pd
posts = []
for post in get_posts('rbloggers', pages=10000):
    print(post['post_text'])
    if post['post_text'] != 'Ditch p-values. Use Bootstrap confidence intervals instead':
        posts.append(post)
    else :
        break
df = pd.DataFrame(posts)[['post_text','time', 'timestamp', 'likes', 'comments', 'shares']]")

reticulate::py$df

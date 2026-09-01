import pandas as pd
import nltk
from nltk.sentiment.vader import SentimentIntensityAnalyzer

nltk.download('vader_lexicon')
df = pd.read_csv('clean_data/clean_customer_reviews.csv')
sia = SentimentIntensityAnalyzer()

def calculate_sentiment(review):
    sentiment = sia.polarity_scores(review)
    return sentiment['compound']

def categorize_sentiment(score, rating):
    if score > 0.05:
        if rating >= 4:
            return 'Positive'
        elif rating == 3:
            return 'Mixed Positive'
        else:
            return 'Mixed Negative'
    elif score < -0.05:
        if rating <= 2:
            return 'Negative'
        elif rating == 3:
            return 'Mixed Negative'
        else:
            return 'Mixed Positive'
    else:
        if rating >= 4:
            return 'Positive'
        elif rating <= 2:
            return 'Negative'
        else:
            return 'Neutral'

def sentiment_bucket(score):
    if score >= 0.5:
        return '0.5 to 1.0'
    elif 0.0 <= score < 0.5:
        return '0.0 to 0.49'
    elif -0.5 <= score < 0.0:
        return '-0.49 to 0.0'
    else:
        return '-1.0 to -0.5'

df['sentiment_score'] = df['comment'].apply(calculate_sentiment)
df['sentiment_bucket'] = df['sentiment_score'].apply(sentiment_bucket)
df['sentiment_category'] = df.apply(lambda row: categorize_sentiment(row['sentiment_score'],row['rating']), axis=1)

df.to_csv('clean_data/clean_customer_reviews_sentiment.csv', index=False)


import re
import string
from wordcloud import WordCloud
import nltk as nl

EXCLUDE_CHARS = string.digits + string.punctuation + string.whitespace + '—…'
STOPWORDS = nl.corpus.stopwords.words("russian") + ['ецп', 'проект', 'пао', 'оао', 'иус', 'должны', 'данных', 'газпром']


def prepare_text(text: str) -> str:
    new_text = ''.join([ch if ch not in EXCLUDE_CHARS else ' ' for ch in text.lower()])
    new_text = re.sub(r'\s+', ' ', new_text)
    text_tokens = nl.word_tokenize(new_text)
    tokens_without_sw = [word for word in text_tokens if word not in STOPWORDS]
    return " ".join(tokens_without_sw)


def generate_wordcloud(text: str) -> WordCloud:
    cleared_text = prepare_text(text)
    wordcloud = WordCloud(width=1024, height=400, max_words=70, background_color='white', random_state=17)
    wordcloud.generate(cleared_text)
    return wordcloud

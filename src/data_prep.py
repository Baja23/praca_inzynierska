from datasets import load_dataset
import os
from dotenv import load_dotenv
from pyspark.sql import functions as F
import spacy


class DataPrep:
    def __init__(self, corpus: str, language: str, token: str):
        # Zapisujemy parametry wewnątrz obiektu jako tzw. atrybuty klasy
        self.corpus = corpus
        self.language = language
        self.token = token

    def load_dataset_from_huggingface(self):
        dataset = load_dataset(self.corpus, token=self.token, language=self.language, streaming=True)
        return dataset

    def split_into_sentence(self, df):
        # Funkcja do dzielenia tekstu na zdania
        return df.withColumn("sentences", F.split(F.col("text"), r"(?<=[.!?])\s+"))

class SpacyTokenizer:
    def __init__(self, language: str):
        self.language = language
        self.nlp = spacy.load(language)

    def tokenize(self, text: str):
        doc = self.nlp(text)
        return [token.text for token in doc]

def main():
    load_dotenv()
    auth_token = os.getenv("HF_TOKEN")
    data_prep = DataPrep("oscar-corpus/mOSCAR", auth_token, "es")
    dataset = data_prep.load_dataset_from_huggingface()
    
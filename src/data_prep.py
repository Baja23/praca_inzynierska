from datasets import load_dataset
import os
from dotenv import load_dotenv
from pyspark.sql import functions as F
import spacy


class DataPrep:
    def __init__(self, corpus: str, language: str, token: str):
        self.corpus = corpus
        self.language = language
        self.token = token

    def load_dataset_from_huggingface(self):
        dataset = load_dataset(self.corpus, token=self.token, name=self.language, streaming=True)
        return dataset

    def split_into_sentence(self, df):
        # Funkcja do dzielenia tekstu na zdania
        return df.withColumn("sentences", F.split(F.col("text"), r"(?<=[.!?])\s+"))

class SpacyTokenizer:
    def __init__(self, language: str):
        self.language = language
        self.nlp = spacy.load(language)

    def initialize_doc(self, text: str):
        doc = self.nlp(text)
        return doc
    
    def tokenize(self, doc):
        tokens = [token.text for token in doc]
        yield tokens
    
    def tag_tokens(self, doc):
        tags = [token.pos_ for token in doc]
        yield tags
    
    def parse_dependencies(self, doc):
        dependencies = [token.dep_ for token in doc]
        yield dependencies
    
    def lemmatize_tokens(self, doc):
        lemmas = [token.lemma_ for token in doc]
        yield lemmas
    
    def extract_named_entities(self, doc):
        entities = [(ent.text, ent.label_) for ent in doc.ents]
        yield entities


def main():
    load_dotenv()
    auth_token = os.getenv("HF_TOKEN")
    try:
        data_prep = DataPrep("oscar-corpus/mOSCAR", 'spa_Latn', auth_token)
        dataset = data_prep.load_dataset_from_huggingface()
        print("Dataset loaded successfully.")
    except Exception as e:
        print(f"Error occurred: {e}")
    
if __name__ == "__main__":
    main()
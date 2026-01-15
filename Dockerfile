# 1. ZMIANA KLUCZOWA: Używamy konkretnej wersji systemu (Bullseye), a nie ogólnego "slim".
# Dzięki temu mamy pewność, jakie pakiety są w środku.
FROM python:3.10-slim-bullseye

LABEL maintainer="Student"

# 2. Zmienne środowiskowe dla Javy 11 (Bullseye standardowo ma Javę 11)
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH
ENV PYTHONUNBUFFERED=1

# 3. Instalacja Javy 11
# Dodajemy folder man, bo slim-bullseye ma błąd, który czasem przerywa instalację Javy bez tego folderu
RUN mkdir -p /usr/share/man/man1 && \
    apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
    openjdk-11-jdk-headless \
    procps \
    curl \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# 4. Pobranie modelu spaCy
RUN python -m spacy download es_core_news_md

# 5. Start
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--no-browser"]
FROM continuumio/miniconda3

LABEL maintainer="Student"

# 1. Instalacja narzędzi systemowych
# Dodalem 'git' - przyda sie do instalacji paczek z GitHuba
# Dodalem 'curl' - czasem potrzebny do pobierania danych
RUN apt-get update && apt-get install -y \
    procps \
    build-essential \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 2. Konfiguracja Condy na 'libmamba' (Przyspieszenie budowania)
# To sprawia, że rozwiązywanie zależności trwa sekundy zamiast minut
RUN conda config --set solver libmamba

# 3. Kopiujemy plik środowiska
COPY environment.yml .

# 4. Aktualizacja środowiska 'base'
# Flaga --prune usuwa stare pakiety, które nie są już potrzebne
RUN conda env update -n base -f environment.yml --prune && \
    conda clean -afy

# 5. Ustawienie JAVA_HOME
# Dla środowiska 'base' w minicondzie to jest poprawna ścieżka
ENV JAVA_HOME=/opt/conda
ENV PATH=$JAVA_HOME/bin:$PATH

# 6. Pobranie modelu spaCy
# Upewniamy się, że python widzi zainstalowane biblioteki
RUN python -m spacy download es_core_news_md

# 7. Start JupyterLab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--no-browser"]

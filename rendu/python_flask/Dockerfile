# Utilise une image officielle de Python
FROM python:3.11-slim

# Variables d'environnement pour éviter les prompts
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Crée et entre dans le dossier d’application
WORKDIR /app

# Copie les fichiers dans le container
COPY . /app

# Installe pip et dépendances Flask + PyMongo
RUN pip install --no-cache-dir flask pymongo

# Expose le port de Flask
EXPOSE 5000

# Lancement de l'app Flask
CMD ["python", "main.py"]

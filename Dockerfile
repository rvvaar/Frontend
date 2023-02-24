# Użyj obrazu bazowego Pythona 3.8
FROM python:3.8-slim-buster

# Ustaw katalog domowy na /app
WORKDIR /app

# Kopiuj plik requirements.txt do kontenera
COPY requirements.txt .

# Uruchom komendę
RUN pip install -r requirements.txt

# Kopiuj całą zawartość obecnego folderu do kontenera
COPY . .

# Przekieruj port na 5000
EXPOSE 5000

#Wykonaj komendę:
CMD ["python", "app.py"]
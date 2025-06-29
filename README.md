# FibroTrack – aplikacja do monitorowania bólu

**FibroTrack** to mobilna aplikacja napisana w Flutterze, która wspiera osoby zmagające się z fibromialgią oraz innymi przewlekłymi bólami. Umożliwia prowadzenie dziennika bólu, analizę objawów i dzielenie się doświadczeniami z innymi użytkownikami.

## 📲 Funkcje

- 🔐 Logowanie / rejestracja użytkownika
- ➕ Dodawanie wpisu:
    - Lokalizacja bólu (z sublokalizacjami, np. "Ręka → Prawa")
    - Charakter bólu (wybór z listy lub własne)
    - Skala bólu (0–10)
    - Notatka
    - Data wystąpienia
    - Możliwość anonimowego udostępnienia wpisu
- ✏️ Edycja i usuwanie wpisów
- 📅 Przegląd wpisów 
- 📤 Ekran z udostępnionymi wpisami (shared entries)
    - Możliwość usunięcia własnych wpisów z tej listy

    
- 📊 Planowana funkcjonalność: generowanie wykresów i analiz statystycznych

## 🛠️ Technologie

- Flutter + Dart
- Firebase Authentication
- Cloud Firestore


Każdy wpis zawiera m.in.:

- `pain_location` – np. `"Ręka_Prawa"` lub `"Inna lokalizacja"`
- `pain_character` – np. `"Tępy"` lub `"Inny opis"`
- `pain_intensity` – liczba 0–10
- `note` – notatka tekstowa
- `date` – ISO string daty
- `share` – `true/false`
- `created_at`, `updated_at` – timestamp



## 📸 Zrzuty ekranu

### 🔐 Logowanie
<p align="center">
  <img src="assets/screenshots/logowanie.jpg" width="300"/>
</p>

### 📋 Menu główne
<p align="center">
  <img src="assets/screenshots/menu.jpg" width="300"/>
</p>

### ➕ Dodawanie wpisu
<p align="center">
  <img src="assets/screenshots/dodawanie.jpg" width="300"/>
</p>

### 📅 Kalendarz
<p align="center">
  <img src="assets/screenshots/kalendarz.jpg" width="300"/>
</p>

### 📊 Statystyki
<p align="center">
  <img src="assets/screenshots/statystyki.jpg" width="300"/>
</p>


## ✨ Autor

Mateusz Szygulski
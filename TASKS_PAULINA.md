# Zadania - Database & Cycle Lead (Paulina)

**Projekt:** Mira Smart Ring App
**Obszar:** Baza danych, cykl menstruacyjny, eksport danych
**Sprint:** 4 tygodnie (14 gru 2025 - 11 sty 2026)

---

## Przegląd Zadań

| ID | Zadanie | Tydzień | Priorytet | Estymacja |
|----|---------|---------|-----------|-----------|
| P1 | Implementacja bazy SQLite z szyfrowaniem | 1 | KRYTYCZNY | 12h |
| P2 | Schemat bazy i migracje | 1 | KRYTYCZNY | 6h |
| P3 | Migracja danych mock do prawdziwej bazy | 1 | KRYTYCZNY | 4h |
| P4 | Model danych dla objawów | 2 | WYSOKI | 4h |
| P5 | Ekran logowania objawów | 2 | WYSOKI | 8h |
| P6 | Logowanie miesiączki z persystencją | 2 | WYSOKI | 6h |
| P7 | Analiza historii cyklu | 3 | WYSOKI | 8h |
| P8 | Wyświetlanie okna płodności | 3 | WYSOKI | 6h |
| P9 | Eksport danych do CSV | 4 | WYSOKI | 8h |
| P10 | UI pewności predykcji | 4 | ŚREDNI | 4h |

**Łączny szacowany czas:** 66h (~16.5h/tydzień)

---

## P1: Implementacja Bazy Danych SQLite z Szyfrowaniem

### User Story
```
JAKO użytkowniczka aplikacji Mira
CHCĘ aby moje dane zdrowotne były zapisywane trwale na urządzeniu
PO TO ŻEBY nie tracić historii śledzenia po ponownym uruchomieniu aplikacji
```

### Kontekst Biznesowy
Dane zdrowotne są wrażliwe i muszą być:
- Przechowywane lokalnie (prywatność)
- Zaszyfrowane (bezpieczeństwo)
- Dostępne offline (użyteczność)
- Trwałe między sesjami (niezawodność)

### Kryteria Akceptacji
- [ ] Aplikacja używa bazy SQLite zamiast danych w pamięci (mock)
- [ ] Plik bazy danych jest zaszyfrowany algorytmem AES-256
- [ ] Klucz szyfrowania jest przechowywany bezpiecznie w keychain urządzenia
- [ ] Istniejąca struktura mock danych jest zachowana (kompatybilność wsteczna)
- [ ] Baza danych jest tworzona przy pierwszym uruchomieniu aplikacji
- [ ] Aplikacja obsługuje błędy bazy gracefully (pokazuje przyjazny komunikat)
- [ ] Operacje na bazie nie blokują UI (są asynchroniczne)

### Wymagania Techniczne
**Paczki do dodania:**
- `sqflite` lub `sqflite_sqlcipher` - lokalna baza SQLite
- `path` - zarządzanie ścieżkami plików
- `flutter_secure_storage` - bezpieczne przechowywanie klucza

**Wzorce do zastosowania:**
- Singleton pattern dla helpera bazy danych
- Async/await dla wszystkich operacji
- Try-catch dla obsługi błędów

### Scenariusze Testowe

| ID | Scenariusz | Kroki | Oczekiwany Rezultat |
|----|------------|-------|---------------------|
| P1-T1 | Pierwsze uruchomienie | 1. Zainstaluj aplikację 2. Uruchom ją pierwszy raz | Plik bazy utworzony w katalogu aplikacji |
| P1-T2 | Persystencja danych | 1. Zapisz metryki zdrowia 2. Zamknij aplikację 3. Otwórz ponownie | Dane są nadal dostępne |
| P1-T3 | Przerwanie zapisu | 1. Rozpocznij zapis 2. Zabij aplikację w trakcie | Brak uszkodzenia danych, częściowy zapis cofnięty |
| P1-T4 | Wydajność | 1. Zapytaj o 1 rok danych | Czas odpowiedzi < 500ms |
| P1-T5 | Reinstalacja | 1. Odinstaluj aplikację 2. Zainstaluj ponownie | Baza i dane zostały usunięte |

### Wskazówki Implementacyjne
1. Przestudiuj dokumentację `sqflite` na pub.dev
2. Zobacz jak działają inne aplikacje z lokalnymi bazami (np. Hive, Drift)
3. Klucz szyfrowania generuj losowo przy pierwszym uruchomieniu
4. Nie loguj zawartości bazy do konsoli (wrażliwe dane!)

### Pliki do Utworzenia/Modyfikacji
- **UTWÓRZ:** `lib/services/database_helper.dart`
- **MODYFIKUJ:** `lib/services/database_service.dart`
- **MODYFIKUJ:** `pubspec.yaml`

### Zależności
- Brak (pierwsze zadanie)

---

## P2: Schemat Bazy Danych i Migracje

### User Story
```
JAKO deweloperka
CHCĘ dobrze zaprojektowany schemat bazy z kontrolą wersji
PO TO ŻEBY bezpiecznie aktualizować strukturę bazy w przyszłych wersjach
```

### Kontekst Biznesowy
Aplikacja będzie się rozwijać i schemat bazy będzie się zmieniał. System migracji pozwala:
- Aktualizować strukturę bez utraty danych użytkowników
- Dodawać nowe pola i tabele w kolejnych wersjach
- Cofać zmiany w razie problemów

### Kryteria Akceptacji
- [ ] Wszystkie tabele utworzone z odpowiednimi typami danych
- [ ] Zdefiniowane klucze główne i obce
- [ ] Indeksy na często odpytywanych kolumnach (data)
- [ ] System migracji obsługuje aktualizacje wersji
- [ ] Schemat udokumentowany w komentarzach kodu

### Wymagane Tabele

**1. user_profile** - ustawienia użytkownika
- id (INTEGER, klucz główny, zawsze = 1 - singleton)
- average_cycle_length (INTEGER, domyślnie 28)
- last_period_start (TEXT, format ISO 8601)
- created_at (TEXT, timestamp utworzenia)
- updated_at (TEXT, timestamp aktualizacji)

**2. health_metrics** - dzienne metryki zdrowotne
- id (INTEGER, klucz główny, auto increment)
- date (TEXT, unikalna, format YYYY-MM-DD)
- step_count (INTEGER, może być null)
- basal_temperature (REAL, może być null)
- hrv (REAL, może być null)
- resting_heart_rate (INTEGER, może być null)
- sleep_hours (REAL, może być null)
- sleep_quality (INTEGER, walidacja 1-5)
- readiness_score (INTEGER, walidacja 0-100)
- created_at (TEXT)

**3. cycle_events** - wydarzenia cyklu
- id (INTEGER, klucz główny)
- date (TEXT, format YYYY-MM-DD)
- event_type (TEXT, enum: 'period_start', 'period_end', 'ovulation_predicted', 'ovulation_confirmed', 'fertile_window')
- is_prediction (INTEGER, 0 lub 1)
- confidence (REAL, 0.0-1.0)
- notes (TEXT, opcjonalne)
- created_at (TEXT)

**4. symptoms** - objawy użytkownika
- id (INTEGER, klucz główny)
- date (TEXT)
- symptom_type (TEXT)
- category (TEXT, enum: 'physical', 'mood', 'other')
- intensity (INTEGER, walidacja 1-5)
- notes (TEXT, opcjonalne)
- created_at (TEXT)

**5. calendar_notes** - notatki kalendarza
- id (INTEGER, klucz główny)
- date (TEXT)
- title (TEXT, wymagane)
- description (TEXT, opcjonalne)
- created_at (TEXT)

**6. sync_history** - historia synchronizacji z pierścionkiem
- id (INTEGER, klucz główny)
- sync_start (TEXT, timestamp)
- sync_end (TEXT, może być null jeśli w trakcie)
- records_synced (INTEGER, domyślnie 0)
- status (TEXT, enum: 'in_progress', 'completed', 'failed')
- error_message (TEXT, opcjonalne)

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| P2-T1 | Świeża instalacja | Wszystkie tabele utworzone poprawnie |
| P2-T2 | Aktualizacja z v1 do v2 | Migracja wykonana, dane zachowane |
| P2-T3 | Duplikat daty w health_metrics | Błąd constraint UNIQUE obsłużony |
| P2-T4 | Nieprawidłowa intensywność objawu (6) | Constraint CHECK zapobiega wstawieniu |
| P2-T5 | Wstawianie z brakującymi wymaganymi polami | Odpowiedni błąd zwrócony |

### Wskazówki
1. Używaj TEXT dla dat w formacie ISO 8601 (łatwiejsze sortowanie i porównywanie)
2. Dodaj indeksy na kolumnach `date` - będą najczęściej odpytywane
3. CHECK constraints walidują dane na poziomie bazy
4. Migracje testuj na kopii istniejącej bazy

### Zależności
- P1 (Database Helper)

---

## P3: Migracja Danych Mock do Prawdziwej Bazy

### User Story
```
JAKO użytkowniczka aktualizująca z wersji mock
CHCĘ aby aplikacja działała z nową bazą danych
PO TO ŻEBY mieć płynne przejście bez zauważalnych zmian
```

### Kryteria Akceptacji
- [ ] `DatabaseService` używa prawdziwej bazy zamiast list w pamięci
- [ ] Wszystkie istniejące metody działają identycznie
- [ ] Dane mock można załadować do testów/demo
- [ ] Kod UI nie wymaga żadnych zmian (ten sam interfejs)

### Istniejące Metody do Zaimplementowania
Sprawdź aktualny `database_service.dart` i zaimplementuj wszystkie metody używając prawdziwej bazy:

**Metody kroków:**
- `getWeeklySteps()` - lista 7 dni
- `getTodaySteps()` - liczba kroków dzisiaj

**Metody HRV:**
- `getWeeklyHRV()` - lista 7 dni
- `getTodayHRV()` - HRV dzisiaj

**Metody ogólne:**
- `getHealthMetricsForDate(DateTime)` - wszystkie metryki dla dnia
- `getTodayCalories()` - kalorie (obliczone z kroków)
- `getTodayDistanceKm()` - dystans (obliczony z kroków)

**Metody wydarzeń:**
- `getUserEvents()` - wszystkie wydarzenia użytkownika
- `addUserEvent(Event)` - dodaj wydarzenie
- `deleteEvent(int id)` - usuń wydarzenie
- `getAllOvulationDays()` - wszystkie dni owulacji

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| P3-T1 | getWeeklySteps() | Zwraca listę 7 elementów z prawdziwej bazy |
| P3-T2 | Brak danych w bazie | Zwraca puste listy, nie crashuje |
| P3-T3 | Wywołanie z UI | Ekran aktywności wyświetla dane poprawnie |

### Zależności
- P1, P2

---

## P4: Model Danych dla Objawów (Symptom)

### User Story
```
JAKO użytkowniczka śledząca swoje zdrowie
CHCĘ logować różne objawy których doświadczam
PO TO ŻEBY identyfikować wzorce związane z moim cyklem
```

### Kontekst Biznesowy
Logowanie objawów pomaga użytkowniczkom:
- Zauważać powtarzające się wzorce (np. bóle głowy przed miesiączką)
- Komunikować się z lekarzem (historia objawów)
- Przewidywać trudne dni i planować odpowiednio

### Kryteria Akceptacji
- [] Klasa modelu Symptom z wszystkimi wymaganymi polami
- [] Predefiniowane typy objawów dostępne jako enum/stałe
- [ ] Wsparcie dla niestandardowych objawów
- [ ] Operacje CRUD w DatabaseService
- [ ] Objawy powiązane z konkretnymi datami

### Predefiniowane Objawy

**Kategoria: Fizyczne (physical)**
| ID | Angielski | Polski | Ikona |
|----|-----------|--------|-------|
| cramps | Cramps | Skurcze | zaproponuj |
| headache | Headache | Ból głowy | zaproponuj |
| bloating | Bloating | Wzdęcia | zaproponuj |
| breast_tenderness | Breast tenderness | Tkliwość piersi | zaproponuj |
| fatigue | Fatigue | Zmęczenie | zaproponuj |
| backache | Backache | Ból pleców | zaproponuj |
| nausea | Nausea | Nudności | zaproponuj |
| acne | Acne | Trądzik | zaproponuj |

**Kategoria: Nastrój (mood)**
| ID | Angielski | Polski | Ikona |
|----|-----------|--------|-------|
| happy | Happy | Szczęśliwa | zaproponuj |
| anxious | Anxious | Niespokojna | zaproponuj |
| irritable | Irritable | Rozdrażniona | zaproponuj |
| sad | Sad | Smutna | zaproponuj |
| calm | Calm | Spokojna | zaproponuj |
| energetic | Energetic | Energiczna | zaproponuj |
| sensitive | Sensitive | Wrażliwa | zaproponuj |

### Wymagane Pola Modelu

**Symptom:**
- id (int?, null dla nowych)
- date (DateTime)
- symptomType (String, id objawu)
- category (enum SymptomCategory)
- intensity (int, 1-5)
- notes (String?, opcjonalne)

**SymptomType (predefiniowany):**
- id (String)
- name (String, angielski)
- namePolish (String, polski)
- category (SymptomCategory)
- icon (String, emoji lub nazwa ikony)

### Metody DatabaseService do Dodania
- `addSymptom(Symptom)` - zwraca id
- `getSymptomsForDate(DateTime)` - lista objawów dla dnia
- `getSymptomsInRange(DateTime start, DateTime end)` - zakres dat
- `updateSymptom(Symptom)` - aktualizacja
- `deleteSymptom(int id)` - usunięcie

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| P4-T1 | Dodaj objaw z intensywnością 3 | Zapisany do bazy, id zwrócone |
| P4-T2 | Dodaj objaw z intensywnością 6 | Błąd walidacji |
| P4-T3 | Pobierz objawy dla daty | Zwraca poprawną listę |
| P4-T4 | Usuń objaw | Usunięty z bazy |
| P4-T5 | Objaw z notatką | Notatka zapisana i odczytana |

### Pliki do Utworzenia/Modyfikacji
- **UTWÓRZ:** `lib/models/symptom.dart`
- **MODYFIKUJ:** `lib/services/database_service.dart`

### Zależności
- P1, P2, P3

---

## P5: Ekran Logowania Objawów

### User Story
```
JAKO użytkowniczka
CHCĘ prosty interfejs do logowania codziennych objawów
PO TO ŻEBY szybko zapisywać jak się czuję bez pisania
```

### Kontekst Biznesowy
Interfejs musi być:
- Szybki (logowanie w < 30 sekund)
- Intuicyjny (bez instrukcji)
- Przyjemny wizualnie (zachęca do regularnego używania)

### Kryteria Akceptacji
- [ ] Ekran dostępny z ekranu głównego i kalendarza
- [ ] Siatka przycisków objawów (sekcje fizyczne i nastrój)
- [ ] Suwak intensywności (1-5) z wizualnym feedbackiem
- [ ] Opcjonalne pole notatek
- [ ] Pokazuje już zalogowane objawy dla wybranej daty
- [ ] Można edytować lub usuwać istniejące wpisy
- [ ] Design neumorphic spójny z resztą aplikacji

### Wymagane Elementy UI
- Nagłówek z datą i nawigacją wstecz
- Sekcja "Fizyczne" - siatka przycisków objawów (8 elementów)
- Sekcja "Nastrój" - siatka przycisków emocji (7 elementów)
- Suwak intensywności (1-5) z wizualnym feedbackiem
- Pole tekstowe na opcjonalne notatki
- Przycisk "Zapisz objaw"
- Lista dzisiejszych objawów z możliwością usunięcia (swipe)

### Logika Ekranu

**Stan ekranu:**
- selectedSymptom (String?) - aktualnie wybrany objaw
- selectedCategory (SymptomCategory?) - kategoria wybranego
- intensity (int) - wartość suwaka, domyślnie 3
- notes (String) - tekst notatki
- todaySymptoms (List<Symptom>) - zalogowane objawy

**Przepływ:**
1. Użytkownik dotyka przycisku objawu → zaznacza się
2. Opcjonalnie przesuwa suwak intensywności
3. Opcjonalnie wpisuje notatkę
4. Klika "Zapisz objaw"
5. Objaw pojawia się na liście poniżej
6. Formularz się czyści

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| P5-T1 | Dotknij przycisk objawu | Przycisk wizualnie zaznaczony |
| P5-T2 | Przesuń suwak intensywności | Wartość się aktualizuje (1-5) |
| P5-T3 | Zapisz bez wyboru objawu | Pokazuje komunikat walidacji |
| P5-T4 | Zapisz poprawny objaw | Dodany do listy, formularz wyczyszczony |
| P5-T5 | Swipe na objawach do usunięcia | Objaw usunięty |
| P5-T6 | Zmień datę | Ładuje objawy dla nowej daty |

### Pliki do Utworzenia
- `lib/ekrany/symptoms/symptom_logging_screen.dart`
- `lib/ekrany/symptoms/widgets/symptom_button.dart`
- `lib/ekrany/symptoms/widgets/intensity_slider.dart`

### Zależności
- P4 (Model Symptom)

---

## P6: Logowanie Miesiączki z Persystencją

### User Story
```
JAKO użytkowniczka śledząca mój cykl menstruacyjny
CHCĘ logować kiedy zaczyna się i kończy moja miesiączka
PO TO ŻEBY aplikacja mogła nauczyć się moich wzorców i robić dokładne predykcje
```

### Kontekst Biznesowy
Logowanie miesiączki to kluczowa funkcja aplikacji:
- Podstawa do wszystkich predykcji cyklu
- Dane do obliczania średniej długości cyklu
- Historyczny zapis dla użytkowniczki i lekarza

### Kryteria Akceptacji
- [ ] Szybki przycisk "Miesiączka zaczęła się dziś" na ekranie głównym
- [ ] Można oznaczyć początek/koniec miesiączki na dowolnej dacie w kalendarzu
- [ ] Dni miesiączki wizualnie wyróżnione w kalendarzu
- [ ] Dane zapisywane natychmiast do bazy
- [ ] Można edytować wcześniejsze wpisy
- [ ] Automatyczne obliczanie długości cyklu

### Logika Biznesowa

**Obliczanie długości cyklu:**
```
Długość cyklu = Data rozpoczęcia obecnego cyklu - Data rozpoczęcia poprzedniego cyklu
```

**Obliczanie średniej długości (na podstawie ostatnich 6 cykli):**
```
Średnia = Suma długości 6 ostatnich cykli / 6
```

### Metody DatabaseService do Dodania
- `logPeriodStart(DateTime)` - zapisuje początek
- `logPeriodEnd(DateTime)` - zapisuje koniec
- `getPeriodDays(DateTime start, DateTime end)` - lista dni miesiączki w zakresie
- `calculateAverageCycleLength()` - średnia z ostatnich cykli
- `getLastPeriodStart()` - ostatni początek miesiączki

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| P6-T1 | Kliknij "Miesiączka dziś" | Zapisane jako period_start |
| P6-T2 | Zaznacz dzień jako koniec | Zapisane jako period_end |
| P6-T3 | Pokaż kalendarz | Dni miesiączki mają inny kolor |
| P6-T4 | 2 cykle zapisane | Średnia obliczona z 2 cykli |
| P6-T5 | Edytuj datę początkową | Stary wpis usunięty, nowy dodany |

### Zależności
- P1, P2, P3

---

## P7: Analiza Historii Cyklu

### User Story
```
JAKO użytkowniczka
CHCĘ widzieć analizę mojej historii cyklu
PO TO ŻEBY rozumieć moje wzorce i wykrywać nieregularności
```

### Kontekst Biznesowy
Analiza cyklu pomaga użytkowniczkom:
- Zrozumieć czy ich cykle są regularne
- Zauważyć niepokojące zmiany
- Dzielić się danymi z lekarzem

### Kryteria Akceptacji
- [ ] Pokazuje średnią długość cyklu
- [ ] Pokazuje zmienność cyklu (min, max, odchylenie standardowe)
- [ ] Lista ostatnich 6 cykli z długościami
- [ ] Wyróżnia nieregularne cykle (>7 dni od średniej)
- [ ] Pokazuje średnią długość miesiączki
- [ ] Wykres wizualizujący długości cykli w czasie

### Dane do Wyświetlenia

**CycleAnalysis:**
- averageCycleLength (int) - średnia długość
- shortestCycle (int) - najkrótszy
- longestCycle (int) - najdłuższy
- standardDeviation (double) - odchylenie standardowe
- averagePeriodLength (int) - średnia długość miesiączki
- recentCycles (List<CycleRecord>) - ostatnie cykle
- isRegular (bool) - czy regularne (SD < 3 dni)

**CycleRecord:**
- startDate (DateTime)
- endDate (DateTime?)
- cycleLength (int)
- periodLength (int)
- isIrregular (bool)

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| P7-T1 | Mniej niż 2 cykle | Komunikat "Za mało danych" |
| P7-T2 | 6 regularnych cykli | isRegular = true |
| P7-T3 | Cykl 35 dni przy średniej 28 | Oznaczony jako nieregularny |
| P7-T4 | Wykres 12 miesięcy | Pokazuje wszystkie cykle |

### Zależności
- P6

---

## P8: Wyświetlanie Okna Płodności

### User Story
```
JAKO użytkowniczka planująca ciążę (lub jej unikająca)
CHCĘ widzieć moje przewidywane okno płodności na kalendarzu
PO TO ŻEBY móc podejmować świadome decyzje dotyczące planowania rodziny
```

### Kontekst Biznesowy
**WAŻNE:** Ta funkcja wymaga wyraźnego disclaimera prawnego!
- "Tylko do celów informacyjnych"
- "Nie jest metodą antykoncepcji"
- "Skonsultuj się z lekarzem"

### Kryteria Akceptacji
- [ ] Okno płodności (5 dni) wyróżnione na kalendarzu
- [ ] Dzień szczytowej płodności oznaczony wyraźnie
- [ ] Bazuje na predykcji owulacji (14 dni przed następną miesiączką)
- [ ] Wyświetlany wskaźnik pewności
- [ ] Wyraźny disclaimer: "Tylko do celów informacyjnych"
- [ ] Inny kolor niż dni miesiączki

### Logika Obliczania Płodności

```
Predykcja owulacji:
  owulacja = ostatnia_miesiączka + długość_cyklu - 14

Okno płodności (6 dni łącznie):
  - 5 dni przed owulacją
  - dzień owulacji (szczyt)
```

### Kodowanie Kolorów w Kalendarzu
- Dni miesiączki: różowy
- Okno płodności: jasnozielony
- Dzień owulacji: zielony (ciemniejszy)
- Zwykłe dni: bez koloru

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| P8-T1 | Otwórz kalendarz | Okno płodności widoczne |
| P8-T2 | Dotknij dzień płodny | Pokazuje tooltip z info |
| P8-T3 | Brak historii cyklu | Okno nie pokazane |
| P8-T4 | Nieregularny cykl | Niższa pewność wyświetlona |

### Zależności
- P6, P7

---

## P9: Eksport Danych do CSV

### User Story
```
JAKO użytkowniczka troszcząca się o własność danych
CHCĘ wyeksportować wszystkie moje dane zdrowotne do pliku CSV
PO TO ŻEBY móc ich użyć gdzie indziej lub udostępnić lekarzowi
```

### Kontekst Biznesowy
Eksport danych to:
- Wymóg RODO (prawo do przenoszenia danych)
- Wartość dla użytkowniczki
- Buduje zaufanie do aplikacji

### Kryteria Akceptacji
- [ ] Przycisk eksportu w ekranie Ustawień
- [ ] Wybór zakresu dat (ostatni miesiąc, 3 miesiące, cały czas)
- [ ] Osobne sekcje CSV dla: metryki zdrowia, wydarzenia cyklu, objawy
- [ ] Lub jeden połączony plik CSV
- [ ] Eksport kończy się w < 10 sekund dla 1 roku danych
- [ ] Plik zapisany do folderu Downloads
- [ ] Share sheet otwiera się po eksporcie

### Format Pliku CSV

```csv
=== METRYKI ZDROWIA ===
Data,Kroki,Temperatura,HRV,Tętno,Sen (h),Gotowość
2025-12-01,8500,36.5,65,72,7.5,85
2025-12-02,10200,36.4,70,68,8.0,90

=== WYDARZENIA CYKLU ===
Data,Typ wydarzenia,Notatki
2025-11-28,period_start,
2025-12-02,period_end,
2025-12-12,ovulation_predicted,Pewność: 80%

=== OBJAWY ===
Data,Objaw,Kategoria,Intensywność,Notatki
2025-12-01,headache,physical,3,Po stresie w pracy
2025-12-01,anxious,mood,2,
```

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| P9-T1 | Eksport ostatniego miesiąca | Plik CSV utworzony poprawnie |
| P9-T2 | Brak danych | Plik z nagłówkami, bez wierszy |
| P9-T3 | Udostępnij plik | Share sheet się otwiera |
| P9-T4 | Otwórz w Excelu | Dane wyświetlone poprawnie |

### Pliki do Utworzenia
- `lib/services/export_service.dart`

### Zależności
- P1, P2, P3

---

## P10: UI Pewności Predykcji

### User Story
```
JAKO użytkowniczka
CHCĘ widzieć jak pewna jest aplikacja swoich predykcji
PO TO ŻEBY wiedzieć jak bardzo ufać szacunkom
```

### Kryteria Akceptacji
- [ ] Procent pewności pokazany przy predykcjach (np. "85% pewności")
- [ ] Wizualny wskaźnik (progress bar lub badge)
- [ ] Tooltip wyjaśniający co wpływa na pewność
- [ ] Pewność rośnie po zalogowaniu więcej cykli

### Logika Obliczania Pewności

```
Bazowa pewność: 50%

+ 10% za każdy zalogowany cykl (max +30%)
+ 20% jeśli cykle regularne (zmienność < 3 dni)
+ 10% jeśli cykle umiarkowanie regularne (zmienność < 5 dni)

Maksymalna pewność: 95% (nigdy 100%!)
```

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| P10-T1 | 0 cykli | Pewność ~50% |
| P10-T2 | 3 regularne cykle | Pewność ~80% |
| P10-T3 | Dotknij wskaźnik | Tooltip się pokazuje |

### Zależności
- P7, P8

---

## Harmonogram Tygodniowy

### Tydzień 1 (14-20 gru)
- P1: Baza SQLite z szyfrowaniem
- P2: Schemat i migracje
- P3: Migracja mock danych

### Tydzień 2 (21-27 gru)
- P4: Model objawów
- P5: Ekran logowania objawów
- P6: Logowanie miesiączki

### Tydzień 3 (28 gru - 3 sty)
- P7: Analiza historii cyklu
- P8: Okno płodności

### Tydzień 4 (4-11 sty)
- P9: Eksport CSV
- P10: UI pewności predykcji

---

## Zasoby do Nauki

### Dokumentacja
- [sqflite - pub.dev](https://pub.dev/packages/sqflite)
- [flutter_secure_storage - pub.dev](https://pub.dev/packages/flutter_secure_storage)
- [SQLite Tutorial](https://www.sqlitetutorial.net/)

### Wzorce
- Singleton Pattern w Dart
- Repository Pattern
- Async/Await w Flutter

### Wskazówki
1. Testuj na prawdziwym urządzeniu, nie tylko emulatorze
2. Loguj operacje bazy podczas development
3. Rób backup przed migracjami
4. Waliduj dane wejściowe przed zapisem

---

## Cechy Nowoczesnej Aplikacji dla GenZ (Privacy-First)

### Prywatność i Bezpieczeństwo (Kluczowe dla Database Lead)
- **Zero cloud** - wszystkie dane lokalnie na urządzeniu
- **Szyfrowanie end-to-end** - dane zaszyfrowane w bazie (AES-256)
- **Brak konta** - nie wymaga rejestracji ani logowania
- **Transparentność** - jasne komunikaty co aplikacja robi z danymi
- **Prawo do zapomnienia** - łatwe usunięcie wszystkich danych jednym kliknięciem
- **Eksport danych** - użytkownik jest właścicielem swoich danych (CSV export)
- **Secure key storage** - klucze w Keychain/Keystore, nie w kodzie

### Data Ownership
- **Full export** - wszystkie dane w formacie czytelnym dla człowieka
- **No lock-in** - dane można przenieść do innej aplikacji
- **Audit trail** - historia co i kiedy było zapisane (opcjonalnie)
- **Data minimization** - zbieraj tylko to co niezbędne

### Performance i Niezawodność
- **Offline-first** - pełna funkcjonalność bez internetu
- **Fast queries** - indeksy na często odpytywanych kolumnach
- **Graceful degradation** - obsługa błędów bez crashowania
- **Data integrity** - transakcje, rollback przy błędach

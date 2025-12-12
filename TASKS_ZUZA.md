# Zadania - UI/UX & Health Lead (Zuza)

**Projekt:** Mira Smart Ring App
**Obszar:** Interfejs użytkownika, metryki zdrowotne, onboarding
**Sprint:** 4 tygodnie (14 gru 2025 - 11 sty 2026)

---

## Przegląd Zadań

| ID | Zadanie | Tydzień | Priorytet | Estymacja |
|----|---------|---------|-----------|-----------|
| Z1 | Wykres trendów temperatury | 1 | WYSOKI | 8h |
| Z2 | Wizualizacja jakości snu | 1 | WYSOKI | 6h |
| Z3 | Projektowanie ekranów onboardingu | 2 | KRYTYCZNY | 6h |
| Z4 | Nawigacja w procesie onboardingu | 2 | KRYTYCZNY | 8h |
| Z5 | Ekran ustawień profilu | 2 | KRYTYCZNY | 6h |
| Z6 | Komponent dziennej gotowości (readiness) | 3 | WYSOKI | 8h |
| Z7 | Edukacyjne tooltips w aplikacji | 3 | ŚREDNI | 6h |
| Z8 | Kompletny ekran Ustawień | 4 | WYSOKI | 8h |
| Z9 | UI preferencji powiadomień | 4 | ŚREDNI | 4h |
| Z10 | Finalne polerowanie UI | 4 | ŚREDNI | 4h |

**Łączny szacowany czas:** 64h (~16h/tydzień)

---

## Wprowadzenie: Zasady UI/UX w Mira

### Design System Aplikacji

**Paleta kolorów (z core/theme.dart):**
| Nazwa | Hex | Użycie |
|-------|-----|--------|
| Primary (Pink) | #ECDFE7 | Tło główne, akcenty |
| Activity (Blue) | #409BC5 | Ekran aktywności |
| Health (Green) | #8DE38A | Ekran zdrowia |
| Cycle (Pink) | #ECA1CA | Ekran cyklu |

**Styl neumorphic:**
- Zaokrąglone rogi (16-24px)
- Delikatne cienie (soft shadows)
- Efekt "wypukłości" lub "wklęsłości"
- Spójny w całej aplikacji

**Typografia:**
- Nagłówki: Bold, 18-24px
- Tekst główny: Regular, 14-16px
- Etykiety: Light, 12px
- Polskie znaki muszą być obsługiwane!

### Responsywność
- Obsługuj różne rozmiary ekranów
- Używaj MediaQuery dla proporcjonalnych rozmiarów
- Testuj na małych i dużych telefonach

### Dostępność
- Minimalny rozmiar touch target: 48x48px
- Kontrast kolorów: min 4.5:1
- Obsługa czytników ekranu (Semantics)

---

## Z1: Wykres Trendów Temperatury

### User Story
```
JAKO użytkowniczka monitorująca moje zdrowie
CHCĘ widzieć trendy mojej temperatury ciała w czasie
PO TO ŻEBY identyfikować wzorce związane z moim cyklem i ogólnym zdrowiem
```

### Kontekst Biznesowy
Temperatura bazowa ciała (BBT) jest kluczowym wskaźnikiem:
- Wzrasta po owulacji (o ~0.2-0.5°C)
- Pomaga potwierdzić owulację
- Może wskazywać na chorobę lub ciążę

### Kryteria Akceptacji
- [ ] Wykres liniowy pokazujący ostatnie 30 dni BBT
- [ ] Oś Y w zakresie: 35.5°C - 38.0°C
- [ ] Wyróżniony zakres bazowy (średnia ± 0.2°C)
- [ ] Oznaczony skok temperatury przy owulacji (jeśli wykryty)
- [ ] Dotknięcie punktu danych pokazuje dokładną wartość i datę
- [ ] Opcja eksportu wykresu jako obrazu

### Wymagane Elementy UI Wykresu Temperatury
- Wykres liniowy (LineChart z fl_chart)
- Oś Y: zakres 35.5°C - 38.0°C, etykiety co 0.5°C
- Oś X: dni miesiąca, etykiety co 7 dni
- Główna linia: kolor różowy, krzywa (curved)
- Punkty danych: widoczne, możliwe do dotknięcia
- Obszar bazowy: podświetlony (średnia ± 0.2°C) jako shaded area
- Legenda: "Zakres bazowy", "Skok owulacyjny"
- Tooltip przy dotknięciu punktu: data + wartość

### Specyfikacja Techniczna

**Biblioteka:** fl_chart (już zainstalowana)

**Dane wejściowe:**
- Lista HealthMetrics z ostatnich 30 dni
- Pole basalTemperature (nullable double)

**Obliczenia:**
1. Średnia temperatura = suma wszystkich / liczba dni
2. Zakres bazowy = średnia ± 0.2°C
3. Skok owulacyjny = gdy temp wzrasta >0.3°C i utrzymuje się

**Elementy wykresu:**
- Główna linia: kolor różowy (#ECA1CA), krzywa
- Punkty danych: widoczne, możliwe do dotknięcia
- Obszar bazowy: jasnoniebieski z opacity 0.1
- Siatka: poziome linie co 0.5°C

### Interakcje
- Dotknięcie punktu: tooltip z datą i wartością
- Przesuwanie: scroll jeśli więcej danych
- Pinch-zoom: opcjonalne powiększanie

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| Z1-T1 | 30 dni danych | Wykres renderuje poprawnie |
| Z1-T2 | Brakujące dni | Linia przerywana lub luka |
| Z1-T3 | Dotknij punkt | Tooltip z 36.5°C, 5 gru |
| Z1-T4 | Brak danych | Komunikat "Brak danych" |
| Z1-T5 | Skok owulacyjny | Wyraźnie oznaczony |

### Pliki do Utworzenia
- `lib/ekrany/zdrowie/widgets/temperature_chart.dart`

### Zależności
- Paulina: P1 (Baza danych dla prawdziwych danych)

---

## Z2: Wizualizacja Jakości Snu

### User Story
```
JAKO użytkowniczka dbająca o swój sen
CHCĘ widzieć wizualizację mojej jakości snu
PO TO ŻEBY rozumieć moje wzorce snu i jak wpływają na moje samopoczucie
```

### Kontekst Biznesowy
Sen jest fundamentem zdrowia:
- Wpływa na nastrój i energię
- Powiązany z cyklem menstruacyjnym
- Kluczowy składnik "gotowości" (readiness)

### Kryteria Akceptacji
- [ ] Wykres słupkowy pokazujący godziny snu (7 dni)
- [ ] Wyświetlona ocena jakości snu (1-5 gwiazdek lub emoji)
- [ ] Kolorowe kodowanie: zielony (>7h), żółty (6-7h), czerwony (<6h)
- [ ] Średnia z tygodnia
- [ ] Cel snu (domyślnie 8h) jako linia referencyjna

### Wymagane Elementy UI Snu
- Nagłówek: "Sen - ten tydzień"
- Statystyki: średnia z tygodnia, cel snu
- Wykres słupkowy (BarChart): 7 słupków dla dni tygodnia
- Linia referencyjna: cel snu (np. 8h) jako pozioma linia
- Etykiety dni: Pn, Wt, Śr, Cz, Pt, So, Nd
- Sekcja jakości snu: ocena gwiazdkowa (1-5) + etykieta tekstowa
- Kolorowanie słupków według wartości (zielony/żółty/czerwony)

### Logika Kolorowania

```
Kolor słupka:
  >= 8h: Zielony (#8DE38A) - Doskonały
  7-8h:  Jasnozielony - Dobry
  6-7h:  Żółty (#FFC107) - Wystarczający
  < 6h:  Czerwony (#F44336) - Niewystarczający
```

### Ocena Jakości Snu (1-5)

| Ocena | Etykieta | Emoji |
|-------|----------|-------|
| 5 | Doskonała | 😴💯 |
| 4 | Dobra | 😊 |
| 3 | Przeciętna | 😐 |
| 2 | Słaba | 😕 |
| 1 | Bardzo słaba | 😫 |

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| Z2-T1 | 7 dni danych | 7 słupków widocznych |
| Z2-T2 | Sen 9h | Słupek zielony, powyżej celu |
| Z2-T3 | Sen 5h | Słupek czerwony |
| Z2-T4 | Brak danych dla dnia | Pusty slot lub szary |
| Z2-T5 | Jakość 5/5 | 5 gwiazdek, "Doskonała" |

### Pliki do Modyfikacji/Utworzenia
- `lib/ekrany/zdrowie/widgets/sleep_chart.dart`
- Modyfikuj `lib/ekrany/zdrowie.dart`

### Zależności
- Paulina: P1 (Baza danych)

---

## Z3: Projektowanie Ekranów Onboardingu

### User Story
```
JAKO nowa użytkowniczka
CHCĘ przejść przez przyjazny proces wprowadzenia
PO TO ŻEBY zrozumieć wartość aplikacji i skonfigurować ją dla siebie
```

### Kontekst Biznesowy
Onboarding to "pierwsze wrażenie":
- Decyduje czy użytkowniczka zostanie
- Komunikuje wartość aplikacji
- Zbiera niezbędne dane początkowe
- Buduje zaufanie (prywatność!)

### Kryteria Akceptacji
- [ ] 3 ekrany wprowadzające zaprojektowane
- [ ] Spójna estetyka z resztą aplikacji
- [ ] Animacje między ekranami
- [ ] Wskaźnik postępu (dots)
- [ ] Możliwość pominięcia dla powracających użytkowniczek

### Ekran 1: Powitanie

**Wymagane elementy:**
- Logo aplikacji (animowane wejście - fade in + scale)
- Nazwa "MIRA" z podtytułem "Twój inteligentny towarzysz cyklu zdrowia"
- 3 value propositions z ikonami checkmark
- Wskaźnik postępu (dots): ● ○ ○
- Przycisk CTA "Rozpocznij"

### Ekran 2: Prywatność

**Wymagane elementy:**
- Ikona tarczy/kłódki (bezpieczeństwo) - animowana
- Nagłówek "Twoja prywatność jest priorytetem"
- 3 karty z gwarancjami prywatności (każda z ikoną)
- Wskaźnik postępu: ○ ● ○
- Przycisk "Rozumiem"
- Link "Polityka prywatności" (otwiera w przeglądarce)

### Ekran 3: Konfiguracja Profilu

**Wymagane elementy:**
- Nagłówek "Skonfiguruj swój profil"
- Number picker: średnia długość cyklu (21-35 dni, domyślnie 28)
- Date picker: ostatnia miesiączka (z walidacją)
- Number picker: cel snu (5-10h, domyślnie 8)
- Helper text pod każdym polem (np. "typowo 21-35 dni")
- Wskaźnik postępu: ○ ○ ●
- Przycisk "Rozpocznij używanie"
- Tekst uspokajający: "Możesz zmienić to później"

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| Z3-T1 | Pierwsze uruchomienie | Onboarding się pokazuje |
| Z3-T2 | Swipe między ekranami | Płynna animacja |
| Z3-T3 | Dotknij dots | Przejście do odpowiedniego ekranu |
| Z3-T4 | Wybierz datę | Date picker się otwiera |
| Z3-T5 | "Rozpocznij używanie" | Zapisane dane, główny ekran |

### Pliki do Utworzenia
- `lib/ekrany/onboarding/onboarding_welcome.dart`
- `lib/ekrany/onboarding/onboarding_privacy.dart`
- `lib/ekrany/onboarding/onboarding_setup.dart`

### Zależności
- Brak

---

## Z4: Nawigacja w Procesie Onboardingu

### User Story
```
JAKO użytkowniczka
CHCĘ płynnie przechodzić między ekranami onboardingu
PO TO ŻEBY proces był intuicyjny i przyjemny
```

### Kryteria Akceptacji
- [ ] PageView z trzema ekranami
- [ ] Wskaźnik kropek (dots) na dole
- [ ] Gest swipe do nawigacji
- [ ] Przyciski "Dalej" / "Wstecz"
- [ ] Animacje przejść
- [ ] Zapisanie danych po zakończeniu

### Specyfikacja Nawigacji

**Kontroler:**
- PageController z physics do swipe
- Śledzenie aktualnej strony

**Wskaźnik kropek:**
- 3 kropki odpowiadające ekranom
- Aktywna: wypełniona głównym kolorem
- Nieaktywna: kontur lub szara

**Animacje:**
- Fade + slide między ekranami
- Czas trwania: 300ms
- Krzywa: easeInOut

### Logika Zapisu Danych

Po kliknięciu "Rozpocznij używanie":
1. Waliduj dane (długość cyklu, data)
2. Zapisz do SharedPreferences lub bazy:
   - average_cycle_length
   - last_period_start
   - sleep_goal
   - onboarding_completed = true
3. Nawiguj do głównego ekranu
4. Nigdy nie pokazuj onboardingu ponownie

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| Z4-T1 | Swipe w prawo | Przejście do następnego ekranu |
| Z4-T2 | Swipe w lewo | Przejście do poprzedniego ekranu |
| Z4-T3 | Kliknij dot | Przejście do odpowiedniego ekranu |
| Z4-T4 | Zakończ onboarding | Dane zapisane, główny ekran |
| Z4-T5 | Ponowne uruchomienie | Onboarding pominięty |

### Pliki do Utworzenia
- `lib/ekrany/onboarding/onboarding_screen.dart` (kontener)
- `lib/ekrany/onboarding/widgets/page_indicator.dart`

### Zależności
- Z3

---

## Z5: Ekran Ustawień Profilu Początkowego

### User Story
```
JAKO nowa użytkowniczka
CHCĘ wprowadzić podstawowe informacje o moim cyklu
PO TO ŻEBY aplikacja mogła zacząć robić predykcje
```

### Kryteria Akceptacji
- [ ] Input dla średniej długości cyklu
- [ ] Date picker dla ostatniej miesiączki
- [ ] Walidacja danych wejściowych
- [ ] Domyślne wartości (28 dni, brak daty)
- [ ] Przycisk "Pomiń" (opcjonalnie)
- [ ] Zapisanie do bazy danych

### Walidacja

**Długość cyklu:**
- Min: 21 dni
- Max: 35 dni
- Domyślnie: 28 dni
- Błąd: "Długość cyklu powinna być między 21 a 35 dni"

**Data ostatniej miesiączki:**
- Nie może być w przyszłości
- Nie starsza niż 60 dni
- Błąd: "Wybierz datę z ostatnich 60 dni"

### Komponenty UI

**Number Picker dla długości cyklu:**
```
    ◀  [28]  ▶
       dni
```
- Strzałki zmniejszają/zwiększają o 1
- Dotknięcie liczby otwiera klawiaturę

**Date Picker:**
- Calendar widget
- Domyślnie pokazuje bieżący miesiąc
- Dni w przyszłości nieaktywne

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| Z5-T1 | Wybierz 28 dni | Wartość zapisana |
| Z5-T2 | Wybierz 20 dni | Błąd walidacji |
| Z5-T3 | Wybierz jutro jako datę | Błąd walidacji |
| Z5-T4 | Wybierz poprawną datę | Data zapisana |
| Z5-T5 | Pomiń setup | Domyślne wartości użyte |

### Pliki do Modyfikacji
- `lib/ekrany/onboarding/onboarding_setup.dart`

### Zależności
- Z3, Z4, Paulina: P1 (baza danych)

---

## Z6: Komponent Dziennej Gotowości (Readiness Score)

### User Story
```
JAKO użytkowniczka
CHCĘ widzieć prosty wskaźnik mojej "gotowości" na dzień
PO TO ŻEBY wiedzieć jak planować aktywności i odpoczynek
```

### Kontekst Biznesowy
Readiness score to "inteligentna" funkcja łącząca wiele metryk:
- Pokazuje jedno zrozumiałe liczba zamiast wielu danych
- Personalizuje rekomendacje
- Buduje zaangażowanie (sprawdzanie codziennie)

### Kryteria Akceptacji
- [ ] Okrągły wskaźnik postępu (0-100)
- [ ] Gradient kolorów (czerwony → żółty → zielony)
- [ ] Rozbicie na czynniki składowe
- [ ] Dotknięcie pokazuje szczegóły
- [ ] Animacja przy ładowaniu

### Algorytm Obliczania (z PRD)

```
Readiness = (HRV × 0.30) + (Sen × 0.30) + (Temperatura × 0.20) + (Faza cyklu × 0.20)

Gdzie:
- HRV: Znormalizowane do 0-100 (wyższe = lepiej)
- Sen: Procent celu snu (np. 7h/8h = 87.5)
- Temperatura: Jak blisko średniej (bliżej = lepiej)
- Faza cyklu:
  - Folikularna (po miesiączce): 90
  - Owulacja: 80
  - Lutealna wczesna: 70
  - Lutealna późna (PMS): 50
  - Miesiączka: 60
```

### Wymagane Elementy UI Readiness Score
- Circular progress indicator (arc) z liczbą w środku
- Gradient kolorów na łuku (czerwony → żółty → zielony)
- Etykieta tekstowa pod wskaźnikiem (np. "DOBRA FORMA")
- Sekcja "Co wpływa na gotowość" z 4 mini progress bars:
  - Sen (%)
  - HRV (%)
  - Temperatura (%)
  - Faza cyklu (%)
- Sekcja rekomendacji z ikoną żarówki
- Animacja przy wejściu (arc rysowany od 0 do wartości)
- Dotknięcie rozwija szczegóły

### Etykiety Gotowości

| Zakres | Etykieta | Kolor | Rekomendacja |
|--------|----------|-------|--------------|
| 80-100 | Doskonała forma | Zielony | Świetny dzień na wysiłek! |
| 60-79 | Dobra forma | Jasnozielony | Normalna aktywność OK |
| 40-59 | Przeciętna forma | Żółty | Rozważ odpoczynek |
| 20-39 | Potrzebujesz odpoczynku | Pomarańczowy | Priorytet: regeneracja |
| 0-19 | Odpoczywaj | Czerwony | Unikaj wysiłku |

### Animacja
- Łuk rysowany od 0% do aktualnej wartości
- Czas: 1 sekunda
- Krzywa: easeOutExpo
- Liczba również animowana (counting up)

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| Z6-T1 | Readiness 85 | Zielony łuk, "Doskonała forma" |
| Z6-T2 | Readiness 45 | Żółty łuk, "Przeciętna forma" |
| Z6-T3 | Brak danych HRV | Oblicz bez HRV, komunikat |
| Z6-T4 | Dotknij komponent | Szczegóły się rozwijają |
| Z6-T5 | Animacja przy wejściu | Łuk animowany od 0 |

### Pliki do Utworzenia
- `lib/ekrany/startowy/widgets/readiness_score.dart`
- `lib/services/readiness_calculator.dart`

### Zależności
- Paulina: P1 (Baza danych), P7 (Dane cyklu)
- Z1 (Temperatura), Z2 (Sen)

---

## Z7: Edukacyjne Tooltips w Aplikacji

### User Story
```
JAKO użytkowniczka
CHCĘ rozumieć co oznaczają różne metryki i wskaźniki
PO TO ŻEBY mogła lepiej interpretować moje dane zdrowotne
```

### Kontekst Biznesowy
Edukacja zwiększa:
- Zaangażowanie (rozumiem więc używam)
- Retencję (uczę się nowych rzeczy)
- Zaufanie (wiem jak to działa)

### Kryteria Akceptacji
- [ ] Ikony info (ℹ️) przy złożonych metrykach
- [ ] Popup/bottomsheet z wyjaśnieniem po dotknięciu
- [ ] Tekst przystępny, bez żargonu medycznego
- [ ] Opcjonalnie: "Dowiedz się więcej" link

### Metryki Wymagające Wyjaśnienia

| Metryka | Tooltip |
|---------|---------|
| HRV | **Zmienność rytmu serca (HRV)** to miara różnic między kolejnymi uderzeniami serca. Wyższa HRV zazwyczaj oznacza lepszą regenerację i mniejszy stres. |
| BBT | **Temperatura bazowa ciała (BBT)** to najniższa temperatura ciała w spoczynku. Zmienia się podczas cyklu - rośnie po owulacji. |
| Readiness | **Wskaźnik gotowości** pokazuje jak Twoje ciało jest przygotowane na aktywność. Bazuje na śnie, HRV, temperaturze i fazie cyklu. |
| Owulacja | **Owulacja** to moment uwolnienia komórki jajowej. Następuje zazwyczaj 14 dni przed następną miesiączką. |
| Okno płodności | **Okno płodności** to 5-6 dni przed i podczas owulacji, kiedy zajście w ciążę jest najbardziej prawdopodobne. |
| Faza lutealna | **Faza lutealna** to okres między owulacją a miesiączką. Może wiązać się ze zmianami nastroju (PMS). |

### Wymagane Elementy Tooltip
- Trigger: ikona ℹ️ obok metryki
- BottomSheet lub Modal Dialog
- Nagłówek z nazwą metryki
- Opis przystępny, bez żargonu medycznego
- Lista bullet points (jeśli potrzebna)
- Personalizacja: "Twoja średnia: X" (jeśli dane dostępne)
- Zakres normalnych wartości
- Przycisk "OK, rozumiem"
- Animacja wejścia (slide up)
- Zamknięcie: tap outside lub przycisk

### Implementacja
- Użyj BottomSheet lub Dialog
- Spójny styl z resztą aplikacji
- Animacja wejścia (slide up / fade)
- Tap outside = zamknięcie

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| Z7-T1 | Dotknij ℹ️ przy HRV | Tooltip się pokazuje |
| Z7-T2 | Kliknij "OK" | Tooltip się zamyka |
| Z7-T3 | Tap outside | Tooltip się zamyka |
| Z7-T4 | Wszystkie tooltips | Tekst wyświetlony poprawnie |

### Pliki do Utworzenia
- `lib/widgets/info_tooltip.dart`
- `lib/data/tooltip_content.dart` (teksty)

### Zależności
- Brak

---

## Z8: Kompletny Ekran Ustawień

### User Story
```
JAKO użytkowniczka
CHCĘ mieć dostęp do wszystkich ustawień aplikacji w jednym miejscu
PO TO ŻEBY dostosować aplikację do moich potrzeb
```

### Kryteria Akceptacji
- [ ] Wszystkie sekcje ustawień funkcjonalne
- [ ] Spójny design z resztą aplikacji
- [ ] Nawigacja do ekranów szczegółowych
- [ ] Natychmiastowe zapisywanie zmian

### Struktura Ekranu Ustawień

**Sekcja PROFIL:**
- Dane cyklu (→ edycja długości cyklu, ostatnia miesiączka)
- Cele (→ cel kroków, cel snu)

**Sekcja PIERŚCIONEK:**
- Mira Ring (→ ekran Niny N7)

**Sekcja DANE:**
- Eksportuj dane (→ ekran Pauliny P9)
- Usuń wszystkie dane (→ dialog potwierdzenia, nieodwracalne)

**Sekcja POWIADOMIENIA:**
- Ustawienia powiadomień (→ Z9)

**Sekcja INFORMACJE:**
- O aplikacji (→ wersja, twórcy, licencje)
- Polityka prywatności (→ otwiera link)

**Stopka:**
- Wersja aplikacji (np. "Wersja 1.0.0")

### Podstrony do Utworzenia

**Dane cyklu:**
- Edycja średniej długości cyklu
- Edycja daty ostatniej miesiączki

**Cele:**
- Cel kroków dziennie
- Cel snu (godziny)

**Usuń wszystkie dane:**
- Dialog potwierdzenia
- Hasło/biometria do autoryzacji
- Nieodwracalne usunięcie

**O aplikacji:**
- Wersja
- Twórcy (Paulina, Nina, Zuza)
- Licencje bibliotek

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| Z8-T1 | Otwórz ustawienia | Wszystkie sekcje widoczne |
| Z8-T2 | Kliknij "Dane cyklu" | Ekran edycji się otwiera |
| Z8-T3 | Zmień cel snu | Zapisane natychmiast |
| Z8-T4 | "Usuń wszystkie dane" | Dialog potwierdzenia |
| Z8-T5 | Potwierdź usunięcie | Dane usunięte, reset app |

### Pliki do Modyfikacji/Utworzenia
- Modyfikuj `lib/ekrany/wiecej.dart`
- `lib/ekrany/settings/profile_settings.dart`
- `lib/ekrany/settings/goals_settings.dart`
- `lib/ekrany/settings/about_screen.dart`

### Zależności
- Nina: N7 (Ustawienia pierścionka)
- Paulina: P9 (Eksport danych)

---

## Z9: UI Preferencji Powiadomień

### User Story
```
JAKO użytkowniczka
CHCĘ kontrolować jakie powiadomienia otrzymuję
PO TO ŻEBY aplikacja nie była natrętna ale informowała mnie o ważnych rzeczach
```

### Kryteria Akceptacji
- [ ] Toggle switches dla różnych typów powiadomień
- [ ] Time pickers dla powiadomień czasowych
- [ ] Jasne opisy co każde powiadomienie robi
- [ ] Natychmiastowe zapisywanie preferencji

### Typy Powiadomień

| Typ | Opis | Domyślnie |
|-----|------|-----------|
| Przypomnienie o logowaniu | Codzienna zachęta do zalogowania samopoczucia | ON, 20:00 |
| Predykcja miesiączki | Powiadomienie na 3 dni przed przewidywaną miesiączką | ON |
| Okno płodności | Powiadomienie o zbliżającym się oknie płodności | OFF |
| Niska bateria pierścionka | Gdy bateria < 20% | ON |
| Sync reminder | Gdy dane nie były synchronizowane > 3 dni | ON |

### Wymagane Elementy UI Powiadomień

**Sekcja CODZIENNE:**
- Przypomnienie o logowaniu
  - Opis + toggle switch
  - Time picker (gdy włączone)

**Sekcja CYKL:**
- Predykcja miesiączki (toggle)
- Okno płodności (toggle, domyślnie OFF)

**Sekcja PIERŚCIONEK:**
- Niska bateria (toggle)
- Przypomnienie o synchronizacji (toggle)

**Każdy element:**
- Tytuł
- Krótki opis
- Toggle switch (ON/OFF)
- Opcjonalnie: dodatkowe ustawienia (np. godzina)

### Logika Time Picker
- Dotknięcie "Godzina: XX:XX" otwiera picker
- Format 24h
- Dostępne co 15 minut (00, 15, 30, 45)

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| Z9-T1 | Toggle OFF powiadomienie | Zapisane jako wyłączone |
| Z9-T2 | Zmień godzinę na 21:30 | Nowa godzina zapisana |
| Z9-T3 | Włącz okno płodności | Toggle zmienia się na ON |

### Pliki do Utworzenia
- `lib/ekrany/settings/notifications_settings.dart`

### Zależności
- Z8

---

## Z10: Finalne Polerowanie UI

### User Story
```
JAKO użytkowniczka
CHCĘ spójną i dopracowaną aplikację
PO TO ŻEBY czuła się przyjemnie podczas codziennego użytkowania
```

### Kryteria Akceptacji
- [ ] Spójne odstępy (spacing) w całej aplikacji
- [ ] Jednolite kolory zgodne z theme
- [ ] Spójna typografia
- [ ] Poprawne zachowanie na różnych rozmiarach ekranów
- [ ] Brak błędów wizualnych (overflow, cut text)
- [ ] Poprawne stany ładowania i błędów

### Checklist Spójności

**Spacing:**
- [ ] Padding ekranów: 16px
- [ ] Odstępy między sekcjami: 24px
- [ ] Odstępy między elementami: 8-12px
- [ ] Border radius: 16px dla głównych kontenerów

**Kolory:**
- [ ] Wszystkie teksty główne: Colors.black87
- [ ] Teksty drugorzędne: Colors.grey[600]
- [ ] Tła: Colors zgodne z theme.dart
- [ ] Akcenty: główny kolor aplikacji

**Typografia:**
- [ ] Nagłówki ekranów: 20px, bold
- [ ] Nagłówki sekcji: 16px, semibold
- [ ] Tekst główny: 14px, regular
- [ ] Etykiety: 12px, regular

**Stany UI:**
- [ ] Loading: CircularProgressIndicator + tekst
- [ ] Empty: ilustracja + tekst zachęcający
- [ ] Error: komunikat + przycisk "Spróbuj ponownie"

### Obszary do Sprawdzenia

1. **Ekran główny (startowy.dart)**
   - Karty z danymi
   - Wskaźnik połączenia

2. **Ekran aktywności (aktywnosc.dart)**
   - Histogram
   - Dane liczbowe

3. **Ekran zdrowia (zdrowie.dart)**
   - Wykresy
   - Metryki

4. **Ekran cyklu (cykl.dart)**
   - Kalendarz
   - Legenda

5. **Ekran ustawień (wiecej.dart)**
   - Lista opcji
   - Ikony

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| Z10-T1 | Przejrzyj wszystkie ekrany | Brak wizualnych błędów |
| Z10-T2 | Testuj na małym ekranie (SE) | Brak overflow |
| Z10-T3 | Testuj na tablecie | Skaluje się sensownie |
| Z10-T4 | Tryb ciemny (jeśli) | Kolory czytelne |
| Z10-T5 | Długi tekst | Nie ucina się bez ... |

### Zależności
- Wszystkie inne zadania Z1-Z9

---

## Harmonogram Tygodniowy

### Tydzień 1 (14-20 gru)
- Z1: Wykres trendów temperatury
- Z2: Wizualizacja jakości snu

### Tydzień 2 (21-27 gru)
- Z3: Projektowanie ekranów onboardingu
- Z4: Nawigacja w onboardingu
- Z5: Ekran ustawień profilu

### Tydzień 3 (28 gru - 3 sty)
- Z6: Komponent dziennej gotowości
- Z7: Edukacyjne tooltips

### Tydzień 4 (4-11 sty)
- Z8: Kompletny ekran ustawień
- Z9: UI preferencji powiadomień
- Z10: Finalne polerowanie UI

---

## Zasoby do Nauki

### Dokumentacja
- [fl_chart - pub.dev](https://pub.dev/packages/fl_chart)
- [Flutter Animation Tutorial](https://docs.flutter.dev/ui/animations)
- [Material Design Guidelines](https://m3.material.io/)

### Inspiracje UI
- Flo App (cycle tracking)
- Clue App (cycle tracking)
- Oura Ring App (health tracking)
- Whoop App (readiness score)

### Narzędzia
- Figma - projektowanie mockupów
- Flutter DevTools - debugowanie UI
- Material Theme Builder - generowanie palet kolorów

### Wskazówki
1. Testuj na prawdziwych urządzeniach
2. Używaj hot reload intensywnie
3. Proś koleżanki o feedback UI
4. Mniej znaczy więcej (prostota!)
5. Animacje powinny być subtelne, nie przeszkadzać

---

## Współpraca z Zespołem

### Integracje z Pauliną
- Z6 potrzebuje danych z bazy (P1)
- Z1, Z2 potrzebują danych zdrowotnych (P3)
- Z8 integruje eksport (P9)

### Integracje z Niną
- Z8 zawiera ustawienia pierścionka (N7)
- Z9 powiadomienia o baterii (N5)
- Wskaźnik połączenia na home (N8)

---

## Cechy Nowoczesnej Aplikacji dla GenZ (Privacy-First)

### Prywatność i Bezpieczeństwo
- **Zero cloud** - wszystkie dane lokalnie na urządzeniu
- **Szyfrowanie end-to-end** - dane zaszyfrowane w bazie
- **Brak konta** - nie wymaga rejestracji ani logowania
- **Transparentność** - jasne komunikaty co aplikacja robi z danymi
- **Prawo do zapomnienia** - łatwe usunięcie wszystkich danych
- **Eksport danych** - użytkownik jest właścicielem swoich danych

### UX/UI Nowoczesne
- **Dark mode** - opcja ciemnego motywu
- **Minimalizm** - czyste UI, bez cluttera
- **Micro-interactions** - subtelne animacje przy akcjach
- **Haptic feedback** - wibracje przy ważnych akcjach
- **Gesture-based** - swipe actions, pull-to-refresh
- **Skeleton loaders** - płynne ładowanie zamiast spinnerów
- **Empty states** - przyjazne komunikaty gdy brak danych

### Personalizacja
- **Customizable widgets** - możliwość zmiany układu dashboard
- **Themes** - wybór kolorystyki
- **Notification control** - granularna kontrola powiadomień
- **Goals** - personalizowane cele

### Social Proof bez Naruszania Prywatności
- **Anonimowe statystyki** - "87% użytkowniczek ma podobne wyniki"
- **Brak porównań** - nie porównuj użytkowniczek między sobą
- **Brak sharing'u** - nie zachęcaj do udostępniania danych

### Dostępność
- **Accessible colors** - kontrast 4.5:1 minimum
- **Screen reader support** - Semantics w Flutter
- **Dynamic text size** - obsługa systemowych preferencji
- **Reduced motion** - opcja wyłączenia animacji

### Performance
- **Instant feedback** - < 100ms na każdą akcję
- **Offline-first** - pełna funkcjonalność bez internetu
- **Battery efficient** - minimalne zużycie baterii
- **Small app size** - optymalizacja rozmiaru APK/IPA

### Trust Building
- **Onboarding z wyjaśnieniem prywatności** - zanim zbierzesz dane, wyjaśnij
- **No dark patterns** - nie oszukuj użytkowniczki
- **Clear data usage** - pokaż co i dlaczego przechowujesz
- **Open source friendly** - rozważ open source w przyszłości

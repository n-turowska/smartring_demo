# Zadania - Ring & Bluetooth Lead (Nina)

**Projekt:** Mira Smart Ring App
**Obszar:** Bluetooth, parowanie pierścionka, synchronizacja
**Sprint:** 4 tygodnie (14 gru 2025 - 11 sty 2026)

---

## Przegląd Zadań

| ID | Zadanie | Tydzień | Priorytet | Estymacja |
|----|---------|---------|-----------|-----------|
| N1 | Integracja pakietu flutter_blue_plus | 1 | KRYTYCZNY | 4h |
| N2 | Skanowanie urządzeń BLE | 1 | KRYTYCZNY | 8h |
| N3 | Ekran wyszukiwania urządzeń | 1 | KRYTYCZNY | 6h |
| N4 | Proces parowania z feedbackiem | 2 | KRYTYCZNY | 10h |
| N5 | Wyświetlanie stanu baterii | 2 | WYSOKI | 4h |
| N6 | Ręczna synchronizacja z postępem | 3 | WYSOKI | 8h |
| N7 | Ekran ustawień pierścionka | 3 | WYSOKI | 6h |
| N8 | Status połączenia na ekranie głównym | 4 | ŚREDNI | 4h |
| N9 | Logika automatycznego ponownego łączenia | 4 | ŚREDNI | 8h |
| N10 | Obsługa danych offline | 4 | ŚREDNI | 6h |

**Łączny szacowany czas:** 64h (~16h/tydzień)

---

## Wprowadzenie do Bluetooth Low Energy (BLE)

### Czym jest BLE?
Bluetooth Low Energy to protokół komunikacji bezprzewodowej zaprojektowany dla urządzeń o niskim zużyciu energii (jak smartwatche, pierścionki, czujniki).

### Kluczowe Pojęcia

**Urządzenie Centralne (Central):** Twój telefon - skanuje i łączy się
**Urządzenie Peryferyjne (Peripheral):** Pierścionek Mira - rozgłasza i odpowiada

**GATT (Generic Attribute Profile):**
- **Serwisy (Services):** Grupują powiązane funkcje (np. Serwis Baterii)
- **Charakterystyki (Characteristics):** Pojedyncze punkty danych (np. Poziom Baterii)
- **UUID:** Unikalny identyfikator serwisu/charakterystyki

**Standardowe Serwisy BLE (Bluetooth SIG):**
| Serwis | UUID | Opis |
|--------|------|------|
| Battery Service | 0x180F | Poziom baterii |
| Heart Rate | 0x180D | Tętno |
| Health Thermometer | 0x1809 | Temperatura |

### Stany Połączenia BLE
```
disconnected → scanning → connecting → connected → syncing → disconnected
      ↑                                     |
      └────────── (błąd/timeout) ──────────┘
```

---

## N1: Integracja Pakietu flutter_blue_plus

### User Story
```
JAKO deweloperka
CHCĘ dodać możliwości Bluetooth Low Energy do aplikacji
PO TO ŻEBYŚMY mogły komunikować się z pierścionkiem Mira
```

### Kontekst Biznesowy
flutter_blue_plus to najpopularniejsza paczka Flutter do BLE:
- Działa na iOS i Android
- Obsługuje skanowanie, łączenie, odczyt/zapis
- Aktywnie utrzymywana

### Kryteria Akceptacji
- [ ] Pakiet flutter_blue_plus dodany i skonfigurowany
- [ ] Uprawnienia Android skonfigurowane (BLUETOOTH, BLUETOOTH_ADMIN, ACCESS_FINE_LOCATION)
- [ ] Uprawnienia iOS skonfigurowane (NSBluetoothAlwaysUsageDescription)
- [ ] Podstawowa detekcja stanu adaptera BLE działa
- [ ] Można sprawdzić czy Bluetooth jest włączony na urządzeniu

### Konfiguracja Uprawnień

**Android (android/app/src/main/AndroidManifest.xml):**
Wymagane uprawnienia:
- `android.permission.BLUETOOTH` - podstawowe BT
- `android.permission.BLUETOOTH_ADMIN` - zarządzanie BT
- `android.permission.BLUETOOTH_SCAN` - skanowanie (Android 12+)
- `android.permission.BLUETOOTH_CONNECT` - łączenie (Android 12+)
- `android.permission.ACCESS_FINE_LOCATION` - lokalizacja (wymagana dla BLE)
- `android.permission.BLUETOOTH_ADVERTISE` - dla Android 12+

Wymagane cechy:
- `android.hardware.bluetooth_le` z `android:required="true"`

**iOS (ios/Runner/Info.plist):**
Wymagane klucze:
- `NSBluetoothAlwaysUsageDescription` - wyjaśnienie dla użytkownika
- `NSBluetoothPeripheralUsageDescription` - dla starszych iOS
- `UIBackgroundModes` z wartością `bluetooth-central` - praca w tle

### Scenariusze Testowe

| ID | Scenariusz | Kroki | Oczekiwany Rezultat |
|----|------------|-------|---------------------|
| N1-T1 | Otwórz app z BT włączonym | 1. Włącz BT 2. Otwórz app | Stan adaptera = on |
| N1-T2 | Otwórz app z BT wyłączonym | 1. Wyłącz BT 2. Otwórz app | Stan = off, prompt pokazany |
| N1-T3 | Włącz BT podczas używania app | 1. Wyłącz BT 2. Otwórz app 3. Włącz BT | Stan zmienia się na on |
| N1-T4 | Odrzuć uprawnienia | 1. Otwórz app 2. Odrzuć uprawnienia | Graceful error, info dla user |

### Pliki do Utworzenia/Modyfikacji
- **UTWÓRZ:** `lib/services/ble_service.dart`
- **MODYFIKUJ:** `pubspec.yaml`
- **MODYFIKUJ:** `android/app/src/main/AndroidManifest.xml`
- **MODYFIKUJ:** `ios/Runner/Info.plist`

### Wskazówki Implementacyjne
1. Użyj Singleton pattern dla BleService
2. Nasłuchuj zmian stanu adaptera jako Stream
3. Obsłuż przypadek gdy użytkownik nie da uprawnień
4. Przetestuj na PRAWDZIWYM urządzeniu (emulatory nie mają BT!)

### Zależności
- Brak (pierwsze zadanie)

---

## N2: Skanowanie Urządzeń BLE

### User Story
```
JAKO użytkowniczka konfigurująca pierścionek
CHCĘ aby aplikacja znajdowała pobliskie pierścionki Mira
PO TO ŻEBY wybrać moje urządzenie do sparowania
```

### Kontekst Biznesowy
Skanowanie to pierwszy krok do połączenia:
- Musi być szybkie (użytkowniczka czeka)
- Filtrowanie tylko pierścionków Mira (nie wszystkich urządzeń BT)
- Wyświetlanie siły sygnału (pomocne przy wielu urządzeniach)

### Kryteria Akceptacji
- [ ] Skanowanie uruchamia się po otwarciu ekranu parowania
- [ ] Skanowanie zatrzymuje się po 10 sekundach lub gdy użytkownik anuluje
- [ ] Pokazuje tylko urządzenia z "Mira" w nazwie (filtr)
- [ ] Wyświetla nazwę urządzenia, siłę sygnału (RSSI), i adres MAC
- [ ] Pull-to-refresh restartuje skanowanie
- [ ] Obsługuje przypadek gdy nie znaleziono urządzeń

### Logika Skanowania

**Filtrowanie urządzeń:**
```
Pokaż urządzenie JEŚLI:
  - nazwa zawiera "Mira" (case insensitive)
  LUB
  - nazwa zawiera "MIRA"
  LUB
  - nazwa zawiera "MiraRing"
```

**Sortowanie wyników:**
```
Sortuj wg siły sygnału (RSSI) malejąco
  - RSSI bliżej 0 = silniejszy sygnał = urządzenie bliżej
  - np. -50 dBm > -70 dBm > -90 dBm
```

### Interpretacja Siły Sygnału (RSSI)

| RSSI | Interpretacja | Wizualne |
|------|---------------|----------|
| ≥ -50 dBm | Doskonały | ████ (4 kreski) |
| -50 do -60 dBm | Dobry | ███░ (3 kreski) |
| -60 do -70 dBm | Przeciętny | ██░░ (2 kreski) |
| -70 do -80 dBm | Słaby | █░░░ (1 kreska) |
| < -80 dBm | Bardzo słaby | ░░░░ (0 kresek, migający) |

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| N2-T1 | Rozpocznij skanowanie z BT włączonym | Wskaźnik skanowania pokazany |
| N2-T2 | Pierścionek Mira w pobliżu | Urządzenie pojawia się na liście |
| N2-T3 | Brak urządzeń w pobliżu | Komunikat "Nie znaleziono urządzeń" |
| N2-T4 | Anuluj skanowanie | Skanowanie natychmiast się zatrzymuje |
| N2-T5 | Pull-to-refresh | Nowe skanowanie się rozpoczyna |
| N2-T6 | Wiele urządzeń Mira | Wszystkie na liście, posortowane wg RSSI |
| N2-T7 | Urządzenie nie-Mira | NIE pojawia się na liście |

### Parametry Skanowania
- Timeout: 10 sekund
- Filtr po nazwie: "Mira", "MIRA", "MiraRing"
- Opcjonalnie filtr po UUID serwisu (jeśli znany)

### Pliki do Modyfikacji
- `lib/services/ble_service.dart` - dodaj metody skanowania

### Zależności
- N1

---

## N3: Ekran Wyszukiwania Urządzeń

### User Story
```
JAKO użytkowniczka
CHCĘ przejrzysty interfejs do znajdowania i wybierania pierścionka
PO TO ŻEBY parowanie było łatwe i intuicyjne
```

### Kryteria Akceptacji
- [ ] Animowany wskaźnik skanowania (efekt radaru lub pulsowanie)
- [ ] Lista znalezionych urządzeń z nazwą, sygnałem, baterią (jeśli dostępna)
- [ ] Dotknięcie urządzenia inicjuje połączenie
- [ ] Komunikat "Nie znaleziono" z wskazówkami rozwiązywania problemów
- [ ] Przycisk wstecz do anulowania
- [ ] Design neumorphic spójny z resztą aplikacji

### Wymagane Elementy UI
- Nagłówek z tytułem i nawigacją wstecz
- Animacja radaru/skanowania (pulsujące koła)
- Tekst statusu ("Szukam...", "Znaleziono X urządzeń")
- Lista znalezionych urządzeń (nazwa, sygnał RSSI, ikona)
- Sekcja wskazówek troubleshooting (rozwijana)
- Przycisk "Skanuj ponownie"
- Pull-to-refresh gesture

### Stan Ekranu

```
Stan ekranu:
- isScanning (bool) - czy skanowanie trwa
- devices (List<ScanResult>) - znalezione urządzenia
- errorMessage (String?) - błąd jeśli wystąpił
```

### Animacja Radaru
Utwórz CustomPainter lub użyj AnimatedBuilder:
- Koła rozchodzące się od środka
- Kolor: główny kolor aplikacji z opacity
- Tempo: 2 sekundy na pełny cykl
- Aktywna tylko podczas skanowania

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| N3-T1 | Otwórz ekran | Animacja radaru startuje, skanowanie się rozpoczyna |
| N3-T2 | Urządzenie znalezione | Pojawia się na liście z info |
| N3-T3 | Dotknij urządzenie | Nawigacja do ekranu parowania |
| N3-T4 | Brak urządzeń po 10s | "Nie znaleziono" + wskazówki |
| N3-T5 | Kliknij "Skanuj ponownie" | Nowe skanowanie |
| N3-T6 | Przycisk wstecz | Powrót do poprzedniego ekranu |

### Pliki do Utworzenia
- `lib/ekrany/pairing/device_discovery_screen.dart`
- `lib/ekrany/pairing/widgets/radar_animation.dart`
- `lib/ekrany/pairing/widgets/device_list_tile.dart`

### Zależności
- N1, N2

---

## N4: Proces Parowania z Wizualnym Feedbackiem

### User Story
```
JAKO użytkowniczka
CHCĘ wyraźny feedback podczas procesu parowania
PO TO ŻEBY wiedzieć czy parowanie się udało lub co poszło nie tak
```

### Kontekst Biznesowy
Parowanie to stresujący moment dla użytkowniczki:
- Nie wie co się dzieje "pod spodem"
- Błędy BLE są cryptyczne
- Potrzebuje potwierdzenia sukcesu

### Kryteria Akceptacji
- [ ] Pokazane etapy: Łączenie → Wykrywanie serwisów → Parowanie → Gotowe
- [ ] Każdy etap ma wskaźnik ładowania
- [ ] Błąd pokazuje komunikat z opcją ponowienia
- [ ] Sukces pokazuje potwierdzenie z wibracją pierścionka (jeśli wspierana)
- [ ] Timeout po 30 sekundach z komunikatem błędu
- [ ] Sparowane urządzenie zapisane do lokalnego storage

### Maszyna Stanów Parowania

```
┌────────────────────────────────────────────────────────────┐
│                                                            │
│  idle ──→ connecting ──→ discovering ──→ pairing ──→ success
│    │           │               │             │              │
│    │           └───────────────┴─────────────┴──→ failed ──┘
│    │                                               │
│    └───────────────────retry───────────────────────┘
│
└────────────────────────────────────────────────────────────┘
```

**Stany (PairingState enum):**
- `idle` - oczekiwanie
- `connecting` - nawiązywanie połączenia
- `discoveringServices` - odkrywanie serwisów GATT
- `pairing` - wymiana kluczy parowania
- `success` - sukces!
- `failed` - błąd (z komunikatem)

### Wymagane Elementy UI Parowania
- Nagłówek z tytułem i możliwością anulowania
- Lista kroków postępu (4 kroki: Łączenie, Wykrywanie, Parowanie, Gotowe)
- Każdy krok: ikona statusu (spinner/check/error), nazwa, opcjonalnie czas
- Animacja pierścionka w centrum
- Tekst instrukcji ("Nie ruszaj pierścionka...")
- Przycisk "Spróbuj ponownie" w przypadku błędu
- Ekran sukcesu z confetti/animacją i przyciskiem "Kontynuuj"

### Weryfikacja Pierścionka Mira

Sprawdź czy urządzenie to prawdziwy pierścionek Mira:
1. Po połączeniu wykryj serwisy
2. Szukaj charakterystycznego UUID serwisu Mira
3. Jeśli brak - błąd "To nie jest pierścionek Mira"

### Zapisywanie Sparowanego Urządzenia

Po sukcesie zapisz do SharedPreferences lub secure storage:
- `paired_ring_id` - identyfikator urządzenia
- `paired_ring_name` - nazwa urządzenia
- `paired_at` - timestamp parowania

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| N4-T1 | Połącz z prawidłowym pierścionkiem Mira | Wszystkie kroki ukończone, sukces |
| N4-T2 | Połącz z urządzeniem nie-Mira | Błąd: "To nie jest pierścionek Mira" |
| N4-T3 | Pierścionek poza zasięgiem podczas parowania | Błąd timeout z opcją ponowienia |
| N4-T4 | Kliknij ponów po błędzie | Parowanie się restartuje |
| N4-T5 | Sukces parowania | Dane zapisane, można wrócić do home |

### Pliki do Utworzenia
- `lib/ekrany/pairing/pairing_screen.dart`
- `lib/ekrany/pairing/widgets/progress_steps.dart`
- `lib/ekrany/pairing/widgets/pairing_animation.dart`

### Zależności
- N1, N2, N3

---

## N5: Wyświetlanie Stanu Baterii Pierścionka

### User Story
```
JAKO użytkowniczka
CHCĘ widzieć poziom baterii mojego pierścionka
PO TO ŻEBY wiedzieć kiedy go naładować
```

### Kontekst Biznesowy
Rozładowany pierścionek = brak danych = frustracja użytkowniczki
Wczesne ostrzeżenia pomagają uniknąć przerw w trackingu

### Kryteria Akceptacji
- [ ] Procent baterii pokazany w aplikacji (ekran główny i ustawienia pierścionka)
- [ ] Ikona baterii zmienia się w zależności od poziomu (pełna, średnia, niska, krytyczna)
- [ ] Ostrzeżenie przy 20% baterii
- [ ] Krytyczne ostrzeżenie przy 10%
- [ ] Pokazany timestamp ostatniej aktualizacji

### UUID Serwisu Baterii (Standard BLE)
- Battery Service: `0x180F` lub `0000180F-0000-1000-8000-00805F9B34FB`
- Battery Level Characteristic: `0x2A19` lub `00002A19-0000-1000-8000-00805F9B34FB`

### Odczyt Poziomu Baterii

**Metody:**
1. Jednorazowy odczyt: `characteristic.read()`
2. Subskrypcja notify: `characteristic.setNotifyValue(true)` + nasłuchiwanie streamu

**Format danych:**
- Jeden bajt (uint8)
- Wartość 0-100 (procent)

### Wizualizacja Baterii

| Poziom | Kolor | Ikona | Akcja |
|--------|-------|-------|-------|
| > 50% | Zielony | battery_full | Brak |
| 20-50% | Pomarańczowy | battery_3_bar | Brak |
| 10-20% | Czerwony | battery_2_bar | Ostrzeżenie |
| < 10% | Czerwony (migający) | battery_alert | Krytyczne ostrzeżenie |

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| N5-T1 | Połączony, bateria 80% | Zielona ikona, "80%" |
| N5-T2 | Bateria spadnie do 20% | Ostrzeżenie pokazane |
| N5-T3 | Bateria spadnie do 5% | Krytyczne ostrzeżenie |
| N5-T4 | Odświeżenie baterii | Timestamp zaktualizowany |

### Pliki do Modyfikacji
- `lib/services/ble_service.dart` - dodaj metody baterii
- `lib/widgets/battery_indicator.dart` - utwórz widget

### Zależności
- N4

---

## N6: Ręczna Synchronizacja z Postępem

### User Story
```
JAKO użytkowniczka
CHCĘ ręcznie synchronizować dane z pierścionka
PO TO ŻEBY mieć pewność że moje dane zdrowotne są aktualne
```

### Kontekst Biznesowy
Synchronizacja to kluczowy moment transferu danych:
- Użytkowniczka chce wiedzieć że coś się dzieje
- Postęp procentowy buduje zaufanie
- Powiadomienie o sukcesie/błędzie zamyka pętlę

### Kryteria Akceptacji
- [ ] Gest pull-to-refresh wyzwala sync na ekranie głównym
- [ ] Przycisk ręcznej synchronizacji w ustawieniach
- [ ] Pasek postępu pokazuje procent (0-100%)
- [ ] Pokazana liczba zsynchronizowanych rekordów
- [ ] Szacowany pozostały czas
- [ ] Powiadomienie sukces/błąd na koniec
- [ ] Historia synchronizacji widoczna w ustawieniach

### Stany Synchronizacji

```
SyncState enum:
- idle - gotowy do sync
- starting - inicjalizacja
- syncing - transfer danych (z progress %)
- completed - sukces
- failed - błąd (z komunikatem)
```

### Model Postępu Synchronizacji

```
SyncProgress:
- state (SyncState)
- progress (int, 0-100)
- syncedRecords (int?)
- totalRecords (int?)
- estimatedTimeRemaining (Duration?)
- error (String?)
```

### Wymagane Elementy UI Synchronizacji
- Pasek postępu (linear progress bar) z procentem
- Licznik rekordów (np. "145 / 320 rekordów")
- Szacowany czas pozostały
- Przycisk "Anuluj" (z potwierdzeniem)
- Animacja synchronizacji (opcjonalnie)
- Powiadomienie sukcesu/błędu po zakończeniu

### Logika Synchronizacji

**Krok po kroku:**
1. Połącz z pierścionkiem (jeśli nie połączony)
2. Wykryj serwis danych Mira
3. Odczytaj liczbę rekordów do pobrania
4. Włącz notify na charakterystyce danych
5. Dla każdego otrzymanego rekordu:
   - Parsuj dane zdrowotne
   - Zapisz do bazy (DatabaseService)
   - Aktualizuj progress
6. Po zakończeniu - powiadomienie sukcesu
7. Opcjonalnie - wyczyść pamięć pierścionka

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| N6-T1 | Pull-to-refresh na home | Sync się rozpoczyna |
| N6-T2 | 100 rekordów do sync | Progress 0→100%, sukces |
| N6-T3 | Utrata połączenia podczas sync | Błąd z opcją ponowienia |
| N6-T4 | Anuluj sync | Sync przerwany, dane częściowe zachowane |
| N6-T5 | Brak nowych danych | "Wszystko aktualne" |

### Pliki do Utworzenia
- `lib/services/sync_service.dart`
- `lib/ekrany/sync/sync_progress_screen.dart`

### Zależności
- N4, Paulina: P1 (Baza danych)

---

## N7: Ekran Ustawień Pierścionka

### User Story
```
JAKO użytkowniczka
CHCĘ konfigurować ustawienia mojego pierścionka
PO TO ŻEBY dostosować go do moich preferencji
```

### Kryteria Akceptacji
- [ ] Wyświetla nazwę sparowanego pierścionka
- [ ] Pokazuje stan połączenia (online/offline)
- [ ] Poziom baterii widoczny
- [ ] Ostatnia synchronizacja (data i czas)
- [ ] Przycisk ręcznej synchronizacji
- [ ] Przycisk "Zapomnij urządzenie"
- [ ] Opcjonalnie: jasność LED, siła wibracji

### Wymagane Elementy UI Ustawień Pierścionka
- Karta z info pierścionka (nazwa, status połączenia, ikona)
- Sekcja "Informacje": bateria, ostatni sync, wersja firmware
- Sekcja "Akcje": przycisk sync, przycisk ustawień pierścionka
- Sekcja "Zaawansowane": "Zapomnij urządzenie" (czerwony, z potwierdzeniem)
- Wskaźnik połączenia real-time (online/offline)

### Funkcja "Zapomnij Urządzenie"

**Potwierdzenie:**
```
"Czy na pewno chcesz zapomnieć to urządzenie?
Będziesz musiała sparować pierścionek ponownie.

[Anuluj]  [Zapomnij]"
```

**Po potwierdzeniu:**
1. Rozłącz BLE
2. Usuń z SharedPreferences/SecureStorage
3. Nawiguj do ekranu początkowego lub parowania

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| N7-T1 | Otwórz ustawienia pierścionka | Info pierścionka widoczne |
| N7-T2 | Kliknij "Synchronizuj teraz" | Sync się rozpoczyna |
| N7-T3 | Kliknij "Zapomnij urządzenie" | Dialog potwierdzenia |
| N7-T4 | Potwierdź zapomnienie | Urządzenie zapomniane, powrót |

### Pliki do Utworzenia
- `lib/ekrany/settings/ring_settings_screen.dart`

### Zależności
- N4, N5, N6

---

## N8: Status Połączenia na Ekranie Głównym

### User Story
```
JAKO użytkowniczka
CHCĘ widzieć status połączenia z pierścionkiem na pierwszy rzut oka
PO TO ŻEBY wiedzieć czy moje dane są aktualne
```

### Kryteria Akceptacji
- [ ] Mały wskaźnik pokazujący połączony/rozłączony
- [ ] Wyświetlony czas ostatniej synchronizacji
- [ ] Dotknięcie otwiera zarządzanie pierścionkiem
- [ ] Zmienia się w czasie rzeczywistym

### Wymagane Elementy Wskaźnika
- Mała kropka statusu (zielona = połączony, szara = rozłączony)
- Nazwa pierścionka lub "Rozłączony"
- Czas od ostatniej synchronizacji (np. "Sync: 5 min temu")
- Dotknięcie otwiera ekran ustawień pierścionka
- Animacja przy zmianie statusu

### Logika Aktualizacji
- Nasłuchuj zmian stanu połączenia z BleService
- Aktualizuj UI natychmiast po zmianie
- Pobierz ostatni sync time z bazy/preferencji

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| N8-T1 | Połączony | Zielony wskaźnik, nazwa pierścionka |
| N8-T2 | Rozłączony | Szary wskaźnik, "Rozłączony" |
| N8-T3 | Dotknij wskaźnik | Otwiera ekran ustawień pierścionka |
| N8-T4 | Sync przed 5 min | "Sync: 5 min temu" |

### Pliki do Modyfikacji
- `lib/ekrany/startowy.dart` - dodaj wskaźnik
- `lib/widgets/connection_indicator.dart` - utwórz widget

### Zależności
- N4

---

## N9: Logika Automatycznego Ponownego Łączenia

### User Story
```
JAKO użytkowniczka
CHCĘ aby aplikacja automatycznie łączyła się z moim pierścionkiem
PO TO ŻEBY nie musieć ręcznie parować za każdym razem
```

### Kontekst Biznesowy
Automatyczne reconnect to podstawa doświadczenia:
- Użytkowniczka nie powinna wiedzieć że połączenie zostało przerwane
- Płynne doświadczenie = więcej danych = lepsza wartość

### Kryteria Akceptacji
- [ ] Serwis w tle próbujący ponowne połączenie
- [ ] Konfigurowalne interwały retry
- [ ] Powiadomienie gdy połączenie przywrócone
- [ ] Limit prób (np. 5) zanim porzuci
- [ ] Manualne wyłączenie reconnect w ustawieniach

### Strategia Reconnect

```
Strategi exponential backoff:
  Próba 1: czekaj 5 sekund
  Próba 2: czekaj 10 sekund
  Próba 3: czekaj 30 sekund
  Próba 4: czekaj 1 minuta
  Próba 5: czekaj 5 minut
  Potem: spróbuj co 10 minut lub porzuć
```

### Warunki Próby Reconnect
- Bluetooth włączony
- Było wcześniej sparowane urządzenie
- Nie w trakcie synchronizacji
- Aplikacja na pierwszym planie lub ma uprawnienia do pracy w tle

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| N9-T1 | Utrata połączenia | Auto-reconnect się rozpoczyna |
| N9-T2 | Sukces reconnect | Powiadomienie, status się zmienia |
| N9-T3 | 5 nieudanych prób | Porzucenie, komunikat dla user |
| N9-T4 | BT wyłączone | Nie próbuje reconnect |
| N9-T5 | Użytkownik wyłączył auto-reconnect | Nie próbuje |

### Pliki do Modyfikacji
- `lib/services/ble_service.dart` - dodaj logikę reconnect

### Zależności
- N4

---

## N10: Obsługa Danych Offline na Pierścionku

### User Story
```
JAKO użytkowniczka która zapomniała zsynchronizować
CHCĘ aby pierścionek przechowywał moje dane
PO TO ŻEBY nie tracić historii gdy nie mam telefonu
```

### Kryteria Akceptacji
- [ ] Wykryj ile dni danych pierścionek przechowuje
- [ ] Wyczyść pamięć pierścionka po udanej synchronizacji
- [ ] Obsłuż wznowienie synchronizacji po przerwaniu
- [ ] Ostrzeżenie gdy pamięć pierścionka bliska pełnej

### Logika

**Sprawdzenie pamięci:**
1. Odczytaj charakterystykę "liczba rekordów"
2. Porównaj z maksimum pierścionka (np. 7 dni = ~10000 rekordów)
3. Oblicz % zajętej pamięci

**Po synchronizacji:**
1. Wyślij komendę czyszczenia pamięci
2. Zweryfikuj że pamięć jest pusta

### Scenariusze Testowe

| ID | Scenariusz | Oczekiwany Rezultat |
|----|------------|---------------------|
| N10-T1 | 5 dni danych offline | Wszystkie zsynchronizowane |
| N10-T2 | Pamięć > 80% pełna | Ostrzeżenie dla user |
| N10-T3 | Przerwanie sync w połowie | Wznów od miejsca przerwania |
| N10-T4 | Sukces sync | Pamięć wyczyszczona |

### Zależności
- N6

---

## Testowanie z nRF52 XIAO BLE

### Przegląd
Seeed XIAO nRF52840 to płytka deweloperska która może symulować pierścionek Mira do testów.

### Co Potrzebujesz
- Seeed XIAO nRF52840 lub XIAO nRF52840 Sense
- Kabel USB-C
- Arduino IDE

### Konfiguracja Arduino IDE
1. Dodaj URL Board Manager: `https://files.seeedstudio.com/arduino/package_seeeduino_boards_index.json`
2. Zainstaluj "Seeed nRF52 mbed-enabled Boards"
3. Zainstaluj bibliotekę ArduinoBLE

### Co Firmware Powinien Robić
- Rozgłaszać się jako "Mira Ring"
- Udostępniać serwisy: Battery (0x180F), Heart Rate (0x180D), Temperature (0x1809)
- Wysyłać symulowane dane (kroki, temperatura, HR, HRV)
- Reagować na komendy (vibrate, reset, sync)

### UUIDs do Użycia

| Serwis/Charakterystyka | UUID |
|------------------------|------|
| Mira Custom Service | 12345678-1234-5678-1234-56789ABCDEF0 |
| Mira Data | ...DEF1 |
| Mira Control | ...DEF2 |
| Battery Level | 0x2A19 |
| Heart Rate | 0x2A37 |
| Temperature | 0x2A1C |

### Testowanie Krok po Kroku
1. Wgraj firmware do XIAO
2. Otwórz Serial Monitor (115200 baud)
3. Uruchom app na telefonie
4. Przejdź do ekranu parowania
5. Powinieneś zobaczyć "Mira Ring"
6. Sparuj i przetestuj sync

### Troubleshooting

| Problem | Rozwiązanie |
|---------|-------------|
| Urządzenie nie znalezione | Sprawdź filtr nazwy, czy XIAO rozgłasza |
| Połączenie się nie udaje | Zresetuj XIAO, upewnij się że tylko jedno urządzenie łączy |
| Brak danych | Sprawdź UUIDs, czy notify włączone |
| Serwisy nie wykryte | Zwiększ timeout discovery |

---

## Harmonogram Tygodniowy

### Tydzień 1 (14-20 gru)
- N1: Integracja flutter_blue_plus
- N2: Skanowanie BLE
- N3: Ekran wyszukiwania

### Tydzień 2 (21-27 gru)
- N4: Proces parowania
- N5: Status baterii

### Tydzień 3 (28 gru - 3 sty)
- N6: Synchronizacja z postępem
- N7: Ustawienia pierścionka

### Tydzień 4 (4-11 sty)
- N8: Status na home
- N9: Auto-reconnect
- N10: Dane offline

---

## Zasoby do Nauki

### Dokumentacja
- [flutter_blue_plus - pub.dev](https://pub.dev/packages/flutter_blue_plus)
- [Bluetooth SIG - GATT Services](https://www.bluetooth.com/specifications/gatt/services/)
- [ArduinoBLE Library](https://www.arduino.cc/reference/en/libraries/arduinoble/)

### Tutoriale
- Bluetooth basics na YouTube
- Flutter BLE tutorial na Medium
- Seeed XIAO Getting Started

### Wskazówki
1. ZAWSZE testuj na prawdziwym urządzeniu
2. BLE jest kapryśne - dodaj dużo logów
3. Timeouty są ważne - nie czekaj w nieskończoność
4. Handle disconnects gracefully
5. Stan połączenia może się zmienić w każdej chwili

---

## Cechy Nowoczesnej Aplikacji dla GenZ (Privacy-First)

### Prywatność i Bezpieczeństwo (Kluczowe dla Bluetooth Lead)
- **Local-only communication** - dane z pierścionka tylko na urządzeniu
- **No telemetry** - nie wysyłaj danych o użyciu do serwerów
- **Secure pairing** - używaj BLE bonding dla bezpieczeństwa
- **Clear permissions** - wyjaśnij dlaczego potrzebujesz Bluetooth i lokalizacji
- **No background tracking** - nie zbieraj danych gdy aplikacja zamknięta (bez zgody)

### UX Nowoczesne dla Bluetooth
- **Graceful degradation** - działaj bez pierścionka (tryb demo/manual)
- **Clear status** - zawsze pokazuj stan połączenia
- **Recovery paths** - jasne instrukcje gdy coś nie działa
- **Progress feedback** - pokazuj postęp długich operacji (sync)
- **Haptic feedback** - wibracja przy sukcesie/błędzie parowania

### Trust Building
- **Transparency** - pokazuj co dokładnie przesyłasz z pierścionka
- **User control** - pozwól "zapomnieć" urządzenie
- **No forced updates** - nie wymuszaj aktualizacji firmware
- **Offline capability** - działaj bez internetu

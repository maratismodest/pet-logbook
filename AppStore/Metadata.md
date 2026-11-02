# App Store Connect — Pet Logbook

Тексты для страницы приложения в App Store Connect. Язык страницы: English (U.S.).

## App Information

| Field | Value |
|---|---|
| Name (max 30) | Pet Logbook: Health & Vet |
| Subtitle (max 30) | Feeding, walks & symptoms log |
| Bundle ID | com.chamala.petlogbook |
| SKU | petlogbook-ios-001 |
| Primary category | Lifestyle |
| Secondary category | Medical |
| Age rating | 4+ (no objectionable content) |
| Price | Free |

Имя на домашнем экране: «Pet Logbook». Если имя в App Store занято, варианты: «Pet Logbook: Vet Summary», «Paw Logbook: Pet Health», «Pet Diary – Vet Notes».

## Promotional Text (max 170)

Log feedings, walks, symptoms, and medications in seconds. Before a vet visit, get a clear summary you can share as a PDF.

## Description (max 4000)

Pet Logbook keeps your pet's daily life and health in one place, so you're ready when the vet asks "When did this start?"

LOG EVERYTHING IN SECONDS
• Feedings with portion sizes
• Walks with duration
• Symptoms, medications, and vaccinations
• Filter the timeline by entry type

QUICK ENTRY
Type it the way you'd say it — "Fed 100 g of kibble at 9 am, then a 30-minute walk" — and Pet Logbook turns it into separate entries for you to review. Quick Entry uses Apple Intelligence on supported devices.

VET SUMMARY
Choose the last 7, 30, or 90 days and get a one-page summary: diet and activity, every symptom and medication with dates, and vaccination history. On devices with Apple Intelligence, Pet Logbook also writes a short overview, highlights recurring symptoms, and suggests questions to ask your vet. Share the summary as a PDF in one tap.

PRIVATE BY DESIGN
Your diary stays on your device. Pet Logbook has no accounts, no ads, and no tracking. Smart features run entirely on device.

Pet Logbook helps you keep notes. It doesn't provide medical advice or diagnoses. Always consult a veterinarian about your pet's health.

## Keywords (max 100, comma-separated, no spaces)

Слова из названия и подзаголовка (pet, health, vet, feeding, walks, symptoms, log) App Store уже учитывает, поэтому здесь они не повторяются.

dog,cat,puppy,kitten,tracker,diary,journal,meds,pill,vaccine,food,diet,care,pdf,record,history,notes

(100 символов. Единственное число покрывает множественное, поэтому `dogs`, `cats` не нужны. «veterinarian» убрано: `vet` уже есть в названии.)

### Дополнительные английские локализации

Каждая локализация — это отдельные 100 символов ключевых слов в своей стране. В App Store Connect: App Information → Localizable Information → добавить язык. Name, Subtitle, Description и Promotional Text копируются из English (U.S.), меняются только ключевые слова.

| Локализация | Где индексируется | Keywords |
|---|---|---|
| English (U.K.) | Великобритания, Ирландия и др. | dog,cat,puppy,kitten,tracker,diary,journal,medicine,jab,vaccination,food,diet,care,pdf,record,notes |
| English (Australia) | Австралия, Новая Зеландия | dog,cat,puppy,kitten,tracker,diary,journal,medicine,vaccination,food,care,pdf,record,history,notes |
| English (Canada) | Канада | dog,cat,puppy,kitten,tracker,diary,journal,medicine,vaccination,food,diet,care,pdf,record,history |

Приложение не напоминает о событиях и не отслеживает вес, поэтому слова `reminder` и `weight` намеренно не используются: App Review отклоняет ключевые слова, не соответствующие функциям.

## URLs

| Field | Value |
|---|---|
| Support URL | https://maratismodest.github.io/pet-logbook/ |
| Privacy Policy URL | https://maratismodest.github.io/pet-logbook/privacy |
| Marketing URL | Необязательно |

Страницы публикуются через GitHub Pages из папки `docs/` ветки `main`.

Скриншоты с демо-данными: в Debug-сборке запустите приложение с аргументом `-seedDemoData` (Scheme → Run → Arguments) на чистом симуляторе.

## App Privacy (nutrition label)

- Data collection: **Data Not Collected**.
- Tracking: **No**.

Приложение хранит данные только на устройстве (SwiftData), не имеет сервера, аналитики и рекламы. Foundation Models работает на устройстве.

## Export Compliance

`ITSAppUsesNonExemptEncryption = NO` уже стоит в Info.plist, поэтому App Store Connect не будет спрашивать о шифровании при каждой загрузке.

## Age Rating (questionnaire)

На все вопросы анкеты ответ **None / No**:

- Насилие, сексуальный контент, ненормативная лексика, хоррор, азартные игры, алкоголь/табак/наркотики — None.
- Medical or Treatment Information — None. Приложение хранит заметки владельца и не даёт медицинских рекомендаций.
- Unrestricted Web Access — No. User-Generated Content (публичный) — No. Messaging/Chat — No. Advertising — No. Parental Controls / Age Assurance — No.

Итог: **4+**.

## Pricing and Availability

| Field | Value |
|---|---|
| Price | Free (Tier 0) |
| Availability | All countries or regions |
| Pre-order | No |
| Apple Silicon Mac / Vision Pro | Можно оставить включённым (приложение iPhone/iPad) |

## Version Information (1.0.0)

| Field | Value |
|---|---|
| Copyright | 2026 Marat Faizerakhmanov |
| What's New | Не заполняется для первой версии |
| Version release | Manually release this version (выпустить вручную после одобрения) |
| Content Rights | Does not contain, show, or access third-party content |
| Sign-in required | No (снять галочку «Sign-in required» в App Review Information) |

## App Review Information

| Field | Value |
|---|---|
| First / Last name | Marat Faizerakhmanov |
| Email | maratismodest@gmail.com |
| Phone | Указать свой номер в международном формате (+…) |
| Demo account | Не нужен |

## Notes for App Review

Pet Logbook is a pet health journal. No account or login is required.

Quick Entry and the written part of the Vet Summary use the on-device Foundation Models framework (Apple Intelligence). On devices without Apple Intelligence, or when it's turned off, the app explains why these features are unavailable, and everything else works: manual entries, the timeline, and the Vet Summary with all recorded facts and PDF export.

To test: tap + to add a pet, open it, tap + → Manual Entry to add a few entries, then open the … menu → Vet Summary and tap Share PDF.

The app doesn't provide medical advice. The summary includes a disclaimer that it is based on the owner's notes and is not a medical report.

## Screenshots

Готовы в `AppStore/Screenshots/` (снято на симуляторе с демо-данными `-seedDemoData`):

| Папка | Размер | Файлы |
|---|---|---|
| `iPhone/` (6.9") | 1320 × 2868 | 01-pets, 02-timeline, 03-vet-summary, 06-add-entry |
| `iPad/` (13") | 2064 × 2752 | 01-pets, 02-timeline, 03-vet-summary, 04-add-entry |

Рекомендуемый порядок загрузки: 02-timeline, 03-vet-summary, 01-pets, add-entry. Лента лучше всего показывает приложение, поэтому её стоит поставить первой.

Apple Intelligence в симуляторе не работает, поэтому скриншотов Quick Entry с разобранными записями и Vet Summary с текстом от модели нет. Их можно снять на устройстве с Apple Intelligence и поставить первыми.

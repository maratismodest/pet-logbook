# App Store Connect — Pet Logbook

Тексты для страницы приложения в App Store Connect. Язык страницы: English (U.S.).

## App Information

| Field | Value |
|---|---|
| Name (max 30) | Pet Logbook: Health & Vet |
| Subtitle (max 30) | Feeding, walks & symptoms log |
| Bundle ID | com.chamala.petlogbook |
| SKU | petdiary-ios-001 |
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

dog,cat,puppy,kitten,tracker,diary,journal,medication,vaccine,food,care,pdf,veterinarian

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

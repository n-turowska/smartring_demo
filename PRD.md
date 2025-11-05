# Product Requirements Document: Mira Smart Ring Companion App

**Version:** 1.0
**Date:** November 5, 2025
**Product:** Mira - Privacy-First Women's Health Smart Ring App
**Document Owner:** Product Team

---

## Executive Summary

Mira is a privacy-first companion app for the Mira smart ring, designed specifically for women's health monitoring. The app leverages on-device deep learning to analyze physiological data (steps, temperature, accelerometer, PPG) for menstrual cycle prediction and health insights. Unlike competitors, Mira prioritizes user privacy by processing all sensitive health data locally on-device, with optional encrypted cloud backup.

---

## Problem Statement

### Current Pain Points
1. **Privacy Concerns**: Existing femtech apps often upload sensitive health data to cloud servers, raising privacy and data security concerns
2. **Limited Context**: Period tracking apps rely on manual input without physiological data validation
3. **Inaccurate Predictions**: Calendar-based predictions don't account for individual physiological variations
4. **Data Silos**: Health data locked in proprietary systems with no user ownership
5. **One-Dimensional Tracking**: Apps focus solely on menstruation without holistic health insights

### Target Solution
A privacy-first smart ring companion app that:
- Processes all health data on-device using deep learning
- Provides accurate cycle predictions based on physiological signals
- Empowers users with complete data ownership and control
- Delivers actionable health insights beyond just period tracking

---

## Goals & Objectives

### Business Goals
- Launch MVP within 6 months supporting core cycle tracking features
- Achieve 90%+ user retention after 3 months of use
- Establish Mira as the privacy leader in femtech space
- Build trust through transparent data practices

### User Goals
- **Primary**: Understand menstrual cycle patterns with science-backed predictions
- **Secondary**: Monitor overall health trends (sleep, activity, temperature)
- **Tertiary**: Track fertility windows for family planning
- **Foundational**: Maintain complete privacy and control over health data

### Success Metrics
- Daily Active Users (DAU) / Monthly Active Users (MAU) ratio > 40%
- Cycle prediction accuracy > 85% after 2 cycles of data
- Average time to sync < 30 seconds
- 0 data privacy incidents
- App Store rating > 4.5/5.0
- User data export adoption > 20%

---

## Target Users

### Primary Persona: "Health-Conscious Sarah"
- **Age**: 25-40
- **Profile**: Professionally active, values privacy, tracks health metrics
- **Goals**: Understand body patterns, optimize wellness, family planning
- **Pain Points**: Distrusts apps that upload health data, tired of manual tracking
- **Tech Savviness**: High - comfortable with wearables and health apps

### Secondary Persona: "Privacy-First Maria"
- **Age**: 30-45
- **Profile**: Privacy advocate, may have experienced data breaches
- **Goals**: Health monitoring without sacrificing privacy
- **Pain Points**: Refuses to use cloud-based health apps
- **Tech Savviness**: Medium-High - values open source and encryption

### Tertiary Persona: "Planning-Focused Jessica"
- **Age**: 28-38
- **Profile**: Trying to conceive or practicing fertility awareness
- **Goals**: Identify fertile windows accurately
- **Pain Points**: Calendar methods unreliable, wants science-backed data
- **Tech Savviness**: Medium

---

## User Stories

### Epic 1: Ring Setup & Connectivity

**US-1.1**: As a new user, I want to pair my Mira ring with the app via Bluetooth so that I can start tracking my health data.
- **Acceptance Criteria**:
  - Ring discoverable within 10 seconds of opening pairing screen
  - Clear visual feedback during pairing process
  - Automatic retry on connection failure
  - Success confirmation with ring vibration/LED

**US-1.2**: As a user, I want the ring to store data when my phone isn't nearby so that I don't lose tracking data when separated.
- **Acceptance Criteria**:
  - Ring stores up to 7 days of data locally
  - Automatic sync when phone comes back in range
  - Visual indicator showing last sync time
  - No data loss during offline periods

**US-1.3**: As a user, I want to receive notifications about ring battery status so that I know when to charge it.
- **Acceptance Criteria**:
  - Notification at 20% battery
  - Warning at 10% battery
  - Battery level visible in app at all times
  - Estimated time remaining shown

### Epic 2: Data Collection & Privacy

**US-2.1**: As a privacy-conscious user, I want all my health data processed on my device so that it never leaves my control.
- **Acceptance Criteria**:
  - ML models run entirely on-device
  - No health data transmitted to servers without explicit consent
  - Privacy policy clearly states on-device processing
  - Option to verify no network activity during processing

**US-2.2**: As a user, I want to optionally back up my data with end-to-end encryption so that I can restore it if I change devices.
- **Acceptance Criteria**:
  - Opt-in cloud backup (disabled by default)
  - User controls encryption keys (not stored on servers)
  - Clear explanation of what data is backed up
  - One-click backup export
  - Ability to delete cloud backup permanently

**US-2.3**: As a user, I want to export all my health data in standard formats so that I own and can use my data elsewhere.
- **Acceptance Criteria**:
  - Export to CSV, JSON, and PDF formats
  - Include all raw sensor data and computed insights
  - Date range selection for exports
  - Export completes in < 10 seconds for 1 year of data

**US-2.4**: As a user, I want to permanently delete my data from the app and any backups so that I have complete control over my information.
- **Acceptance Criteria**:
  - Clear "Delete All Data" option in settings
  - Confirmation dialog explaining permanence
  - Deletes local data and cloud backups
  - Confirmation of deletion completion

### Epic 3: Menstrual Cycle Tracking & Prediction

**US-3.1**: As a user, I want to see my current cycle phase and predicted period start date so that I can plan accordingly.
- **Acceptance Criteria**:
  - Home screen shows current cycle day and phase
  - Calendar view highlights predicted period days
  - Prediction confidence level displayed
  - Updates daily based on new physiological data

**US-3.2**: As a user, I want to log my period start/end dates so that the ML model has accurate training data.
- **Acceptance Criteria**:
  - Quick one-tap period logging
  - Edit past period dates
  - Visual calendar confirmation
  - Data immediately incorporated into predictions

**US-3.3**: As a user, I want to receive notifications 2-3 days before my predicted period so that I can prepare.
- **Acceptance Criteria**:
  - Configurable notification timing (1-5 days advance)
  - Includes confidence level in notification
  - Ability to snooze or dismiss
  - Option to disable notifications

**US-3.4**: As a user, I want to see how my temperature, activity, and sleep correlate with my cycle phases so that I understand my body patterns.
- **Acceptance Criteria**:
  - Overlay charts showing physiological metrics vs cycle phase
  - Identify patterns (e.g., "Temperature rises during luteal phase")
  - Historical comparison across multiple cycles
  - Educational tooltips explaining correlations

**US-3.5**: As a user with irregular cycles, I want to see detection of unusual patterns so that I can seek medical advice if needed.
- **Acceptance Criteria**:
  - Alerts for cycle length variations > 7 days from baseline
  - Temperature anomaly detection (> 0.5°C deviation)
  - Suggestion to consult healthcare provider (not medical advice)
  - Historical view of irregularities

### Epic 4: Fertility Tracking

**US-4.1**: As a user planning pregnancy, I want to see my predicted fertile window so that I can optimize conception timing.
- **Acceptance Criteria**:
  - Calendar highlights 5-day fertile window
  - Peak fertility day marked distinctly
  - Based on temperature + PPG + cycle history
  - Confidence score displayed
  - Disclaimer: Not for contraceptive use

**US-4.2**: As a user practicing fertility awareness, I want to track basal body temperature (BBT) trends so that I can identify ovulation.
- **Acceptance Criteria**:
  - Daily BBT chart with trend line
  - Highlight temperature shift indicating ovulation
  - Overlay period and fertile window predictions
  - Historical comparison across cycles

**US-4.3**: As a user, I want fertility insights that don't make medical claims so that I have useful information without regulatory issues.
- **Acceptance Criteria**:
  - All fertility features marked "for informational purposes"
  - Clear disclaimer: not a contraceptive method
  - Suggestion to consult healthcare provider for fertility planning
  - Educational content about fertility awareness methods

### Epic 5: Health Monitoring & Insights

**US-5.1**: As a user, I want to see my daily step count and activity levels so that I can monitor my physical activity.
- **Acceptance Criteria**:
  - Real-time step count on home screen
  - Daily activity goal setting
  - Weekly bar chart histogram (reuse existing histogram component)
  - Activity streaks and achievements

**US-5.2**: As a user, I want to see temperature trends beyond cycle tracking so that I can detect potential illness or baseline changes.
- **Acceptance Criteria**:
  - Daily temperature chart (last 30 days)
  - Baseline temperature range calculated
  - Alerts for sustained temperature increases
  - Export temperature data for healthcare provider

**US-5.3**: As a user, I want to understand my heart rate variability (HRV) from PPG data so that I can monitor stress and recovery.
- **Acceptance Criteria**:
  - Daily HRV score calculated from PPG
  - Weekly HRV trends (reuse existing wykres1 chart component)
  - Correlation with sleep quality and activity
  - Educational content explaining HRV

**US-5.4**: As a user, I want a daily readiness score so that I understand my body's preparedness for activity.
- **Acceptance Criteria**:
  - 0-100 readiness score on home screen
  - Based on sleep, HRV, temperature, cycle phase
  - Explanation of contributing factors
  - Historical trend view

**US-5.5**: As a user, I want to receive unusual pattern alerts so that I'm aware of significant health changes.
- **Acceptance Criteria**:
  - Sustained elevated temperature (> 3 days)
  - Significant HRV drops (> 30% from baseline)
  - Unusual activity patterns (very low activity > 3 days)
  - Recommendation to seek medical advice if concerned

### Epic 6: Symptom & Lifestyle Tracking

**US-6.1**: As a user, I want to log symptoms (cramps, headaches, mood, energy) so that I can correlate them with my cycle.
- **Acceptance Criteria**:
  - Quick symptom logging with predefined categories
  - Custom symptom creation
  - Intensity rating (1-5 scale)
  - Calendar view showing symptom patterns

**US-6.2**: As a user, I want to see which symptoms correlate with specific cycle phases so that I can anticipate and manage them.
- **Acceptance Criteria**:
  - Insights showing symptom frequency by cycle phase
  - Example: "You typically experience cramps 2 days before period"
  - Historical symptom patterns across multiple cycles
  - Export symptom reports for healthcare provider

**US-6.3**: As a user, I want to log lifestyle factors (sleep quality, stress, exercise) so that I can see their impact on my health.
- **Acceptance Criteria**:
  - Quick daily logging interface
  - Sleep quality auto-detected from ring data when possible
  - Manual stress level input (reuse Stres component from zdrowie.dart)
  - Exercise type and duration tracking

**US-6.4**: As a user, I want to see how lifestyle factors affect my cycle and overall health so that I can make informed choices.
- **Acceptance Criteria**:
  - Correlation analysis (e.g., "High stress correlates with irregular cycles")
  - Impact of exercise on sleep quality
  - Lifestyle recommendations based on patterns
  - No medical claims - educational insights only

### Epic 7: Calendar & Event Management

**US-7.1**: As a user, I want a visual calendar showing my cycle, predictions, and logged events so that I have a comprehensive view.
- **Acceptance Criteria**:
  - Monthly calendar view (reuse existing TableCalendar from cykl.dart)
  - Color-coded cycle phases
  - Period days highlighted
  - Fertile window marked
  - Custom events and notes

**US-7.2**: As a user, I want to add notes and events to specific dates so that I can remember important context.
- **Acceptance Criteria**:
  - Tap any date to add note (reuse Event system from kalendarz/event.dart)
  - Event categories (appointment, symptom, note, etc.)
  - Edit/delete events
  - Search events by keyword

### Epic 8: Onboarding & Education

**US-8.1**: As a new user, I want a simple onboarding flow so that I can quickly start using the app.
- **Acceptance Criteria**:
  - 3-screen onboarding: Welcome, Privacy Explanation, Ring Pairing
  - Skip option available
  - Initial profile setup (cycle length, last period)
  - Clear value proposition on privacy

**US-8.2**: As a user, I want educational content about cycle phases and physiology so that I can better understand my data.
- **Acceptance Criteria**:
  - Info tooltips throughout app
  - Dedicated education section
  - Explanations of: cycle phases, temperature tracking, HRV, fertility awareness
  - No medical advice - general education only

**US-8.3**: As a user, I want to understand how the ML model works so that I can trust the predictions.
- **Acceptance Criteria**:
  - Plain-language explanation of ML approach
  - What data is used for predictions
  - Why accuracy improves over time
  - Transparency about limitations

### Epic 9: Ring Management

**US-9.1**: As a user, I want to see ring connection status and battery level so that I know my device is working properly.
- **Acceptance Criteria**:
  - Connection indicator on home screen
  - Battery percentage visible
  - Last sync time displayed
  - Troubleshooting guide for connection issues

**US-9.2**: As a user, I want to manually trigger data sync so that I can ensure data is up-to-date.
- **Acceptance Criteria**:
  - Pull-to-refresh gesture
  - Manual sync button in settings
  - Sync progress indicator
  - Success/failure notification

**US-9.3**: As a user, I want to configure ring settings (LED brightness, vibration, wear detection) so that I can customize my experience.
- **Acceptance Criteria**:
  - Settings screen with ring configuration options
  - Changes sync to ring immediately
  - Default settings optimized for battery life
  - Preview of LED/vibration before saving

---

## Functional Requirements

### Data Collection
- **FR-1.1**: Ring shall collect step count data continuously with ±5% accuracy
- **FR-1.2**: Ring shall measure skin temperature every 5 minutes with ±0.1°C accuracy
- **FR-1.3**: Ring shall collect accelerometer data at 25Hz for activity classification
- **FR-1.4**: Ring shall collect PPG data at 100Hz for HRV calculation
- **FR-1.5**: Ring shall store minimum 7 days of data in local flash memory
- **FR-1.6**: App shall sync with ring automatically when in Bluetooth range (< 10m)
- **FR-1.7**: Full data sync shall complete in < 30 seconds for 24 hours of data

### Data Processing
- **FR-2.1**: All ML inference shall run on-device (iOS: Core ML, Android: TensorFlow Lite)
- **FR-2.2**: Cycle prediction model shall update daily at user-configured time
- **FR-2.3**: HRV calculation shall use RMSSD algorithm from PPG R-R intervals
- **FR-2.4**: Basal body temperature shall be calculated from nighttime minimum temperature
- **FR-2.5**: Activity classification shall distinguish: resting, walking, moderate exercise, vigorous exercise
- **FR-2.6**: Readiness score algorithm shall weight: HRV (30%), sleep (30%), temperature (20%), cycle phase (20%)

### Data Storage
- **FR-3.1**: Local database shall use SQLite with SQLCipher encryption (AES-256)
- **FR-3.2**: Database encryption key shall be stored in platform keychain (iOS Keychain, Android Keystore)
- **FR-3.3**: App shall store minimum 2 years of historical data locally
- **FR-3.4**: Optional cloud backup shall use end-to-end encryption with user-controlled keys
- **FR-3.5**: Cloud backup sync shall be manual or scheduled (daily/weekly/never)

### Privacy & Security
- **FR-4.1**: No personally identifiable health data shall be transmitted without encryption
- **FR-4.2**: No health data shall be used for advertising or sold to third parties
- **FR-4.3**: Analytics shall be anonymized and aggregated (no individual tracking)
- **FR-4.4**: Biometric authentication (Face ID, Touch ID, fingerprint) shall be required to access app
- **FR-4.5**: App shall function fully offline (except optional cloud backup)
- **FR-4.6**: Privacy policy shall be displayed before first use and accepted explicitly

### Notifications
- **FR-5.1**: Notifications shall be configurable per category (cycle, health, ring status)
- **FR-5.2**: Notification content shall not reveal sensitive health info in preview (e.g., "Mira notification" not "Your period starts tomorrow")
- **FR-5.3**: Quiet hours shall be configurable to suppress non-urgent notifications

### Data Export
- **FR-6.1**: Export shall include: raw sensor data, processed metrics, cycle data, symptoms, notes
- **FR-6.2**: CSV export format shall be compatible with common spreadsheet software
- **FR-6.3**: JSON export shall follow FHIR-compatible schema where applicable
- **FR-6.4**: PDF export shall include charts and summary statistics

---

## Non-Functional Requirements

### Performance
- **NFR-1.1**: App launch time < 2 seconds on devices from last 3 years
- **NFR-1.2**: Screen transitions < 200ms
- **NFR-1.3**: ML inference latency < 500ms on-device
- **NFR-1.4**: Battery impact < 5% per day with continuous Bluetooth connection
- **NFR-1.5**: App size < 50MB initial download, < 200MB with ML models

### Reliability
- **NFR-2.1**: App crash rate < 0.1% of sessions
- **NFR-2.2**: Data sync success rate > 99%
- **NFR-2.3**: Zero data loss during app updates or crashes
- **NFR-2.4**: Graceful degradation if ring disconnected

### Usability
- **NFR-3.1**: Support iOS 15+ and Android 9+
- **NFR-3.2**: Accessibility: VoiceOver/TalkBack support, minimum contrast ratios (WCAG AA)
- **NFR-3.3**: Localization: English and Polish at launch (extensible to other languages)
- **NFR-3.4**: Design system shall use neumorphic style (consistent with current demo app)
- **NFR-3.5**: All primary tasks achievable in ≤ 3 taps

### Scalability
- **NFR-4.1**: Architecture shall support future multi-user profiles (out of scope for v1)
- **NFR-4.2**: ML model architecture shall support over-the-air updates
- **NFR-4.3**: Database schema shall be versioned with migration support

### Compliance
- **NFR-5.1**: GDPR compliant: right to access, delete, export data
- **NFR-5.2**: CCPA compliant: privacy policy, opt-out mechanisms
- **NFR-5.3**: App Store and Google Play health data policies compliant
- **NFR-5.4**: Medical disclaimer: "Not intended for medical diagnosis or contraception"

---

## Technical Architecture

### Mobile App Stack
- **Platform**: Flutter 3.x (cross-platform iOS/Android)
- **Language**: Dart 3.x
- **Local Database**: SQLite with SQLCipher encryption
- **ML Framework**:
  - iOS: Core ML via flutter_coreml or tflite_flutter
  - Android: TensorFlow Lite via tflite_flutter
- **Bluetooth**: flutter_blue_plus for BLE communication
- **Charts**: fl_chart (already in use)
- **Calendar**: table_calendar (already in use)
- **State Management**: Provider or Riverpod
- **Biometric Auth**: local_auth package

### Ring Firmware (Assumptions)
- **MCU**: Nordic nRF52/nRF53 series or equivalent
- **Sensors**:
  - Accelerometer: 3-axis, 25Hz sampling
  - Temperature: NTC thermistor or equivalent
  - PPG: 1-2 LED optical sensor
- **Storage**: Flash memory for ≥7 days buffering
- **Communication**: BLE 5.0+
- **Battery**: 5-7 day life with continuous sensing

### ML Model Architecture
- **Model Type**: LSTM or 1D CNN for time-series cycle prediction
- **Inputs**:
  - Daily: BBT, resting HR, HRV, activity level
  - Historical: cycle lengths, period lengths
  - Optional: symptom logs
- **Outputs**:
  - Cycle phase probabilities (menstrual, follicular, ovulation, luteal)
  - Period start date prediction (± confidence interval)
  - Fertile window prediction
- **Training**: Pre-trained on anonymized dataset, personalizes on-device with user data
- **Model Size**: < 10MB for on-device deployment
- **Update Frequency**: Daily inference, monthly personalization retraining

### Data Flow
1. **Collection**: Ring sensors → Ring flash storage
2. **Transmission**: Ring BLE → App via flutter_blue_plus
3. **Processing**: Raw data → Feature extraction → ML inference (on-device)
4. **Storage**: Processed data → SQLite (encrypted)
5. **Display**: Database → UI widgets (reusing MainShape, charts, etc.)
6. **Backup** (optional): Encrypted data → User-controlled cloud storage

### API Design (Ring ↔ App BLE Protocol)
- **Characteristics**:
  - Data Stream: Ring → App (notify)
  - Control: App → Ring (write)
  - Status: Ring → App (read/notify)
- **Data Packets**: Timestamped sensor readings (compressed)
- **Control Commands**: Sync request, settings update, battery query

---

## User Experience

### Visual Design
- **Design Language**: Neumorphic (soft shadows, subtle depth) - consistent with current demo
- **Color Palette**:
  - Primary: Soft purple/pink (#EC9FE6 - consistent with current app)
  - Accent: Teal/turquoise for health metrics
  - Background: Light pastels with texture overlays
  - Cycle phases: Color-coded (pink=period, blue=follicular, green=fertile, purple=luteal)
- **Typography**: Clean sans-serif, high readability
- **Components**: Reuse MainShape container, fl_chart visualizations, table_calendar

### Key Screens (extending current demo)
1. **Home Dashboard**:
   - Cycle day & phase
   - Next period prediction
   - Readiness score
   - Quick action buttons (log period, symptoms)
   - Ring connection status

2. **Calendar** (extend existing cykl.dart):
   - Month view with cycle overlay
   - Period days, fertile window, ovulation
   - Event/symptom markers
   - Tap date for details/logging

3. **Activity** (extend existing aktywnosc.dart):
   - Step count (already implemented)
   - Weekly histogram (already implemented)
   - Activity goals
   - Correlation with cycle phase

4. **Health** (extend existing zdrowie.dart):
   - Temperature trends (new)
   - HRV chart (already implemented as StressChart)
   - Sleep quality (new)
   - Readiness score (new)

5. **Insights**:
   - Cycle analysis (average length, regularity)
   - Symptom patterns
   - Lifestyle correlations
   - Educational content

6. **Settings**:
   - Ring management
   - Privacy & data controls
   - Notifications
   - Profile (cycle parameters)
   - Export/backup

### Navigation
- **Bottom Navigation Bar** (5 tabs):
  - Home, Calendar, Activity, Health, Insights
- **Settings**: Top-right icon on home screen
- **Modal overlays**: Symptom logging, event creation

### Interaction Patterns
- **Swipe**: Navigate between days on calendar
- **Pull-to-refresh**: Sync ring data
- **Long-press**: Edit existing entries
- **Quick actions**: Floating action button for common tasks (log period)

---

## Success Metrics & KPIs

### User Engagement
- Daily Active Users / Monthly Active Users (DAU/MAU) > 40%
- Average session length > 3 minutes
- Sessions per day > 2 (morning check-in, evening logging)
- Feature adoption:
  - 90% use cycle tracking
  - 60% use symptom logging
  - 40% use fertility tracking
  - 30% enable cloud backup
  - 20% export data

### Product Quality
- Cycle prediction accuracy > 85% (±1 day) after 2 cycles
- App crash rate < 0.1%
- Sync success rate > 99%
- Average App Store rating > 4.5/5.0
- Customer support tickets < 5% of MAU

### Privacy & Trust
- Zero data breach incidents
- Privacy policy acceptance rate 100% (required)
- Cloud backup opt-in rate (measure of trust)
- Data export usage (measure of user empowerment)

### Business Metrics (if applicable)
- User retention:
  - Day 7: > 60%
  - Day 30: > 40%
  - Day 90: > 30%
- Organic growth rate (word-of-mouth)
- NPS (Net Promoter Score) > 50

---

## Out of Scope (Version 1.0)

### Explicitly Excluded Features
- ❌ Multiple user profiles or family sharing
- ❌ Social features (sharing data, community)
- ❌ Integration with third-party health apps (Apple Health, Google Fit) - future consideration
- ❌ Telemedicine or healthcare provider integration
- ❌ Contraceptive efficacy claims (regulatory compliance)
- ❌ Pregnancy mode or pregnancy tracking
- ❌ Menopause-specific features
- ❌ Medication reminders
- ❌ Partner/spouse accounts
- ❌ Web dashboard
- ❌ Smartwatch companion app
- ❌ Voice assistant integration

### Deferred to Future Versions
- 🔜 **v1.1**: Apple Health / Google Fit integration (read-only export)
- 🔜 **v1.2**: Advanced insights (cycle irregularity scoring, PCOS detection assistance)
- 🔜 **v1.3**: Healthcare provider data sharing (secure PDF reports)
- 🔜 **v2.0**: Pregnancy tracking mode (different sensor interpretation)
- 🔜 **v2.0**: Partner notifications (opt-in cycle sharing)
- 🔜 **v2.5**: Perimenopause/menopause support

---

## Risks & Mitigation

### Technical Risks
| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| On-device ML insufficient accuracy | High | Medium | Pre-train with quality dataset; allow 2-3 cycles for personalization; hybrid cloud option in v2 |
| Bluetooth connectivity issues | High | Medium | Robust retry logic; offline data storage on ring; clear user feedback |
| Battery drain from continuous BLE | Medium | High | Optimize sync frequency; allow scheduling; adaptive sync based on proximity |
| Platform fragmentation (iOS/Android) | Medium | High | Use Flutter for cross-platform; thorough testing on multiple devices |

### Regulatory Risks
| Risk | Impact | Likelihood | Mitigation |
| Medical device classification | High | Low | Explicit disclaimers; no medical claims; wellness positioning; consult legal counsel |
| GDPR/CCPA compliance violations | High | Low | Privacy-by-design; legal review; explicit consent flows |
| App store rejection | Medium | Low | Follow guidelines; health data disclosures; content review |

### Business Risks
| Risk | Impact | Likelihood | Mitigation |
| Low user trust in privacy claims | High | Medium | Open-source core ML models; third-party privacy audits; transparent communication |
| Competitor feature parity | Medium | High | Focus on privacy differentiation; superior UX; continuous innovation |
| Hardware issues affecting data quality | High | Medium | Robust error handling; data quality indicators; user education |

### User Experience Risks
| Risk | Impact | Likelihood | Mitigation |
| Onboarding too complex | Medium | Medium | Streamlined 3-screen onboarding; defer advanced features; progressive disclosure |
| Prediction inaccuracy causing distrust | High | Medium | Clear confidence levels; educational content on limitations; improve over time |
| Notification fatigue | Medium | High | Configurable notifications; smart defaults (minimal); quiet hours |

---

## Development Roadmap

### Phase 1: MVP Core (Months 1-3)
- Ring connectivity and data sync
- Basic cycle tracking and period logging
- Calendar view with predictions
- Activity tracking (steps, histogram)
- Local data storage (encrypted)
- Minimal viable UI (Home, Calendar, Activity screens)

### Phase 2: ML & Insights (Months 3-4)
- On-device ML model integration
- Cycle prediction algorithm
- Temperature tracking and BBT calculation
- HRV calculation from PPG
- Basic insights and correlations

### Phase 3: Complete Feature Set (Months 4-5)
- Fertility window prediction
- Symptom tracking
- Lifestyle logging
- Health monitoring (readiness score)
- Unusual pattern alerts
- Educational content

### Phase 4: Polish & Privacy (Month 5-6)
- Optional encrypted cloud backup
- Data export (CSV, JSON, PDF)
- Notification system
- Biometric authentication
- Onboarding flow
- Accessibility improvements
- Privacy policy and compliance review

### Phase 5: Beta & Launch (Month 6)
- Beta testing (100 users)
- Bug fixes and performance optimization
- App Store / Play Store submission
- Marketing materials
- Public launch

---

## Appendix

### Glossary
- **BBT (Basal Body Temperature)**: Lowest body temperature during rest, used to detect ovulation
- **HRV (Heart Rate Variability)**: Variation in time between heartbeats, indicator of stress and recovery
- **PPG (Photoplethysmography)**: Optical technique to measure blood volume changes (for HR/HRV)
- **Neumorphic Design**: UI style with soft shadows creating subtle 3D appearance
- **Luteal Phase**: Post-ovulation phase of menstrual cycle
- **Follicular Phase**: Pre-ovulation phase of menstrual cycle
- **RMSSD**: Root Mean Square of Successive Differences, HRV calculation method

### References
- Flutter documentation: https://flutter.dev
- fl_chart: https://pub.dev/packages/fl_chart
- table_calendar: https://pub.dev/packages/table_calendar
- GDPR compliance: https://gdpr.eu
- FDA mobile medical app guidance: https://www.fda.gov/medical-devices/digital-health
- Femtech privacy best practices: https://www.privacyinternational.org/long-read/4312/femtech-apps

### Document Revision History
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-11-05 | Product Team | Initial PRD based on user requirements |

---

**Approval Signatures:**
- Product Manager: _________________ Date: _______
- Engineering Lead: _________________ Date: _______
- Design Lead: _________________ Date: _______
- Privacy Officer: _________________ Date: _______

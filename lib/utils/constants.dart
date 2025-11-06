// utils/constants.dart

/// Application-wide constants
///
/// This file contains all hardcoded values used throughout the app.
/// Using constants makes the code more maintainable and easier to change.

// ============ DATABASE ============
const String DATABASE_NAME = 'mira.db';
const int DATABASE_VERSION = 1;

// ============ HEALTH DEFAULTS ============
const int DEFAULT_DAILY_STEP_GOAL = 10000;
const int DEFAULT_CYCLE_LENGTH = 28;
const int DEFAULT_PERIOD_LENGTH = 5;

// ============ UI ============
const double MAIN_SHAPE_HEIGHT = 50.0;
const double MAIN_SHAPE_WIDTH = 400.0;
const double MAIN_SHAPE_BORDER_RADIUS = 15.0;
const double CHART_HEIGHT = 200.0;

// ============ ANIMATION ============
const Duration ANIMATION_DURATION = Duration(milliseconds: 300);

// ============ ROUTES ============
const String ROUTE_HOME = '/glowny';
const String ROUTE_ACTIVITY = '/aktywnosc';
const String ROUTE_HEALTH = '/zdrowie';
const String ROUTE_CYCLE = '/cykl';

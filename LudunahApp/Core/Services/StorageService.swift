// StorageService.swift - storage + weekly progress.
//
// Contains:
// - A final class, the only place that reads and writes saved data (UserDefaults).
// - Save and load: onboarding completed, selected interests.
// - Record a completed activity (ActivityProgress).
// - Weekly progress: completed count for each of the last 7 days.
// - Reset progress, reset everything.
//
// Used by: AppState, HomeViewModel.
// Learn: UserDefaults, Codable, JSONEncoder, Calendar

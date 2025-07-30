import Foundation
import DeviceActivity
import FamilyControls

/// A shared scheduler for "phoneUse" monitoring.
enum Activity {
  static let phoneUse = DeviceActivityName("phoneUse")
}

class DeviceActivityScheduler {
  static let shared = DeviceActivityScheduler()
  private let center = DeviceActivityCenter()

  /// Ask Screen Time / Family Controls permission.
  func requestAuthorization(completion: @escaping (Bool) -> Void) {
    // AuthorizationCenter's API is async, so bridge it back to a closure-based callback
    Task {
      do {
        // Request permission for the current (individual) user of the device.
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)

        // Check whether the user actually granted the permission.
        let approved = AuthorizationCenter.shared.authorizationStatus == .approved

        // Report back on the main thread.
        DispatchQueue.main.async {
          completion(approved)
        }
      } catch {
        print("❌ Failed to obtain Screen Time / Family Controls authorization:", error)
        DispatchQueue.main.async {
          completion(false)
        }
      }
    }
  }

  /// Start monitoring from the given "put-away" time until end-of-day,
  /// sending a threshold event every `intervalMinutes` of usage.
  func startMonitoring(
    atHour hour: Int,
    minute: Int,
    intervalMinutes: Int = 5
  ) {
      _ = Calendar.current

    // 1. Define your daily window
    let startDC = DateComponents(hour: hour, minute: minute)
    let endDC   = DateComponents(hour: 23,    minute: 59)
    let schedule = DeviceActivitySchedule(
      intervalStart: startDC,
      intervalEnd:   endDC,
      repeats:       true
    )

    // 2. Fire a threshold event every `intervalMinutes` of active usage
    let thresholdDC = DateComponents(minute: intervalMinutes)
    let event = DeviceActivityEvent(threshold: thresholdDC)

    do {
      try center.startMonitoring(
        Activity.phoneUse,
        during: schedule,
        events: [DeviceActivityEvent.Name("usageInterval"): event]
      )
      print("✅ Started phone-use monitoring @ \(hour):\(minute), every \(intervalMinutes)m")
    } catch {
      print("❌ Could not start monitoring:", error)
    }
  }

  /// Stop it (if you ever need to)
  func stopMonitoring() {
    center.stopMonitoring([Activity.phoneUse])
  }

  /// Apply (save & optionally activate) the given SettingsModel.
  ///
  /// If `settings.isActive` is `true`, the scheduler will (re)start monitoring
  /// using the first DaySettings entry's start time and the provided
  /// `intervalMinutes`. If `isActive` is `false`, the current monitoring session
  /// will be stopped instead. This gives the UI a single entry-point for
  /// persisting changes while ensuring we only run the heavy-weight monitoring
  /// features when explicitly activated by the user.
  func apply(settings: SettingsModel) {
      // Persist settings to disk so that they survive app restarts.
      // For the sake of this sample we encode them into `UserDefaults`.
      do {
          let data = try JSONEncoder().encode(settings.days)
          UserDefaults.standard.set(data, forKey: "angryReminders.days")
          UserDefaults.standard.set(settings.intervalMinutes, forKey: "angryReminders.intervalMinutes")
          UserDefaults.standard.set(settings.angerPhrases, forKey: "angryReminders.angerPhrases")
          UserDefaults.standard.set(settings.isActive, forKey: "angryReminders.isActive")
      } catch {
          print("⚠️ Failed to persist settings:", error)
      }

      // Start or stop monitoring depending on the `isActive` flag.
      guard settings.isActive else {
          stopMonitoring()
          return
      }

      // Derive the hour/minute from the first active day (for simplicity).
      guard let firstDay = settings.days.first else { return }
      let comps = Calendar.current.dateComponents([.hour, .minute], from: firstDay.startTime)
      guard let hour = comps.hour, let minute = comps.minute else { return }

      startMonitoring(
          atHour: hour,
          minute: minute,
          intervalMinutes: settings.intervalMinutes
      )
  }
}

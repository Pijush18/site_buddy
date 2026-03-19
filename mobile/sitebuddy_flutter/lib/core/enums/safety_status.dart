/// Enum representing the safety status of a structural design element.
enum SafetyStatus {
  /// Design satisfies all code requirements.
  safe,

  /// Design satisfies requirements but is close to limits or needs attention.
  warning,

  /// Design fails one or more critical code requirements.
  fail,
}

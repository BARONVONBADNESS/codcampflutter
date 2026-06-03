class CoachingRequest {
  final String mode;
  final String weakness;
  final String goal;
  final String sessionLength;
  final String urgency;
  final String notes;
  final bool patchAware;
  final bool includeLoadoutReview;
  final bool includeVodReview;

  const CoachingRequest({
    required this.mode,
    required this.weakness,
    required this.goal,
    required this.sessionLength,
    required this.urgency,
    required this.notes,
    required this.patchAware,
    required this.includeLoadoutReview,
    required this.includeVodReview,
  });
}

/// FullRequest holds a list of CoachingRequest snapshots
/// and provides convenient access to the latest state.
/// Used by RequestSummary to display animated terminal-style previews.
class FullRequest {
  const FullRequest({
    this.snapshots = const [],
  });

  final List<CoachingRequest> snapshots;

  /// Returns the most recent CoachingRequest snapshot, or null if empty
  CoachingRequest? get latest {
    if (snapshots.isEmpty) return null;
    return snapshots.last;
  }
}
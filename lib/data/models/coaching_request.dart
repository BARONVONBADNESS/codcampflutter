class CoachingRequest {
  final String? requestId; // assigned by server; null if server unreachable
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
    this.requestId,
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

  CoachingRequest copyWithRequestId(String id) => CoachingRequest(
    requestId:            id,
    mode:                 mode,
    weakness:             weakness,
    goal:                 goal,
    sessionLength:        sessionLength,
    urgency:              urgency,
    notes:                notes,
    patchAware:           patchAware,
    includeLoadoutReview: includeLoadoutReview,
    includeVodReview:     includeVodReview,
  );
}

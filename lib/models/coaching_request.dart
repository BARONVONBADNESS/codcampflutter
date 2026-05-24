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
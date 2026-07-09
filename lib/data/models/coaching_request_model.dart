// Model classes for the request_form.dart / request_summary.dart widgets.
// CoachingRequestController is a mutable state bag used by the form.
// FullRequest + RequestSnapshot are immutable read models used by the summary.

/// Mutable controller holding all coaching request form fields.
class CoachingRequestController {
  String mode = 'Ranked';
  String modeDetail = '';
  String weakness = '';
  String goal = '';
  /// Stored as a string so it can be bound directly to a TextField.
  String sessionLength = '60';
  String urgency = 'Within 24h';
  bool patchAware = true;
  bool includeLoadoutReview = false;
  bool includeVodReview = false;
  String notes = '';
}

/// Immutable snapshot of a submitted coaching request, used by the preview.
class RequestSnapshot {
  final String mode;
  final String modeDetail;
  final String weakness;
  final String goal;
  /// Parsed to int so the summary can call `.toInt()` safely.
  final int sessionLength;
  final String urgency;
  final bool patchAware;
  final bool includeLoadoutReview;
  final bool includeVodReview;
  final String notes;

  const RequestSnapshot({
    required this.mode,
    required this.modeDetail,
    required this.weakness,
    required this.goal,
    required this.sessionLength,
    required this.urgency,
    required this.patchAware,
    required this.includeLoadoutReview,
    required this.includeVodReview,
    required this.notes,
  });

  factory RequestSnapshot.fromController(CoachingRequestController c) {
    return RequestSnapshot(
      mode: c.mode,
      modeDetail: c.modeDetail,
      weakness: c.weakness,
      goal: c.goal,
      sessionLength: int.tryParse(c.sessionLength) ?? 60,
      urgency: c.urgency,
      patchAware: c.patchAware,
      includeLoadoutReview: c.includeLoadoutReview,
      includeVodReview: c.includeVodReview,
      notes: c.notes,
    );
  }
}

/// Wrapper used by RequestSummary — holds the latest submitted snapshot.
class FullRequest {
  final RequestSnapshot? latest;

  const FullRequest({this.latest});
}

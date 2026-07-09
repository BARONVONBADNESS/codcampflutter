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
  final int messageCount; // how many messages in the thread

  const CoachingRequest({
    this.requestId,
    required this.mode,
    this.weakness = '',
    this.goal = '',
    this.sessionLength = '',
    this.urgency = '',
    this.notes = '',
    this.patchAware = true,
    this.includeLoadoutReview = false,
    this.includeVodReview = false,
    this.messageCount = 0,
  });

  /// Parse a coaching request from the server JSON (GET /api/requests).
  factory CoachingRequest.fromJson(Map<String, dynamic> json) {
    final messages = json['messages'] as List<dynamic>?;
    return CoachingRequest(
      requestId:            json['requestId'] as String?,
      mode:                 (json['mode'] as String?) ?? '',
      weakness:             (json['weakness'] as String?) ?? '',
      goal:                 (json['goal'] as String?) ?? '',
      sessionLength:        (json['sessionLength'] as String?) ?? '',
      urgency:              (json['urgency'] as String?) ?? '',
      notes:                (json['notes'] as String?) ?? '',
      patchAware:           json['patchAware'] == true,
      includeLoadoutReview: json['includeLoadoutReview'] == true,
      includeVodReview:     json['includeVodReview'] == true,
      messageCount:         messages?.length ?? 0,
    );
  }

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
    messageCount:         messageCount,
  );
}

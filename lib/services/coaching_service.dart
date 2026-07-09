import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/coaching_request.dart';
import '../data/models/chat_message.dart';
import 'auth_service.dart';
import 'tips_service.dart'; // reuses kTipsBaseUrl (same server, same port)

class CoachingService {
  /// POST /api/requests — returns the server-assigned requestId, or null on failure.
  static Future<String?> submitRequest(CoachingRequest request) async {
    try {
      // Resolve user identity + delivery preference from AuthService.
      final user       = AuthService.currentUser;
      final deliveryPref = AuthService.deliveryPreference;

      final response = await http
          .post(
            Uri.parse('$kTipsBaseUrl/api/requests'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'memberName':           user?.displayName ?? 'Member',
              'userId':               AuthService.userId,
              'discordId':            AuthService.discordId,
              // 'app' → Lt. Reaper posts to in-app inbox.
              // 'discord' → Lt. Reaper DMs via OpenClaw bot.
              'deliveryPreference':   deliveryPref == DeliveryPreference.discord
                                        ? 'discord'
                                        : 'app',
              'mode':                 request.mode,
              'weakness':             request.weakness,
              'goal':                 request.goal,
              'sessionLength':        request.sessionLength,
              'urgency':              request.urgency,
              'notes':                request.notes,
              'patchAware':           request.patchAware,
              'includeLoadoutReview': request.includeLoadoutReview,
              'includeVodReview':     request.includeVodReview,
            }),
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['requestId'] as String?;
      }
    } catch (e) {
      // ignore: avoid_print
      print('[CoachingService] submitRequest failed: $e');
    }
    return null;
  }

  /// POST /api/messages — send a message from the member side.
  static Future<bool> sendMessage(String requestId, String text) async {
    try {
      final response = await http
          .post(
            Uri.parse('$kTipsBaseUrl/api/messages'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'requestId':  requestId,
              'sender':     'member',
              'senderName': 'Member',
              'text':       text,
            }),
          )
          .timeout(const Duration(seconds: 6));
      return response.statusCode == 201;
    } catch (e) {
      // ignore: avoid_print
      print('[CoachingService] sendMessage failed: $e');
      return false;
    }
  }

  /// GET /api/requests?userId=X — fetch the user's coaching request history.
  static Future<List<CoachingRequest>> fetchHistory(String userId) async {
    try {
      final response = await http
          .get(Uri.parse('$kTipsBaseUrl/api/requests?userId=$userId'))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final reqs = data['requests'] as List<dynamic>;
        return reqs
            .map((r) => CoachingRequest.fromJson(r as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      // ignore: avoid_print
      print('[CoachingService] fetchHistory failed: $e');
    }
    return [];
  }

  /// DELETE /api/requests/:requestId — remove a coaching request from the server.
  static Future<bool> deleteRequest(String requestId) async {
    try {
      final response = await http
          .delete(Uri.parse('$kTipsBaseUrl/api/requests/$requestId'))
          .timeout(const Duration(seconds: 6));
      return response.statusCode == 200;
    } catch (e) {
      // ignore: avoid_print
      print('[CoachingService] deleteRequest failed: $e');
      return false;
    }
  }

  /// GET /api/messages/:requestId — fetch the thread for a coaching request.
  static Future<List<ChatMessage>> getMessages(String requestId) async {
    try {
      final response = await http
          .get(Uri.parse('$kTipsBaseUrl/api/messages/$requestId'))
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final msgs = data['messages'] as List<dynamic>;
        return msgs
            .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      // ignore: avoid_print
      print('[CoachingService] getMessages failed: $e');
    }
    return [];
  }
}

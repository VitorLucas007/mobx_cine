import 'dart:convert';

import 'package:mobx_cine/features/tickets/data/models/ticket_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketLocalDataSource {
  TicketLocalDataSource(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'tickets';

  List<TicketModel> getAll() {
    final raw = _prefs.getString(_key);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((e) => TicketModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> save(TicketModel ticket) async {
    final all = getAll()..add(ticket);
    await _prefs.setString(_key, jsonEncode(all.map((t) => t.toJson()).toList()));
  }
}

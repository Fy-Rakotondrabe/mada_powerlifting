import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lights/services/services.dart';

final serverConnectionProvider =
    Provider.family<ServerConnection, String>((ref, url) {
  return ServerConnection(
    url,
    (data) {
      log(data.toString());
    },
  );
});

import 'dart:developer';
import 'dart:io';

import 'package:admin/api/handler.dart';
import 'package:admin/providers/screen.dart';
import 'package:admin/providers/server.dart';
import 'package:admin/router.dart';
import 'package:admin/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1400, 800),
    minimumSize: Size(1000, 500),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    alwaysOnTop: true,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  final container = ProviderContainer();
  final serverHandler = ServerHandler(container);

  // Start the server
  final server = await shelf_io.serve(
    serverHandler.handler,
    InternetAddress.anyIPv4,
    8080,
  );

  // Get the host IP address
  final interfaces = await NetworkInterface.list(
    type: InternetAddressType.IPv4,
  );
  final hostAddress = interfaces.first.addresses.first.address;
  final serverUrl = 'http://$hostAddress:${server.port}';

  log(serverUrl);

  runApp(
    ProviderScope(
      overrides: [
        serverUrlProvider.overrideWith((ref) => serverUrl),
      ],
      parent: container,
      child: const Admin(),
    ),
  );
}

class Admin extends ConsumerStatefulWidget {
  const Admin({super.key});

  @override
  ConsumerState<Admin> createState() => _AdminState();
}

class _AdminState extends ConsumerState<Admin> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Set up listener for key events
    _focusNode.requestFocus();
    HardwareKeyboard.instance.addHandler(_handleKeyPress);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyPress);
    _focusNode.dispose();
    super.dispose();
  }

  // Function to handle key presses
  bool _handleKeyPress(KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      ref.read(frameLessProvider.notifier).setFrameLess(false);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Admin',
        theme: themeData,
        routerConfig: router,
      ),
    );
  }
}

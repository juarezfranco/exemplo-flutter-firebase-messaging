import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> _manipularMensagem(RemoteMessage message) async {
  if (message.data["awesome_notifications"] != null) {
    await AwesomeNotifications().createNotificationFromJsonData(
      jsonDecode(message.data["awesome_notifications"]),
    );
  }

  if (message.data["url_callback_recebimento"] != null) {
    await Firebase.initializeApp();
    final token = await FirebaseMessaging.instance.getToken();
    print("recebimento: ${message.data["url_callback_recebimento"]}");
    print("token: $token");
  }
}

Future<void> _manipularAcoes(action) async {
  if (action.payload?["url_callback_interacao"] != null) {
    await Firebase.initializeApp();
    final token = await FirebaseMessaging.instance.getToken();
    print("interação: ${action.payload!["url_callback_interacao"]}");
    print("token: $token");
  }

  switch (action.buttonKeyPressed) {
    case 'ABRIR_WEBVIEW':
      // ...
      break;
  }
}

Future<void> inicializarAwesomeNotifications() async {
  const icone = 'resource://mipmap/ic_launcher';
  const canal = 'high_importance_channel';
  const debug = true;

  final awesomeNotifications = AwesomeNotifications();
  if (!await awesomeNotifications.isNotificationAllowed()) {
    awesomeNotifications.requestPermissionToSendNotifications();
  }

  awesomeNotifications.initialize(
    icone,
    [
      NotificationChannel(
        channelKey: canal,
        channelName: 'Canal de notificações',
        channelDescription: 'Canal de notificações',
        importance: NotificationImportance.High,
      ),
    ],
    debug: debug,
  );

  // msg recebida em segundo plano
  FirebaseMessaging.onBackgroundMessage(_manipularMensagem);
  // msg recebida em primeiro plano
  FirebaseMessaging.onMessage.listen(_manipularMensagem);
  // interacoes na notificaçao
  awesomeNotifications.actionStream.listen(_manipularAcoes);
}

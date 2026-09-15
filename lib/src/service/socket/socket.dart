import 'dart:async';
import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart';
import 'package:sovchilar/src/data/user_status.dart';

import '../../data/get_con.dart';
import '../../data/get_mes.dart';
import '../../data/get_new_con.dart';
import '../../data/get_new_message.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() => _instance;

  SocketService._internal();

  final StreamController<List<DataMes>> _messageController =
  StreamController<List<DataMes>>.broadcast();

  Stream<List<DataMes>> get messageStream => _messageController.stream;

  Socket? _socket;

  String _userId = '';
  String _accessToken = '';
  String _consId = '';

  String get userId => _userId;

  String get consId => _consId;

  Socket get socket => _socket!;

  bool get isConnected => _socket?.connected ?? false;

  String setConsId(String consId) {
    _consId = consId;
    return _consId;
  }

  // ============================================================
  // CONNECT
  // ============================================================

  Future<void> connect(
      String userId,
      String accessToken,
      ) async {
    _userId = userId;
    _accessToken = accessToken;

    // Agar allaqachon ulangan bo'lsa
    if (_socket?.connected == true) {
      log('🟢 SOCKET ALREADY CONNECTED');
      return;
    }

    // Eski socketni tozalash
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;

    final completer = Completer<void>();

    log('🔌 SOCKET CONNECTING...');
    log('👤 USER ID: $userId');

    final socket = io(
      'wss://back.sovchilar.net',
      OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({
        'token': accessToken,
      })
          .setExtraHeaders({
        'Authorization': 'Bearer $accessToken',
      })
          .setQuery({
        'userId': userId,
      })
          .disableAutoConnect()
          .build(),
    );

    _socket = socket;

    // ============================================================
    // CONNECT
    // ============================================================

    socket.onConnect((_) {
      log('🟢 SOCKET CONNECTED: ${socket.id}');

      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    // ============================================================
    // CONNECT ERROR
    // ============================================================

    socket.onConnectError((error) {
      log('❌ SOCKET CONNECT ERROR: $error');

      if (!completer.isCompleted) {
        completer.completeError(error);
      }
    });

    // ============================================================
    // SOCKET ERROR
    // ============================================================

    socket.onError((error) {
      log('❌ SOCKET ERROR: $error');
    });

    // ============================================================
    // ALL EVENTS
    // ============================================================

    socket.onAny((event, data) {
      log('📡 SOCKET EVENT: $event -> $data');
    });

    // ============================================================
    // DISCONNECT
    // ============================================================

    socket.onDisconnect((reason) {
      log('🔴 SOCKET DISCONNECTED: $reason');
    });

    // ============================================================
    // CONNECT
    // ============================================================

    socket.connect();

    await completer.future;

    log('✅ SOCKET CONNECT COMPLETED');
  }

  // ============================================================
  // WAIT FOR CONNECTION
  // ============================================================

  Future<void> waitForConnection() async {
    if (_socket?.connected == true) {
      return;
    }

    final socket = _socket;

    if (socket == null) {
      throw StateError(
        'Socket hali initialize qilinmagan',
      );
    }

    final completer = Completer<void>();

    void onConnect(_) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    }

    socket.once(
      'connect',
      onConnect,
    );

    if (!socket.connected) {
      log('⏳ WAITING FOR SOCKET CONNECTION...');
    } else {
      onConnect(null);
    }

    await completer.future;
  }

  // ============================================================
  // DISCONNECT
  // ============================================================

  void disconnect() {
    log('🔴 SOCKET DISCONNECT');

    _socket?.disconnect();
  }

  // ============================================================
  // RECONNECT
  // ============================================================

  Future<void> reconnect() async {
    if (_userId.isEmpty || _accessToken.isEmpty) {
      log('❌ RECONNECT: userId yoki token mavjud emas');
      return;
    }

    if (isConnected) {
      disconnect();
    }

    await connect(
      _userId,
      _accessToken,
    );
  }

  // ============================================================
  // CHECK ONLINE
  // ============================================================

  bool checkOnline(String id) {
    UserStatus? userStatus;

    final socket = _socket;

    if (socket == null || !socket.connected) {
      log('❌ CHECK ONLINE: socket ulanmagan');
      return false;
    }

    socket.on(
      "login",
          (response) {
        log('LOGIN RESPONSE: $response');

        try {
          userStatus = UserStatus.fromJson(response);
        } catch (e) {
          log('❌ USER STATUS PARSE ERROR: $e');
        }
      },
    );

    return userStatus?.status == 'online';
  }

  // ============================================================
  // GET CONVERSATIONS
  // ============================================================

  void getConversations(
      void Function(List<Items>) handler,
      ) {
    log('📥 getConversations called');

    final socket = _socket;

    if (socket == null) {
      log('❌ SOCKET NULL');
      return;
    }

    log('🔌 SOCKET CONNECTED: ${socket.connected}');
    log('🆔 SOCKET ID: ${socket.id}');
    log('👤 USER ID: $_userId');

    if (!socket.connected) {
      log('❌ SOCKET CONNECTED EMAS!');
      return;
    }

    // Eski listenerni o'chirish
    socket.off('conversations');

    // ============================================================
    // RESPONSE
    // ============================================================

    socket.on(
      'conversations',
          (response) {
        log('🔥 CONVERSATIONS RESPONSE KELDI');
        log('$response');

        try {
          final getConversation =
          GetConversations.fromJson(response);

          final items =
              getConversation.data?.items ?? [];

          log('🔥 ITEMS: ${items.length}');

          handler(items);
        } catch (e, stackTrace) {
          log(
            '❌ CONVERSATIONS PARSE ERROR: $e',
            stackTrace: stackTrace,
          );
        }
      },
    );

    // ============================================================
    // REQUEST
    // ============================================================

    log('📤 EMIT get-conversations');

    socket.emit(
      'get-conversations',
      {
        'userId': _userId,
      },
    );
  }

  // ============================================================
  // GET CONVERSATION MESSAGES
  // ============================================================

  void getConversationMessages() {
    final socket = _socket;

    if (socket == null || !socket.connected) {
      log(
        '❌ GET MESSAGES: socket ulanmagan',
      );
      return;
    }

    socket.emit(
      "get-conversation-messages",
      {
        "conversationId": _consId,
      },
    );

    socket.off(
      "conversation-messages",
    );

    socket.on(
      "conversation-messages",
          (response) {
        try {
          final GetMessage getMessage =
          GetMessage.fromJson(response);

          _messageController.add(
            getMessage.data ?? [],
          );
        } catch (e, stackTrace) {
          log(
            '❌ MESSAGE PARSE ERROR: $e',
            stackTrace: stackTrace,
          );
        }
      },
    );

    socket.emit(
      "markAsRead",
      {
        "userId": _userId,
        "conversationId": _consId,
      },
    );
  }

  // ============================================================
  // CLEAR MESSAGES
  // ============================================================

  void clearMessages() {
    if (!_messageController.isClosed) {
      _messageController.add([]);
    }
  }

  // ============================================================
  // DELETE MESSAGE
  // ============================================================

  Future<void> deleteMessage(
      String messageId,
      ) async {
    final socket = _socket;

    if (socket == null || !socket.connected) {
      log(
        '❌ DELETE MESSAGE: socket ulanmagan',
      );
      return;
    }

    socket.emit(
      'deleteMessages',
      {
        'messageIds': [
          messageId,
        ],
        'userId': _userId,
        'conversationId': _consId,
      },
    );

    log('📤 DELETE MESSAGE: $messageId');

    List<DataMes> currentMessages = [];

    if (_messageController.hasListener) {
      currentMessages =
      await _messageController.stream.first;
    }

    final updatedMessages =
    currentMessages
        .where(
          (msg) => msg.id != messageId,
    )
        .toList();

    if (!_messageController.isClosed) {
      _messageController.add(
        updatedMessages,
      );
    }
  }

  // ============================================================
  // SEND MESSAGE
  // ============================================================

  Future<void> sendMessage(
      String messageText,
      String consId,
      ) async {
    if (messageText.trim().isEmpty) {
      return;
    }

    final socket = _socket;

    if (socket == null || !socket.connected) {
      log(
        '❌ SEND MESSAGE: socket ulanmagan',
      );
      return;
    }

    final message =
    messageText.trim();

    // ============================================================
    // SEND TO SERVER
    // ============================================================

    socket.emit(
      "sendMessage",
      {
        "senderId": _userId,
        "conversationId": consId,
        "message": message,
      },
    );

    log('📤 SEND MESSAGE: $message');

    // ============================================================
    // UPDATE LOCAL STREAM
    // ============================================================

    List<DataMes> currentMessages = [];

    if (_messageController.hasListener) {
      currentMessages =
      await _messageController.stream.first;
    }

    currentMessages.add(
      DataMes(
        id: DateTime.now().toString(),
        sender: Sender1(
          id: _userId,
        ),
        message: message,
        isRead: false,
        createdAt:
        DateTime.now().toString(),
        updatedAt:
        DateTime.now().toString(),
      ),
    );

    if (!_messageController.isClosed) {
      _messageController.add(
        currentMessages,
      );
    }
  }

  // ============================================================
  // REMOVE CONVERSATION
  // ============================================================

  void removeConversation() {
    final socket = _socket;

    if (socket == null || !socket.connected) {
      log(
        '❌ DELETE CONVERSATION: socket ulanmagan',
      );
      return;
    }

    socket.emit(
      "deleteConversation",
      {
        "conversationId": _consId,
        "userId": _userId,
      },
    );

    log(
      '📤 DELETE CONVERSATION: $_consId',
    );
  }

  // ============================================================
  // CREATE CONVERSATION
  // ============================================================

  Future<String?> createConversation(String userId) async {
    final socket = _socket;

    if (socket == null || !socket.connected) {
      log('❌ CREATE CONVERSATION: socket ulanmagan');
      return null;
    }

    final completer = Completer<String?>();

    socket.once('conversationCreated', (response) {
      log('🔥 CONVERSATION CREATED: $response');

      try {
        final consId = response['id']?.toString();

        log('🔥 CONVERSATION ID: $consId');

        if (!completer.isCompleted) {
          completer.complete(consId);
        }
      } catch (e) {
        log('❌ CONVERSATION PARSE ERROR: $e');

        if (!completer.isCompleted) {
          completer.complete(null);
        }
      }
    });

    socket.emit(
      'createConversation',
      {
        'userId1': _userId,
        'userId2': userId,
      },
    );

    log('📤 CREATE CONVERSATION: $_userId -> $userId');

    return completer.future;
  }


  // ============================================================
  // DISPOSE
  // ============================================================

  Future<void> dispose() async {
    _socket?.disconnect();
    _socket?.dispose();

    _socket = null;

    if (!_messageController.isClosed) {
      await _messageController.close();
    }
  }

  @override
  Future<void> close() async {
    await dispose();
  }
}

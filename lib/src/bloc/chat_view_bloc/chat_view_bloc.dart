import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sovchilar/src/data/get_mes.dart';
import '../../service/socket/socket.dart';

part 'chat_view_event.dart';
part 'chat_view_state.dart';

class ChatViewBloc extends Bloc<ChatViewEvent, ChatViewState> {
  final SocketService _socketService;
  StreamSubscription<List<DataMes>>? _messageSubscription;
  Timer? _timer;

  ChatViewBloc(this._socketService) : super(ChatViewInitial()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<GetMessagesEvent>(
      _onGetMessages,
      transformer: _debounce(const Duration(milliseconds: 500)),
    );
  }

  /// **Socket orqali xabarlarni real vaqt rejimida tinglash**
  void startListening(String conversationId) {
    _socketService.setConsId(conversationId);
    _socketService.getConversationMessages();

    // Eski subscription'ni tozalash
    _messageSubscription?.cancel();

    // **Stream orqali yangi xabarlarni olish**
    _messageSubscription = _socketService.messageStream.listen((messages) {
      add(GetMessagesEvent(messages: messages));
    });

    // **Har 2 soniyada eski xabarlarni qayta yuklash**
    _timer?.cancel();
    // _timer = Timer.periodic(const Duration(seconds: 2), (_) {
    //   _socketService.getConversationMessages();
    // });
  }

  /// **Debounce bilan eventlarni boshqarish**
  static EventTransformer<E> _debounce<E>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }

  /// **Xabarlarni yuklash (Timer orqali har 2 soniyada yangilanadi)**
  void _onLoadMessages(LoadMessagesEvent event, Emitter<ChatViewState> emit) {
    _socketService.getConversationMessages();
    emit(LoadingChatMessagesState());
  }

  /// **Yangi xabar kelganda faqat o‘zgargan bo‘lsa `emit` qilamiz**
  void _onGetMessages(GetMessagesEvent event, Emitter<ChatViewState> emit) {
    if (state is GetChatMessagesState) {
      final currentState = state as GetChatMessagesState;
      final List<DataMes> updatedMessages = event.messages;

      // **Yangi xabarlar mavjudligini tekshirish**
      if (updatedMessages.isEmpty) {
        emit(LoadingChatMessagesState());
      } else if (updatedMessages.last.id != currentState.messages.lastOrNull?.id) {
        emit(GetChatMessagesState(messages: updatedMessages));
      }
    } else {
      emit(GetChatMessagesState(messages: event.messages));
    }
  }
  /// **Bloc yopilganda barcha timer va subscription'larni tozalash**
  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _timer?.cancel();
    return super.close();
  }
}
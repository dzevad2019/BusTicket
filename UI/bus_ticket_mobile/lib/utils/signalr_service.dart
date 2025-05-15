import 'package:signalr_core/signalr_core.dart';

class SignalRService {
  late HubConnection _hubConnection;
  final String _hubUrl;

  SignalRService(this._hubUrl);

  Future<void> startConnection(String accessToken) async {
    _hubConnection = HubConnectionBuilder()
        .withUrl(
      _hubUrl,
      HttpConnectionOptions(
        accessTokenFactory: () => Future.value(accessToken),
        logging: (level, message) => print(message),
      ),
    )
        .build();

    await _hubConnection.start();
  }

  Future<void> joinGroup(String groupName) async {
    if (_hubConnection.state == HubConnectionState.connected) {
      await _hubConnection.invoke('JoinGroup', args: [groupName]);
    }
  }

  Future<void> leaveGroup(String groupName) async {
    if (_hubConnection.state == HubConnectionState.connected) {
      await _hubConnection.invoke('LeaveGroup', args: [groupName]);
    }
  }

  void updateService(SignalRService newService) {
    if (_hubConnection.state == HubConnectionState.connected) {
      _hubConnection.stop();
    }
    _hubConnection = newService._hubConnection;
  }

  void registerNotificationHandler(Function(dynamic) handler) {
    _hubConnection.on('ReceiveNotification', handler);
  }

  void disconnect() {
    _hubConnection.stop();
  }
}

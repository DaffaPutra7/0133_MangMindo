import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:projek_akhir/data/repository/admin_order_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final AdminOrderRepository repository;
  Timer? _timer;
  int _lastOrderCount = 0;
  bool _isFirstFetch = true;

  NotificationBloc(this.repository) : super(NotificationInitial()) {
    on<StartOrderCheck>((event, emit) {
      _timer?.cancel();
      // Langsung cek saat pertama kali di-start
      add(_CheckOrders());
      // Lalu jalankan pengecekan setiap 15 detik
      _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
        if (!isClosed) { // Pastikan BLoC belum ditutup
          add(_CheckOrders());
        }
      });
    });

    on<StopOrderCheck>((event, emit) {
      _timer?.cancel();
    });

    on<_CheckOrders>((event, emit) async {
      final result = await repository.getAllOrders();
      result.fold(
        (l) {}, // Jika error, abaikan
        (r) {
          final currentOrderCount = r.data.length;
          if (_isFirstFetch) {
            _lastOrderCount = currentOrderCount;
            _isFirstFetch = false;
          } else if (currentOrderCount > _lastOrderCount) {
            final newOrders = currentOrderCount - _lastOrderCount;
            emit(NewOrderReceived(newOrderCount: newOrders));
          }
          _lastOrderCount = currentOrderCount;
        },
      );
    });
  }

  // ✅ Method close() akan otomatis dipanggil saat BLoC dihancurkan
  @override
  Future<void> close() {
    _timer?.cancel(); // Hentikan timer di sini, ini cara yang aman
    return super.close();
  }
}
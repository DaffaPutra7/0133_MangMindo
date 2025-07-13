import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:projek_akhir/data/model/request/user/order_item_model.dart';
import 'package:projek_akhir/data/model/response/admin/admin_menu_response_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<AddToCart>((event, emit) {
      final currentState = state;
      if (currentState is CartLoaded) {
        final List<OrderItem> updatedItems = List.from(currentState.items);
        final index = updatedItems.indexWhere((item) => item.menu.id == event.item.id);

        if (index != -1) {
          // Jika item sudah ada, tambah quantity
          updatedItems[index].quantity++;
        } else {
          // Jika item baru, tambahkan ke list
          updatedItems.add(OrderItem(menu: event.item, quantity: 1));
        }
        
        final newTotalPrice = _calculateTotalPrice(updatedItems);
        emit(CartLoaded(items: updatedItems, totalPrice: newTotalPrice));
      } else {
        // Jika keranjang masih kosong
        final newItems = [OrderItem(menu: event.item, quantity: 1)];
        final newTotalPrice = _calculateTotalPrice(newItems);
        emit(CartLoaded(items: newItems, totalPrice: newTotalPrice));
      }
    });

    on<RemoveFromCart>((event, emit) {
       final currentState = state;
       if (currentState is CartLoaded) {
         final List<OrderItem> updatedItems = List.from(currentState.items);
         updatedItems.remove(event.item);
         final newTotalPrice = _calculateTotalPrice(updatedItems);
         emit(CartLoaded(items: updatedItems, totalPrice: newTotalPrice));
       }
    });

    on<ClearCart>((event, emit) {
      // Cukup kembalikan state ke kondisi awal
      emit(CartInitial());
    });
  }

  double _calculateTotalPrice(List<OrderItem> items) {
    return items.fold(0.0, (sum, item) => sum + (item.menu.price * item.quantity));
  }
}
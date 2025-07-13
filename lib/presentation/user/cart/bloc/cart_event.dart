part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

// Event saat item ditambahkan ke keranjang
class AddToCart extends CartEvent {
  final Menu item;
  AddToCart({required this.item});
}

// Event saat item dihapus dari keranjang
class RemoveFromCart extends CartEvent {
  final OrderItem item;
  RemoveFromCart({required this.item});
}

class ClearCart extends CartEvent {}
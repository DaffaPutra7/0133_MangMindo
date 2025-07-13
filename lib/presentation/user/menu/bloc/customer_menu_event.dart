part of 'customer_menu_bloc.dart';

@immutable
sealed class CustomerMenuEvent {}

class FetchCustomerMenus extends CustomerMenuEvent {}
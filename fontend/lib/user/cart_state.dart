import '../models/models.dart';

/// State giỏ hàng đơn giản cho frontend (in-memory).
class CartState {
  static final List<CartItem> _items = [];
  static void Function()? onChanged;

  static List<CartItem> get items => List.unmodifiable(_items);

  static int get itemCount =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  static double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + item.subtotal);

  static void add(Product product, [int quantity = 1]) {
    final i = _items.indexWhere((e) => e.product.id == product.id);
    if (i >= 0) {
      _items[i].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    onChanged?.call();
  }

  static void setQuantity(Product product, int quantity) {
    if (quantity <= 0) {
      remove(product);
      return;
    }
    final i = _items.indexWhere((e) => e.product.id == product.id);
    if (i >= 0) {
      _items[i].quantity = quantity;
      onChanged?.call();
    }
  }

  static void remove(Product product) {
    _items.removeWhere((e) => e.product.id == product.id);
    onChanged?.call();
  }

  static void clear() {
    _items.clear();
    onChanged?.call();
  }
}

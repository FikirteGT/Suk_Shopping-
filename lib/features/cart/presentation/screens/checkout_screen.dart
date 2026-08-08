import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../order/presentation/providers/order_provider.dart';
import '../providers/cart_provider.dart';
import 'payment_success_screen.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _currentStep = 0;
  String _selectedPayment = 'Credit Card';
  final _addressController =
      TextEditingController(text: '123 Tech Avenue, Silicon Valley, CA');
  bool _isProcessing = false;

  void _processPayment() async {
    setState(() => _isProcessing = true);
    final cartItems = ref.read(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final total = cartNotifier.grandTotal;

    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    // Log order in order history
    await ref.read(orderHistoryProvider.notifier).addOrder(
          cartItems,
          total,
          _addressController.text,
        );

    // Clear cart
    cartNotifier.clearCart();

    setState(() => _isProcessing = false);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => PaymentSuccessScreen(totalAmount: total),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartNotifier = ref.watch(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() => _currentStep += 1);
          } else {
            _processPayment();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          }
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: _currentStep == 2 ? 'Place Order' : 'Continue',
                    isLoading: _isProcessing,
                    onPressed: details.onStepContinue!,
                  ),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Back'),
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          // Step 1: Delivery Address
          Step(
            title: const Text('Shipping Address'),
            isActive: _currentStep >= 0,
            content: Column(
              children: [
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Full Delivery Address',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                ),
              ],
            ),
          ),

          // Step 2: Payment Method
          Step(
            title: const Text('Payment Method'),
            isActive: _currentStep >= 1,
            content: Column(
              children: [
                RadioListTile<String>(
                  title: const Text('Credit / Debit Card'),
                  subtitle: const Text('Visa, Mastercard, Amex'),
                  secondary: const Icon(Icons.credit_card_rounded),
                  value: 'Credit Card',
                  groupValue: _selectedPayment,
                  onChanged: (val) => setState(() => _selectedPayment = val!),
                ),
                RadioListTile<String>(
                  title: const Text('Apple Pay / Google Pay'),
                  secondary: const Icon(Icons.account_balance_wallet_rounded),
                  value: 'Digital Wallet',
                  groupValue: _selectedPayment,
                  onChanged: (val) => setState(() => _selectedPayment = val!),
                ),
                RadioListTile<String>(
                  title: const Text('Cash on Delivery (COD)'),
                  secondary: const Icon(Icons.payments_rounded),
                  value: 'Cash',
                  groupValue: _selectedPayment,
                  onChanged: (val) => setState(() => _selectedPayment = val!),
                ),
              ],
            ),
          ),

          // Step 3: Order Summary Review
          Step(
            title: const Text('Order Summary'),
            isActive: _currentStep >= 2,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Amount Payable'),
                    Text(
                      CurrencyFormatter.format(cartNotifier.grandTotal),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Shipping to: ${_addressController.text}',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

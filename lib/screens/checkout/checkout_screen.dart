import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../utils/app_theme.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  int _currentStep = 0;
  String _paymentMethod = 'card';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'الاسم مطلوب';
    if (value.trim().length < 3) return 'الاسم يجب أن يكون 3 أحرف على الأقل';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'رقم الهاتف مطلوب';
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 9) return 'رقم الهاتف غير صحيح';
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) return 'العنوان مطلوب';
    if (value.trim().length < 10) return 'يرجى إدخال عنوان تفصيلي';
    return null;
  }

  String? _validateCity(String? value) {
    if (value == null || value.trim().isEmpty) return 'المدينة مطلوبة';
    return null;
  }

  String? _validateCardNumber(String? value) {
    if (_paymentMethod != 'card') return null;
    if (value == null || value.trim().isEmpty) return 'رقم البطاقة مطلوب';
    final digits = value.replaceAll(' ', '');
    if (digits.length != 16) return 'رقم البطاقة يجب أن يكون 16 رقماً';
    return null;
  }

  String? _validateExpiry(String? value) {
    if (_paymentMethod != 'card') return null;
    if (value == null || value.trim().isEmpty) return 'تاريخ الانتهاء مطلوب';
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) return 'الصيغة: MM/YY';
    final parts = value.split('/');
    final month = int.tryParse(parts[0]) ?? 0;
    if (month < 1 || month > 12) return 'الشهر غير صحيح';
    return null;
  }

  String? _validateCVV(String? value) {
    if (_paymentMethod != 'card') return null;
    if (value == null || value.trim().isEmpty) return 'CVV مطلوب';
    if (value.length < 3 || value.length > 4) return 'CVV غير صحيح';
    return null;
  }

  void _nextStep() {
    
    bool valid = true;
    if (_currentStep == 0) {
      valid = _formKey.currentState?.validate() ?? false;
    } else if (_currentStep == 1) {
      valid = _formKey.currentState?.validate() ?? false;
    }
    if (valid && _currentStep < 2) {
      setState(() => _currentStep++);
    }
  }

  Future<void> _placeOrder() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    if (!mounted) return;
    final cart = Provider.of<CartProvider>(context, listen: false);
    cart.clearCart();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: AppTheme.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 16),
            const Text(
              'تم الطلب بنجاح! 🎉',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'سيتم توصيل طلبك خلال 3-5 أيام عمل.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('العودة للرئيسية'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('إتمام الطلب',
            style: TextStyle(
                color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppTheme.textPrimary, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            
            _StepIndicator(currentStep: _currentStep),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _currentStep == 0
                      ? _ShippingStep(
                          key: const ValueKey('shipping'),
                          nameController: _nameController,
                          phoneController: _phoneController,
                          addressController: _addressController,
                          cityController: _cityController,
                          validateName: _validateName,
                          validatePhone: _validatePhone,
                          validateAddress: _validateAddress,
                          validateCity: _validateCity,
                        )
                      : _currentStep == 1
                          ? _PaymentStep(
                              key: const ValueKey('payment'),
                              paymentMethod: _paymentMethod,
                              onPaymentChanged: (val) =>
                                  setState(() => _paymentMethod = val!),
                              cardNumberController: _cardNumberController,
                              expiryController: _expiryController,
                              cvvController: _cvvController,
                              validateCardNumber: _validateCardNumber,
                              validateExpiry: _validateExpiry,
                              validateCVV: _validateCVV,
                            )
                          : _ReviewStep(
                              key: const ValueKey('review'),
                              name: _nameController.text,
                              phone: _phoneController.text,
                              address: _addressController.text,
                              city: _cityController.text,
                              paymentMethod: _paymentMethod,
                              cart: cart,
                            ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            setState(() => _currentStep--),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.textPrimary,
                          side: const BorderSide(
                              color: AppTheme.surfaceLight),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('السابق'),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : (_currentStep < 2 ? _nextStep : _placeOrder),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : Text(_currentStep < 2
                              ? 'التالي'
                              : 'تأكيد الطلب (\$${cart.totalAmount.toStringAsFixed(2)})'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = ['الشحن', 'الدفع', 'المراجعة'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      color: AppTheme.background,
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            return Expanded(
              child: Container(
                height: 2,
                color: i ~/ 2 < currentStep
                    ? AppTheme.primary
                    : AppTheme.surfaceLight,
              ),
            );
          }
          final stepIndex = i ~/ 2;
          final isDone = stepIndex < currentStep;
          final isActive = stepIndex == currentStep;
          return Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone || isActive
                      ? AppTheme.primary
                      : AppTheme.surfaceLight,
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : Text(
                          '${stepIndex + 1}',
                          style: TextStyle(
                            color: isActive
                                ? Colors.white
                                : AppTheme.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                steps[stepIndex],
                style: TextStyle(
                  color: isActive
                      ? AppTheme.primary
                      : AppTheme.textSecondary,
                  fontSize: 11,
                  fontWeight:
                      isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _ShippingStep extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final String? Function(String?) validateName;
  final String? Function(String?) validatePhone;
  final String? Function(String?) validateAddress;
  final String? Function(String?) validateCity;

  const _ShippingStep({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.cityController,
    required this.validateName,
    required this.validatePhone,
    required this.validateAddress,
    required this.validateCity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text('معلومات الشحن',
            style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        _FormField(
          controller: nameController,
          label: 'الاسم الكامل',
          hint: 'مثال: محمد أحمد',
          icon: Icons.person_outline,
          validator: validateName,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 14),
        _FormField(
          controller: phoneController,
          label: 'رقم الهاتف',
          hint: '07XXXXXXXX',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: validatePhone,
          textInputAction: TextInputAction.next,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 14),
        _FormField(
          controller: addressController,
          label: 'العنوان التفصيلي',
          hint: 'الشارع، المبنى، الطابق...',
          icon: Icons.location_on_outlined,
          validator: validateAddress,
          maxLines: 2,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 14),
        _FormField(
          controller: cityController,
          label: 'المدينة',
          hint: 'عمّان',
          icon: Icons.location_city_outlined,
          validator: validateCity,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}

class _PaymentStep extends StatelessWidget {
  final String paymentMethod;
  final ValueChanged<String?> onPaymentChanged;
  final TextEditingController cardNumberController;
  final TextEditingController expiryController;
  final TextEditingController cvvController;
  final String? Function(String?) validateCardNumber;
  final String? Function(String?) validateExpiry;
  final String? Function(String?) validateCVV;

  const _PaymentStep({
    super.key,
    required this.paymentMethod,
    required this.onPaymentChanged,
    required this.cardNumberController,
    required this.expiryController,
    required this.cvvController,
    required this.validateCardNumber,
    required this.validateExpiry,
    required this.validateCVV,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text('طريقة الدفع',
            style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),

        _PaymentOption(
          label: 'بطاقة ائتمان / خصم',
          icon: Icons.credit_card,
          value: 'card',
          groupValue: paymentMethod,
          onChanged: onPaymentChanged,
        ),
        const SizedBox(height: 10),
        _PaymentOption(
          label: 'الدفع عند الاستلام',
          icon: Icons.money,
          value: 'cash',
          groupValue: paymentMethod,
          onChanged: onPaymentChanged,
        ),

        if (paymentMethod == 'card') ...[
          const SizedBox(height: 20),
          _FormField(
            controller: cardNumberController,
            label: 'رقم البطاقة',
            hint: '1234 5678 9012 3456',
            icon: Icons.credit_card,
            keyboardType: TextInputType.number,
            validator: validateCardNumber,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
            ],
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _FormField(
                  controller: expiryController,
                  label: 'تاريخ الانتهاء',
                  hint: 'MM/YY',
                  icon: Icons.calendar_today_outlined,
                  keyboardType: TextInputType.number,
                  validator: validateExpiry,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                    _ExpiryFormatter(),
                  ],
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FormField(
                  controller: cvvController,
                  label: 'CVV',
                  hint: '123',
                  icon: Icons.lock_outline,
                  keyboardType: TextInputType.number,
                  validator: validateCVV,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                ),
              ),
            ],
          ),
        ],

        if (paymentMethod == 'cash') ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.success.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'سيتم الدفع عند استلام الطلب. يُرجى تجهيز المبلغ كاملاً.',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: AppTheme.success, fontSize: 13),
                  ),
                ),
                Icon(Icons.info_outline, color: AppTheme.success, size: 20),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _ReviewStep extends StatelessWidget {
  final String name, phone, address, city, paymentMethod;
  final CartProvider cart;

  const _ReviewStep({
    super.key,
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    required this.paymentMethod,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text('مراجعة الطلب',
            style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),

        _ReviewSection(title: 'معلومات الشحن', rows: [
          _ReviewRow(label: 'الاسم', value: name),
          _ReviewRow(label: 'الهاتف', value: phone),
          _ReviewRow(label: 'العنوان', value: address),
          _ReviewRow(label: 'المدينة', value: city),
        ]),

        const SizedBox(height: 16),

        _ReviewSection(title: 'طريقة الدفع', rows: [
          _ReviewRow(
            label: 'الدفع',
            value: paymentMethod == 'card'
                ? 'بطاقة ائتمانية'
                : 'الدفع عند الاستلام',
          ),
        ]),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              ...cart.items.values.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${item.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                        child: Text(
                          '${item.product.title} × ${item.quantity}',
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: AppTheme.textPrimary, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(color: AppTheme.surfaceLight, height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${cart.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('الإجمالي',
                      style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label, hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final bool obscureText;
  final TextInputAction textInputAction;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.maxLines = 1,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      obscureText: obscureText,
      textInputAction: textInputAction,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      style: const TextStyle(color: AppTheme.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppTheme.textSecondary),
        hintText: hint,
        hintStyle: const TextStyle(
            color: AppTheme.textSecondary, fontSize: 13),
        prefixIcon: Icon(icon, color: AppTheme.textSecondary, size: 20),
        filled: true,
        fillColor: AppTheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppTheme.surfaceLight, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppTheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppTheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppTheme.error, width: 1.5),
        ),
        errorStyle:
            const TextStyle(color: AppTheme.error, fontSize: 11),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String label, value, groupValue;
  final IconData icon;
  final ValueChanged<String?> onChanged;

  const _PaymentOption({
    required this.label,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withOpacity(0.1)
              : AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.surfaceLight,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: AppTheme.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: isSelected
                      ? AppTheme.primary
                      : AppTheme.textPrimary,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            Icon(icon,
                color:
                    isSelected ? AppTheme.primary : AppTheme.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _ReviewSection extends StatelessWidget {
  final String title;
  final List<_ReviewRow> rows;

  const _ReviewSection({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(title,
              style: const TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          const SizedBox(height: 10),
          ...rows.map((r) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(r.value,
                        style: const TextStyle(
                            color: AppTheme.textPrimary, fontSize: 13)),
                    Text(r.label,
                        style: const TextStyle(
                            color: AppTheme.textSecondary, fontSize: 13)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _ReviewRow {
  final String label, value;
  const _ReviewRow({required this.label, required this.value});
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll('/', '');
    if (digits.length >= 3) {
      final formatted = '${digits.substring(0, 2)}/${digits.substring(2)}';
      return newValue.copyWith(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    return newValue;
  }
}

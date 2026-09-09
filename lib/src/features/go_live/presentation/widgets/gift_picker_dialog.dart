import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/global_export.dart';

class GiftPickerDialog extends StatefulWidget {
  const GiftPickerDialog({super.key});

  static Future<int?> show(BuildContext context) async {
    return await showModalBottomSheet<int?>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const GiftPickerDialog(),
    );
  }

  @override
  State<GiftPickerDialog> createState() => _GiftPickerDialogState();
}

class _GiftPickerDialogState extends State<GiftPickerDialog> {
  String? _selectedGiftId;
  int _quantity = 1;

  static const List<_GiftItem> _availableGifts = <_GiftItem>[
    _GiftItem(id: '1', name: 'Rose', emoji: '🌹', price: 10),
    _GiftItem(id: '2', name: 'Heart', emoji: '❤️', price: 20),
    _GiftItem(id: '3', name: 'Star', emoji: '⭐', price: 50),
    _GiftItem(id: '4', name: 'Diamond', emoji: '💎', price: 100),
    _GiftItem(id: '5', name: 'Crown', emoji: '👑', price: 200),
    _GiftItem(id: '6', name: 'Rocket', emoji: '🚀', price: 500),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ATColors.hex202020,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Send a Gift',
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: _availableGifts.length,
              itemBuilder: (_, int index) {
                final _GiftItem gift = _availableGifts[index];
                final bool isSelected = _selectedGiftId == gift.id;
                return GestureDetector(
                  onTap: () => setState(() => _selectedGiftId = gift.id),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ATColors.hex307FE2.withValues(alpha: 0.3)
                          : ATColors.hex292929,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: ATColors.hex307FE2, width: 2)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(gift.emoji, style: const TextStyle(fontSize: 32)),
                        const SizedBox(height: 4),
                        Text(
                          gift.name,
                          style: context.textTheme.bodySmall,
                        ),
                        Text(
                          '₦${gift.price}',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: ATColors.hexC2C2C2,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            if (_selectedGiftId != null) ...<Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed:
                        _quantity > 1 ? () => setState(() => _quantity--) : null,
                    icon: const Icon(Icons.remove_circle_outline),
                    color: Colors.white,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: ATColors.hex292929,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'x$_quantity',
                      style: context.textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _quantity++),
                    icon: const Icon(Icons.add_circle_outline),
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedGiftId != null
                    ? () {
                        Navigator.pop(context, _quantity);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ATColors.hex307FE2,
                  disabledBackgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _selectedGiftId != null
                      ? 'Send ${_availableGifts.firstWhere((_GiftItem g) => g.id == _selectedGiftId).emoji} x$_quantity'
                      : 'Select a gift',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
          ],
        ),
      ),
    );
  }
}

class _GiftItem {
  const _GiftItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.price,
  });
  final String id;
  final String name;
  final String emoji;
  final int price;
}

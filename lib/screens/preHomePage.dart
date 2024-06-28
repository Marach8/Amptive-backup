import 'package:flutter/material.dart';

class PreHomePage extends StatefulWidget {
  const PreHomePage({Key? key}) : super(key: key);

  @override
  State<PreHomePage> createState() => _PreHomePageState();
}

class _PreHomePageState extends State<PreHomePage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<String> _notifications = List.generate(10, (index) => 'Notification ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Cards'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: _notifications.length,
              itemBuilder: (context, index, animation) {
                return _buildItem(_notifications[index], animation, index);
              },
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _removeTopNotification(),
            child: Text('Remove Top Notification'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildItem(String item, Animation<double> animation, int index) {
    double baseWidth = 300.0; // Fixed width for the top card
    double widthReductionFactor = 20.0; // Reduction in width for each subsequent card

    double width = (index == 0)
        ? baseWidth
        : baseWidth - (index * widthReductionFactor).clamp(0, baseWidth - 50);

    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.vertical,
      child: Center(
        child: Container(
          width: width,
          margin: EdgeInsets.symmetric(vertical: 5),
          child: CardWidget(item)
        ),
      ),
    );
  }

  void _removeTopNotification() {
    if (_notifications.isNotEmpty) {
      final int removeIndex = 0;
      String removedItem = _notifications.removeAt(removeIndex);
      _listKey.currentState?.removeItem(
        removeIndex,
            (context, animation) => _buildItem(removedItem, animation, removeIndex),
        duration: Duration(milliseconds: 600),
      );
    }
  }


}


class CardWidget extends StatelessWidget {
  final String index;

  CardWidget(this.index);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.credit_card),
        title: Text('Card $index'),
      ),
    );
  }
}

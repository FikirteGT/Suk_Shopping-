import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'Flash Sale Started! ⚡',
        'body': 'Get up to 50% off on all electronics items for the next 4 hours!',
        'time': '10 mins ago',
        'icon': Icons.bolt_rounded,
        'color': Colors.amber,
      },
      {
        'title': 'Order Dispatched 🚚',
        'body': 'Your order #SUK-89102 has been shipped and is on its way.',
        'time': '2 hours ago',
        'icon': Icons.local_shipping_rounded,
        'color': Colors.blue,
      },
      {
        'title': 'AI Assistant Recommendation 🤖',
        'body': 'We found new jewelry items that match your browsing history.',
        'time': '1 day ago',
        'icon': Icons.auto_awesome_rounded,
        'color': Colors.purple,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor:
                      (notif['color'] as Color).withValues(alpha: 0.15),
                  child: Icon(notif['icon'] as IconData,
                      color: notif['color'] as Color),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notif['title'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notif['body'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notif['time'] as String,
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:delivery_online_app/utils/format_date.dart';

class OrderTimeline extends StatelessWidget {
  final DateTime createdAt;
  final DateTime? shipperConfirmedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final ThemeData theme;
  final bool isDark;

  const OrderTimeline({
    required this.createdAt,
    this.shipperConfirmedAt,
    this.completedAt,
    this.cancelledAt,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final List<TimelineStep> steps = [
      TimelineStep(
        label: 'Tạo đơn hàng',
        time: formatDateTimeVN(createdAt),
        icon: Icons.create,
        color: Colors.blue,
      ),
      if (shipperConfirmedAt != null)
        TimelineStep(
          label: 'Shipper nhận đơn',
          time: formatDateTimeVN(shipperConfirmedAt!),
          icon: Icons.delivery_dining,
          color: Colors.orange,
        ),
      if (completedAt != null)
        TimelineStep(
          label: 'Hoàn thành',
          time: formatDateTimeVN(completedAt!),
          icon: Icons.check_circle,
          color: Colors.green,
        ),
      if (cancelledAt != null)
        TimelineStep(
          label: 'Đã huỷ',
          time: formatDateTimeVN(cancelledAt!),
          icon: Icons.cancel,
          color: Colors.red,
        ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tiến trình đơn hàng:', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(steps.length, (i) {
            final step = steps[i];
            final isLast = i == steps.length - 1;
            return Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: step.color.withOpacity(0.15),
                            shape: BoxShape.circle,
                            border: Border.all(color: step.color, width: 2),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Icon(step.icon, color: step.color, size: 24),
                        ),
                        const SizedBox(height: 6),
                        Text(step.label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        Text(step.time, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 32,
                      height: 2,
                      color: step.color,
                      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 24),
                    ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 18),
      ],
    );
  }
}

class TimelineStep {
  final String label;
  final String time;
  final IconData icon;
  final Color color;
  TimelineStep({required this.label, required this.time, required this.icon, required this.color});
}

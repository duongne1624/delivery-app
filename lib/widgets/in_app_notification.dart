import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../utils/notification_utils.dart';

class InAppNotificationWidget extends StatefulWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final Duration duration;

  const InAppNotificationWidget({
    Key? key,
    required this.notification,
    this.onTap,
    this.onDismiss,
    this.duration = const Duration(seconds: 4),
  }) : super(key: key);

  @override
  State<InAppNotificationWidget> createState() => _InAppNotificationWidgetState();
}

class _InAppNotificationWidgetState extends State<InAppNotificationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();

    // Auto dismiss after duration
    Future.delayed(widget.duration, () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() {
    _animationController.reverse().then((_) {
      if (widget.onDismiss != null) {
        widget.onDismiss!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                if (widget.onTap != null) {
                  widget.onTap!();
                }
                _dismiss();
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: NotificationUtils.getColorByStatus(widget.notification.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        NotificationUtils.getIconByStatus(widget.notification.status),
                        color: NotificationUtils.getColorByStatus(widget.notification.status),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.notification.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                NotificationUtils.formatTimeAgo(widget.notification.time),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.notification.body,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (widget.notification.orderId != null) ...[
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Đơn hàng: ${widget.notification.orderId}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _dismiss,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationOverlay {
  static OverlayEntry? _overlayEntry;

  static void show(
    BuildContext context,
    NotificationModel notification, {
    VoidCallback? onTap,
    Duration duration = const Duration(seconds: 4),
  }) {
    hide(); // Hide any existing notification

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 0,
        right: 0,
        child: InAppNotificationWidget(
          notification: notification,
          duration: duration,
          onTap: onTap,
          onDismiss: () => hide(),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saimpexwater_vendorapp/core/constants/app_assets.dart';
import 'package:saimpexwater_vendorapp/models/home_order.dart';
import 'package:saimpexwater_vendorapp/views/home/pause_subscription_sheet.dart';

class SubscriptionDetailsView extends StatelessWidget {
  const SubscriptionDetailsView({super.key, required this.order});

  final SubscriptionOrder order;

  static const Color _orange = Color(0xFFFF5E21);
  static const Color _title = Color(0xFF1E212C);
  static const Color _muted = Color(0xFF8E8E8E);
  static const Color _purple = Color(0xFF6C63FF);
  static const Color _purpleBg = Color(0xFFF3EFFF);
  static const Color _activeGreen = Color(0xFF2EAD5B);

  bool get _isPaused => order.status == SubscriptionOrderStatus.paused;
  bool get _isActive => order.status == SubscriptionOrderStatus.active;
  bool get _isNew => order.status == SubscriptionOrderStatus.newOrder;
  /// New + Active share the full schedule layout from the design.
  bool get _showDeliverySchedule => _isActive || _isNew;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF8F4),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFF0E8),
                Color(0xFFFFF8F4),
                Color(0xFFF7F7F7),
              ],
              stops: [0, 0.2, 1],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 8),
                _Header(onBack: () => Navigator.of(context).maybePop()),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      _CustomerCard(order: order),
                      if (_isPaused) ...[
                        const SizedBox(height: 12),
                        _PausedStatusCard(order: order),
                      ],
                      const SizedBox(height: 16),
                      const Text(
                        'PLAN SUMMARY',
                        style: TextStyle(
                          color: _muted,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const _ProductCard(),
                      const SizedBox(height: 12),
                      _PlanGrid(
                        frequency: order.planName,
                        timeSlot: order.timeSlot,
                        startDate: 'Jul-22-2026',
                        endDate: 'Aug-22-2026',
                      ),
                      if (_showDeliverySchedule) ...[
                        const SizedBox(height: 10),
                        _NextDeliveryBar(
                          value: order.nextDelivery ?? 'Tomorrow',
                        ),
                        const SizedBox(height: 18),
                        const _SectionTitle(
                          title: 'UPCOMING DELIVERIES',
                          action: 'See All',
                        ),
                        const SizedBox(height: 10),
                        const _UpcomingDeliveriesCard(),
                      ],
                      const SizedBox(height: 18),
                      const _SectionTitle(
                        title: 'DELIVERY HISTORY',
                        action: 'See All',
                        titleColor: Color(0xFF96A1B1),
                      ),
                      const SizedBox(height: 10),
                      const _DeliveryHistoryCard(),
                      const SizedBox(height: 18),
                      const Text(
                        'PAYMENT SUMMARY',
                        style: TextStyle(
                          color: _muted,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const _PaymentSummary(),
                    ],
                  ),
                ),
                _BottomActions(
                  status: order.status,
                  pausedByVendor: order.pausedByVendor,
                  onPause: () => showPauseSubscriptionSheet(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 44,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Text(
              'Subscription Details',
              style: TextStyle(
                color: SubscriptionDetailsView._title,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: onBack,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: SubscriptionDetailsView._orange.withValues(
                        alpha: 0.35,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    color: SubscriptionDetailsView._orange,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.order});

  final SubscriptionOrder order;

  @override
  Widget build(BuildContext context) {
    final typeColor = order.isDelivery
        ? SubscriptionDetailsView._orange
        : const Color(0xFF2F80ED);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.person_search_outlined,
                color: SubscriptionDetailsView._orange,
                size: 18,
              ),
              const SizedBox(width: 6),
              const Text(
                'CUSTOMER',
                style: TextStyle(
                  color: SubscriptionDetailsView._orange,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: switch (order.status) {
                    // New-order details use the same green ACTIVE badge as the design.
                    SubscriptionOrderStatus.active ||
                    SubscriptionOrderStatus.newOrder =>
                      SubscriptionDetailsView._activeGreen,
                    SubscriptionOrderStatus.paused =>
                      SubscriptionDetailsView._orange,
                    SubscriptionOrderStatus.cancelled =>
                      const Color(0xFF9E9E9E),
                  },
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  switch (order.status) {
                    SubscriptionOrderStatus.newOrder ||
                    SubscriptionOrderStatus.active =>
                      'ACTIVE',
                    SubscriptionOrderStatus.paused => 'PAUSED',
                    SubscriptionOrderStatus.cancelled => 'CANCELLED',
                  },
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFFFE4E8),
                child: Text(
                  order.customerName[0].toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFFC62828),
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.customerName,
                      style: const TextStyle(
                        color: SubscriptionDetailsView._title,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      '+222 45 12 34 56',
                      style: TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: SubscriptionDetailsView._orange,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: SubscriptionDetailsView._orange
                          .withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.phone, color: Colors.white, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'REQUEST ID',
                      style: TextStyle(
                        color: Color(0xFFB0B0B0),
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: order.orderId,
                            style: const TextStyle(
                              color: SubscriptionDetailsView._orange,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          const TextSpan(
                            text: ' · Today · 10:45 AM',
                            style: TextStyle(
                              color: Color(0xFF5A5A5A),
                              fontWeight: FontWeight.w400,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DELIVERY TYPE',
                      style: TextStyle(
                        color: Color(0xFFB0B0B0),
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        ColorFiltered(
                          colorFilter: const ColorFilter.matrix(<double>[
                            1, 0, 0, 0, 0,
                            0, 1, 0, 0, 0,
                            0, 0, 1, 0, 0,
                            1, 1, 1, 0, 0,
                          ]),
                          child: Image.asset(
                            order.isDelivery
                                ? AppAssets.deliveryIcon
                                : AppAssets.selfPickupIcon,
                            width: 14,
                            height: 14,
                            errorBuilder: (_, _, _) => Icon(
                              order.isDelivery
                                  ? Icons.delivery_dining
                                  : Icons.shopping_bag_outlined,
                              size: 14,
                              color: typeColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          order.isDelivery ? 'Delivery' : 'Self Pickup',
                          style: TextStyle(
                            color: typeColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (order.isDelivery) ...[
            const SizedBox(height: 14),
            const Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: SubscriptionDetailsView._orange,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  'DELIVERY ADDRESS',
                  style: TextStyle(
                    color: SubscriptionDetailsView._orange,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFFFFF0E6),
                    child: Icon(
                      Icons.home_outlined,
                      color: SubscriptionDetailsView._orange,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sahara View Home',
                          style: TextStyle(
                            color: SubscriptionDetailsView._title,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Near Marhaba Supermarket, Nouakchott',
                          style: TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontWeight: FontWeight.w400,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 64,
              height: 64,
              color: const Color(0xFFE8E8E8),
              child: Image.asset(
                AppAssets.waterCan19L,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.water_drop,
                  color: Color(0xFF9E9E9E),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Drinking Water 19L',
                  style: TextStyle(
                    color: SubscriptionDetailsView._title,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Qty: 1',
                    style: TextStyle(
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanGrid extends StatelessWidget {
  const _PlanGrid({
    required this.frequency,
    required this.timeSlot,
    required this.startDate,
    required this.endDate,
  });

  final String frequency;
  final String timeSlot;
  final String startDate;
  final String endDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _PlanTile(
                icon: Icons.sync_rounded,
                label: 'Frequency',
                value: frequency,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _PlanTile(
                icon: Icons.access_time_rounded,
                label: 'Time Slot',
                value: timeSlot,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _PlanTile(
                icon: Icons.calendar_month_outlined,
                label: 'Start',
                value: startDate,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _PlanTile(
                icon: Icons.calendar_month_outlined,
                label: 'End',
                value: endDate,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PlanTile extends StatelessWidget {
  const _PlanTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: SubscriptionDetailsView._purpleBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: SubscriptionDetailsView._purple),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF8B83C7),
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: SubscriptionDetailsView._purple,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _NextDeliveryBar extends StatelessWidget {
  const _NextDeliveryBar({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: SubscriptionDetailsView._purpleBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_shipping_outlined,
            color: SubscriptionDetailsView._purple,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Next Delivery',
                  style: TextStyle(
                    color: Color(0xFF8B83C7),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: SubscriptionDetailsView._purple,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: SubscriptionDetailsView._purple,
            size: 24,
          ),
        ],
      ),
    );
  }
}

class _PausedStatusCard extends StatelessWidget {
  const _PausedStatusCard({required this.order});

  final SubscriptionOrder order;

  static const Color _amber = Color(0xFFF2A000);
  static const Color _cardBg = Color(0xFFFFF6E8);
  static const Color _labelGray = Color(0xFF9AA0A6);

  @override
  Widget build(BuildContext context) {
    final pausedBy = order.pausedByVendor ? 'You' : 'Customer';
    final pausedOn = order.pausedOn ?? 'Jul-24-2026 - 10:30 AM';
    final reason = order.pauseReason;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFE4B8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: _amber,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.pause_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Currently Paused',
                style: TextStyle(
                  color: _amber,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _PausedMetaRow(label: 'PAUSED BY:', value: pausedBy),
          const SizedBox(height: 6),
          _PausedMetaRow(label: 'PAUSED ON:', value: pausedOn),
          if (order.pausedByVendor &&
              reason != null &&
              reason.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            _PausedMetaRow(label: 'REASON:', value: reason),
          ],
        ],
      ),
    );
  }
}

class _PausedMetaRow extends StatelessWidget {
  const _PausedMetaRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _PausedStatusCard._labelGray,
            fontWeight: FontWeight.w600,
            fontSize: 11.5,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(
            color: SubscriptionDetailsView._title,
            fontWeight: FontWeight.w700,
            fontSize: 12.5,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.action,
    this.titleColor = SubscriptionDetailsView._muted,
  });

  final String title;
  final String action;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              letterSpacing: 0.4,
            ),
          ),
        ),
        Text(
          action,
          style: const TextStyle(
            color: Color(0xFFEB6F3D),
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _UpcomingDeliveriesCard extends StatelessWidget {
  const _UpcomingDeliveriesCard();

  static const items = [
    ('23', 'Tomorrow', '08:30 AM'),
    ('24', 'Sunday', '08:30 AM'),
    ('25', 'Saturday', '08:30 AM'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: Color(0xFFF0F0F0)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: SubscriptionDetailsView._purpleBg,
                    child: Text(
                      items[i].$1,
                      style: const TextStyle(
                        color: SubscriptionDetailsView._purple,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      items[i].$2,
                      style: const TextStyle(
                        color: SubscriptionDetailsView._title,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: SubscriptionDetailsView._purple,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    items[i].$3,
                    style: const TextStyle(
                      color: SubscriptionDetailsView._purple,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DeliveryHistoryCard extends StatelessWidget {
  const _DeliveryHistoryCard();

  static const Color _deliveredGreen = Color(0xFF0A6B3D);
  static const Color _deliveredBg = Color(0xFFE8F5EE);
  static const Color _progressBlue = Color(0xFF005B99);
  static const Color _progressBg = Color(0xFFEBF2F9);
  static const Color _detailGray = Color(0xFF505B66);
  static const Color _lineGray = Color(0xFFE0E4EA);

  static const items = [
    (true, 'Delivered', 'Order #22789104 - 23-Jul-2026'),
    (true, 'Delivered', 'Order #22789104 - 24-Jul-2026'),
    (false, 'In Progress', 'Order #22789112 - Processing'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 36,
                    child: Column(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: items[i].$1 ? _deliveredBg : _progressBg,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            items[i].$1
                                ? Icons.check_rounded
                                : Icons.sync_rounded,
                            size: 18,
                            color: items[i].$1
                                ? _deliveredGreen
                                : _progressBlue,
                          ),
                        ),
                        if (i < items.length - 1)
                          Expanded(
                            child: Container(
                              width: 2,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              color: _lineGray,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: i < items.length - 1 ? 20 : 0,
                        top: 2,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            items[i].$2,
                            style: TextStyle(
                              color: items[i].$1
                                  ? _deliveredGreen
                                  : _progressBlue,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            items[i].$3,
                            style: const TextStyle(
                              color: _detailGray,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PaymentSummary extends StatelessWidget {
  const _PaymentSummary();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          _PayRow(label: 'Subscription Amount', value: '9000 MRU'),
          SizedBox(height: 10),
          _PayRow(
            label: 'Subscription Savings',
            value: '-4500 MRU',
            valueColor: SubscriptionDetailsView._orange,
          ),
          SizedBox(height: 10),
          _PayRow(label: 'Estimated Delivery Fee', value: '900 MRU'),
          SizedBox(height: 10),
          _PayRow(label: 'Tax', value: '100 MRU'),
          SizedBox(height: 10),
          _PayRow(
            label: 'Payment on',
            value: 'Feb 07, 2026 10:45 AM, Today',
            valueColor: Color(0xFFB0B0B0),
            valueSize: 12,
          ),
          SizedBox(height: 12),
          Divider(color: Color(0xFF444444), height: 1),
          SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Total payed',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              Spacer(),
              Text(
                '5500 MRU',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PayRow extends StatelessWidget {
  const _PayRow({
    required this.label,
    required this.value,
    this.valueColor = Colors.white,
    this.valueSize = 13.5,
  });

  final String label;
  final String value;
  final Color valueColor;
  final double valueSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 13.5,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.w500,
              fontSize: valueSize,
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.status,
    required this.pausedByVendor,
    required this.onPause,
  });

  final SubscriptionOrderStatus status;
  final bool pausedByVendor;
  final VoidCallback onPause;

  Widget _chatButton({bool fullWidth = false}) {
    return SizedBox(
      height: 50,
      width: fullWidth ? double.infinity : null,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: SubscriptionDetailsView._orange,
          backgroundColor: Colors.white,
          side: const BorderSide(
            color: SubscriptionDetailsView._orange,
            width: 1.2,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_bubble_outline, size: 18),
              SizedBox(width: 6),
              Text(
                'Chat With Customer',
                maxLines: 1,
                softWrap: false,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _primaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    double iconSize = 18,
  }) {
    return SizedBox(
      height: 50,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: SubscriptionDetailsView._orange.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: SubscriptionDetailsView._orange,
            foregroundColor: Colors.white,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: iconSize),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCustomerPaused =
        status == SubscriptionOrderStatus.paused && !pausedByVendor;
    final isVendorPaused =
        status == SubscriptionOrderStatus.paused && pausedByVendor;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: SafeArea(
        top: false,
        child: isCustomerPaused
            ? _chatButton(fullWidth: true)
            : Row(
                children: [
                  Expanded(child: _chatButton()),
                  const SizedBox(width: 12),
                  Expanded(
                    child: isVendorPaused
                        ? _primaryButton(
                            label: 'Resume',
                            icon: Icons.play_arrow_rounded,
                            iconSize: 20,
                            onPressed: () {},
                          )
                        : _primaryButton(
                            label: 'Pause',
                            icon: Icons.pause,
                            onPressed: onPause,
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}

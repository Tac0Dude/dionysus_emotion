import 'package:flutter/material.dart';

import '../../common/date_helpers.dart';
import '../../theme/app_colors.dart';

class CalendarGrid extends StatelessWidget {
  final DateTime month;
  final Map<DateTime, Color> dayColors;
  final void Function(DateTime) onDayTap;

  const CalendarGrid({
    super.key,
    required this.month,
    required this.dayColors,
    required this.onDayTap,
  });

  static const _weekdayLabels = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leadingEmpty = (firstOfMonth.weekday - 1) % 7;
    final today = normalizeDate(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: _weekdayLabels
              .map(
                (label) => Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 4),
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 6.0;
            final cellWidth =
                (constraints.maxWidth - spacing * 6) / 7;
            final totalCells = leadingEmpty + daysInMonth;
            final rows = (totalCells / 7).ceil();
            return Column(
              children: List.generate(rows, (rowIndex) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: rowIndex == rows - 1 ? 0 : spacing,
                  ),
                  child: Row(
                    children: List.generate(7, (col) {
                      final cellIndex = rowIndex * 7 + col;
                      final dayNumber = cellIndex - leadingEmpty + 1;
                      Widget cell;
                      if (dayNumber < 1 || dayNumber > daysInMonth) {
                        cell = SizedBox(width: cellWidth, height: cellWidth);
                      } else {
                        final date = DateTime(month.year, month.month, dayNumber);
                        final color = dayColors[date];
                        final isToday = normalizeDate(date) == today;
                        cell = SizedBox(
                          width: cellWidth,
                          height: cellWidth,
                          child: _DayCell(
                            day: dayNumber,
                            color: color,
                            isToday: isToday,
                            onTap: () => onDayTap(date),
                          ),
                        );
                      }
                      return Padding(
                        padding: EdgeInsets.only(
                          right: col == 6 ? 0 : spacing,
                        ),
                        child: cell,
                      );
                    }),
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final Color? color;
  final bool isToday;
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    required this.color,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasColor = color != null;
    return Material(
      color: hasColor ? color : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          alignment: Alignment.center,
          decoration: isToday && !hasColor
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: AppColors.primary, width: 1.4),
                )
              : null,
          child: Text(
            '$day',
            style: TextStyle(
              fontSize: 14,
              fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

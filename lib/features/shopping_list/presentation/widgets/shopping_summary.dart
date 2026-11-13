import 'package:flutter/material.dart';
import 'package:shopping_list/core/utils/polish_plural.dart';

class ShoppingSummary extends StatelessWidget {
  final int boughtCount;
  final int totalCount;

  const ShoppingSummary({
    super.key,
    required this.boughtCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remaining = totalCount - boughtCount;
    final progress = totalCount == 0 ? 0.0 : boughtCount / totalCount;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Text(
              remaining == 0
                  ? 'Wszystko kupione 🎉'
                  : '${pluralize(remaining, 'Został', 'Zostały', 'Zostało')} '
                        '$remaining ${pluralize(remaining, 'produkt', 'produkty', 'produktów')}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: progress, minHeight: 8),
            ),
            Text(
              '$boughtCount z $totalCount w koszyku',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

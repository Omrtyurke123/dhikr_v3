import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/adhkar_data.dart';
import '../models/types.dart';
import 'tasbeeh_counter_screen.dart';

class TasbeehScreen extends StatelessWidget {
  const TasbeehScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final allDhikr = AdhkarData.categories
        .expand((c) => c.adhkar)
        .where((d) => d.count >= 10)
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: allDhikr.length,
      itemBuilder: (_, i) {
        final d = allDhikr[i];
        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => TasbeehCounterScreen(dhikr: d))),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(d.arabic,
                            style: const TextStyle(
                              color: AppTheme.textPrimary, fontSize: 17, height: 1.6,
                            )),
                        if (d.virtue != null) ...[
                          const SizedBox(height: 4),
                          Text('✨ ${d.virtue!}',
                              style: const TextStyle(color: AppTheme.accentGold, fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${d.count}',
                            style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16,
                            )),
                        const Text('مرة',
                            style: TextStyle(color: Colors.white70, fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

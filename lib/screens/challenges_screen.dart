import 'package:flutter/material.dart';
import 'dart:convert';
import '../theme/app_theme.dart';
import '../models/types.dart';
import '../services/storage_service.dart';
import '../data/adhkar_data.dart';
import 'challenge_counter_screen.dart';

// ===== Challenges Screen =====
class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  List<DailyChallenge> _challenges = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await StorageService.getChallenges();
    setState(() => _challenges = list);
  }

  Future<void> _delete(String id) async {
    await StorageService.deleteChallenge(id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.accentGreen,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('تحدي جديد', style: TextStyle(color: Colors.white)),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ChallengeSetupScreen()))
            .then((_) => _load()),
      ),
      body: _challenges.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🏆', style: TextStyle(fontSize: 60)),
                  SizedBox(height: 16),
                  Text('لا يوجد تحديات بعد',
                      style: TextStyle(color: AppTheme.textPrimary, fontSize: 18)),
                  SizedBox(height: 8),
                  Text('اضغط "تحدي جديد" لبدء تحدي يومي',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
              itemCount: _challenges.length,
              itemBuilder: (_, i) {
                final c = _challenges[i];
                return _ChallengeCard(
                  challenge: c,
                  onDelete: () => _delete(c.id),
                  onRefresh: _load,
                );
              },
            ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final DailyChallenge challenge;
  final VoidCallback onDelete;
  final VoidCallback onRefresh;
  const _ChallengeCard({required this.challenge, required this.onDelete, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(challenge.name,
                      style: const TextStyle(
                        color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold,
                      )),
                ),
                if (challenge.isCompleted)
                  const Text('✅', style: TextStyle(fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppTheme.dangerColor, size: 20),
                  onPressed: onDelete,
                ),
              ],
            ),
            Text(challenge.dhikrText,
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 10),
            // عرض العداد المخصص
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.accentGold.withOpacity(0.4)),
                  ),
                  child: Text(
                    'الهدف: ${challenge.targetCount} مرة',
                    style: const TextStyle(color: AppTheme.accentGold, fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: challenge.progress,
                      backgroundColor: AppTheme.borderColor,
                      color: challenge.isCompleted ? AppTheme.successColor : AppTheme.accentGreen,
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('${challenge.currentCount}/${challenge.targetCount}',
                    style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold)),
              ],
            ),
            if (!challenge.isCompleted) ...[
              const SizedBox(height: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.touch_app, size: 16),
                label: const Text('متابعة التحدي'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChallengeCounterScreen(challenge: challenge),
                  ),
                ).then((_) => onRefresh()),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ===== Challenge Setup Screen =====
class ChallengeSetupScreen extends StatefulWidget {
  const ChallengeSetupScreen({super.key});

  @override
  State<ChallengeSetupScreen> createState() => _ChallengeSetupScreenState();
}

class _ChallengeSetupScreenState extends State<ChallengeSetupScreen> {
  final _nameCtrl = TextEditingController();
  final _targetCtrl = TextEditingController(text: '33');
  DhikrItem? _selectedDhikr;

  final _allDhikr = AdhkarData.categories.expand((c) => c.adhkar).toList();

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدخل اسم التحدي')));
      return;
    }
    if (_selectedDhikr == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختر ذكراً')));
      return;
    }
    // العداد المخصص — مش عدد الذكر الأصلي
    final target = int.tryParse(_targetCtrl.text) ?? 33;
    if (target <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدخل عدداً صحيحاً')));
      return;
    }

    await StorageService.addChallenge(DailyChallenge(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      dhikrId: _selectedDhikr!.id,
      dhikrText: _selectedDhikr!.arabic,
      targetCount: target, // العداد المخصص للتحدي
      createdAt: DateTime.now().toIso8601String(),
    ));
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحدي جديد'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('حفظ', style: TextStyle(color: AppTheme.accentGreen, fontSize: 16)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildField(_nameCtrl, 'اسم التحدي', 'مثال: استغفار اليوم'),
                const SizedBox(height: 12),
                // العداد المخصص
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('عدد المرات المطلوبة في التحدي',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _targetCtrl,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 18),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppTheme.cardColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // أزرار سريعة
                        Wrap(
                          spacing: 4,
                          children: [10, 33, 100, 500].map((n) =>
                            GestureDetector(
                              onTap: () => setState(() => _targetCtrl.text = '$n'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentGreen.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppTheme.accentGreen.withOpacity(0.4)),
                                ),
                                child: Text('$n', style: const TextStyle(color: AppTheme.accentGreen, fontSize: 12)),
                              ),
                            ),
                          ).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('* هذا هو عدد مرات التحدي، مستقل عن عدد الذكر الأصلي',
                        style: TextStyle(color: AppTheme.accentGold, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('اختر الذكر:',
                  style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _allDhikr.length,
              itemBuilder: (_, i) {
                final d = _allDhikr[i];
                final isSelected = _selectedDhikr?.id == d.id;
                return Card(
                  color: isSelected ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: isSelected ? AppTheme.accentGreen : Colors.transparent),
                  ),
                  child: ListTile(
                    title: Text(d.arabic,
                        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    subtitle: Text(d.meaning,
                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                    onTap: () => setState(() => _selectedDhikr = d),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: AppTheme.accentGreen)
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          textAlign: TextAlign.right,
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppTheme.textSecondary),
            filled: true,
            fillColor: AppTheme.cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _hapticEnabled = true;
  bool _notifEnabled = false;
  String _morningTime = '07:00';
  String _eveningTime = '18:00';
  int _periodicHours = 0;
  int _dailyGoal = 1000;
  final _goalCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _goalCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final haptic = await StorageService.getHapticEnabled();
    final notif = await StorageService.getNotificationsEnabled();
    final morning = await StorageService.getMorningNotifTime();
    final evening = await StorageService.getEveningNotifTime();
    final goal = await StorageService.getDailyGoal();
    setState(() {
      _hapticEnabled = haptic;
      _notifEnabled = notif;
      _morningTime = morning;
      _eveningTime = evening;
      _dailyGoal = goal;
      _goalCtrl.text = '$goal';
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    if (value) {
      await NotificationService.init();
      await NotificationService.scheduleMorningReminder(_morningTime);
      await NotificationService.scheduleEveningReminder(_eveningTime);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('âœ… طھظ… طھظپط¹ظٹظ„ ط§ظ„ط¥ط´ط¹ط§ط±ط§طھ'),
            backgroundColor: Color(0xFF6B8F3E),
          ),
        );
      }
    } else {
      await NotificationService.cancelAll();
    }
    await StorageService.setNotificationsEnabled(value);
    setState(() => _notifEnabled = value);
  }

  Future<void> _pickTime(bool isMorning) async {
    final current = isMorning ? _morningTime : _eveningTime;
    final parts = current.split(':');
    final initial = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: AppTheme.accentGreen),
        ),
        child: child!,
      ),
    );
    if (picked == null || !mounted) return;
    final formatted =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    if (isMorning) {
      await StorageService.setMorningNotifTime(formatted);
      if (_notifEnabled) await NotificationService.scheduleMorningReminder(formatted);
      setState(() => _morningTime = formatted);
    } else {
      await StorageService.setEveningNotifTime(formatted);
      if (_notifEnabled) await NotificationService.scheduleEveningReminder(formatted);
      setState(() => _eveningTime = formatted);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('âœ… طھظ… طھط­ط¯ظٹط« ظˆظ‚طھ ط§ظ„ط¥ط´ط¹ط§ط± ط¥ظ„ظ‰ $formatted')),
      );
    }
  }

  Future<void> _saveGoal() async {
    final val = int.tryParse(_goalCtrl.text);
    if (val == null || val <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ط£ط¯ط®ظ„ ط±ظ‚ظ…ط§ظ‹ طµط­ظٹط­ط§ظ‹')));
      return;
    }
    await StorageService.setDailyGoal(val);
    setState(() => _dailyGoal = val);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('âœ… طھظ… ط­ظپط¸ ط§ظ„ظ‡ط¯ظپ'), backgroundColor: Color(0xFF6B8F3E)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ط§ظ„ط¥ط¹ط¯ط§ط¯ط§طھ âڑ™ï¸ڈ')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // ===== ط§ظ„ظ‡ط¯ظپ ط§ظ„ظٹظˆظ…ظٹ =====
          _Section('ًںژ¯ ط§ظ„ظ‡ط¯ظپ ط§ظ„ظٹظˆظ…ظٹ'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('ط¹ط¯ط¯ ط§ظ„ط£ط°ظƒط§ط± ط§ظ„ظٹظˆظ…ظٹط© ط§ظ„ظ…ط·ظ„ظˆط¨ط©',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                      child: TextField(
                        controller: _goalCtrl,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppTheme.bgColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppTheme.borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppTheme.borderColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(onPressed: _saveGoal, child: const Text('ط­ظپط¸')),
                  ]),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: [100, 500, 1000, 2000].map((n) =>
                      ActionChip(
                        label: Text('$n', style: const TextStyle(color: AppTheme.accentGreen, fontSize: 12)),
                        backgroundColor: AppTheme.accentGreen.withOpacity(0.1),
                        side: BorderSide(color: AppTheme.accentGreen.withOpacity(0.3)),
                        onPressed: () {
                          _goalCtrl.text = '$n';
                          _saveGoal();
                        },
                      ),
                    ).toList(),
                  ),
                ],
              ),
            ),
          ),

          // ===== ط§ظ„ط§ظ‡طھط²ط§ط² =====
          _Section('ًں“³ ط§ظ„ط§ظ‡طھط²ط§ط²'),
          Card(
            child: SwitchListTile(
              title: const Text('طھظپط¹ظٹظ„ ط§ظ„ط§ظ‡طھط²ط§ط²',
                  style: TextStyle(color: AppTheme.textPrimary)),
              subtitle: const Text('ط§ظ‡طھط²ط§ط² ط®ظپظٹظپ ط¹ظ†ط¯ ظƒظ„ طھط³ط¨ظٹط­ط©',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
              value: _hapticEnabled,
              onChanged: (v) async {
                await StorageService.setHapticEnabled(v);
                setState(() => _hapticEnabled = v);
              },
            ),
          ),

          // ===== ط§ظ„ط¥ط´ط¹ط§ط±ط§طھ =====
          _Section('ًں”” ط§ظ„ط¥ط´ط¹ط§ط±ط§طھ'),
          Card(
            child: Column(children: [
              SwitchListTile(
                title: const Text('طھظپط¹ظٹظ„ ط¥ط´ط¹ط§ط±ط§طھ ط§ظ„ط£ط°ظƒط§ط±',
                    style: TextStyle(color: AppTheme.textPrimary)),
                subtitle: const Text('طھط°ظƒظٹط±ط§طھ ظٹظˆظ…ظٹط© ط¨ط£ط°ظƒط§ط± ط§ظ„طµط¨ط§ط­ ظˆط§ظ„ظ…ط³ط§ط،',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                value: _notifEnabled,
                onChanged: _toggleNotifications,
              ),
              if (_notifEnabled) ...[
                const Divider(color: AppTheme.borderColor, height: 1),
                // ظˆظ‚طھ ط§ظ„طµط¨ط§ط­
                ListTile(
                  leading: const Text('ًںŒ…', style: TextStyle(fontSize: 22)),
                  title: const Text('ط¥ط´ط¹ط§ط± ط§ظ„طµط¨ط§ط­',
                      style: TextStyle(color: AppTheme.textPrimary)),
                  trailing: GestureDetector(
                    onTap: () => _pickTime(true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGreen.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.accentGreen),
                      ),
                      child: Text(_morningTime,
                          style: const TextStyle(
                              color: AppTheme.accentGreen, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  onTap: () => _pickTime(true),
                ),
                const Divider(color: AppTheme.borderColor, height: 1),
                // ظˆظ‚طھ ط§ظ„ظ…ط³ط§ط،
                ListTile(
                  leading: const Text('ًںŒ‡', style: TextStyle(fontSize: 22)),
                  title: const Text('ط¥ط´ط¹ط§ط± ط§ظ„ظ…ط³ط§ط،',
                      style: TextStyle(color: AppTheme.textPrimary)),
                  trailing: GestureDetector(
                    onTap: () => _pickTime(false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGreen.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.accentGreen),
                      ),
                      child: Text(_eveningTime,
                          style: const TextStyle(
                              color: AppTheme.accentGreen, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  onTap: () => _pickTime(false),
                ),
                const Divider(color: AppTheme.borderColor, height: 1),
                // ط²ط± ط§ط®طھط¨ط§ط±
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.notifications_active),
                    label: const Text('ط¥ط±ط³ط§ظ„ ط¥ط´ط¹ط§ط± طھط¬ط±ظٹط¨ظٹ ط§ظ„ط¢ظ†'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 46),
                    ),
                    onPressed: () async {
                      await NotificationService.init();
                      await NotificationService.showTestNotification();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('ًں“³ طھظ… ط¥ط±ط³ط§ظ„ ط¥ط´ط¹ط§ط± طھط¬ط±ظٹط¨ظٹ â€” طھط­ظ‚ظ‚ ظ…ظ† ط´ط±ظٹط· ط§ظ„ط¥ط´ط¹ط§ط±ط§طھ'),
                            backgroundColor: Color(0xFF6B8F3E),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ]),
          ),

          // ===== ظ…ط¹ظ„ظˆظ…ط§طھ =====
          _Section('â„¹ï¸ڈ ط¹ظ† ط§ظ„طھط·ط¨ظٹظ‚'),
          Card(
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(children: [
                Text('Azkar Filter',
                    style: TextStyle(
                        color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('ط§ظ„ط¥طµط¯ط§ط± 2.0.0',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                SizedBox(height: 8),
                Text(
                  'طھط·ط¨ظٹظ‚ ط¥ط³ظ„ط§ظ…ظٹ ط´ط§ظ…ظ„ ظ„ظ„ط£ط°ظƒط§ط± ظˆط§ظ„طھط³ط¨ظٹط­\nظ…ط¹ ظˆط¶ط¹ ط§ظ„ط±ط­ظ„ط© ظˆط§ظ„ط¥ط´ط¹ط§ط±ط§طھ ط§ظ„ظٹظˆظ…ظٹط©',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  const _Section(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 14, 4, 8),
      child: Text(title,
          style: const TextStyle(
              color: AppTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
    );
  }
}


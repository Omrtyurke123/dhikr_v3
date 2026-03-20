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
  int _dailyGoal = 1000;
  final _goalCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
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
      await NotificationService.requestPermissions();
      await NotificationService.scheduleMorningReminder(_morningTime);
      await NotificationService.scheduleEveningReminder(_eveningTime);
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

    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;

    final formatted = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';

    if (isMorning) {
      await StorageService.setMorningNotifTime(formatted);
      if (_notifEnabled) await NotificationService.scheduleMorningReminder(formatted);
      setState(() => _morningTime = formatted);
    } else {
      await StorageService.setEveningNotifTime(formatted);
      if (_notifEnabled) await NotificationService.scheduleEveningReminder(formatted);
      setState(() => _eveningTime = formatted);
    }
  }

  Future<void> _saveGoal() async {
    final val = int.tryParse(_goalCtrl.text);
    if (val != null && val > 0) {
      await StorageService.setDailyGoal(val);
      setState(() => _dailyGoal = val);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ تم حفظ الهدف')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات ⚙️')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // ===== الهدف اليومي =====
          _SectionTitle(title: '🎯 الهدف اليومي'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('عدد الأذكار اليومية المطلوبة',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _goalCtrl,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          style: const TextStyle(color: AppTheme.textPrimary),
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
                      ElevatedButton(
                        onPressed: _saveGoal,
                        child: const Text('حفظ'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ===== الاهتزاز =====
          _SectionTitle(title: '📳 الاهتزاز'),
          Card(
            child: SwitchListTile(
              title: const Text('تفعيل الاهتزاز',
                  style: TextStyle(color: AppTheme.textPrimary)),
              subtitle: const Text('اهتزاز خفيف عند كل تسبيحة',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              value: _hapticEnabled,
              onChanged: (v) async {
                await StorageService.setHapticEnabled(v);
                setState(() => _hapticEnabled = v);
              },
            ),
          ),

          // ===== الإشعارات =====
          _SectionTitle(title: '🔔 الإشعارات'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('تفعيل الإشعارات',
                      style: TextStyle(color: AppTheme.textPrimary)),
                  subtitle: const Text('تذكيرات بالأذكار اليومية',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  value: _notifEnabled,
                  onChanged: _toggleNotifications,
                ),
                if (_notifEnabled) ...[
                  const Divider(color: AppTheme.borderColor),
                  ListTile(
                    title: const Text('وقت إشعار الصباح',
                        style: TextStyle(color: AppTheme.textPrimary)),
                    trailing: Text(_morningTime,
                        style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold)),
                    onTap: () => _pickTime(true),
                  ),
                  const Divider(color: AppTheme.borderColor),
                  ListTile(
                    title: const Text('وقت إشعار المساء',
                        style: TextStyle(color: AppTheme.textPrimary)),
                    trailing: Text(_eveningTime,
                        style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold)),
                    onTap: () => _pickTime(false),
                  ),
                  const Divider(color: AppTheme.borderColor),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.notifications_active),
                      label: const Text('إرسال إشعار تجريبي'),
                      onPressed: () async {
                        await NotificationService.showInstantNotification(
                          '📿 تذكير بالذكر',
                          'لا تنسَ ذكر الله — سبّح الله واستغفر',
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم إرسال الإشعار ✅')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ===== معلومات =====
          _SectionTitle(title: 'ℹ️ عن التطبيق'),
          Card(
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('تطبيق الذكر والتسبيح',
                      style: TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('الإصدار 2.0.0',
                      style: TextStyle(color: AppTheme.textSecondary)),
                  SizedBox(height: 8),
                  Text(
                    'تطبيق إسلامي شامل للأذكار والتسبيح مع إشعارات تذكير يومية',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      child: Text(title,
          style: const TextStyle(
            color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold,
          )),
    );
  }
}

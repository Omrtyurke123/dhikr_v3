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
      final granted = await NotificationService.requestPermissions();
      if (!granted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ لم يتم منح إذن الإشعارات — فعّله من إعدادات الهاتف'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      await NotificationService.scheduleMorningReminder(_morningTime);
      await NotificationService.scheduleEveningReminder(_eveningTime);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ تم تفعيل الإشعارات'),
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
        SnackBar(content: Text('✅ تم تحديث وقت الإشعار إلى $formatted')),
      );
    }
  }

  Future<void> _saveGoal() async {
    final val = int.tryParse(_goalCtrl.text);
    if (val == null || val <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدخل رقماً صحيحاً')));
      return;
    }
    await StorageService.setDailyGoal(val);
    setState(() => _dailyGoal = val);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ تم حفظ الهدف'), backgroundColor: Color(0xFF6B8F3E)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات ⚙️')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // ===== الهدف اليومي =====
          _Section('🎯 الهدف اليومي'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('عدد الأذكار اليومية المطلوبة',
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
                    ElevatedButton(onPressed: _saveGoal, child: const Text('حفظ')),
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

          // ===== الاهتزاز =====
          _Section('📳 الاهتزاز'),
          Card(
            child: SwitchListTile(
              title: const Text('تفعيل الاهتزاز',
                  style: TextStyle(color: AppTheme.textPrimary)),
              subtitle: const Text('اهتزاز خفيف عند كل تسبيحة',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
              value: _hapticEnabled,
              onChanged: (v) async {
                await StorageService.setHapticEnabled(v);
                setState(() => _hapticEnabled = v);
              },
            ),
          ),

          // ===== الإشعارات =====
          _Section('🔔 الإشعارات'),
          Card(
            child: Column(children: [
              SwitchListTile(
                title: const Text('تفعيل إشعارات الأذكار',
                    style: TextStyle(color: AppTheme.textPrimary)),
                subtitle: const Text('تذكيرات يومية بأذكار الصباح والمساء',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                value: _notifEnabled,
                onChanged: _toggleNotifications,
              ),
              if (_notifEnabled) ...[
                const Divider(color: AppTheme.borderColor, height: 1),
                // وقت الصباح
                ListTile(
                  leading: const Text('🌅', style: TextStyle(fontSize: 22)),
                  title: const Text('إشعار الصباح',
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
                // وقت المساء
                ListTile(
                  leading: const Text('🌇', style: TextStyle(fontSize: 22)),
                  title: const Text('إشعار المساء',
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
                // زر اختبار
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.notifications_active),
                    label: const Text('إرسال إشعار تجريبي الآن'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 46),
                    ),
                    onPressed: () async {
                      await NotificationService.init();
                      await NotificationService.showTestNotification();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('📳 تم إرسال إشعار تجريبي — تحقق من شريط الإشعارات'),
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

          // ===== معلومات =====
          _Section('ℹ️ عن التطبيق'),
          Card(
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(children: [
                Text('Azkar Filter',
                    style: TextStyle(
                        color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('الإصدار 2.0.0',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                SizedBox(height: 8),
                Text(
                  'تطبيق إسلامي شامل للأذكار والتسبيح\nمع وضع الرحلة والإشعارات اليومية',
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

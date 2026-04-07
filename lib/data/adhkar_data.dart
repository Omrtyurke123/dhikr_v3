import '../models/types.dart';

class AdhkarData {
  static List<DhikrCategory> get categories => [
    // ===== أذكار الصباح =====
    DhikrCategory(
      id: 'morning', name: 'أذكار الصباح', icon: '🌅', type: CategoryType.morning,
      description: 'أذكار تُقال بعد صلاة الفجر حتى الضحى',
      adhkar: [
        const DhikrItem(id: 'm1', arabic: 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ\nبِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ', transliteration: 'Audhu billahi minash shaytanir rajeem', meaning: 'التعوذ والبسملة', count: 1, category: CategoryType.morning),
        const DhikrItem(id: 'm2', arabic: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، رَبِّ أَسْأَلُكَ خَيْرَ مَا فِي هَذَا الْيَوْمِ وَخَيْرَ مَا بَعْدَهُ', transliteration: 'Asbahna wa asbahal mulku lillah...', meaning: 'أصبحنا وأصبح الملك لله', count: 1, source: 'أبو داود', category: CategoryType.morning),
        const DhikrItem(id: 'm3', arabic: 'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ', transliteration: 'Allahumma bika asbahna...', meaning: 'اللهم بك أصبحنا', count: 1, source: 'الترمذي', category: CategoryType.morning),
        const DhikrItem(id: 'm4', arabic: 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ', transliteration: 'Allahumma anta rabbi...', meaning: 'سيد الاستغفار', count: 1, source: 'البخاري', category: CategoryType.morning, virtue: 'من قالها موقناً فمات من يومه دخل الجنة'),
        const DhikrItem(id: 'm5', arabic: 'اللَّهُمَّ إِنِّي أَصْبَحْتُ أُشْهِدُكَ وَأُشْهِدُ حَمَلَةَ عَرْشِكَ وَمَلَائِكَتَكَ وَجَمِيعَ خَلْقِكَ أَنَّكَ أَنْتَ اللَّهُ لَا إِلَهَ إِلَّا أَنْتَ وَحْدَكَ لَا شَرِيكَ لَكَ وَأَنَّ مُحَمَّدًا عَبْدُكَ وَرَسُولُكَ', transliteration: 'Allahumma inni asbahtu ushiduka...', meaning: 'اللهم إني أصبحت أشهدك', count: 4, source: 'أبو داود', category: CategoryType.morning, virtue: 'أعتق الله ربعه من النار'),
        const DhikrItem(id: 'm6', arabic: 'اللَّهُمَّ مَا أَصْبَحَ بِي مِنْ نِعْمَةٍ أَوْ بِأَحَدٍ مِنْ خَلْقِكَ فَمِنْكَ وَحْدَكَ لَا شَرِيكَ لَكَ، فَلَكَ الْحَمْدُ وَلَكَ الشُّكْرُ', transliteration: 'Allahumma ma asbaha bi min nimah...', meaning: 'اللهم ما أصبح بي من نعمة', count: 1, source: 'أبو داود', category: CategoryType.morning, virtue: 'من قالها فقد أدى شكر يومه'),
        const DhikrItem(id: 'm7', arabic: 'اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي، لَا إِلَهَ إِلَّا أَنْتَ', transliteration: 'Allahumma afini fi badani...', meaning: 'اللهم عافني في بدني', count: 3, source: 'أبو داود', category: CategoryType.morning),
        const DhikrItem(id: 'm8', arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْكُفْرِ وَالْفَقْرِ، اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ عَذَابِ الْقَبْرِ، لَا إِلَهَ إِلَّا أَنْتَ', transliteration: 'Allahumma inni audhu bika minal kufri wal faqr...', meaning: 'التعوذ من الكفر والفقر وعذاب القبر', count: 3, source: 'أبو داود', category: CategoryType.morning),
        const DhikrItem(id: 'm9', arabic: 'حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ', transliteration: 'Hasbiyallahu la ilaha illa huwa...', meaning: 'حسبي الله', count: 7, source: 'أبو داود', category: CategoryType.morning, virtue: 'كفاه الله ما أهمه'),
        const DhikrItem(id: 'm10', arabic: 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ', transliteration: 'Bismillahil ladhi la yadurru...', meaning: 'بسم الله الذي لا يضر مع اسمه شيء', count: 3, source: 'الترمذي', category: CategoryType.morning, virtue: 'لم يضره شيء'),
        const DhikrItem(id: 'm11', arabic: 'رَضِيتُ بِاللَّهِ رَبًّا وَبِالْإِسْلَامِ دِينًا وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا', transliteration: 'Radheetu billahi rabba...', meaning: 'رضيت بالله رباً وبالإسلام ديناً', count: 3, source: 'الترمذي', category: CategoryType.morning, virtue: 'كان حقاً على الله أن يرضيه'),
        const DhikrItem(id: 'm12', arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ', transliteration: 'Subhanallahi wa bihamdih', meaning: 'سبحان الله وبحمده', count: 100, source: 'مسلم', category: CategoryType.morning, virtue: 'حطت خطاياه وإن كانت مثل زبد البحر'),
        const DhikrItem(id: 'm13', arabic: 'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ', transliteration: 'Allahumma salli wa sallim ala nabiyyina Muhammad', meaning: 'الصلاة على النبي', count: 10, source: 'الترمذي', category: CategoryType.morning, virtue: 'صلى الله عليه بها عشراً'),
        const DhikrItem(id: 'm14', arabic: 'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ', transliteration: 'Astaghfirullaha wa atubu ilayh', meaning: 'أستغفر الله وأتوب إليه', count: 100, source: 'البخاري', category: CategoryType.morning),
      ],
    ),

    // ===== أذكار المساء =====
    DhikrCategory(
      id: 'evening', name: 'أذكار المساء', icon: '🌇', type: CategoryType.evening,
      description: 'أذكار تُقال بعد صلاة العصر حتى المغرب',
      adhkar: [
        const DhikrItem(id: 'e1', arabic: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، رَبِّ أَسْأَلُكَ خَيْرَ مَا فِي هَذِهِ اللَّيْلَةِ وَخَيْرَ مَا بَعْدَهَا', transliteration: 'Amsayna wa amsal mulku lillah...', meaning: 'أمسينا وأمسى الملك لله', count: 1, source: 'أبو داود', category: CategoryType.evening),
        const DhikrItem(id: 'e2', arabic: 'اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ الْمَصِيرُ', transliteration: 'Allahumma bika amsayna...', meaning: 'اللهم بك أمسينا', count: 1, source: 'الترمذي', category: CategoryType.evening),
        const DhikrItem(id: 'e3', arabic: 'اللَّهُمَّ إِنِّي أَمْسَيْتُ أُشْهِدُكَ وَأُشْهِدُ حَمَلَةَ عَرْشِكَ وَمَلَائِكَتَكَ وَجَمِيعَ خَلْقِكَ أَنَّكَ أَنْتَ اللَّهُ لَا إِلَهَ إِلَّا أَنْتَ وَحْدَكَ لَا شَرِيكَ لَكَ وَأَنَّ مُحَمَّدًا عَبْدُكَ وَرَسُولُكَ', transliteration: 'Allahumma inni amsaytu ushhiduka...', meaning: 'اللهم إني أمسيت أشهدك', count: 4, source: 'أبو داود', category: CategoryType.evening, virtue: 'أعتق الله ربعه من النار'),
        const DhikrItem(id: 'e4', arabic: 'اللَّهُمَّ مَا أَمْسَى بِي مِنْ نِعْمَةٍ أَوْ بِأَحَدٍ مِنْ خَلْقِكَ فَمِنْكَ وَحْدَكَ لَا شَرِيكَ لَكَ، فَلَكَ الْحَمْدُ وَلَكَ الشُّكْرُ', transliteration: 'Allahumma ma amsa bi min nimah...', meaning: 'اللهم ما أمسى بي من نعمة', count: 1, source: 'أبو داود', category: CategoryType.evening, virtue: 'من قالها فقد أدى شكر ليلته'),
        const DhikrItem(id: 'e5', arabic: 'اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي، لَا إِلَهَ إِلَّا أَنْتَ', transliteration: 'Allahumma afini fi badani...', meaning: 'اللهم عافني في بدني', count: 3, source: 'أبو داود', category: CategoryType.evening),
        const DhikrItem(id: 'e6', arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْكُفْرِ وَالْفَقْرِ، وَأَعُوذُ بِكَ مِنْ عَذَابِ الْقَبْرِ، لَا إِلَهَ إِلَّا أَنْتَ', transliteration: 'Allahumma inni audhu bika...', meaning: 'التعوذ من الكفر والفقر', count: 3, source: 'أبو داود', category: CategoryType.evening),
        const DhikrItem(id: 'e7', arabic: 'حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ', transliteration: 'Hasbiyallahu la ilaha illa huwa...', meaning: 'حسبي الله', count: 7, source: 'أبو داود', category: CategoryType.evening, virtue: 'كفاه الله ما أهمه'),
        const DhikrItem(id: 'e8', arabic: 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ', transliteration: 'Bismillahil ladhi la yadurru...', meaning: 'بسم الله الذي لا يضر مع اسمه شيء', count: 3, source: 'الترمذي', category: CategoryType.evening, virtue: 'لم يضره شيء'),
        const DhikrItem(id: 'e9', arabic: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ', transliteration: 'Audhu bikalimatillahit tammati min sharri ma khalaq', meaning: 'أعوذ بكلمات الله التامات', count: 3, source: 'مسلم', category: CategoryType.evening, virtue: 'لم يضره شيء في تلك الليلة'),
        const DhikrItem(id: 'e10', arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ', transliteration: 'Allahumma inni asalukal afwa wal afiyah...', meaning: 'اللهم إني أسألك العفو والعافية', count: 1, source: 'أبو داود', category: CategoryType.evening),
        const DhikrItem(id: 'e11', arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي دِينِي وَدُنْيَايَ وَأَهْلِي وَمَالِي', transliteration: 'Allahumma inni asalukal afiyata fid dunya wal akhirah...', meaning: 'اللهم إني أسألك العافية في الدنيا والآخرة', count: 1, source: 'ابن ماجه', category: CategoryType.evening),
        const DhikrItem(id: 'e12', arabic: 'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ', transliteration: 'Allahumma salli wa sallim ala nabiyyina Muhammad', meaning: 'الصلاة على النبي', count: 10, category: CategoryType.evening),
        const DhikrItem(id: 'e13', arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ', transliteration: 'Subhanallahi wa bihamdih', meaning: 'سبحان الله وبحمده', count: 100, source: 'مسلم', category: CategoryType.evening, virtue: 'حطت خطاياه وإن كانت مثل زبد البحر'),
      ],
    ),

    // ===== أذكار بعد الصلاة =====
    DhikrCategory(
      id: 'prayer', name: 'أذكار بعد الصلاة', icon: '🕌', type: CategoryType.prayer,
      adhkar: [
        const DhikrItem(id: 'p1', arabic: 'أَسْتَغْفِرُ اللَّهَ', transliteration: 'Astaghfirullah', meaning: 'أستغفر الله', count: 3, source: 'مسلم', category: CategoryType.prayer),
        const DhikrItem(id: 'p2', arabic: 'اللَّهُمَّ أَنْتَ السَّلَامُ، وَمِنْكَ السَّلَامُ، تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ', transliteration: 'Allahumma antas salam...', meaning: 'اللهم أنت السلام', count: 1, source: 'مسلم', category: CategoryType.prayer),
        const DhikrItem(id: 'p3', arabic: 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ', transliteration: 'La ilaha illallahu wahdahu...', meaning: 'لا إله إلا الله وحده', count: 1, source: 'مسلم', category: CategoryType.prayer),
        const DhikrItem(id: 'p4', arabic: 'اللَّهُمَّ لَا مَانِعَ لِمَا أَعْطَيْتَ، وَلَا مُعْطِيَ لِمَا مَنَعْتَ، وَلَا يَنْفَعُ ذَا الْجَدِّ مِنْكَ الْجَدُّ', transliteration: 'Allahumma la mania lima atayt...', meaning: 'اللهم لا مانع لما أعطيت', count: 1, source: 'البخاري', category: CategoryType.prayer),
        const DhikrItem(id: 'p5', arabic: 'سُبْحَانَ اللَّهِ', transliteration: 'Subhanallah', meaning: 'سبحان الله', count: 33, source: 'مسلم', category: CategoryType.prayer),
        const DhikrItem(id: 'p6', arabic: 'الْحَمْدُ لِلَّهِ', transliteration: 'Alhamdulillah', meaning: 'الحمد لله', count: 33, source: 'مسلم', category: CategoryType.prayer),
        const DhikrItem(id: 'p7', arabic: 'اللَّهُ أَكْبَرُ', transliteration: 'Allahu Akbar', meaning: 'الله أكبر', count: 33, source: 'مسلم', category: CategoryType.prayer),
        const DhikrItem(id: 'p8', arabic: 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ', transliteration: 'La ilaha illallahu wahdahu la sharika lahu...', meaning: 'لا إله إلا الله وحده (بعد التسبيح)', count: 1, source: 'مسلم', category: CategoryType.prayer, virtue: 'غُفرت له ذنوبه وإن كانت مثل زبد البحر'),
        const DhikrItem(id: 'p9', arabic: 'آيَةُ الْكُرْسِيِّ:\nاللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ', transliteration: 'Allahu la ilaha illa huwal hayyul qayyum...', meaning: 'آية الكرسي', count: 1, source: 'النسائي', category: CategoryType.prayer, virtue: 'من قرأها دبر كل صلاة لم يمنعه من دخول الجنة إلا الموت'),
        const DhikrItem(id: 'p10', arabic: 'قُلْ هُوَ اللَّهُ أَحَدٌ - وَالْمُعَوِّذَتَيْنِ', transliteration: 'Qul huwallahu ahad wal muawwidhatain', meaning: 'الإخلاص والمعوذتان', count: 1, source: 'أبو داود', category: CategoryType.prayer, virtue: 'كفتاه من كل شيء بعد المغرب والصبح'),
        const DhikrItem(id: 'p11', arabic: 'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ', transliteration: 'Allahumma ainni ala dhikrika wa shukrika...', meaning: 'اللهم أعني على ذكرك وشكرك', count: 1, source: 'أبو داود', category: CategoryType.prayer),
      ],
    ),

    // ===== أذكار النوم =====
    DhikrCategory(
      id: 'sleep', name: 'أذكار النوم', icon: '🌙', type: CategoryType.sleep,
      adhkar: [
        const DhikrItem(id: 's1', arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا', transliteration: 'Bismika Allahumma amutu wa ahya', meaning: 'باسمك اللهم أموت وأحيا', count: 1, source: 'البخاري', category: CategoryType.sleep),
        const DhikrItem(id: 's2', arabic: 'اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ', transliteration: 'Allahumma qini adhabaka...', meaning: 'اللهم قني عذابك', count: 3, source: 'أبو داود', category: CategoryType.sleep),
        const DhikrItem(id: 's3', arabic: 'بِاسْمِكَ رَبِّي وَضَعْتُ جَنْبِي، وَبِكَ أَرْفَعُهُ، فَإِنْ أَمْسَكْتَ نَفْسِي فَارْحَمْهَا، وَإِنْ أَرْسَلْتَهَا فَاحْفَظْهَا بِمَا تَحْفَظُ بِهِ عِبَادَكَ الصَّالِحِينَ', transliteration: 'Bismika rabbi wadatu janbi...', meaning: 'باسمك ربي وضعت جنبي', count: 1, source: 'البخاري', category: CategoryType.sleep),
        const DhikrItem(id: 's4', arabic: 'اللَّهُمَّ أَسْلَمْتُ نَفْسِي إِلَيْكَ، وَفَوَّضْتُ أَمْرِي إِلَيْكَ، وَوَجَّهْتُ وَجْهِي إِلَيْكَ، وَأَلْجَأْتُ ظَهْرِي إِلَيْكَ، رَغْبَةً وَرَهْبَةً إِلَيْكَ، لَا مَلْجَأَ وَلَا مَنْجَا مِنْكَ إِلَّا إِلَيْكَ، آمَنْتُ بِكِتَابِكَ الَّذِي أَنْزَلْتَ وَبِنَبِيِّكَ الَّذِي أَرْسَلْتَ', transliteration: 'Allahumma aslamtu nafsi ilayk...', meaning: 'دعاء النوم الكامل', count: 1, source: 'البخاري', category: CategoryType.sleep, virtue: 'إن مات مات على الفطرة'),
        const DhikrItem(id: 's5', arabic: 'سُبْحَانَ اللَّهِ', transliteration: 'Subhanallah', meaning: 'سبحان الله', count: 33, source: 'البخاري', category: CategoryType.sleep),
        const DhikrItem(id: 's6', arabic: 'الْحَمْدُ لِلَّهِ', transliteration: 'Alhamdulillah', meaning: 'الحمد لله', count: 33, source: 'البخاري', category: CategoryType.sleep),
        const DhikrItem(id: 's7', arabic: 'اللَّهُ أَكْبَرُ', transliteration: 'Allahu Akbar', meaning: 'الله أكبر', count: 34, source: 'البخاري', category: CategoryType.sleep, virtue: 'خيرٌ لك من خادم'),
        const DhikrItem(id: 's8', arabic: 'آيَةُ الْكُرْسِيِّ:\nاللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ', transliteration: 'Ayatul Kursi', meaning: 'آية الكرسي قبل النوم', count: 1, source: 'البخاري', category: CategoryType.sleep, virtue: 'لم يزل عليه من الله حافظ ولا يقربه شيطان حتى يصبح'),
        const DhikrItem(id: 's9', arabic: 'قُلْ هُوَ اللَّهُ أَحَدٌ - قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ - قُلْ أَعُوذُ بِرَبِّ النَّاسِ', transliteration: 'Qul huwallahu ahad...', meaning: 'المعوذات ثلاثاً', count: 3, source: 'أبو داود', category: CategoryType.sleep),
      ],
    ),

    // ===== الاستغفار =====
    DhikrCategory(
      id: 'istighfar', name: 'الاستغفار', icon: '🤲', type: CategoryType.istighfar,
      adhkar: [
        const DhikrItem(id: 'i1', arabic: 'أَسْتَغْفِرُ اللَّهَ', transliteration: 'Astaghfirullah', meaning: 'أستغفر الله', count: 100, category: CategoryType.istighfar),
        const DhikrItem(id: 'i2', arabic: 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ', transliteration: 'Astaghfirullahal Azeem', meaning: 'أستغفر الله العظيم', count: 100, category: CategoryType.istighfar),
        const DhikrItem(id: 'i3', arabic: 'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ', transliteration: 'Astaghfirullaha wa atubu ilayh', meaning: 'أستغفر الله وأتوب إليه', count: 70, source: 'البخاري', category: CategoryType.istighfar, virtue: 'كان النبي ﷺ يستغفر في اليوم أكثر من سبعين مرة'),
        const DhikrItem(id: 'i4', arabic: 'رَبِّ اغْفِرْ لِي', transliteration: 'Rabbighfir li', meaning: 'رب اغفر لي', count: 100, category: CategoryType.istighfar),
        const DhikrItem(id: 'i5', arabic: 'سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ، أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا أَنْتَ، أَسْتَغْفِرُكَ وَأَتُوبُ إِلَيْكَ', transliteration: 'Subhanakal Lahumma wa bihamdik...', meaning: 'سبحانك اللهم وبحمدك', count: 1, source: 'الترمذي', category: CategoryType.istighfar),
        const DhikrItem(id: 'i6', arabic: 'اللَّهُمَّ اغْفِرْ لِي ذَنْبِي كُلَّهُ، دِقَّهُ وَجِلَّهُ، وَأَوَّلَهُ وَآخِرَهُ، وَعَلَانِيَتَهُ وَسِرَّهُ', transliteration: 'Allahumma ighfir li dhanbi kullahu...', meaning: 'اللهم اغفر لي ذنبي كله', count: 1, source: 'مسلم', category: CategoryType.istighfar),
        const DhikrItem(id: 'i7', arabic: 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ', transliteration: 'Allahumma anta rabbi la ilaha illa anta...', meaning: 'سيد الاستغفار', count: 1, source: 'البخاري', category: CategoryType.istighfar, virtue: 'من قالها موقناً فمات من يومه دخل الجنة'),
      ],
    ),

    // ===== التسبيح =====
    DhikrCategory(
      id: 'tasbeeh', name: 'التسبيح', icon: '📿', type: CategoryType.tasbeeh,
      adhkar: [
        const DhikrItem(id: 't1', arabic: 'سُبْحَانَ اللَّهِ', transliteration: 'Subhanallah', meaning: 'سبحان الله', count: 33, source: 'مسلم', category: CategoryType.tasbeeh),
        const DhikrItem(id: 't2', arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ', transliteration: 'Subhanallahi wa bihamdih', meaning: 'سبحان الله وبحمده', count: 100, source: 'مسلم', category: CategoryType.tasbeeh, virtue: 'حطت خطاياه وإن كانت مثل زبد البحر'),
        const DhikrItem(id: 't3', arabic: 'سُبْحَانَ اللَّهِ الْعَظِيمِ', transliteration: 'Subhanallahil Azeem', meaning: 'سبحان الله العظيم', count: 100, source: 'البخاري', category: CategoryType.tasbeeh),
        const DhikrItem(id: 't4', arabic: 'سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَلَا إِلَهَ إِلَّا اللَّهُ وَاللَّهُ أَكْبَرُ', transliteration: 'Subhanallah wal hamdulillah...', meaning: 'الباقيات الصالحات', count: 100, source: 'مسلم', category: CategoryType.tasbeeh),
        const DhikrItem(id: 't5', arabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ', transliteration: 'La hawla wa la quwwata illa billah', meaning: 'لا حول ولا قوة إلا بالله', count: 100, source: 'البخاري', category: CategoryType.tasbeeh, virtue: 'كنز من كنوز الجنة'),
        const DhikrItem(id: 't6', arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ سُبْحَانَ اللَّهِ الْعَظِيمِ', transliteration: 'Subhanallahi wa bihamdih subhanallahil azeem', meaning: 'كلمتان خفيفتان على اللسان', count: 100, source: 'البخاري', category: CategoryType.tasbeeh, virtue: 'خفيفتان على اللسان ثقيلتان في الميزان حبيبتان إلى الرحمن'),
        const DhikrItem(id: 't7', arabic: 'لَا إِلَهَ إِلَّا اللَّهُ', transliteration: 'La ilaha illallah', meaning: 'لا إله إلا الله', count: 100, category: CategoryType.tasbeeh, virtue: 'أفضل الذكر'),
      ],
    ),

    // ===== الصلاة على النبي =====
    DhikrCategory(
      id: 'salawat', name: 'الصلاة على النبي', icon: '☪️', type: CategoryType.salawat,
      adhkar: [
        const DhikrItem(id: 'sal1', arabic: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ', transliteration: 'Allahumma salli ala Muhammad', meaning: 'اللهم صل على محمد', count: 100, category: CategoryType.salawat, virtue: 'من صلى علي صلاة صلى الله عليه بها عشراً'),
        const DhikrItem(id: 'sal2', arabic: 'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ', transliteration: 'Allahumma salli wa sallim ala nabiyyina Muhammad', meaning: 'اللهم صل وسلم على نبينا محمد', count: 100, category: CategoryType.salawat),
        const DhikrItem(id: 'sal3', arabic: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ', transliteration: 'Allahumma salli ala Muhammadin wa ala ali Muhammad...', meaning: 'الصلاة الإبراهيمية', count: 10, source: 'البخاري', category: CategoryType.salawat),
        const DhikrItem(id: 'sal4', arabic: 'صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ', transliteration: 'Sallallahu alayhi wa sallam', meaning: 'صلى الله عليه وسلم', count: 100, category: CategoryType.salawat),
        const DhikrItem(id: 'sal5', arabic: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَأَزْوَاجِهِ وَذُرِّيَّتِهِ كَمَا صَلَّيْتَ عَلَى آلِ إِبْرَاهِيمَ وَبَارِكْ عَلَى مُحَمَّدٍ وَأَزْوَاجِهِ وَذُرِّيَّتِهِ', transliteration: 'Allahumma salli ala Muhammadin wa azwajihi...', meaning: 'الصلاة على النبي وآله وذريته', count: 10, source: 'البخاري', category: CategoryType.salawat),
        const DhikrItem(id: 'sal6', arabic: 'اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ وَالصَّلَاةِ الْقَائِمَةِ آتِ مُحَمَّدًا الْوَسِيلَةَ وَالْفَضِيلَةَ وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ', transliteration: 'Allahumma rabba hadhihid dawatit tammah...', meaning: 'دعاء سماع الأذان', count: 1, source: 'البخاري', category: CategoryType.salawat),
        const DhikrItem(id: 'sal7', arabic: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ النَّبِيِّ الأُمِّيِّ وَعَلَى آلِهِ وَصَحْبِهِ وَسَلِّمْ تَسْلِيمًا', transliteration: 'Allahumma salli ala Muhammadin nabiyyil ummiyyi...', meaning: 'الصلاة على النبي الأمي', count: 10, category: CategoryType.salawat),
      ],
    ),

    // ===== أدعية مأثورة =====
    DhikrCategory(
      id: 'dua', name: 'أدعية مأثورة', icon: '🌿', type: CategoryType.dua,
      description: 'أدعية من القرآن الكريم والسنة النبوية',
      adhkar: [
        const DhikrItem(id: 'd1', arabic: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ', transliteration: 'Rabbana atina fid dunya hasanah...', meaning: 'دعاء الدنيا والآخرة', count: 1, source: 'القرآن الكريم', category: CategoryType.dua),
        const DhikrItem(id: 'd2', arabic: 'رَبِّ زِدْنِي عِلْمًا', transliteration: 'Rabbi zidni ilma', meaning: 'رب زدني علماً', count: 10, source: 'القرآن الكريم', category: CategoryType.dua),
        const DhikrItem(id: 'd3', arabic: 'رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِنْ لَدُنْكَ رَحْمَةً إِنَّكَ أَنْتَ الْوَهَّابُ', transliteration: 'Rabbana la tuzigh qulubana...', meaning: 'دعاء ثبات القلب', count: 1, source: 'القرآن الكريم', category: CategoryType.dua),
        const DhikrItem(id: 'd4', arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْجَنَّةَ وَأَعُوذُ بِكَ مِنَ النَّارِ', transliteration: 'Allahumma inni asalukal jannata...', meaning: 'دعاء الجنة والنار', count: 3, source: 'أبو داود', category: CategoryType.dua),
        const DhikrItem(id: 'd5', arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَأَعُوذُ بِكَ مِنَ الْعَجْزِ وَالْكَسَلِ، وَأَعُوذُ بِكَ مِنَ الْجُبْنِ وَالْبُخْلِ، وَأَعُوذُ بِكَ مِنْ غَلَبَةِ الدَّيْنِ وَقَهْرِ الرِّجَالِ', transliteration: 'Allahumma inni audhu bika minal hammi wal hazan...', meaning: 'دعاء رفع الهم والحزن', count: 1, source: 'البخاري', category: CategoryType.dua),
        const DhikrItem(id: 'd6', arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا وَرِزْقًا طَيِّبًا وَعَمَلًا مُتَقَبَّلًا', transliteration: 'Allahumma inni asaluka ilman nafia...', meaning: 'دعاء العلم والرزق والعمل', count: 1, source: 'ابن ماجه', category: CategoryType.dua),
        const DhikrItem(id: 'd7', arabic: 'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ', transliteration: 'Hasbunallahu wa nimal wakeel', meaning: 'حسبنا الله ونعم الوكيل', count: 40, source: 'البخاري', category: CategoryType.dua, virtue: 'قالها إبراهيم عليه السلام حين ألقي في النار'),
      ],
    ),

    // ===== أذكار متنوعة =====
    DhikrCategory(
      id: 'misc', name: 'أذكار متنوعة', icon: '✨', type: CategoryType.misc,
      adhkar: [
        const DhikrItem(id: 'x1', arabic: 'لَا إِلَهَ إِلَّا اللَّهُ', transliteration: 'La ilaha illallah', meaning: 'لا إله إلا الله', count: 100, category: CategoryType.misc),
        const DhikrItem(id: 'x2', arabic: 'اللَّهُ أَكْبَرُ', transliteration: 'Allahu Akbar', meaning: 'الله أكبر', count: 100, category: CategoryType.misc),
        const DhikrItem(id: 'x3', arabic: 'الْحَمْدُ لِلَّهِ', transliteration: 'Alhamdulillah', meaning: 'الحمد لله', count: 100, category: CategoryType.misc),
        const DhikrItem(id: 'x4', arabic: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ', transliteration: 'Bismillahir Rahmanir Raheem', meaning: 'بسم الله الرحمن الرحيم', count: 1, category: CategoryType.misc),
        const DhikrItem(id: 'x5', arabic: 'إِنَّا لِلَّهِ وَإِنَّا إِلَيْهِ رَاجِعُونَ', transliteration: 'Inna lillahi wa inna ilayhi rajioon', meaning: 'إنا لله وإنا إليه راجعون', count: 1, source: 'القرآن الكريم', category: CategoryType.misc),
      ],
    ),
  ];

  // آيات قرآنية للعرض اليومي
  static final List<QuranAyah> dailyAyahs = [
    const QuranAyah(surahNumber: 2, surahName: 'البقرة', ayahNumber: 286, arabic: 'لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا', meaning: 'لا يكلف الله نفساً إلا وسعها'),
    const QuranAyah(surahNumber: 3, surahName: 'آل عمران', ayahNumber: 173, arabic: 'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ', meaning: 'حسبنا الله ونعم الوكيل'),
    const QuranAyah(surahNumber: 94, surahName: 'الشرح', ayahNumber: 5, arabic: 'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا', meaning: 'فإن مع العسر يسراً'),
    const QuranAyah(surahNumber: 13, surahName: 'الرعد', ayahNumber: 28, arabic: 'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ', meaning: 'ألا بذكر الله تطمئن القلوب'),
    const QuranAyah(surahNumber: 65, surahName: 'الطلاق', ayahNumber: 3, arabic: 'وَمَن يَتَوَكَّلْ عَلَى اللَّهِ فَهُوَ حَسْبُهُ', meaning: 'ومن يتوكل على الله فهو حسبه'),
    const QuranAyah(surahNumber: 2, surahName: 'البقرة', ayahNumber: 152, arabic: 'فَاذْكُرُونِي أَذْكُرْكُمْ وَاشْكُرُوا لِي وَلَا تَكْفُرُونِ', meaning: 'فاذكروني أذكركم'),
    const QuranAyah(surahNumber: 33, surahName: 'الأحزاب', ayahNumber: 41, arabic: 'يَا أَيُّهَا الَّذِينَ آمَنُوا اذْكُرُوا اللَّهَ ذِكْرًا كَثِيرًا', meaning: 'اذكروا الله ذكراً كثيراً'),
    const QuranAyah(surahNumber: 39, surahName: 'الزمر', ayahNumber: 53, arabic: 'لَا تَقْنَطُوا مِن رَّحْمَةِ اللَّهِ إِنَّ اللَّهَ يَغْفِرُ الذُّنُوبَ جَمِيعًا', meaning: 'لا تقنطوا من رحمة الله'),
    const QuranAyah(surahNumber: 14, surahName: 'إبراهيم', ayahNumber: 7, arabic: 'لَئِن شَكَرْتُمْ لَأَزِيدَنَّكُمْ', meaning: 'لئن شكرتم لأزيدنكم'),
    const QuranAyah(surahNumber: 40, surahName: 'غافر', ayahNumber: 60, arabic: 'وَقَالَ رَبُّكُمُ ادْعُونِي أَسْتَجِبْ لَكُمْ', meaning: 'ادعوني أستجب لكم'),
    const QuranAyah(surahNumber: 112, surahName: 'الإخلاص', ayahNumber: 1, arabic: 'قُلْ هُوَ اللَّهُ أَحَدٌ ۝ اللَّهُ الصَّمَدُ', meaning: 'قل هو الله أحد'),
    const QuranAyah(surahNumber: 2, surahName: 'البقرة', ayahNumber: 255, arabic: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ', meaning: 'آية الكرسي'),
    const QuranAyah(surahNumber: 18, surahName: 'الكهف', ayahNumber: 10, arabic: 'رَبَّنَا آتِنَا مِن لَّدُنكَ رَحْمَةً وَهَيِّئْ لَنَا مِنْ أَمْرِنَا رَشَدًا', meaning: 'ربنا آتنا من لدنك رحمة'),
    const QuranAyah(surahNumber: 20, surahName: 'طه', ayahNumber: 25, arabic: 'رَبِّ اشْرَحْ لِي صَدْرِي ۝ وَيَسِّرْ لِي أَمْرِي', meaning: 'رب اشرح لي صدري'),
    const QuranAyah(surahNumber: 57, surahName: 'الحديد', ayahNumber: 3, arabic: 'هُوَ الْأَوَّلُ وَالْآخِرُ وَالظَّاهِرُ وَالْبَاطِنُ وَهُوَ بِكُلِّ شَيْءٍ عَلِيمٌ', meaning: 'هو الأول والآخر والظاهر والباطن'),
    const QuranAyah(surahNumber: 2, surahName: 'البقرة', ayahNumber: 201, arabic: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ', meaning: 'ربنا آتنا في الدنيا حسنة'),
    const QuranAyah(surahNumber: 3, surahName: 'آل عمران', ayahNumber: 8, arabic: 'رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا', meaning: 'ربنا لا تزغ قلوبنا'),
    const QuranAyah(surahNumber: 7, surahName: 'الأعراف', ayahNumber: 23, arabic: 'رَبَّنَا ظَلَمْنَا أَنفُسَنَا وَإِن لَّمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُونَنَّ مِنَ الْخَاسِرِينَ', meaning: 'دعاء آدم وحواء عليهما السلام'),
    const QuranAyah(surahNumber: 21, surahName: 'الأنبياء', ayahNumber: 87, arabic: 'لَّا إِلَٰهَ إِلَّا أَنتَ سُبْحَانَكَ إِنِّي كُنتُ مِنَ الظَّالِمِينَ', meaning: 'دعاء يونس عليه السلام'),
    const QuranAyah(surahNumber: 27, surahName: 'النمل', ayahNumber: 62, arabic: 'أَمَّن يُجِيبُ الْمُضْطَرَّ إِذَا دَعَاهُ وَيَكْشِفُ السُّوءَ', meaning: 'أمن يجيب المضطر إذا دعاه'),
  ];
}

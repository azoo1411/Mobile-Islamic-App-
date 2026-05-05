import React from 'react';
import {
  View,
  Text,
  ScrollView,
  TouchableOpacity,
  StyleSheet,
  SafeAreaView,
} from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { Colors, Spacing, BorderRadius, Shadow } from '../theme';

const QUICK_ACCESS = [
  { icon: '🕋', label_ar: 'مناسك الحج', label_en: 'Hajj Guide', tab: 'Hajj Guide', highlight: true },
  { icon: '📖', label_ar: 'القرآن الكريم', label_en: 'Quran', tab: null },
  { icon: '🕌', label_ar: 'أوقات الصلاة', label_en: 'Prayer Times', tab: null },
  { icon: '🧭', label_ar: 'القبلة', label_en: 'Qibla', tab: null },
  { icon: '📿', label_ar: 'الأذكار', label_en: 'Dhikr', tab: null },
  { icon: '🌙', label_ar: 'رمضان', label_en: 'Ramadan', tab: null },
];

function QuickCard({ item, onPress }) {
  return (
    <TouchableOpacity
      style={[styles.card, item.highlight && styles.cardHighlight]}
      onPress={onPress}
      activeOpacity={0.8}
    >
      <Text style={styles.cardIcon}>{item.icon}</Text>
      <Text style={[styles.cardAr, item.highlight && styles.cardTextLight]}>
        {item.label_ar}
      </Text>
      <Text style={[styles.cardEn, item.highlight && styles.cardTextLightMuted]}>
        {item.label_en}
      </Text>
    </TouchableOpacity>
  );
}

export default function HomeScreen() {
  const navigation = useNavigation();

  const handleCardPress = (item) => {
    if (item.tab) {
      navigation.navigate(item.tab);
    }
  };

  return (
    <SafeAreaView style={styles.safe}>
      <ScrollView
        style={styles.scroll}
        contentContainerStyle={styles.scrollContent}
        showsVerticalScrollIndicator={false}
      >
        {/* Header */}
        <View style={styles.header}>
          <Text style={styles.greeting}>السلام عليكم</Text>
          <Text style={styles.appName}>Islamic App</Text>
        </View>

        {/* Hajj Season Banner */}
        <View style={styles.banner}>
          <View style={styles.bannerTextBlock}>
            <Text style={styles.bannerTitle}>حج مبروك 🕋</Text>
            <Text style={styles.bannerSubtitle}>
              Complete step-by-step Hajj guide is now available
            </Text>
          </View>
          <TouchableOpacity
            style={styles.bannerBtn}
            onPress={() => navigation.navigate('Hajj Guide')}
            activeOpacity={0.85}
          >
            <Text style={styles.bannerBtnText}>Start Guide →</Text>
          </TouchableOpacity>
        </View>

        {/* Quick Access */}
        <Text style={styles.sectionTitle}>Quick Access — الوصول السريع</Text>
        <View style={styles.grid}>
          {QUICK_ACCESS.map((item, i) => (
            <QuickCard key={i} item={item} onPress={() => handleCardPress(item)} />
          ))}
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: {
    flex: 1,
    backgroundColor: Colors.background,
  },
  scroll: {
    flex: 1,
  },
  scrollContent: {
    paddingBottom: Spacing.xxl,
  },
  header: {
    paddingHorizontal: Spacing.lg,
    paddingTop: Spacing.xl,
    paddingBottom: Spacing.lg,
  },
  greeting: {
    fontSize: 14,
    color: Colors.textMuted,
    textAlign: 'right',
    fontWeight: '500',
  },
  appName: {
    fontSize: 26,
    fontWeight: '800',
    color: Colors.primary,
    marginTop: 2,
  },
  banner: {
    marginHorizontal: Spacing.lg,
    backgroundColor: Colors.primary,
    borderRadius: BorderRadius.xl,
    padding: Spacing.lg,
    marginBottom: Spacing.xl,
    ...Shadow.strong,
  },
  bannerTextBlock: {
    marginBottom: Spacing.md,
  },
  bannerTitle: {
    fontSize: 20,
    fontWeight: '700',
    color: Colors.textOnDark,
    marginBottom: 4,
  },
  bannerSubtitle: {
    fontSize: 13,
    color: 'rgba(255,255,255,0.75)',
    lineHeight: 20,
  },
  bannerBtn: {
    backgroundColor: Colors.secondary,
    borderRadius: BorderRadius.full,
    paddingVertical: Spacing.sm + 2,
    paddingHorizontal: Spacing.lg,
    alignSelf: 'flex-start',
  },
  bannerBtnText: {
    color: Colors.text,
    fontWeight: '700',
    fontSize: 13,
  },
  sectionTitle: {
    fontSize: 13,
    fontWeight: '700',
    color: Colors.textSecondary,
    letterSpacing: 0.8,
    textTransform: 'uppercase',
    paddingHorizontal: Spacing.lg,
    marginBottom: Spacing.md,
  },
  grid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    paddingHorizontal: Spacing.md,
    gap: Spacing.sm,
  },
  card: {
    width: '30.5%',
    backgroundColor: Colors.surface,
    borderRadius: BorderRadius.lg,
    padding: Spacing.md,
    alignItems: 'center',
    gap: Spacing.xs,
    borderWidth: 1,
    borderColor: Colors.border,
    ...Shadow.card,
  },
  cardHighlight: {
    backgroundColor: Colors.primary,
    borderColor: Colors.primaryLight,
  },
  cardIcon: {
    fontSize: 28,
    marginBottom: 2,
  },
  cardAr: {
    fontSize: 12,
    fontWeight: '700',
    color: Colors.text,
    textAlign: 'center',
  },
  cardEn: {
    fontSize: 10,
    color: Colors.textMuted,
    textAlign: 'center',
  },
  cardTextLight: {
    color: Colors.textOnDark,
  },
  cardTextLightMuted: {
    color: 'rgba(255,255,255,0.65)',
  },
});

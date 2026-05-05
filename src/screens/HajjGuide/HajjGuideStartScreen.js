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
import hajjData from '../../data/hajjGuideData.json';
import { Colors, Spacing, BorderRadius, Shadow } from '../../theme';

const PILLAR_LABELS = [
  'Ihram', 'Mina', 'Arafat', 'Muzdalifah', 'Jamarat',
  'Sacrifice', 'Haircut', 'Tawaf', "Sa'i",
];

function RitualRow({ ritual, index }) {
  const navigation = useNavigation();
  const isLast = index === hajjData.hajjGuide.length - 1;

  return (
    <View style={styles.ritualRow}>
      {/* Timeline column */}
      <View style={styles.timelineCol}>
        <View style={styles.timelineDot}>
          <Text style={styles.timelineDotText}>{index + 1}</Text>
        </View>
        {!isLast && <View style={styles.timelineLine} />}
      </View>

      {/* Content */}
      <TouchableOpacity
        style={styles.ritualCard}
        activeOpacity={0.75}
        onPress={() => navigation.navigate('HajjRitual', { ritualIndex: index })}
      >
        <Text style={styles.ritualIcon}>{ritual.icon}</Text>
        <View style={styles.ritualText}>
          <Text style={styles.ritualAr}>{ritual.title_ar}</Text>
          <Text style={styles.ritualEn}>{ritual.title_en}</Text>
          <Text style={styles.ritualDate}>{ritual.date_hint}</Text>
        </View>
        <Text style={styles.ritualChevron}>›</Text>
      </TouchableOpacity>
    </View>
  );
}

export default function HajjGuideStartScreen() {
  const navigation = useNavigation();

  return (
    <SafeAreaView style={styles.safe}>
      <ScrollView
        style={styles.scroll}
        contentContainerStyle={styles.scrollContent}
        showsVerticalScrollIndicator={false}
      >
        {/* Hero Header */}
        <View style={styles.hero}>
          <Text style={styles.heroIcon}>🕋</Text>
          <Text style={styles.heroAr}>مناسك الحج</Text>
          <Text style={styles.heroEn}>Complete Hajj Guide</Text>
          <Text style={styles.heroSub}>
            A step-by-step journey through all 9 rituals of Hajj
          </Text>

          {/* Stats row */}
          <View style={styles.statsRow}>
            {[
              { value: '9', label: 'Rituals' },
              { value: '5', label: 'Days' },
              { value: '∞', label: 'Reward' },
            ].map((s, i) => (
              <View key={i} style={styles.statItem}>
                <Text style={styles.statValue}>{s.value}</Text>
                <Text style={styles.statLabel}>{s.label}</Text>
              </View>
            ))}
          </View>
        </View>

        {/* Start button */}
        <TouchableOpacity
          style={styles.startBtn}
          activeOpacity={0.85}
          onPress={() => navigation.navigate('HajjRitual', { ritualIndex: 0 })}
        >
          <Text style={styles.startBtnText}>🚀  Begin Your Journey</Text>
          <Text style={styles.startBtnSub}>Start from Step 1 · Ihram</Text>
        </TouchableOpacity>

        {/* Journey Map */}
        <Text style={styles.sectionTitle}>Your Journey Map</Text>
        <View style={styles.journeyContainer}>
          {hajjData.hajjGuide.map((ritual, i) => (
            <RitualRow key={ritual.id} ritual={ritual} index={i} />
          ))}
        </View>

        {/* Footer note */}
        <View style={styles.footerNote}>
          <Text style={styles.footerNoteText}>
            💡 Tap any ritual to jump directly to that step
          </Text>
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
  scroll: { flex: 1 },
  scrollContent: { paddingBottom: Spacing.xxl },

  // Hero
  hero: {
    alignItems: 'center',
    backgroundColor: Colors.primary,
    paddingTop: Spacing.xl,
    paddingBottom: Spacing.xxl,
    paddingHorizontal: Spacing.lg,
  },
  heroIcon: {
    fontSize: 56,
    marginBottom: Spacing.md,
  },
  heroAr: {
    fontSize: 32,
    fontWeight: '700',
    color: Colors.textOnDark,
    marginBottom: 4,
  },
  heroEn: {
    fontSize: 16,
    fontWeight: '600',
    color: Colors.secondary,
    marginBottom: Spacing.sm,
    letterSpacing: 0.5,
  },
  heroSub: {
    fontSize: 13,
    color: 'rgba(255,255,255,0.7)',
    textAlign: 'center',
    lineHeight: 20,
    maxWidth: 260,
    marginBottom: Spacing.lg,
  },
  statsRow: {
    flexDirection: 'row',
    gap: Spacing.xxl,
  },
  statItem: {
    alignItems: 'center',
  },
  statValue: {
    fontSize: 24,
    fontWeight: '800',
    color: Colors.secondary,
  },
  statLabel: {
    fontSize: 11,
    color: 'rgba(255,255,255,0.6)',
    fontWeight: '500',
    letterSpacing: 0.5,
  },

  // Start button
  startBtn: {
    backgroundColor: Colors.secondary,
    marginHorizontal: Spacing.lg,
    marginTop: -Spacing.lg,
    borderRadius: BorderRadius.xl,
    paddingVertical: Spacing.lg,
    alignItems: 'center',
    ...Shadow.strong,
  },
  startBtnText: {
    fontSize: 17,
    fontWeight: '800',
    color: Colors.text,
    marginBottom: 4,
  },
  startBtnSub: {
    fontSize: 12,
    color: Colors.textSecondary,
    fontWeight: '500',
  },

  // Section
  sectionTitle: {
    fontSize: 13,
    fontWeight: '700',
    color: Colors.textMuted,
    letterSpacing: 1,
    textTransform: 'uppercase',
    paddingHorizontal: Spacing.lg,
    marginTop: Spacing.xl,
    marginBottom: Spacing.md,
  },

  // Journey map
  journeyContainer: {
    paddingHorizontal: Spacing.lg,
  },
  ritualRow: {
    flexDirection: 'row',
    gap: Spacing.md,
  },

  // Timeline
  timelineCol: {
    alignItems: 'center',
    width: 32,
  },
  timelineDot: {
    width: 32,
    height: 32,
    borderRadius: BorderRadius.full,
    backgroundColor: Colors.primary,
    alignItems: 'center',
    justifyContent: 'center',
    flexShrink: 0,
  },
  timelineDotText: {
    color: Colors.textOnDark,
    fontSize: 13,
    fontWeight: '700',
  },
  timelineLine: {
    width: 2,
    flex: 1,
    minHeight: 16,
    backgroundColor: Colors.border,
    marginVertical: 3,
  },

  // Ritual card
  ritualCard: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: Colors.surface,
    borderRadius: BorderRadius.md,
    padding: Spacing.md,
    marginBottom: Spacing.sm,
    borderWidth: 1,
    borderColor: Colors.border,
    gap: Spacing.md,
    ...Shadow.card,
  },
  ritualIcon: {
    fontSize: 26,
    flexShrink: 0,
  },
  ritualText: {
    flex: 1,
  },
  ritualAr: {
    fontSize: 15,
    fontWeight: '700',
    color: Colors.text,
    textAlign: 'right',
  },
  ritualEn: {
    fontSize: 13,
    color: Colors.textSecondary,
    fontWeight: '500',
    marginTop: 1,
  },
  ritualDate: {
    fontSize: 11,
    color: Colors.secondary,
    fontWeight: '600',
    marginTop: 3,
  },
  ritualChevron: {
    fontSize: 22,
    color: Colors.textMuted,
    fontWeight: '300',
  },

  // Footer
  footerNote: {
    marginHorizontal: Spacing.lg,
    marginTop: Spacing.lg,
    backgroundColor: Colors.surfaceAlt,
    borderRadius: BorderRadius.md,
    padding: Spacing.md,
    alignItems: 'center',
  },
  footerNoteText: {
    fontSize: 13,
    color: Colors.textMuted,
    textAlign: 'center',
  },
});

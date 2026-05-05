import React, { useState, useRef, useCallback } from 'react';
import {
  View,
  Text,
  ScrollView,
  TouchableOpacity,
  StyleSheet,
  SafeAreaView,
  Alert,
} from 'react-native';
import { useNavigation, useRoute } from '@react-navigation/native';
import hajjData from '../../data/hajjGuideData.json';
import ProgressIndicator from '../../components/ProgressIndicator';
import ChecklistItem from '../../components/ChecklistItem';
import AudioButton from '../../components/AudioButton';
import RitualPlaceholder from '../../components/RitualPlaceholder';
import { Colors, Spacing, BorderRadius, Shadow } from '../../theme';

const TOTAL = hajjData.hajjGuide.length;

function SectionCard({ children, style }) {
  return <View style={[styles.sectionCard, style]}>{children}</View>;
}

export default function HajjGuideRitualScreen() {
  const navigation = useNavigation();
  const route = useRoute();
  const scrollRef = useRef(null);

  const [ritualIndex, setRitualIndex] = useState(route.params?.ritualIndex ?? 0);
  const ritual = hajjData.hajjGuide[ritualIndex];

  const isFirst = ritualIndex === 0;
  const isLast = ritualIndex === TOTAL - 1;

  const goToRitual = useCallback((index) => {
    setRitualIndex(index);
    scrollRef.current?.scrollTo({ y: 0, animated: true });
  }, []);

  const handleNext = () => {
    if (isLast) {
      Alert.alert(
        'الحمد لله 🎉',
        "Congratulations! You have completed all Hajj rituals.\n\nMay Allah accept your Hajj. Hajjan mabrura!",
        [
          { text: 'Back to Guide', onPress: () => navigation.navigate('HajjStart') },
        ],
      );
    } else {
      goToRitual(ritualIndex + 1);
    }
  };

  const handlePrev = () => {
    if (!isFirst) goToRitual(ritualIndex - 1);
  };

  const handleBack = () => {
    if (isFirst) {
      navigation.navigate('HajjStart');
    } else {
      handlePrev();
    }
  };

  return (
    <SafeAreaView style={styles.safe}>
      {/* Fixed Top Bar */}
      <View style={styles.topBar}>
        <TouchableOpacity style={styles.backBtn} onPress={handleBack} activeOpacity={0.7}>
          <Text style={styles.backBtnText}>← Back</Text>
        </TouchableOpacity>
        <Text style={styles.topBarTitle} numberOfLines={1}>
          {ritual.title_en}
        </Text>
        <View style={styles.backBtn} />
      </View>

      {/* Progress */}
      <ProgressIndicator current={ritualIndex + 1} total={TOTAL} />

      {/* Main scrollable content */}
      <ScrollView
        ref={scrollRef}
        style={styles.scroll}
        contentContainerStyle={styles.scrollContent}
        showsVerticalScrollIndicator={false}
      >
        {/* Hero image area */}
        <RitualPlaceholder ritualId={ritual.id} dateHint={ritual.date_hint} />

        {/* Title block */}
        <View style={styles.titleBlock}>
          <Text style={styles.titleAr}>{ritual.title_ar}</Text>
          <Text style={styles.titleEn}>{ritual.title_en}</Text>
          <Text style={styles.titleSubtitle}>{ritual.subtitle_en}</Text>
        </View>

        {/* Description */}
        <View style={styles.descriptionBlock}>
          <Text style={styles.descriptionText}>{ritual.description}</Text>
        </View>

        {/* Steps checklist */}
        <SectionCard>
          <View style={styles.sectionHeader}>
            <Text style={styles.sectionIcon}>📋</Text>
            <Text style={styles.sectionTitle}>Steps to Follow</Text>
          </View>
          {ritual.steps.map((step, i) => (
            <ChecklistItem key={i} text={step} index={i} />
          ))}
        </SectionCard>

        {/* Tip */}
        <SectionCard style={styles.tipCard}>
          <View style={styles.sectionHeader}>
            <Text style={styles.sectionIcon}>💡</Text>
            <Text style={[styles.sectionTitle, styles.tipTitle]}>Important Tip</Text>
          </View>
          <Text style={styles.tipText}>{ritual.tip}</Text>
        </SectionCard>

        {/* Dua */}
        {ritual.dua ? (
          <SectionCard style={styles.duaCard}>
            <View style={styles.sectionHeader}>
              <Text style={styles.sectionIcon}>🤲</Text>
              <Text style={[styles.sectionTitle, styles.duaTitle]}>Dua</Text>
            </View>
            <Text style={styles.duaArabic}>{ritual.dua}</Text>
            <Text style={styles.duaTranslit}>{ritual.dua_transliteration}</Text>
            <View style={styles.duaDivider} />
            <Text style={styles.duaTranslation}>"{ritual.dua_translation}"</Text>

            {/* Audio playback */}
            <View style={styles.audioContainer}>
              <AudioButton duaText={ritual.dua} label="استمع للدعاء" />
            </View>
          </SectionCard>
        ) : null}

        {/* Image prompt for developers/content team */}
        <SectionCard style={styles.devCard}>
          <View style={styles.sectionHeader}>
            <Text style={styles.sectionIcon}>🎨</Text>
            <Text style={[styles.sectionTitle, { color: Colors.textMuted }]}>
              AI Image Prompt
            </Text>
          </View>
          <Text style={styles.devPromptText}>{ritual.image_prompt}</Text>
        </SectionCard>

        {/* Bottom spacing for buttons */}
        <View style={{ height: 100 }} />
      </ScrollView>

      {/* Fixed Bottom Navigation */}
      <View style={styles.bottomNav}>
        <TouchableOpacity
          style={[styles.navBtn, styles.navBtnSecondary, isFirst && styles.navBtnDisabled]}
          onPress={handlePrev}
          disabled={isFirst}
          activeOpacity={0.8}
        >
          <Text style={[styles.navBtnText, styles.navBtnTextSecondary]}>← Prev</Text>
        </TouchableOpacity>

        <View style={styles.navStepper}>
          <Text style={styles.navStepperText}>{ritualIndex + 1} / {TOTAL}</Text>
        </View>

        <TouchableOpacity
          style={[styles.navBtn, styles.navBtnPrimary]}
          onPress={handleNext}
          activeOpacity={0.85}
        >
          <Text style={styles.navBtnText}>
            {isLast ? '🏁 Finish' : 'Next →'}
          </Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: {
    flex: 1,
    backgroundColor: Colors.background,
  },

  // Top bar
  topBar: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: Spacing.md,
    paddingVertical: Spacing.sm,
    backgroundColor: Colors.background,
    borderBottomWidth: 1,
    borderBottomColor: Colors.border,
  },
  backBtn: {
    width: 70,
  },
  backBtnText: {
    fontSize: 14,
    fontWeight: '600',
    color: Colors.primary,
  },
  topBarTitle: {
    fontSize: 15,
    fontWeight: '700',
    color: Colors.text,
    flex: 1,
    textAlign: 'center',
  },

  // Scroll
  scroll: { flex: 1 },
  scrollContent: { paddingBottom: Spacing.xxl },

  // Title
  titleBlock: {
    alignItems: 'center',
    paddingHorizontal: Spacing.lg,
    paddingTop: Spacing.lg,
    paddingBottom: Spacing.md,
  },
  titleAr: {
    fontSize: 30,
    fontWeight: '700',
    color: Colors.primary,
    marginBottom: 4,
  },
  titleEn: {
    fontSize: 20,
    fontWeight: '700',
    color: Colors.text,
    marginBottom: 4,
  },
  titleSubtitle: {
    fontSize: 12,
    fontWeight: '600',
    color: Colors.secondary,
    textTransform: 'uppercase',
    letterSpacing: 1.2,
  },

  // Description
  descriptionBlock: {
    marginHorizontal: Spacing.lg,
    marginBottom: Spacing.md,
  },
  descriptionText: {
    fontSize: 15,
    lineHeight: 26,
    color: Colors.textSecondary,
    textAlign: 'center',
  },

  // Section cards
  sectionCard: {
    marginHorizontal: Spacing.lg,
    marginBottom: Spacing.md,
    backgroundColor: Colors.surface,
    borderRadius: BorderRadius.lg,
    padding: Spacing.md,
    borderWidth: 1,
    borderColor: Colors.border,
    ...Shadow.card,
  },
  sectionHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: Spacing.sm,
    marginBottom: Spacing.md,
  },
  sectionIcon: {
    fontSize: 16,
  },
  sectionTitle: {
    fontSize: 13,
    fontWeight: '700',
    color: Colors.text,
    textTransform: 'uppercase',
    letterSpacing: 0.8,
  },

  // Tip
  tipCard: {
    backgroundColor: Colors.tipBg,
    borderColor: Colors.tipBorder + '60',
  },
  tipTitle: {
    color: Colors.tipText,
  },
  tipText: {
    fontSize: 14,
    lineHeight: 22,
    color: Colors.tipText,
    fontStyle: 'italic',
  },

  // Dua
  duaCard: {
    backgroundColor: Colors.duaBg,
    borderColor: Colors.duaBorder + '40',
  },
  duaTitle: {
    color: Colors.duaText,
  },
  duaArabic: {
    fontSize: 22,
    lineHeight: 40,
    color: Colors.primary,
    fontWeight: '600',
    textAlign: 'right',
    marginBottom: Spacing.sm,
  },
  duaTranslit: {
    fontSize: 13,
    lineHeight: 22,
    color: Colors.textSecondary,
    fontStyle: 'italic',
    marginBottom: Spacing.sm,
  },
  duaDivider: {
    height: 1,
    backgroundColor: Colors.duaBorder + '30',
    marginVertical: Spacing.sm,
  },
  duaTranslation: {
    fontSize: 13,
    lineHeight: 22,
    color: Colors.textSecondary,
    marginBottom: Spacing.md,
  },
  audioContainer: {
    marginTop: Spacing.xs,
  },

  // Dev / content team prompt card
  devCard: {
    backgroundColor: Colors.surfaceAlt,
    borderStyle: 'dashed',
  },
  devPromptText: {
    fontSize: 11,
    lineHeight: 18,
    color: Colors.textMuted,
    fontFamily: 'monospace',
  },

  // Bottom navigation
  bottomNav: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: Spacing.lg,
    paddingVertical: Spacing.md,
    backgroundColor: Colors.surface,
    borderTopWidth: 1,
    borderTopColor: Colors.border,
    gap: Spacing.sm,
    ...Shadow.strong,
  },
  navBtn: {
    flex: 1,
    borderRadius: BorderRadius.full,
    paddingVertical: Spacing.md,
    alignItems: 'center',
  },
  navBtnPrimary: {
    backgroundColor: Colors.primary,
    ...Shadow.card,
  },
  navBtnSecondary: {
    backgroundColor: Colors.surfaceAlt,
    borderWidth: 1,
    borderColor: Colors.border,
  },
  navBtnDisabled: {
    opacity: 0.35,
  },
  navBtnText: {
    fontSize: 15,
    fontWeight: '700',
    color: Colors.textOnDark,
  },
  navBtnTextSecondary: {
    color: Colors.textSecondary,
  },
  navStepper: {
    paddingHorizontal: Spacing.sm,
    alignItems: 'center',
  },
  navStepperText: {
    fontSize: 13,
    fontWeight: '600',
    color: Colors.textMuted,
  },
});

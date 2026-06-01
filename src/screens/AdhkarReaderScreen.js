import React, { useState } from 'react';
import {
  View, Text, TouchableOpacity, ScrollView,
  StyleSheet, StatusBar, Clipboard, Alert,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useTheme } from '../context/ThemeContext';
import { adhkarContent } from '../data/adhkarData';
import { fonts, fontSizes } from '../design-system/typography';
import { spacing, borderRadius } from '../design-system/spacing';

function CounterBadge({ target, onComplete }) {
  const [remaining, setRemaining] = useState(target);
  const done = remaining === 0;

  function handlePress() {
    if (done) {
      setRemaining(target);
      return;
    }
    const next = remaining - 1;
    setRemaining(next);
    if (next === 0 && onComplete) onComplete();
  }

  return (
    <TouchableOpacity
      onPress={handlePress}
      activeOpacity={0.75}
      style={[
        styles.counter,
        done && styles.counterDone,
      ]}
    >
      <Text style={[styles.counterNum, done && styles.counterNumDone]}>
        {done ? '✓' : remaining}
      </Text>
      <Text style={[styles.counterLabel, done && { color: '#52B788' }]}>
        {done ? 'أُتِمَّ' : `/ ${target}`}
      </Text>
    </TouchableOpacity>
  );
}

function AdhkarCard({ dhikr, accentColor, colors }) {
  function handleCopy() {
    Clipboard.setString(dhikr.textAr);
    Alert.alert('', 'تم النسخ');
  }

  return (
    <View style={styles.card}>
      {/* Accent left border */}
      <View style={[styles.cardBorder, { backgroundColor: accentColor }]} />

      <View style={styles.cardInner}>
        {/* Translation label */}
        <Text style={[styles.dhikrLabel, { color: accentColor }]}>
          {dhikr.translationAr}
        </Text>

        {/* Main Arabic text */}
        <Text style={[styles.dhikrText, { color: colors.arabicPrimary }]}>{dhikr.textAr}</Text>

        {/* Source */}
        {dhikr.sourceAr ? (
          <Text style={[styles.dhikrSource, { color: colors.textTertiary }]}>{dhikr.sourceAr}</Text>
        ) : null}

        {/* Counter + Copy row */}
        <View style={styles.cardActions}>
          <TouchableOpacity onPress={handleCopy} style={styles.copyBtn} activeOpacity={0.7}>
            <Text style={styles.copyText}>نسخ</Text>
          </TouchableOpacity>
          {dhikr.count > 1 && <CounterBadge target={dhikr.count} />}
          {dhikr.count === 1 && (
            <View style={[styles.onceBadge, { borderColor: accentColor + '55' }]}>
              <Text style={[styles.onceText, { color: accentColor }]}>مرة واحدة</Text>
            </View>
          )}
        </View>
      </View>
    </View>
  );
}

export default function AdhkarReaderScreen({ route, navigation }) {
  const { category } = route.params;
  const { colors, isDark } = useTheme();
  const insets = useSafeAreaInsets();

  const items = adhkarContent[category.id] || [];

  return (
    <View style={[styles.container, { backgroundColor: colors.bg }]}>
      <StatusBar barStyle="light-content" translucent backgroundColor="transparent" />

      {/* ── Header ─────────────────────────────────────────── */}
      <LinearGradient
        colors={[category.gradientStart, category.gradientEnd]}
        style={[styles.header, { paddingTop: insets.top + spacing.md }]}
      >
        <TouchableOpacity
          style={styles.backBtn}
          onPress={() => navigation.goBack()}
          activeOpacity={0.75}
        >
          <Text style={styles.backArrow}>‹</Text>
          <Text style={styles.backText}>الأذكار</Text>
        </TouchableOpacity>

        <Text style={styles.headerTitle}>{category.titleAr}</Text>
        <Text style={[styles.headerSub, { color: category.accentColor }]}>
          {category.subtitleAr}
        </Text>
        <View style={[styles.countPill, { backgroundColor: category.accentColor + '33', borderColor: category.accentColor + '44' }]}>
          <Text style={[styles.countPillText, { color: category.accentColor }]}>
            {items.length} أذكار
          </Text>
        </View>
      </LinearGradient>

      {/* ── Adhkar list ────────────────────────────────────── */}
      <ScrollView
        contentContainerStyle={[
          styles.list,
          { paddingBottom: 100 + insets.bottom },
        ]}
        showsVerticalScrollIndicator={false}
      >
        {items.map((dhikr, idx) => (
          <View key={dhikr.id}>
            <View style={styles.itemIndexRow}>
              <View style={[styles.indexLine, { backgroundColor: colors.divider }]} />
              <View style={[styles.indexBadge, { backgroundColor: colors.bgCard, borderColor: colors.border }]}>
                <Text style={[styles.indexText, { color: colors.textTertiary }]}>
                  {idx + 1}
                </Text>
              </View>
              <View style={[styles.indexLine, { backgroundColor: colors.divider }]} />
            </View>
            <AdhkarCard dhikr={dhikr} accentColor={category.accentColor} colors={colors} />
          </View>
        ))}
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },

  // ── Header ──────────────────────────────────────────────────
  header: {
    paddingHorizontal: spacing.xxl,
    paddingBottom:     spacing.xl,
  },
  backBtn: {
    flexDirection:  'row',
    alignItems:     'center',
    alignSelf:      'flex-start',
    marginBottom:   spacing.lg,
    gap:            spacing.xxs,
  },
  backArrow: {
    fontFamily: fonts.regular,
    fontSize:   28,
    color:      'rgba(255,255,255,0.75)',
    lineHeight: 28,
    marginTop:  -2,
  },
  backText: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.bodySm,
    color:      'rgba(255,255,255,0.75)',
  },
  headerTitle: {
    fontFamily:    fonts.quranBold,
    fontSize:      fontSizes.h2,
    color:         '#FFFFFF',
    textAlign:     'right',
    marginBottom:  spacing.xxs,
  },
  headerSub: {
    fontFamily:   fonts.regular,
    fontSize:     fontSizes.bodySm,
    textAlign:    'right',
    marginBottom: spacing.md,
    opacity:      0.9,
  },
  countPill: {
    alignSelf:         'flex-end',
    borderWidth:       1,
    borderRadius:      borderRadius.full,
    paddingVertical:   4,
    paddingHorizontal: spacing.lg,
  },
  countPillText: {
    fontFamily: fonts.semiBold,
    fontSize:   fontSizes.caption,
  },

  // ── List ────────────────────────────────────────────────────
  list: {
    paddingHorizontal: spacing.lg,
    paddingTop:        spacing.md,
  },

  // ── Item index row ──────────────────────────────────────────
  itemIndexRow: {
    flexDirection: 'row',
    alignItems:    'center',
    marginBottom:  spacing.sm,
    marginTop:     spacing.md,
  },
  indexLine: {
    flex:   1,
    height: 0.7,
  },
  indexBadge: {
    borderWidth:       1,
    borderRadius:      borderRadius.full,
    paddingVertical:   2,
    paddingHorizontal: 8,
    marginHorizontal:  spacing.sm,
  },
  indexText: {
    fontFamily: fonts.semiBold,
    fontSize:   fontSizes.caption,
  },

  // ── Card ────────────────────────────────────────────────────
  card: {
    flexDirection:  'row',
    borderRadius:   borderRadius.lg,
    overflow:       'hidden',
    backgroundColor: 'transparent',
  },
  cardBorder: {
    width:        3,
    borderRadius: 3,
    marginRight:  spacing.md,
  },
  cardInner: {
    flex:          1,
    paddingRight:  spacing.xs,
    paddingBottom: spacing.lg,
  },
  dhikrLabel: {
    fontFamily:   fonts.semiBold,
    fontSize:     fontSizes.bodySm,
    textAlign:    'right',
    marginBottom: spacing.sm,
  },
  dhikrText: {
    fontFamily:  fonts.quran,
    fontSize:    fontSizes.quranSM,
    textAlign:   'right',
    lineHeight:  46,
    marginBottom: spacing.md,
  },
  dhikrSource: {
    fontFamily:   fonts.regular,
    fontSize:     fontSizes.caption,
    textAlign:    'right',
    marginBottom: spacing.md,
    fontStyle:    'italic',
  },
  cardActions: {
    flexDirection:  'row',
    justifyContent: 'flex-end',
    alignItems:     'center',
    gap:            spacing.md,
  },

  // ── Copy button ─────────────────────────────────────────────
  copyBtn: {
    borderWidth:       1,
    borderColor:       'rgba(200,169,110,0.35)',
    borderRadius:      borderRadius.full,
    paddingVertical:   4,
    paddingHorizontal: spacing.lg,
  },
  copyText: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.caption,
    color:      '#C8A96E',
  },

  // ── Counter ─────────────────────────────────────────────────
  counter: {
    flexDirection:  'row',
    alignItems:     'center',
    gap:            4,
    backgroundColor: 'rgba(200,169,110,0.12)',
    borderWidth:     1,
    borderColor:     'rgba(200,169,110,0.35)',
    borderRadius:    borderRadius.full,
    paddingVertical:   6,
    paddingHorizontal: spacing.lg,
  },
  counterDone: {
    backgroundColor: 'rgba(82,183,136,0.12)',
    borderColor:     'rgba(82,183,136,0.40)',
  },
  counterNum: {
    fontFamily: fonts.bold,
    fontSize:   fontSizes.body,
    color:      '#C8A96E',
  },
  counterNumDone: {
    color: '#52B788',
  },
  counterLabel: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.caption,
    color:      '#C8A96E',
  },

  // ── Once badge ──────────────────────────────────────────────
  onceBadge: {
    borderWidth:       1,
    borderRadius:      borderRadius.full,
    paddingVertical:   4,
    paddingHorizontal: spacing.lg,
  },
  onceText: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.caption,
  },
});

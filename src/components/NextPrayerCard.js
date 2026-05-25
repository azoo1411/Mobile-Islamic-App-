import React, { useRef, useEffect } from 'react';
import {
  View, Text, TouchableOpacity, StyleSheet, Animated, Platform,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { BlurView } from 'expo-blur';
import { useTheme } from '../context/ThemeContext';
import { fonts, fontSizes } from '../design-system/typography';
import { spacing, borderRadius } from '../design-system/spacing';

// ─── Per-prayer gradient + accent ────────────────────────────────────────────
const PRAYER_META = {
  الفجر:  {
    gradient:  ['#08121E', '#0E1E34', '#162A48', '#1A3358'],
    shimmer:   ['rgba(100,160,220,0.10)', 'transparent'],
    accent:    '#7ABADC',
    period:    'قبيل الفجر',
    icon:      '🌙',
  },
  الظهر: {
    gradient:  ['#1A1200', '#382808', '#6E5010', '#A8782A'],
    shimmer:   ['rgba(220,180,80,0.10)', 'transparent'],
    accent:    '#D4AA44',
    period:    'وسط النهار',
    icon:      '☀️',
  },
  العصر: {
    gradient:  ['#1E0C04', '#3E1E08', '#7C4414', '#C27828'],
    shimmer:   ['rgba(220,140,60,0.12)', 'transparent'],
    accent:    '#E0984C',
    period:    'بعد الظهر',
    icon:      '🌤',
  },
  المغرب: {
    gradient:  ['#1A0810', '#3A1428', '#7A2E4E', '#BE5878'],
    shimmer:   ['rgba(220,130,160,0.10)', 'transparent'],
    accent:    '#DC8FA0',
    period:    'بعد الغروب',
    icon:      '🌅',
  },
  العشاء: {
    gradient:  ['#080C1A', '#10162E', '#182040', '#1E2A54'],
    shimmer:   ['rgba(120,140,220,0.10)', 'transparent'],
    accent:    '#8898D0',
    period:    'الليل',
    icon:      '🌙',
  },
};

// ─── Thin ornament separator ──────────────────────────────────────────────────
function CardSeparator({ accent }) {
  return (
    <View style={sep.row}>
      <View style={[sep.line, { backgroundColor: accent + '30' }]} />
      <View style={[sep.dot, { backgroundColor: accent + '60' }]} />
      <View style={[sep.line, { backgroundColor: accent + '30' }]} />
    </View>
  );
}
const sep = StyleSheet.create({
  row:  { flexDirection: 'row', alignItems: 'center', marginVertical: spacing.xl },
  line: { flex: 1, height: 0.5 },
  dot:  { width: 4, height: 4, borderRadius: 2, marginHorizontal: spacing.sm, transform: [{ rotate: '45deg' }] },
});

// ─── Main component ───────────────────────────────────────────────────────────
export default function NextPrayerCard({
  prayerName    = 'العصر',
  prayerTime    = '٣:٤٢ م',
  timeRemaining = '١:٢٥',
  progress      = 0.42,
  prevPrayer    = 'الظهر',
  nextPrayer    = 'المغرب',
  onNotifPress,
}) {
  const meta     = PRAYER_META[prayerName] ?? PRAYER_META['العصر'];
  const clamped  = Math.min(1, Math.max(0, progress));

  // Heartbeat pulse on the countdown number
  const pulse = useRef(new Animated.Value(1)).current;
  useEffect(() => {
    Animated.loop(
      Animated.sequence([
        Animated.timing(pulse, { toValue: 1.018, duration: 2400, useNativeDriver: true }),
        Animated.timing(pulse, { toValue: 1.000, duration: 2400, useNativeDriver: true }),
      ])
    ).start();
    return () => pulse.stopAnimation();
  }, []);

  // Entry fade-in
  const entry = useRef(new Animated.Value(0)).current;
  useEffect(() => {
    Animated.timing(entry, { toValue: 1, duration: 500, useNativeDriver: true, delay: 80 }).start();
  }, []);

  return (
    <Animated.View style={[styles.outerShell, { opacity: entry, transform: [{ translateY: entry.interpolate({ inputRange:[0,1], outputRange:[12,0] }) }] }]}>
      {/* ── Warm glow halo (iOS only for native shadow) ── */}
      {Platform.OS === 'ios' && (
        <View style={[styles.glow, { shadowColor: meta.accent }]} />
      )}

      <LinearGradient
        colors={meta.gradient}
        start={{ x: 0.05, y: 0 }}
        end={{ x: 0.95, y: 1 }}
        style={styles.card}
      >
        {/* Glass shimmer overlay */}
        <LinearGradient
          colors={[...meta.shimmer, 'transparent']}
          start={{ x: 0, y: 0 }}
          end={{ x: 1, y: 1 }}
          style={StyleSheet.absoluteFill}
          pointerEvents="none"
        />

        {/* ── TOP ROW: label (right) · bell (left) ──── */}
        <View style={styles.topRow}>
          {/* Bell — left */}
          <TouchableOpacity
            style={[styles.bellBtn, { backgroundColor: 'rgba(255,255,255,0.10)', borderColor: 'rgba(255,255,255,0.16)' }]}
            onPress={onNotifPress}
            activeOpacity={0.65}
          >
            <Text style={{ fontSize: 13 }}>🔔</Text>
          </TouchableOpacity>

          {/* Label — right */}
          <View style={styles.labelGroup}>
            <View style={[styles.activeDot, { backgroundColor: meta.accent }]} />
            <Text style={[styles.topLabel, { color: `rgba(255,255,255,0.58)` }]}>
              الصلاة القادمة
            </Text>
          </View>
        </View>

        {/* ── PRAYER NAME — right-aligned block ─────── */}
        <View style={styles.prayerBlock}>
          <View style={styles.prayerNameRow}>
            <Text style={styles.prayerIconText}>{meta.icon}</Text>
            <Text style={styles.prayerNameText}>{prayerName}</Text>
          </View>
          <Text style={[styles.periodLabel, { color: meta.accent + 'AA' }]}>
            {meta.period}
          </Text>
        </View>

        {/* Thin ornament line */}
        <CardSeparator accent={meta.accent} />

        {/* ── HERO: countdown ──────────────────────── */}
        <Animated.View style={[styles.heroSection, { transform: [{ scale: pulse }] }]}>
          <Text style={styles.countdownText}>{timeRemaining}</Text>
          <Text style={[styles.countdownLabel, { color: 'rgba(255,255,255,0.45)' }]}>
            الوقت المتبقي
          </Text>
        </Animated.View>

        {/* ── PRAYER TIME PILL ─────────────────────── */}
        <View style={styles.pillWrapper}>
          {Platform.OS === 'ios' ? (
            <BlurView intensity={20} tint="light" style={styles.pill}>
              <Text style={[styles.pillText, { color: 'rgba(255,255,255,0.85)' }]}>
                الأذان في  {prayerTime}
              </Text>
              <Text style={{ fontSize: 12, marginLeft: spacing.xs }}>🕐</Text>
            </BlurView>
          ) : (
            <View style={[styles.pill, { backgroundColor: 'rgba(255,255,255,0.14)', borderColor: 'rgba(255,255,255,0.20)' }]}>
              <Text style={[styles.pillText, { color: 'rgba(255,255,255,0.85)' }]}>
                الأذان في  {prayerTime}
              </Text>
              <Text style={{ fontSize: 12, marginLeft: spacing.xs }}>🕐</Text>
            </View>
          )}
        </View>

        {/* ── PROGRESS BAR ─────────────────────────── */}
        <View style={styles.progressSection}>
          {/* Track */}
          <View style={styles.progressTrackOuter}>
            {/* Filled part with gradient */}
            <View style={[styles.progressFillWrapper, { width: `${clamped * 100}%` }]}>
              <LinearGradient
                colors={[meta.accent + '60', meta.accent + 'CC', '#FFFFFF']}
                start={{ x: 0, y: 0 }}
                end={{ x: 1, y: 0 }}
                style={styles.progressFill}
              />
            </View>

            {/* Thumb dot */}
            <View
              style={[
                styles.progressThumb,
                {
                  left: `${clamped * 100}%`,
                  backgroundColor: '#FFFFFF',
                  shadowColor:     meta.accent,
                },
              ]}
            />
          </View>

          {/* Labels */}
          <View style={styles.progressLabels}>
            <Text style={styles.progressLabelText}>{nextPrayer}</Text>
            <Text style={styles.progressLabelText}>{prevPrayer}</Text>
          </View>
        </View>
      </LinearGradient>
    </Animated.View>
  );
}

// ─── Styles ───────────────────────────────────────────────────────────────────
const styles = StyleSheet.create({
  outerShell: {
    marginHorizontal: spacing.lg,
    marginVertical:   spacing.md,
  },

  // Warm glow halo behind card
  glow: {
    position:       'absolute',
    top:            10,
    left:           20,
    right:          20,
    bottom:         -10,
    borderRadius:   borderRadius['3xl'],
    backgroundColor:'transparent',
    shadowOffset:   { width: 0, height: 14 },
    shadowOpacity:  0.50,
    shadowRadius:   30,
  },

  card: {
    borderRadius:  borderRadius['3xl'],   // 32px — rounder corners
    paddingTop:    spacing.xxl,
    paddingBottom: spacing.xxl,
    paddingHorizontal: spacing.xxl,
    borderWidth:   1,
    borderColor:   'rgba(255,255,255,0.10)',
    overflow:      'hidden',
  },

  // ── Top row ──────────────────────────────────────────
  topRow: {
    flexDirection:  'row',
    justifyContent: 'space-between',
    alignItems:     'center',
    marginBottom:   spacing.xxl,
  },
  bellBtn: {
    width:          34,
    height:         34,
    borderRadius:   borderRadius.xl,
    borderWidth:    1,
    alignItems:     'center',
    justifyContent: 'center',
  },
  labelGroup: {
    flexDirection: 'row',
    alignItems:    'center',
    gap:           spacing.sm,
  },
  topLabel: {
    fontFamily:    fonts.medium,
    fontSize:      fontSizes.caption,
    letterSpacing: 0.8,
  },
  activeDot: {
    width:        6,
    height:       6,
    borderRadius: borderRadius.full,
  },

  // ── Prayer name block (right-aligned) ─────────────────
  prayerBlock: {
    alignItems: 'flex-end',
    gap:        spacing.xxs + 1,
  },
  prayerNameRow: {
    flexDirection: 'row',
    alignItems:    'center',
    gap:           spacing.sm,
  },
  prayerIconText: {
    fontSize:   22,
    lineHeight: 30,
  },
  prayerNameText: {
    fontFamily:    fonts.quranBold,
    fontSize:      fontSizes.h3,
    color:         'rgba(255,255,255,0.95)',
    letterSpacing: 0.5,
    lineHeight:    fontSizes.h3 + 8,
  },
  periodLabel: {
    fontFamily:    fonts.regular,
    fontSize:      fontSizes.caption,
    letterSpacing: 0.5,
  },

  // ── Hero countdown ────────────────────────────────────
  heroSection: {
    alignItems:    'center',
    paddingVertical: spacing.sm,
    gap:           spacing.xs,
  },
  countdownText: {
    fontFamily:    fonts.quranBold,
    fontSize:      60,
    color:         '#FFFFFF',
    lineHeight:    68,
    letterSpacing: 3,
    includeFontPadding: false,
  },
  countdownLabel: {
    fontFamily:    fonts.light,
    fontSize:      fontSizes.caption,
    letterSpacing: 1.5,
  },

  // ── Prayer time pill ──────────────────────────────────
  pillWrapper: {
    alignItems:    'center',
    marginVertical: spacing.xl,
  },
  pill: {
    flexDirection:     'row',
    alignItems:        'center',
    justifyContent:    'center',
    borderRadius:      borderRadius.full,
    borderWidth:       1,
    paddingVertical:   spacing.sm,
    paddingHorizontal: spacing.xxl,
    overflow:          'hidden',
    gap:               spacing.xxs,
  },
  pillText: {
    fontFamily:    fonts.medium,
    fontSize:      fontSizes.bodySm,
    letterSpacing: 0.3,
  },

  // ── Progress ──────────────────────────────────────────
  progressSection: {
    gap: spacing.sm,
    marginTop: spacing.sm,
  },
  progressTrackOuter: {
    height:       3,
    backgroundColor: 'rgba(255,255,255,0.14)',
    borderRadius:    borderRadius.full,
    position:        'relative',
  },
  progressFillWrapper: {
    position:     'absolute',
    top:          0,
    left:         0,
    height:       '100%',
    borderRadius: borderRadius.full,
    overflow:     'hidden',
  },
  progressFill: {
    flex:         1,
    borderRadius: borderRadius.full,
  },
  progressThumb: {
    position:       'absolute',
    width:          11,
    height:         11,
    borderRadius:   borderRadius.full,
    top:            -4,
    marginLeft:     -5.5,
    shadowOffset:   { width: 0, height: 0 },
    shadowOpacity:  0.90,
    shadowRadius:   8,
    elevation:      4,
  },
  progressLabels: {
    flexDirection:  'row',
    justifyContent: 'space-between',
    marginTop:      spacing.xxs,
  },
  progressLabelText: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.micro,
    color:      'rgba(255,255,255,0.38)',
    letterSpacing: 0.3,
  },
});

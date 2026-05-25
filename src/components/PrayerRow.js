import React, { useRef } from 'react';
import { View, Text, TouchableOpacity, StyleSheet, Animated } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useTheme } from '../context/ThemeContext';
import { fonts, fontSizes } from '../design-system/typography';
import { spacing, borderRadius } from '../design-system/spacing';
import { shadows } from '../design-system/shadows';

const ICON_COLORS = {
  الفجر:   { bg: '#E8F4FC', icon: '#4A8CB5' },
  الظهر:  { bg: '#FDF5E0', icon: '#C4920A' },
  العصر:  { bg: '#FEF0E6', icon: '#C47820' },
  المغرب: { bg: '#FCE8EE', icon: '#B8486C' },
  العشاء: { bg: '#EEEDF8', icon: '#5855A8' },
};

const DARK_ICON_COLORS = {
  الفجر:   { bg: '#0E1E2E', icon: '#6ABADC' },
  الظهر:  { bg: '#2A1E04', icon: '#D4AA44' },
  العصر:  { bg: '#2E1408', icon: '#E09848' },
  المغرب: { bg: '#2A0E18', icon: '#DC8FA0' },
  العشاء: { bg: '#0E0E28', icon: '#8898D0' },
};

export default function PrayerRow({ prayer, isNext, isCompleted, onToggleBell }) {
  const { colors, isDark } = useTheme();
  const scale = useRef(new Animated.Value(1)).current;

  const ic = isDark
    ? (DARK_ICON_COLORS[prayer.nameAr] ?? { bg: '#1A1A2E', icon: '#8898D0' })
    : (ICON_COLORS[prayer.nameAr]     ?? { bg: '#F0EFF8', icon: '#5855A8' });

  const onPressIn  = () => Animated.spring(scale, { toValue: 0.975, useNativeDriver: true, tension: 300, friction: 20 }).start();
  const onPressOut = () => Animated.spring(scale, { toValue: 1.000, useNativeDriver: true, tension: 300, friction: 20 }).start();

  if (isNext) {
    // ── Active / Next prayer row — special highlight ──
    return (
      <Animated.View style={[{ transform: [{ scale }] }, styles.rowOuter]}>
        <TouchableOpacity
          activeOpacity={1}
          onPressIn={onPressIn}
          onPressOut={onPressOut}
          style={styles.touchable}
        >
          <LinearGradient
            colors={isDark
              ? ['#2E1A08', '#4A2E10', '#6A4018']
              : ['#FDF5E8', '#FAF0DC', '#F5E8CC']}
            start={{ x: 0, y: 0 }}
            end={{ x: 1, y: 1 }}
            style={[styles.row, styles.rowActive, { borderColor: isDark ? '#8A6020' : '#D4A840' }]}
          >
            <RowContent
              prayer={prayer}
              ic={ic}
              isNext
              isCompleted={false}
              colors={colors}
              isDark={isDark}
              onToggleBell={onToggleBell}
            />
          </LinearGradient>
        </TouchableOpacity>
      </Animated.View>
    );
  }

  // ── Regular row ──────────────────────────────────────
  return (
    <Animated.View style={[{ transform: [{ scale }] }, styles.rowOuter]}>
      <TouchableOpacity
        activeOpacity={1}
        onPressIn={onPressIn}
        onPressOut={onPressOut}
        style={styles.touchable}
      >
        <View style={[
          styles.row,
          {
            backgroundColor: colors.bgCard,
            borderColor:      colors.border,
            opacity: isCompleted ? 0.5 : 1,
          },
          shadows.cardSm(colors.shadowColor),
        ]}>
          <RowContent
            prayer={prayer}
            ic={ic}
            isNext={false}
            isCompleted={isCompleted}
            colors={colors}
            isDark={isDark}
            onToggleBell={onToggleBell}
          />
        </View>
      </TouchableOpacity>
    </Animated.View>
  );
}

// ─── Shared row content ────────────────────────────────────────────────────────
function RowContent({ prayer, ic, isNext, isCompleted, colors, isDark, onToggleBell }) {
  const activeTextColor = isDark ? '#D4A840' : '#A67820';
  const nameColor = isNext
    ? activeTextColor
    : isCompleted
      ? colors.textTertiary
      : colors.textPrimary;
  const timeColor = isNext ? activeTextColor : colors.textSecondary;

  return (
    <>
      {/* Left — bell button */}
      <TouchableOpacity
        style={[
          styles.bellBtn,
          {
            backgroundColor: isNext
              ? (isDark ? 'rgba(212,168,64,0.18)' : 'rgba(212,168,64,0.14)')
              : colors.bgMuted,
            borderColor: isNext
              ? (isDark ? 'rgba(212,168,64,0.40)' : 'rgba(180,140,20,0.30)')
              : colors.border,
          },
        ]}
        onPress={onToggleBell}
        hitSlop={{ top: 8, bottom: 8, left: 8, right: 8 }}
      >
        <Text style={{ fontSize: 13, opacity: prayer.bellOn ? 1 : 0.35 }}>🔔</Text>
      </TouchableOpacity>

      {/* Prayer time — right of bell */}
      <Text style={[styles.timeText, { color: timeColor }]}>
        {prayer.time}
      </Text>

      {/* Spacer */}
      <View style={{ flex: 1 }} />

      {/* Prayer name + icon */}
      <View style={styles.nameGroup}>
        {isNext && (
          <Text style={[styles.nextBadge, { color: activeTextColor, borderColor: activeTextColor + '50' }]}>
            القادمة
          </Text>
        )}
        {isCompleted && (
          <Text style={[styles.doneMark, { color: colors.textTertiary }]}>✓</Text>
        )}
        <Text style={[styles.prayerName, { color: nameColor }]}>{prayer.nameAr}</Text>

        {/* Icon circle */}
        <View style={[styles.iconCircle, { backgroundColor: ic.bg }]}>
          <Text style={{ fontSize: 16 }}>{prayer.icon}</Text>
        </View>
      </View>
    </>
  );
}

// ─── Styles ───────────────────────────────────────────────────────────────────
const styles = StyleSheet.create({
  rowOuter: {
    marginHorizontal: spacing.lg,
    marginVertical:   spacing.xs,
  },
  touchable: {},
  row: {
    flexDirection:     'row',
    alignItems:        'center',
    borderRadius:      borderRadius.xl,
    borderWidth:       1,
    paddingVertical:   spacing.md + 2,
    paddingHorizontal: spacing.lg,
    gap:               spacing.md,
  },
  rowActive: {
    borderWidth: 1.5,
  },
  bellBtn: {
    width:          34,
    height:         34,
    borderRadius:   borderRadius.lg,
    borderWidth:    1,
    alignItems:     'center',
    justifyContent: 'center',
  },
  timeText: {
    fontFamily:    fonts.medium,
    fontSize:      fontSizes.body,
    letterSpacing: 0.2,
  },
  nameGroup: {
    flexDirection: 'row',
    alignItems:    'center',
    gap:           spacing.sm,
  },
  prayerName: {
    fontFamily:    fonts.quranBold,
    fontSize:      fontSizes.h4,
    lineHeight:    fontSizes.h4 + 8,
    writingDirection: 'rtl',
  },
  iconCircle: {
    width:          42,
    height:         42,
    borderRadius:   borderRadius.xl,
    alignItems:     'center',
    justifyContent: 'center',
  },
  nextBadge: {
    fontFamily:        fonts.medium,
    fontSize:          fontSizes.micro,
    borderWidth:       1,
    borderRadius:      borderRadius.full,
    paddingHorizontal: spacing.sm,
    paddingVertical:   spacing.xxs,
    letterSpacing:     0.3,
  },
  doneMark: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.body,
  },
});

import React, { useRef } from 'react';
import { View, Text, TouchableOpacity, StyleSheet, Animated } from 'react-native';
import { useTheme } from '../context/ThemeContext';
import { fonts, fontSizes } from '../design-system/typography';
import { spacing, borderRadius } from '../design-system/spacing';

function toArabicNumerals(n) {
  return String(n).replace(/\d/g, d => '٠١٢٣٤٥٦٧٨٩'[d]);
}

export default function SurahCard({ surah, onPress }) {
  const { colors } = useTheme();
  const scale = useRef(new Animated.Value(1)).current;

  const onPressIn  = () => Animated.spring(scale, { toValue: 0.976, useNativeDriver: true, tension: 300, friction: 22 }).start();
  const onPressOut = () => Animated.spring(scale, { toValue: 1.000, useNativeDriver: true, tension: 300, friction: 22 }).start();

  const isMakki = surah.type === 'Meccan';

  return (
    <Animated.View style={{ transform: [{ scale }] }}>
      <TouchableOpacity
        activeOpacity={1}
        onPress={onPress}
        onPressIn={onPressIn}
        onPressOut={onPressOut}
        style={[styles.row, { borderBottomColor: colors.divider }]}
      >
        {/* Left — number badge */}
        <View style={[styles.badge, {
          backgroundColor: colors.gold + '13',
          borderColor:     colors.gold + '55',
        }]}>
          <Text style={[styles.badgeNum, { color: colors.gold }]}>
            {toArabicNumerals(surah.id)}
          </Text>
        </View>

        {/* Center — English name + meta */}
        <View style={styles.info}>
          <Text style={[styles.nameEn, { color: colors.textSecondary }]} numberOfLines={1}>
            {surah.nameEn}
          </Text>
          <View style={styles.metaRow}>
            <View style={[styles.typeChip, {
              backgroundColor: isMakki ? colors.goldMuted   : colors.greenMuted,
              borderColor:     isMakki ? colors.gold + '40' : colors.green + '35',
            }]}>
              <Text style={[styles.typeText, { color: isMakki ? colors.goldDark : colors.green }]}>
                {surah.typeAr}
              </Text>
            </View>
            <Text style={[styles.verseCount, { color: colors.textTertiary }]}>
              {toArabicNumerals(surah.verses)} آية
            </Text>
          </View>
        </View>

        {/* Right — Arabic name */}
        <Text style={[styles.nameAr, { color: colors.arabicPrimary }]}>
          {surah.nameAr}
        </Text>
      </TouchableOpacity>
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  row: {
    flexDirection:     'row',
    alignItems:        'center',
    paddingVertical:   spacing.md + 2,
    paddingHorizontal: spacing.xl,
    borderBottomWidth: 0.75,
    gap:               spacing.md,
  },
  badge: {
    width:          40,
    height:         40,
    borderRadius:   borderRadius.md,
    borderWidth:    1,
    alignItems:     'center',
    justifyContent: 'center',
  },
  badgeNum: {
    fontFamily: fonts.quranBold,
    fontSize:   fontSizes.body,
    lineHeight: fontSizes.body + 4,
  },
  info: {
    flex: 1,
    gap:  spacing.xxs + 1,
  },
  nameEn: {
    fontFamily:    fonts.semiBold,
    fontSize:      fontSizes.bodySm,
    letterSpacing: 0.2,
  },
  metaRow: {
    flexDirection: 'row',
    alignItems:    'center',
    gap:           spacing.xs,
  },
  typeChip: {
    borderWidth:       0.75,
    borderRadius:      borderRadius.full,
    paddingVertical:   2,
    paddingHorizontal: spacing.sm,
  },
  typeText: {
    fontFamily: fonts.medium,
    fontSize:   fontSizes.micro,
  },
  verseCount: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.micro,
  },
  nameAr: {
    fontFamily:       fonts.quranBold,
    fontSize:         fontSizes.h4,
    writingDirection: 'rtl',
    lineHeight:       fontSizes.h4 + 10,
  },
});

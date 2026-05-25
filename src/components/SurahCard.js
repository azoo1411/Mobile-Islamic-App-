import React, { useRef } from 'react';
import { View, Text, TouchableOpacity, StyleSheet, Animated } from 'react-native';
import { useTheme } from '../context/ThemeContext';
import { fonts, fontSizes } from '../design-system/typography';
import { spacing, borderRadius } from '../design-system/spacing';
import { shadows } from '../design-system/shadows';

function toArabicNumerals(n) {
  return String(n).replace(/\d/g, d => '٠١٢٣٤٥٦٧٨٩'[d]);
}

export default function SurahCard({ surah, onPress }) {
  const { colors } = useTheme();
  const scale = useRef(new Animated.Value(1)).current;

  const onPressIn  = () => Animated.spring(scale, { toValue: 0.97, useNativeDriver: true, tension: 300, friction: 20 }).start();
  const onPressOut = () => Animated.spring(scale, { toValue: 1.00, useNativeDriver: true, tension: 300, friction: 20 }).start();

  const isMakki = surah.type === 'Meccan';

  return (
    <Animated.View style={{ transform: [{ scale }] }}>
      <TouchableOpacity
        activeOpacity={1}
        onPress={onPress}
        onPressIn={onPressIn}
        onPressOut={onPressOut}
        style={[
          styles.card,
          {
            backgroundColor: colors.bgCard,
            borderColor:     colors.border,
            ...shadows.cardSm(colors.shadowColor),
          },
        ]}
      >
        {/* Left — number hexagon */}
        <View style={[styles.numberContainer, { backgroundColor: colors.green + '14', borderColor: colors.green + '30' }]}>
          <Text style={[styles.numberAr, { color: colors.green }]}>
            {toArabicNumerals(surah.id)}
          </Text>
        </View>

        {/* Center — names */}
        <View style={styles.info}>
          <Text style={[styles.nameEn, { color: colors.textSecondary }]}>
            {surah.nameEn}
          </Text>
          <Text style={[styles.nameMeaning, { color: colors.textTertiary }]}>
            {surah.nameMeaning}
          </Text>
        </View>

        {/* Right — Arabic name + meta */}
        <View style={styles.right}>
          <Text style={[styles.nameAr, { color: colors.arabicPrimary }]}>
            {surah.nameAr}
          </Text>
          <View style={styles.metaRow}>
            <View style={[
              styles.typeChip,
              {
                backgroundColor: isMakki ? colors.goldMuted   : colors.greenMuted,
                borderColor:     isMakki ? colors.gold + '50' : colors.green + '40',
              },
            ]}>
              <Text style={[styles.typeText, { color: isMakki ? colors.goldDark : colors.green }]}>
                {surah.typeAr}
              </Text>
            </View>
            <Text style={[styles.verseCount, { color: colors.textTertiary }]}>
              {surah.verses} آية
            </Text>
          </View>
        </View>
      </TouchableOpacity>
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  card: {
    flexDirection:   'row',
    alignItems:      'center',
    paddingVertical:   spacing.lg,
    paddingHorizontal: spacing.lg,
    marginHorizontal:  spacing.lg,
    marginVertical:    spacing.xs,
    borderRadius:      borderRadius.xl,
    borderWidth:       1,
    gap:               spacing.md,
  },
  numberContainer: {
    width:          44,
    height:         44,
    borderRadius:   borderRadius.md,
    borderWidth:    1,
    alignItems:     'center',
    justifyContent: 'center',
  },
  numberAr: {
    fontFamily: fonts.quranBold,
    fontSize:   fontSizes.h4,
    lineHeight: fontSizes.h4 + 4,
  },
  info: {
    flex: 1,
    gap:  spacing.xxs,
  },
  nameEn: {
    fontFamily: fonts.semiBold,
    fontSize:   fontSizes.body,
  },
  nameMeaning: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.caption,
  },
  right: {
    alignItems: 'flex-end',
    gap:        spacing.xs,
  },
  nameAr: {
    fontFamily:       fonts.quranBold,
    fontSize:         fontSizes.h4,
    writingDirection: 'rtl',
    lineHeight:       fontSizes.h4 + 8,
  },
  metaRow: {
    flexDirection:  'row',
    alignItems:     'center',
    gap:            spacing.xs,
  },
  typeChip: {
    borderWidth:       1,
    borderRadius:      borderRadius.full,
    paddingVertical:   1,
    paddingHorizontal: spacing.sm,
  },
  typeText: {
    fontFamily: fonts.medium,
    fontSize:   fontSizes.micro,
  },
  verseCount: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.caption,
  },
});

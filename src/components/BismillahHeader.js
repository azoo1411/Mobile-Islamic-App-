import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useTheme } from '../context/ThemeContext';
import { fonts, fontSizes, lineHeights } from '../design-system/typography';
import { spacing, borderRadius } from '../design-system/spacing';

const BISMILLAH = 'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ';

// Thin geometric ornament line
function OrnamentLine({ color }) {
  return (
    <View style={styles.ornamentRow}>
      <View style={[styles.ornamentDash, { backgroundColor: color }]} />
      <View style={[styles.ornamentDiamond, { backgroundColor: color }]} />
      <View style={[styles.ornamentDash, { backgroundColor: color }]} />
    </View>
  );
}

export default function BismillahHeader({ surahNameAr, surahNameEn, verseCount, revelationType }) {
  const { colors, isDark } = useTheme();

  return (
    <View style={styles.wrapper}>
      {/* Gradient header card */}
      <LinearGradient
        colors={[colors.surahHeaderStart, colors.surahHeaderEnd]}
        start={{ x: 0, y: 0 }}
        end={{ x: 1, y: 1 }}
        style={styles.headerCard}
      >
        {/* Decorative top ornament */}
        <OrnamentLine color={colors.gold + '70'} />

        {/* Surah number badge */}
        <View style={[styles.numberBadge, { borderColor: colors.gold + '50', backgroundColor: colors.gold + '18' }]}>
          <Text style={[styles.numberText, { color: colors.gold }]}>
            ﴿ سورة ﴾
          </Text>
        </View>

        {/* Arabic name */}
        <Text style={[styles.nameAr, { color: '#FFFFFF' }]}>{surahNameAr}</Text>
        <Text style={[styles.nameEn, { color: colors.gold + 'CC' }]}>{surahNameEn}</Text>

        {/* Meta chips */}
        <View style={styles.metaRow}>
          <View style={[styles.metaChip, { borderColor: colors.gold + '40', backgroundColor: colors.gold + '14' }]}>
            <Text style={[styles.metaText, { color: colors.gold }]}>{revelationType}</Text>
          </View>
          <View style={[styles.metaChip, { borderColor: colors.gold + '40', backgroundColor: colors.gold + '14' }]}>
            <Text style={[styles.metaText, { color: colors.gold }]}>{verseCount} آية</Text>
          </View>
        </View>

        {/* Bottom ornament */}
        <OrnamentLine color={colors.gold + '70'} />
      </LinearGradient>

      {/* Bismillah card */}
      <View style={[styles.bismillahCard, {
        backgroundColor: isDark ? colors.bgSecondary : colors.bismillahBg,
        borderColor: colors.gold + '30',
      }]}>
        {/* Subtle glow border top */}
        <View style={[styles.bismillahTopBorder, { backgroundColor: colors.gold + '50' }]} />

        <Text style={[styles.bismillahText, { color: colors.arabicPrimary }]}>
          {BISMILLAH}
        </Text>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  wrapper: {
    marginBottom: spacing.xxl,
  },
  headerCard: {
    borderRadius: borderRadius.xl,
    padding: spacing.xxl,
    alignItems: 'center',
    marginBottom: spacing.md,
    marginHorizontal: spacing.lg,
  },
  numberBadge: {
    borderWidth:   1,
    borderRadius:  borderRadius.full,
    paddingVertical:   spacing.xxs,
    paddingHorizontal: spacing.md,
    marginBottom: spacing.md,
  },
  numberText: {
    fontFamily: fonts.quran,
    fontSize:   fontSizes.bodySm,
    letterSpacing: 1,
  },
  nameAr: {
    fontFamily:   fonts.quranBold,
    fontSize:     fontSizes.h1,
    textAlign:    'center',
    marginBottom: spacing.xs,
    letterSpacing: 2,
  },
  nameEn: {
    fontFamily:   fonts.medium,
    fontSize:     fontSizes.bodySm,
    textAlign:    'center',
    letterSpacing: 1,
    marginBottom: spacing.lg,
  },
  metaRow: {
    flexDirection:  'row',
    gap:            spacing.sm,
    marginBottom:   spacing.lg,
  },
  metaChip: {
    borderWidth:       1,
    borderRadius:      borderRadius.full,
    paddingVertical:   spacing.xxs + 1,
    paddingHorizontal: spacing.md,
  },
  metaText: {
    fontFamily: fonts.semiBold,
    fontSize:   fontSizes.caption,
    letterSpacing: 0.5,
  },
  ornamentRow: {
    flexDirection:  'row',
    alignItems:     'center',
    marginVertical: spacing.sm,
    width:          120,
    justifyContent: 'center',
    gap:            spacing.sm,
  },
  ornamentDash: {
    flex:   1,
    height: 0.75,
    borderRadius: 1,
  },
  ornamentDiamond: {
    width:  5,
    height: 5,
    borderRadius: 1,
    transform: [{ rotate: '45deg' }],
  },
  bismillahCard: {
    marginHorizontal: spacing.lg,
    borderRadius:     borderRadius.xl,
    borderWidth:      1,
    overflow:         'hidden',
    paddingVertical:  spacing.xxl,
    paddingHorizontal: spacing['3xl'],
    alignItems:       'center',
  },
  bismillahTopBorder: {
    position: 'absolute',
    top:   0,
    left:  spacing['3xl'],
    right: spacing['3xl'],
    height: 1,
  },
  bismillahText: {
    fontFamily: fonts.quranBold,
    fontSize:   fontSizes.quranMD,
    lineHeight: lineHeights.quranMD,
    textAlign:  'center',
    writingDirection: 'rtl',
  },
});

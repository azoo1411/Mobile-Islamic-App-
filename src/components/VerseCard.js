import React, { useRef, useState } from 'react';
import {
  View, Text, TouchableOpacity, StyleSheet, Animated,
} from 'react-native';
import * as Haptics from 'expo-haptics';
import { useTheme } from '../context/ThemeContext';
import { fonts, fontSizes, lineHeights } from '../design-system/typography';
import { spacing, borderRadius } from '../design-system/spacing';

// Compact verse-number badge
function VerseNumberBadge({ number, goldColor }) {
  return (
    <View style={[styles.badge, { borderColor: goldColor + '50', backgroundColor: goldColor + '14' }]}>
      <Text style={[styles.badgeText, { color: goldColor }]}>
        ٪{toArabicNumerals(number)}
      </Text>
    </View>
  );
}

function toArabicNumerals(n) {
  return String(n).replace(/\d/g, d => '٠١٢٣٤٥٦٧٨٩'[d]);
}

// Action icon row that appears when a verse is long-pressed
function ActionBar({ colors, onBookmark, onShare, onPlay, onCopy, visible }) {
  const height = useRef(new Animated.Value(0)).current;
  const opacity = useRef(new Animated.Value(0)).current;

  React.useEffect(() => {
    Animated.parallel([
      Animated.spring(height, { toValue: visible ? 44 : 0, useNativeDriver: false, tension: 200, friction: 20 }),
      Animated.timing(opacity, { toValue: visible ? 1 : 0, duration: 180, useNativeDriver: true }),
    ]).start();
  }, [visible]);

  const actions = [
    { icon: '▶', label: 'تشغيل',    onPress: onPlay     },
    { icon: '☆', label: 'حفظ',      onPress: onBookmark },
    { icon: '⌘', label: 'نسخ',      onPress: onCopy     },
    { icon: '↗', label: 'مشاركة',   onPress: onShare    },
  ];

  return (
    <Animated.View style={[styles.actionBar, { height, opacity }]}>
      {actions.map(a => (
        <TouchableOpacity
          key={a.label}
          style={[styles.actionBtn, { backgroundColor: colors.bgElevated, borderColor: colors.border }]}
          onPress={a.onPress}
          activeOpacity={0.7}
        >
          <Text style={{ fontSize: 14, color: colors.gold }}>{a.icon}</Text>
          <Text style={[styles.actionLabel, { color: colors.textTertiary }]}>{a.label}</Text>
        </TouchableOpacity>
      ))}
    </Animated.View>
  );
}

export default function VerseCard({
  verse,
  isActive  = false,
  onPress,
  onBookmark,
  onShare,
  onPlay,
  onCopy,
}) {
  const { colors, arabicFontSize, showTranslation, showTranslit } = useTheme();
  const [expanded, setExpanded] = useState(false);
  const bgAnim  = useRef(new Animated.Value(0)).current;

  function handleLongPress() {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    setExpanded(v => !v);
  }

  function handlePressIn() {
    Animated.timing(bgAnim, { toValue: 1, duration: 100, useNativeDriver: false }).start();
  }
  function handlePressOut() {
    Animated.timing(bgAnim, { toValue: 0, duration: 200, useNativeDriver: false }).start();
  }

  const bgColor = bgAnim.interpolate({
    inputRange:  [0, 1],
    outputRange: [
      isActive ? colors.goldMuted : 'transparent',
      colors.goldMuted,
    ],
  });

  return (
    <Animated.View style={[styles.wrapper, { backgroundColor: bgColor }]}>
      <TouchableOpacity
        activeOpacity={1}
        onPress={onPress}
        onLongPress={handleLongPress}
        onPressIn={handlePressIn}
        onPressOut={handlePressOut}
      >
        {/* Verse content row */}
        <View style={styles.row}>
          {/* Verse number */}
          <VerseNumberBadge number={verse.number} goldColor={colors.gold} />

          {/* Arabic text block */}
          <View style={styles.textBlock}>
            <Text
              style={[
                styles.arabicText,
                {
                  color:      isActive ? colors.gold : colors.arabicPrimary,
                  fontSize:   arabicFontSize,
                  lineHeight: arabicFontSize * 1.85,
                },
              ]}
            >
              {verse.text}
            </Text>

            {/* Transliteration */}
            {showTranslit && verse.translit && (
              <Text style={[styles.translit, { color: colors.textTertiary }]}>
                {verse.translit}
              </Text>
            )}

            {/* Translation */}
            {showTranslation && verse.trans && (
              <Text style={[styles.translation, { color: colors.textSecondary }]}>
                {verse.trans}
              </Text>
            )}
          </View>
        </View>

        {/* Action bar (visible on long-press) */}
        <ActionBar
          colors={colors}
          visible={expanded}
          onPlay={onPlay}
          onBookmark={onBookmark}
          onCopy={onCopy}
          onShare={onShare}
        />
      </TouchableOpacity>

      {/* Verse divider */}
      <View style={[styles.divider, { backgroundColor: colors.divider }]} />
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  wrapper: {
    paddingHorizontal: spacing.lg,
    paddingTop:        spacing.xxl,
    borderRadius:      borderRadius.lg,
  },
  row: {
    flexDirection:  'row-reverse',   // badge on right for RTL
    alignItems:     'flex-start',
    gap:            spacing.md,
  },
  textBlock: {
    flex: 1,
  },
  arabicText: {
    fontFamily:       fonts.quran,
    textAlign:        'right',
    writingDirection: 'rtl',
    includeFontPadding: false,
  },
  translit: {
    fontFamily:   fonts.light,
    fontSize:     fontSizes.caption,
    lineHeight:   fontSizes.caption * 1.8,
    marginTop:    spacing.xs,
    textAlign:    'right',
    letterSpacing: 0.2,
  },
  translation: {
    fontFamily:   fonts.regular,
    fontSize:     fontSizes.bodySm,
    lineHeight:   fontSizes.bodySm * 1.7,
    marginTop:    spacing.sm,
    textAlign:    'left',
    paddingTop:   spacing.xs,
  },
  badge: {
    marginTop:         spacing.xs,
    width:             36,
    height:            36,
    borderRadius:      borderRadius.full,
    borderWidth:       1,
    alignItems:        'center',
    justifyContent:    'center',
  },
  badgeText: {
    fontFamily: fonts.quran,
    fontSize:   fontSizes.caption,
    lineHeight: fontSizes.caption + 4,
  },
  divider: {
    height:           0.75,
    marginTop:        spacing.xxl,
    marginHorizontal: spacing.lg,
    borderRadius:     1,
  },
  actionBar: {
    flexDirection:  'row',
    justifyContent: 'center',
    gap:            spacing.sm,
    overflow:       'hidden',
    marginTop:      spacing.sm,
  },
  actionBtn: {
    alignItems:     'center',
    justifyContent: 'center',
    paddingVertical:   spacing.xs + 2,
    paddingHorizontal: spacing.md,
    borderRadius:   borderRadius.md,
    borderWidth:    1,
    gap:            spacing.xxs,
  },
  actionLabel: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.micro,
  },
});

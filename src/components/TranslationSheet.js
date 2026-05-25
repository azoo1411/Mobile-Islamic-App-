import React, { useRef, useEffect } from 'react';
import {
  View, Text, StyleSheet, Animated, PanResponder,
  TouchableOpacity, Dimensions,
} from 'react-native';
import { useTheme } from '../context/ThemeContext';
import { fonts, fontSizes } from '../design-system/typography';
import { spacing, borderRadius } from '../design-system/spacing';
import { shadows } from '../design-system/shadows';

const { height: SCREEN_H } = Dimensions.get('window');
const SHEET_HEIGHT  = SCREEN_H * 0.42;
const SNAP_OPEN     = 0;
const SNAP_CLOSED   = SHEET_HEIGHT;

export default function TranslationSheet({ verse, visible, onClose }) {
  const { colors, isDark } = useTheme();
  const translateY = useRef(new Animated.Value(SNAP_CLOSED)).current;

  useEffect(() => {
    Animated.spring(translateY, {
      toValue:         visible ? SNAP_OPEN : SNAP_CLOSED,
      useNativeDriver: true,
      tension:         80,
      friction:        14,
    }).start();
  }, [visible]);

  const panResponder = PanResponder.create({
    onMoveShouldSetPanResponder: (_, { dy }) => Math.abs(dy) > 8,
    onPanResponderMove: (_, { dy }) => {
      if (dy > 0) translateY.setValue(dy);
    },
    onPanResponderRelease: (_, { dy, vy }) => {
      if (dy > SHEET_HEIGHT * 0.35 || vy > 0.8) {
        onClose?.();
      } else {
        Animated.spring(translateY, {
          toValue: SNAP_OPEN, useNativeDriver: true, tension: 100, friction: 15,
        }).start();
      }
    },
  });

  if (!verse) return null;

  return (
    <Animated.View
      style={[
        styles.sheet,
        {
          backgroundColor: isDark ? colors.bgElevated : colors.bgCard,
          borderColor:     colors.border,
          transform: [{ translateY }],
          ...shadows.modal(colors.shadowColor),
        },
      ]}
      {...panResponder.panHandlers}
    >
      {/* Drag handle */}
      <View style={styles.handleRow}>
        <View style={[styles.handle, { backgroundColor: colors.border }]} />
      </View>

      {/* Header */}
      <View style={styles.header}>
        <Text style={[styles.title, { color: colors.textTertiary }]}>
          سورة ·  آية {verse.number}
        </Text>
        <TouchableOpacity onPress={onClose} hitSlop={{ top: 8, bottom: 8, left: 8, right: 8 }}>
          <Text style={{ fontSize: 20, color: colors.textTertiary }}>✕</Text>
        </TouchableOpacity>
      </View>

      {/* Arabic text */}
      <Text style={[styles.arabicText, { color: colors.arabicPrimary }]}>
        {verse.text}
      </Text>

      {/* Transliteration */}
      {verse.translit && (
        <Text style={[styles.translit, { color: colors.textTertiary }]}>
          {verse.translit}
        </Text>
      )}

      {/* Divider */}
      <View style={[styles.divider, { backgroundColor: colors.divider }]} />

      {/* Translation */}
      <Text style={[styles.translation, { color: colors.textSecondary }]}>
        {verse.trans}
      </Text>
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  sheet: {
    position:       'absolute',
    bottom:         0,
    left:           0,
    right:          0,
    height:         SHEET_HEIGHT,
    borderTopLeftRadius:  borderRadius['3xl'],
    borderTopRightRadius: borderRadius['3xl'],
    borderWidth:    1,
    borderBottomWidth: 0,
    paddingHorizontal: spacing.xxl,
    paddingBottom:  spacing['4xl'],
  },
  handleRow: {
    alignItems: 'center',
    paddingTop: spacing.md,
    paddingBottom: spacing.sm,
  },
  handle: {
    width:        40,
    height:       4,
    borderRadius: borderRadius.full,
  },
  header: {
    flexDirection:  'row',
    justifyContent: 'space-between',
    alignItems:     'center',
    marginBottom:   spacing.lg,
  },
  title: {
    fontFamily: fonts.medium,
    fontSize:   fontSizes.caption,
    letterSpacing: 1,
    textTransform: 'uppercase',
  },
  arabicText: {
    fontFamily:       fonts.quranBold,
    fontSize:         fontSizes.quranSM,
    lineHeight:       fontSizes.quranSM * 1.9,
    textAlign:        'right',
    writingDirection: 'rtl',
    marginBottom:     spacing.md,
  },
  translit: {
    fontFamily:   fonts.light,
    fontSize:     fontSizes.caption,
    lineHeight:   fontSizes.caption * 1.8,
    textAlign:    'right',
    marginBottom: spacing.lg,
  },
  divider: {
    height:       0.75,
    marginBottom: spacing.lg,
    borderRadius: 1,
  },
  translation: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.body,
    lineHeight: fontSizes.body * 1.7,
    textAlign:  'left',
  },
});

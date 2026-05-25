import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet, Platform } from 'react-native';
import { BlurView } from 'expo-blur';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useTheme } from '../context/ThemeContext';
import { fonts, fontSizes } from '../design-system/typography';
import { spacing } from '../design-system/spacing';

// Icon primitives using Unicode / SVG-free approach for simplicity
const Icon = ({ name, size = 22, color }) => {
  const icons = {
    settings: '⚙',
    back:     '‹',
    search:   '⌕',
    bookmark: '⊹',
    menu:     '≡',
  };
  return (
    <Text style={{ fontSize: size, color, lineHeight: size + 4, fontFamily: fonts.regular }}>
      {icons[name] ?? '•'}
    </Text>
  );
};

export default function GlassHeader({
  surahNameAr,
  surahNameEn,
  juzNumber,
  onSettings,
  onBack,
  showBack = false,
  style,
}) {
  const { colors, isDark } = useTheme();
  const insets = useSafeAreaInsets();

  return (
    <View style={[styles.wrapper, { paddingTop: insets.top }, style]}>
      {Platform.OS === 'ios' ? (
        <BlurView
          intensity={isDark ? 60 : 70}
          tint={isDark ? 'dark' : 'light'}
          style={StyleSheet.absoluteFill}
        />
      ) : (
        <View
          style={[
            StyleSheet.absoluteFill,
            { backgroundColor: colors.glass },
          ]}
        />
      )}

      {/* Bottom border shimmer */}
      <View style={[styles.border, { backgroundColor: colors.gold + '30' }]} />

      <View style={styles.inner}>
        {/* Left — back or spacer */}
        <View style={styles.side}>
          {showBack && (
            <TouchableOpacity
              onPress={onBack}
              style={styles.iconBtn}
              hitSlop={{ top: 8, bottom: 8, left: 8, right: 8 }}
            >
              <Icon name="back" size={28} color={colors.textSecondary} />
            </TouchableOpacity>
          )}
        </View>

        {/* Center — surah info */}
        <View style={styles.center}>
          <Text
            style={[styles.surahAr, { color: colors.textPrimary }]}
            numberOfLines={1}
          >
            {surahNameAr}
          </Text>
          <Text
            style={[styles.surahEn, { color: colors.textTertiary }]}
            numberOfLines={1}
          >
            {surahNameEn}
            {juzNumber != null ? `  •  الجزء ${juzNumber}` : ''}
          </Text>
        </View>

        {/* Right — settings */}
        <View style={[styles.side, styles.sideRight]}>
          <TouchableOpacity
            onPress={onSettings}
            style={styles.iconBtn}
            hitSlop={{ top: 8, bottom: 8, left: 8, right: 8 }}
          >
            <Icon name="settings" size={20} color={colors.textSecondary} />
          </TouchableOpacity>
        </View>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  wrapper: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    zIndex: 100,
    overflow: 'hidden',
  },
  border: {
    position: 'absolute',
    bottom: 0,
    left: 16,
    right: 16,
    height: 1,
  },
  inner: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.md,
    minHeight: 56,
  },
  side: {
    width: 40,
    alignItems: 'flex-start',
  },
  sideRight: {
    alignItems: 'flex-end',
  },
  center: {
    flex: 1,
    alignItems: 'center',
    paddingHorizontal: spacing.sm,
  },
  surahAr: {
    fontFamily: fonts.quranBold,
    fontSize: fontSizes.h4,
    textAlign: 'center',
    letterSpacing: 0.5,
  },
  surahEn: {
    fontFamily: fonts.regular,
    fontSize: fontSizes.caption,
    textAlign: 'center',
    marginTop: 2,
    letterSpacing: 0.3,
  },
  iconBtn: {
    padding: spacing.xs,
  },
});

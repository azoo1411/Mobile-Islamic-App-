import React, { useRef, useEffect } from 'react';
import {
  View, Text, TouchableOpacity, StyleSheet, Platform, Animated,
} from 'react-native';
import { BlurView } from 'expo-blur';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useTheme } from '../context/ThemeContext';
import { fonts, fontSizes } from '../design-system/typography';
import { spacing, borderRadius } from '../design-system/spacing';
import { shadows } from '../design-system/shadows';
import {
  IconQuran,
  IconPrayer,
  IconAdhkar,
  IconSearch,
  IconRecitation,
  IconSettingsKnobs,
} from './TabIcons';

// ─── Icon size token — ONE place to change for all tabs ──────────────────────
const ICON_SIZE = 22;

// ─── Per-route icon mapping ───────────────────────────────────────────────────
// Every entry uses the same ICON_SIZE; color is injected at render time.
const TAB_CONFIG = {
  Quran:      { Icon: IconQuran,         label: 'القرآن'     },
  Prayer:     { Icon: IconPrayer,        label: 'الصلاة'     },
  Search:     { Icon: IconSearch,        label: 'البحث'      },
  Recitation: { Icon: IconRecitation,    label: 'التلاوة'    },
  Settings:   { Icon: IconSettingsKnobs, label: 'الإعدادات'  },
  // Uncomment to add الأذكار:
  // Adhkar:  { Icon: IconAdhkar,        label: 'الأذكار'    },
};

// ─── Single tab button ────────────────────────────────────────────────────────
function TabButton({ route, isFocused, onPress, colors }) {
  const config = TAB_CONFIG[route.name];
  if (!config) return null;

  const { Icon, label } = config;

  // Scale spring on focus change
  const scale   = useRef(new Animated.Value(isFocused ? 1.08 : 1)).current;
  const opacity = useRef(new Animated.Value(isFocused ? 1   : 0.55)).current;

  useEffect(() => {
    Animated.parallel([
      Animated.spring(scale, {
        toValue:         isFocused ? 1.08 : 1,
        useNativeDriver: true,
        tension:         200,
        friction:        16,
      }),
      Animated.timing(opacity, {
        toValue:         isFocused ? 1 : 0.55,
        duration:        200,
        useNativeDriver: true,
      }),
    ]).start();
  }, [isFocused]);

  // Active → gold, inactive → muted — both controlled SVG stroke color
  const iconColor = isFocused ? colors.tabActive : colors.tabInactive;

  return (
    <TouchableOpacity
      style={styles.tab}
      onPress={onPress}
      activeOpacity={0.75}
    >
      <Animated.View
        style={[styles.tabInner, { transform: [{ scale }], opacity }]}
      >
        {/* Active pill glow behind icon */}
        {isFocused && (
          <View
            style={[
              styles.activePill,
              { backgroundColor: colors.gold + '1E' },
            ]}
          />
        )}

        {/*
         * SVG icon — same ICON_SIZE for every tab.
         * Color is passed explicitly so it can be gold or muted,
         * no tint/opacity tricks needed.
         */}
        <Icon size={ICON_SIZE} color={iconColor} />

        <Text
          style={[
            styles.label,
            {
              color:      iconColor,
              fontFamily: isFocused ? fonts.semiBold : fonts.regular,
            },
          ]}
        >
          {label}
        </Text>
      </Animated.View>
    </TouchableOpacity>
  );
}

// ─── Floating tab bar ─────────────────────────────────────────────────────────
export default function FloatingTabBar({ state, descriptors, navigation }) {
  const { colors, isDark, focusMode } = useTheme();
  const insets = useSafeAreaInsets();

  if (focusMode) return null;

  return (
    <View
      style={[
        styles.container,
        { paddingBottom: insets.bottom + spacing.xs },
      ]}
      pointerEvents="box-none"
    >
      <View
        style={[
          styles.pill,
          {
            borderColor: colors.navBarBorder,
          },
          shadows.floating(colors.shadowColor),
        ]}
      >
        {/* Frosted glass background */}
        {Platform.OS === 'ios' ? (
          <BlurView
            intensity={isDark ? 72 : 78}
            tint={isDark ? 'dark' : 'light'}
            style={[StyleSheet.absoluteFill, { borderRadius: borderRadius.xxl }]}
          />
        ) : (
          <View
            style={[
              StyleSheet.absoluteFill,
              {
                backgroundColor: colors.navBar,
                borderRadius:    borderRadius.xxl,
              },
            ]}
          />
        )}

        {state.routes.map((route, index) => {
          const isFocused = state.index === index;

          const onPress = () => {
            const event = navigation.emit({
              type:              'tabPress',
              target:            route.key,
              canPreventDefault: true,
            });
            if (!isFocused && !event.defaultPrevented) {
              navigation.navigate({ name: route.name, merge: true });
            }
          };

          return (
            <TabButton
              key={route.key}
              route={route}
              isFocused={isFocused}
              onPress={onPress}
              colors={colors}
            />
          );
        })}
      </View>
    </View>
  );
}

// ─── Styles ───────────────────────────────────────────────────────────────────
const styles = StyleSheet.create({
  container: {
    position:          'absolute',
    bottom:            0,
    left:              0,
    right:             0,
    alignItems:        'center',
    paddingHorizontal: spacing.xl,
    zIndex:            200,
    pointerEvents:     'box-none',
  },
  pill: {
    flexDirection:     'row',
    borderRadius:      borderRadius.xxl,
    overflow:          'hidden',
    borderWidth:       1,
    paddingHorizontal: spacing.sm,
    paddingVertical:   spacing.sm,
    width:             '100%',
  },
  tab: {
    flex:           1,
    alignItems:     'center',
    justifyContent: 'center',
  },
  tabInner: {
    alignItems:      'center',
    justifyContent:  'center',
    paddingVertical: spacing.xs + 1,
    paddingHorizontal: spacing.sm,
    minWidth:        52,
    position:        'relative',
  },
  activePill: {
    position:     'absolute',
    top:          0,
    left:         0,
    right:        0,
    bottom:       0,
    borderRadius: borderRadius.lg,
  },
  label: {
    fontSize:    fontSizes.micro,
    marginTop:   3,
    textAlign:   'center',
    includeFontPadding: false,
  },
});

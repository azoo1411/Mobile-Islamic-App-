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

const TAB_ICONS = {
  Quran:      { active: '📖', inactive: '📖', label: 'القرآن'    },
  Prayer:     { active: '🕌', inactive: '🕌', label: 'الصلاة'    },
  Search:     { active: '🔍', inactive: '🔍', label: 'البحث'     },
  Recitation: { active: '🎧', inactive: '🎧', label: 'التلاوة'   },
  Settings:   { active: '⚙️', inactive: '⚙️', label: 'الإعدادات' },
};

// Single tab button with scale animation
function TabButton({ route, isFocused, onPress, colors }) {
  const scale  = useRef(new Animated.Value(isFocused ? 1.1 : 1)).current;
  const opaque = useRef(new Animated.Value(isFocused ? 1 : 0.55)).current;

  useEffect(() => {
    Animated.parallel([
      Animated.spring(scale,  { toValue: isFocused ? 1.12 : 1,    useNativeDriver: true, tension: 200, friction: 15 }),
      Animated.timing(opaque, { toValue: isFocused ? 1 : 0.55, duration: 200, useNativeDriver: true }),
    ]).start();
  }, [isFocused]);

  const meta  = TAB_ICONS[route.name] ?? { active: '●', inactive: '○', label: route.name };
  const emoji = isFocused ? meta.active : meta.inactive;
  const color = isFocused ? colors.tabActive : colors.tabInactive;

  return (
    <TouchableOpacity
      style={styles.tab}
      onPress={onPress}
      activeOpacity={0.7}
    >
      <Animated.View style={[styles.tabInner, { transform: [{ scale }], opacity: opaque }]}>
        {/* Active pill indicator */}
        {isFocused && (
          <View style={[styles.activePill, { backgroundColor: colors.gold + '22' }]} />
        )}

        <Text style={[styles.icon, { opacity: isFocused ? 1 : 0.7 }]}>{emoji}</Text>
        <Text style={[styles.label, { color, fontFamily: isFocused ? fonts.semiBold : fonts.regular }]}>
          {meta.label}
        </Text>
      </Animated.View>
    </TouchableOpacity>
  );
}

export default function FloatingTabBar({ state, descriptors, navigation }) {
  const { colors, isDark, focusMode } = useTheme();
  const insets = useSafeAreaInsets();

  if (focusMode) return null;

  return (
    <View style={[styles.container, { paddingBottom: insets.bottom + spacing.xs }]}>
      <View
        style={[
          styles.pill,
          { borderColor: colors.navBarBorder },
          shadows.floating(colors.shadowColor),
        ]}
      >
        {/* Blur / frosted glass background */}
        {Platform.OS === 'ios' ? (
          <BlurView
            intensity={isDark ? 75 : 80}
            tint={isDark ? 'dark' : 'light'}
            style={[StyleSheet.absoluteFill, { borderRadius: borderRadius.xxl }]}
          />
        ) : (
          <View
            style={[
              StyleSheet.absoluteFill,
              {
                backgroundColor: colors.navBar,
                borderRadius: borderRadius.xxl,
              },
            ]}
          />
        )}

        {state.routes.map((route, index) => {
          const isFocused = state.index === index;

          const onPress = () => {
            const event = navigation.emit({ type: 'tabPress', target: route.key, canPreventDefault: true });
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

const styles = StyleSheet.create({
  container: {
    position:        'absolute',
    bottom:          0,
    left:            0,
    right:           0,
    alignItems:      'center',
    paddingHorizontal: spacing.xl,
    zIndex:          200,
    pointerEvents:   'box-none',
  },
  pill: {
    flexDirection:   'row',
    borderRadius:    borderRadius.xxl,
    overflow:        'hidden',
    borderWidth:     1,
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.sm,
    width:           '100%',
  },
  tab: {
    flex:          1,
    alignItems:    'center',
    justifyContent:'center',
  },
  tabInner: {
    alignItems:    'center',
    justifyContent:'center',
    paddingVertical: spacing.xs,
    paddingHorizontal: spacing.sm,
    minWidth:      60,
    position:      'relative',
  },
  activePill: {
    position:      'absolute',
    top:           0,
    left:          0,
    right:         0,
    bottom:        0,
    borderRadius:  borderRadius.lg,
  },
  icon: {
    fontSize:     22,
    lineHeight:   28,
  },
  label: {
    fontSize:     fontSizes.micro,
    marginTop:    2,
    textAlign:    'center',
  },
});

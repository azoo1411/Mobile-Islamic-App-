import React, { useState, useRef, useCallback } from 'react';
import {
  View, FlatList, StyleSheet, StatusBar, TouchableOpacity,
  Text, Animated,
} from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useTheme } from '../context/ThemeContext';
import GlassHeader      from '../components/GlassHeader';
import BismillahHeader  from '../components/BismillahHeader';
import VerseCard        from '../components/VerseCard';
import TranslationSheet from '../components/TranslationSheet';
import { getVerses }    from '../data/quranData';
import { fonts, fontSizes } from '../design-system/typography';
import { spacing, borderRadius } from '../design-system/spacing';
import { shadows } from '../design-system/shadows';

const HEADER_H = 90;

export default function QuranReadingScreen({ route, navigation }) {
  const { surah } = route.params;
  const { colors, isDark, setFocusMode, focusMode } = useTheme();
  const insets  = useSafeAreaInsets();

  const verses      = getVerses(surah.id);
  const [activeId,  setActiveId]  = useState(null);
  const [sheetVerse, setSheetVerse] = useState(null);
  const [sheetOpen,  setSheetOpen]  = useState(false);

  // Header opacity driven by scroll
  const scrollY      = useRef(new Animated.Value(0)).current;
  const headerOpacity = scrollY.interpolate({
    inputRange:  [0, 60],
    outputRange: [0, 1],
    extrapolate: 'clamp',
  });

  // Floating controls visibility
  const controlsAnim = useRef(new Animated.Value(1)).current;
  const lastScroll   = useRef(0);
  function onScroll(e) {
    const y = e.nativeEvent.contentOffset.y;
    if (y - lastScroll.current > 20) {
      Animated.timing(controlsAnim, { toValue: 0, duration: 200, useNativeDriver: true }).start();
    } else if (lastScroll.current - y > 10) {
      Animated.timing(controlsAnim, { toValue: 1, duration: 200, useNativeDriver: true }).start();
    }
    lastScroll.current = y;
    scrollY.setValue(y);
  }

  function tapVerse(verse) {
    setActiveId(prev => (prev === verse.id ? null : verse.id));
  }

  function openSheet(verse) {
    setSheetVerse(verse);
    setSheetOpen(true);
  }

  const renderItem = useCallback(({ item }) => (
    <VerseCard
      verse={item}
      isActive={item.id === activeId}
      onPress={() => tapVerse(item)}
      onBookmark={() => {/* TODO */}}
      onShare={() => {/* TODO */}}
      onPlay={() => openSheet(item)}
      onCopy={() => {/* TODO */}}
    />
  ), [activeId]);

  const ListHeader = useCallback(() => (
    <BismillahHeader
      surahNameAr={surah.nameAr}
      surahNameEn={surah.nameEn}
      verseCount={surah.verses}
      revelationType={surah.typeAr}
    />
  ), [surah]);

  return (
    <View style={[styles.container, { backgroundColor: colors.bg }]}>
      <StatusBar barStyle={isDark ? 'light-content' : 'dark-content'} translucent backgroundColor="transparent" />

      {/* Animated glass header */}
      <Animated.View style={[styles.headerWrap, { opacity: headerOpacity }]}>
        <GlassHeader
          surahNameAr={surah.nameAr}
          surahNameEn={surah.nameEn}
          juzNumber={surah.juz}
          onBack={() => navigation.goBack()}
          onSettings={() => navigation.navigate('Settings')}
          showBack
        />
      </Animated.View>

      {/* Main scroll */}
      <FlatList
        data={verses}
        keyExtractor={v => String(v.id)}
        renderItem={renderItem}
        ListHeaderComponent={ListHeader}
        contentContainerStyle={[
          styles.content,
          { paddingTop: HEADER_H + insets.top, paddingBottom: 120 + insets.bottom },
        ]}
        showsVerticalScrollIndicator={false}
        onScroll={onScroll}
        scrollEventThrottle={16}
        // Paper-texture background pattern (subtle)
        style={{ backgroundColor: colors.bg }}
        ListEmptyComponent={
          <View style={styles.noVerses}>
            <Text style={[styles.noVersesText, { color: colors.textTertiary }]}>
              النص غير متوفر — يرجى تحميل البيانات الكاملة
            </Text>
          </View>
        }
      />

      {/* Floating control bar */}
      <Animated.View
        style={[
          styles.floatingBar,
          {
            backgroundColor: colors.navBar,
            borderColor: colors.navBarBorder,
            bottom: 80 + insets.bottom,
            opacity: controlsAnim,
            transform: [{ translateY: controlsAnim.interpolate({ inputRange: [0,1], outputRange: [20,0] }) }],
            ...shadows.floatingMd(colors.shadowColor),
          },
        ]}
        pointerEvents="box-none"
      >
        {[
          { icon: '🔖', label: 'علامة' },
          { icon: '🎧', label: 'تلاوة', onPress: () => navigation.navigate('Recitation', { surah }) },
          { icon: focusMode ? '👁' : '🧘', label: focusMode ? 'عادي' : 'تركيز', onPress: () => setFocusMode(!focusMode) },
          { icon: '⚙️', label: 'إعدادات', onPress: () => navigation.navigate('Settings') },
        ].map(b => (
          <TouchableOpacity
            key={b.label}
            style={styles.floatBtn}
            onPress={b.onPress}
            activeOpacity={0.7}
          >
            <Text style={{ fontSize: 18 }}>{b.icon}</Text>
            <Text style={[styles.floatLabel, { color: colors.textTertiary }]}>{b.label}</Text>
          </TouchableOpacity>
        ))}
      </Animated.View>

      {/* Translation bottom sheet */}
      <TranslationSheet
        verse={sheetVerse}
        visible={sheetOpen}
        onClose={() => setSheetOpen(false)}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  headerWrap: {
    position: 'absolute',
    top:   0, left: 0, right: 0,
    zIndex: 100,
  },
  content: {
    gap: 0,
  },
  noVerses: {
    paddingHorizontal: spacing.xxl,
    paddingVertical:   spacing['6xl'],
    alignItems: 'center',
  },
  noVersesText: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.body,
    textAlign:  'center',
    lineHeight: fontSizes.body * 1.8,
  },
  floatingBar: {
    position:        'absolute',
    left:            spacing.xxl,
    right:           spacing.xxl,
    flexDirection:   'row',
    justifyContent:  'space-around',
    alignItems:      'center',
    borderRadius:    borderRadius.xxl,
    borderWidth:     1,
    paddingVertical: spacing.sm,
    paddingHorizontal: spacing.lg,
  },
  floatBtn: {
    alignItems:    'center',
    gap:           spacing.xxs,
    paddingVertical: spacing.xs,
    paddingHorizontal: spacing.md,
  },
  floatLabel: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.micro,
  },
});

import React, { useState, useRef, useEffect } from 'react';
import {
  View, Text, TouchableOpacity, StyleSheet, StatusBar,
  FlatList, Animated, ScrollView,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import * as Haptics from 'expo-haptics';
import { useTheme } from '../context/ThemeContext';
import { surahs, reciters, getVerses } from '../data/quranData';
import { fonts, fontSizes } from '../design-system/typography';
import { spacing, borderRadius } from '../design-system/spacing';
import { shadows } from '../design-system/shadows';

// Faux waveform bars for visual interest
function Waveform({ isPlaying, color }) {
  const BARS   = 28;
  const heights = useRef(
    Array.from({ length: BARS }, () => Math.random() * 0.7 + 0.2)
  ).current;
  const anims  = useRef(heights.map(h => new Animated.Value(h))).current;

  useEffect(() => {
    if (!isPlaying) {
      anims.forEach((a, i) =>
        Animated.spring(a, { toValue: heights[i], useNativeDriver: false, tension: 80 }).start()
      );
      return;
    }
    const animations = anims.map((a, i) =>
      Animated.loop(
        Animated.sequence([
          Animated.timing(a, {
            toValue:  Math.random() * 0.8 + 0.2,
            duration: 200 + Math.random() * 300,
            useNativeDriver: false,
          }),
          Animated.timing(a, {
            toValue:  Math.random() * 0.5 + 0.1,
            duration: 150 + Math.random() * 250,
            useNativeDriver: false,
          }),
        ])
      )
    );
    animations.forEach(a => a.start());
    return () => animations.forEach(a => a.stop());
  }, [isPlaying]);

  return (
    <View style={styles.waveform}>
      {anims.map((anim, i) => (
        <Animated.View
          key={i}
          style={[
            styles.bar,
            {
              backgroundColor: color,
              height: anim.interpolate({ inputRange: [0, 1], outputRange: [4, 36] }),
              opacity: isPlaying ? 1 : 0.35,
            },
          ]}
        />
      ))}
    </View>
  );
}

// Playback speed pill
const SPEEDS = [0.75, 1, 1.25, 1.5];

export default function RecitationScreen({ route, navigation }) {
  const { colors, isDark } = useTheme();
  const insets = useSafeAreaInsets();

  // If coming from a surah, pre-select it
  const initSurah = route?.params?.surah ?? surahs[0];

  const [activeSurah,  setActiveSurah]  = useState(initSurah);
  const [activeReciter,setActiveReciter]= useState(reciters[0]);
  const [isPlaying,    setIsPlaying]    = useState(false);
  const [progress,     setProgress]     = useState(0.33);
  const [speed,        setSpeed]        = useState(1);
  const [activeVerse,  setActiveVerse]  = useState(0);

  const verses = getVerses(activeSurah.id);
  const playAnim = useRef(new Animated.Value(1)).current;

  function togglePlay() {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    setIsPlaying(v => !v);
    Animated.sequence([
      Animated.timing(playAnim, { toValue: 0.88, duration: 80, useNativeDriver: true }),
      Animated.spring(playAnim,  { toValue: 1,    tension: 200, friction: 12, useNativeDriver: true }),
    ]).start();
  }

  return (
    <View style={[styles.container, { backgroundColor: colors.bg }]}>
      <StatusBar barStyle="light-content" translucent backgroundColor="transparent" />

      {/* Gradient hero */}
      <LinearGradient
        colors={[colors.surahHeaderStart, colors.surahHeaderEnd, colors.bg]}
        locations={[0, 0.55, 1]}
        style={[styles.hero, { paddingTop: insets.top + spacing.xxl }]}
      >
        {/* Back */}
        <TouchableOpacity
          style={styles.backBtn}
          onPress={() => navigation.goBack()}
        >
          <Text style={{ fontSize: 24, color: 'rgba(255,255,255,0.8)' }}>‹</Text>
        </TouchableOpacity>

        <Text style={styles.heroTitle}>التلاوة</Text>

        {/* Active surah name */}
        <Text style={[styles.surahNameAr, { color: '#FFFFFF' }]}>
          {activeSurah.nameAr}
        </Text>
        <Text style={[styles.surahNameEn, { color: colors.gold + 'BB' }]}>
          {activeSurah.nameEn} · {activeSurah.verses} آية
        </Text>

        {/* Waveform */}
        <Waveform isPlaying={isPlaying} color={colors.gold} />
      </LinearGradient>

      <ScrollView
        showsVerticalScrollIndicator={false}
        contentContainerStyle={{ paddingBottom: 100 + insets.bottom }}
      >

        {/* ── Player card ─────────────────────────────────── */}
        <View style={[styles.playerCard, {
          backgroundColor: colors.bgCard,
          borderColor:     colors.border,
          ...shadows.cardLg(colors.shadowColor),
        }]}>

          {/* Reciter */}
          <View style={styles.reciterRow}>
            <View style={[styles.reciterAvatar, { backgroundColor: colors.greenMuted }]}>
              <Text style={{ fontSize: 22 }}>🎙</Text>
            </View>
            <View style={styles.reciterInfo}>
              <Text style={[styles.reciterName,  { color: colors.textPrimary }]}>
                {activeReciter.nameAr}
              </Text>
              <Text style={[styles.reciterStyle, { color: colors.textTertiary }]}>
                {activeReciter.style}
              </Text>
            </View>
            <TouchableOpacity style={[styles.changeBtn, { borderColor: colors.gold + '50' }]}>
              <Text style={[styles.changeBtnText, { color: colors.gold }]}>تغيير</Text>
            </TouchableOpacity>
          </View>

          {/* Active verse display */}
          {verses.length > 0 && (
            <View style={[styles.versePreview, { backgroundColor: colors.goldMuted, borderColor: colors.gold + '30' }]}>
              <Text style={[styles.versePreviewText, { color: colors.arabicPrimary }]}>
                {verses[activeVerse]?.text ?? ''}
              </Text>
            </View>
          )}

          {/* Progress bar */}
          <View style={styles.progressSection}>
            <View style={[styles.progressTrack, { backgroundColor: colors.border }]}>
              <View style={[styles.progressFill, { backgroundColor: colors.gold, width: `${progress * 100}%` }]} />
              <View style={[styles.progressThumb, {
                backgroundColor: colors.gold,
                left: `${progress * 100}%`,
              }]} />
            </View>
            <View style={styles.progressTimes}>
              <Text style={[styles.timeText, { color: colors.textTertiary }]}>٢:١٥</Text>
              <Text style={[styles.timeText, { color: colors.textTertiary }]}>٦:٤٨</Text>
            </View>
          </View>

          {/* Speed selector */}
          <View style={styles.speedRow}>
            <Text style={[styles.speedLabel, { color: colors.textTertiary }]}>السرعة</Text>
            {SPEEDS.map(s => (
              <TouchableOpacity
                key={s}
                style={[
                  styles.speedChip,
                  {
                    backgroundColor: speed === s ? colors.gold      : colors.bgMuted,
                    borderColor:     speed === s ? colors.gold       : colors.border,
                  },
                ]}
                onPress={() => setSpeed(s)}
              >
                <Text style={[styles.speedText, { color: speed === s ? '#FFFFFF' : colors.textSecondary }]}>
                  {s}x
                </Text>
              </TouchableOpacity>
            ))}
          </View>

          {/* Controls */}
          <View style={styles.controls}>
            <TouchableOpacity style={styles.ctrlBtn} onPress={() => setActiveVerse(v => Math.max(0, v - 1))}>
              <Text style={[styles.ctrlIcon, { color: colors.textSecondary }]}>⏮</Text>
            </TouchableOpacity>
            <TouchableOpacity style={styles.ctrlBtn}>
              <Text style={[styles.ctrlIcon, { color: colors.textSecondary }]}>⏪</Text>
            </TouchableOpacity>

            {/* Play/Pause main button */}
            <Animated.View style={{ transform: [{ scale: playAnim }] }}>
              <TouchableOpacity
                style={[styles.playBtn, {
                  backgroundColor: colors.gold,
                  ...shadows.cardMd('#C8A96E'),
                }]}
                onPress={togglePlay}
                activeOpacity={0.85}
              >
                <Text style={styles.playIcon}>{isPlaying ? '⏸' : '▶'}</Text>
              </TouchableOpacity>
            </Animated.View>

            <TouchableOpacity style={styles.ctrlBtn}>
              <Text style={[styles.ctrlIcon, { color: colors.textSecondary }]}>⏩</Text>
            </TouchableOpacity>
            <TouchableOpacity style={styles.ctrlBtn} onPress={() => setActiveVerse(v => Math.min((verses.length || 1) - 1, v + 1))}>
              <Text style={[styles.ctrlIcon, { color: colors.textSecondary }]}>⏭</Text>
            </TouchableOpacity>
          </View>
        </View>

        {/* ── Reciter list ────────────────────────────────── */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, { color: colors.textPrimary }]}>اختر القارئ</Text>
          {reciters.map(r => (
            <TouchableOpacity
              key={r.id}
              style={[
                styles.reciterItem,
                {
                  backgroundColor: activeReciter.id === r.id ? colors.goldMuted : colors.bgCard,
                  borderColor:     activeReciter.id === r.id ? colors.gold + '50' : colors.border,
                },
              ]}
              onPress={() => setActiveReciter(r)}
            >
              <Text style={[styles.rName,  { color: colors.textPrimary }]}>{r.nameAr}</Text>
              <Text style={[styles.rStyle, { color: colors.textTertiary }]}>{r.style}</Text>
              {activeReciter.id === r.id && (
                <Text style={{ color: colors.gold, fontSize: 18 }}>✓</Text>
              )}
            </TouchableOpacity>
          ))}
        </View>

      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  hero: {
    paddingHorizontal: spacing.xxl,
    paddingBottom:     spacing.xxl,
    alignItems:        'center',
  },
  backBtn: {
    position: 'absolute',
    top:      spacing.xxl,
    left:     spacing.xxl,
    padding:  spacing.sm,
  },
  heroTitle: {
    fontFamily:   fonts.bold,
    fontSize:     fontSizes.caption,
    color:        'rgba(255,255,255,0.6)',
    letterSpacing: 2,
    textTransform: 'uppercase',
    marginBottom: spacing.md,
  },
  surahNameAr: {
    fontFamily:   fonts.quranBold,
    fontSize:     fontSizes.h1,
    textAlign:    'center',
    letterSpacing: 2,
    marginBottom: spacing.xs,
  },
  surahNameEn: {
    fontFamily:   fonts.regular,
    fontSize:     fontSizes.bodySm,
    textAlign:    'center',
    marginBottom: spacing.xxl,
  },
  waveform: {
    flexDirection:  'row',
    alignItems:     'center',
    gap:            3,
    height:         44,
    marginTop:      spacing.lg,
  },
  bar: {
    width:        3,
    borderRadius: 2,
  },
  playerCard: {
    margin:       spacing.lg,
    borderRadius: borderRadius.xxl,
    borderWidth:  1,
    padding:      spacing.xxl,
    gap:          spacing.xxl,
  },
  reciterRow: {
    flexDirection:  'row',
    alignItems:     'center',
    gap:            spacing.md,
  },
  reciterAvatar: {
    width:          48,
    height:         48,
    borderRadius:   borderRadius.xl,
    alignItems:     'center',
    justifyContent: 'center',
  },
  reciterInfo: { flex: 1 },
  reciterName: {
    fontFamily: fonts.semiBold,
    fontSize:   fontSizes.body,
    textAlign:  'right',
  },
  reciterStyle: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.caption,
    textAlign:  'right',
  },
  changeBtn: {
    borderWidth:       1,
    borderRadius:      borderRadius.full,
    paddingVertical:   spacing.xxs + 1,
    paddingHorizontal: spacing.md,
  },
  changeBtnText: {
    fontFamily: fonts.medium,
    fontSize:   fontSizes.caption,
  },
  versePreview: {
    borderRadius:      borderRadius.xl,
    borderWidth:       1,
    padding:           spacing.lg,
  },
  versePreviewText: {
    fontFamily:       fonts.quranBold,
    fontSize:         fontSizes.quranSM,
    lineHeight:       fontSizes.quranSM * 1.85,
    textAlign:        'right',
    writingDirection: 'rtl',
  },
  progressSection: {
    gap: spacing.sm,
  },
  progressTrack: {
    height:       4,
    borderRadius: borderRadius.full,
    position:     'relative',
  },
  progressFill: {
    height:       4,
    borderRadius: borderRadius.full,
    position:     'absolute',
    left:         0,
    top:          0,
  },
  progressThumb: {
    width:        14,
    height:       14,
    borderRadius: borderRadius.full,
    position:     'absolute',
    top:          -5,
    marginLeft:   -7,
  },
  progressTimes: {
    flexDirection:  'row',
    justifyContent: 'space-between',
  },
  timeText: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.caption,
  },
  speedRow: {
    flexDirection:  'row',
    alignItems:     'center',
    gap:            spacing.sm,
    justifyContent: 'flex-end',
  },
  speedLabel: {
    fontFamily:  fonts.regular,
    fontSize:    fontSizes.caption,
    marginRight: spacing.xs,
  },
  speedChip: {
    borderWidth:       1,
    borderRadius:      borderRadius.full,
    paddingVertical:   spacing.xxs,
    paddingHorizontal: spacing.sm,
  },
  speedText: {
    fontFamily: fonts.semiBold,
    fontSize:   fontSizes.caption,
  },
  controls: {
    flexDirection:  'row',
    alignItems:     'center',
    justifyContent: 'center',
    gap:            spacing.xl,
  },
  ctrlBtn: {
    padding: spacing.sm,
  },
  ctrlIcon: {
    fontSize: 22,
  },
  playBtn: {
    width:          68,
    height:         68,
    borderRadius:   borderRadius.full,
    alignItems:     'center',
    justifyContent: 'center',
  },
  playIcon: {
    fontSize:  28,
    color:     '#FFFFFF',
    marginLeft: 2,
  },
  section: {
    marginHorizontal: spacing.lg,
    marginTop:        spacing.md,
    gap:              spacing.sm,
  },
  sectionTitle: {
    fontFamily:   fonts.bold,
    fontSize:     fontSizes.h4,
    marginBottom: spacing.sm,
    textAlign:    'right',
  },
  reciterItem: {
    flexDirection:   'row',
    alignItems:      'center',
    borderWidth:     1,
    borderRadius:    borderRadius.xl,
    padding:         spacing.lg,
    gap:             spacing.sm,
  },
  rName: {
    flex:       1,
    fontFamily: fonts.semiBold,
    fontSize:   fontSizes.body,
    textAlign:  'right',
  },
  rStyle: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.caption,
  },
});

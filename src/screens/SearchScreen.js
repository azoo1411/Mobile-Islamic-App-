import React, { useState, useMemo, useRef } from 'react';
import {
  View, Text, TextInput, FlatList, TouchableOpacity,
  StyleSheet, StatusBar, Animated,
} from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useTheme } from '../context/ThemeContext';
import { surahs, verses as allVerses } from '../data/quranData';
import { fonts, fontSizes } from '../design-system/typography';
import { spacing, borderRadius } from '../design-system/spacing';
import { shadows } from '../design-system/shadows';

const RECENT = ['الرحمن', 'آية الكرسي', 'Al-Kahf', 'Bismillah'];

// Build a flat list of all available verses for search
const SEARCHABLE = Object.entries(allVerses).flatMap(([surahId, vList]) => {
  const surah = surahs.find(s => s.id === Number(surahId));
  return vList.map(v => ({ ...v, surah }));
});

function HighlightText({ text, query, style }) {
  if (!query.trim() || !text.includes(query)) {
    return <Text style={style}>{text}</Text>;
  }
  const parts = text.split(query);
  return (
    <Text style={style}>
      {parts.map((part, i) => (
        <React.Fragment key={i}>
          {part}
          {i < parts.length - 1 && (
            <Text style={{ backgroundColor: '#C8A96E33', color: '#A6784A' }}>{query}</Text>
          )}
        </React.Fragment>
      ))}
    </Text>
  );
}

function ResultCard({ item, query, onPress, colors }) {
  return (
    <TouchableOpacity
      style={[styles.resultCard, { backgroundColor: colors.bgCard, borderColor: colors.border, ...shadows.cardSm(colors.shadowColor) }]}
      onPress={onPress}
      activeOpacity={0.75}
    >
      {/* Reference */}
      <View style={styles.refRow}>
        <Text style={[styles.refText, { color: colors.textTertiary }]}>
          {item.surah?.nameEn} · آية {item.number}
        </Text>
        <Text style={[styles.refAr, { color: colors.gold }]}>
          {item.surah?.nameAr}
        </Text>
      </View>

      {/* Arabic verse */}
      <HighlightText
        text={item.text}
        query={query}
        style={[styles.arabicVerse, { color: colors.arabicPrimary }]}
      />

      {/* Translation snippet */}
      {item.trans && (
        <Text style={[styles.transSnippet, { color: colors.textSecondary }]} numberOfLines={2}>
          {item.trans}
        </Text>
      )}
    </TouchableOpacity>
  );
}

export default function SearchScreen({ navigation }) {
  const { colors, isDark } = useTheme();
  const insets  = useSafeAreaInsets();
  const inputRef = useRef(null);
  const [query, setQuery] = useState('');
  const inputFocused = useRef(new Animated.Value(0)).current;

  const results = useMemo(() => {
    const q = query.trim();
    if (!q) return [];
    return SEARCHABLE.filter(v =>
      v.text.includes(q) ||
      v.trans?.toLowerCase().includes(q.toLowerCase()) ||
      v.surah?.nameEn?.toLowerCase().includes(q.toLowerCase())
    ).slice(0, 30);
  }, [query]);

  function onFocus() {
    Animated.timing(inputFocused, { toValue: 1, duration: 200, useNativeDriver: false }).start();
  }
  function onBlur() {
    Animated.timing(inputFocused, { toValue: 0, duration: 200, useNativeDriver: false }).start();
  }

  const borderColor = inputFocused.interpolate({
    inputRange:  [0, 1],
    outputRange: [colors.border, colors.gold],
  });

  return (
    <View style={[styles.container, { backgroundColor: colors.bg }]}>
      <StatusBar barStyle={isDark ? 'light-content' : 'dark-content'} translucent backgroundColor="transparent" />

      {/* ── Search header ──────────────────────────────────── */}
      <View style={[styles.header, { paddingTop: insets.top + spacing.lg, backgroundColor: colors.bg }]}>
        <Text style={[styles.pageTitle, { color: colors.textPrimary }]}>البحث</Text>
        <Text style={[styles.pageSubtitle, { color: colors.textTertiary }]}>
          ابحث في آيات القرآن الكريم
        </Text>

        {/* Input */}
        <Animated.View style={[styles.searchBox, { borderColor, backgroundColor: colors.bgMuted }]}>
          <Text style={{ fontSize: 18, color: colors.gold }}>🔍</Text>
          <TextInput
            ref={inputRef}
            style={[styles.input, { color: colors.textPrimary }]}
            placeholder="ابحث بالعربية أو الإنجليزية..."
            placeholderTextColor={colors.textTertiary}
            value={query}
            onChangeText={setQuery}
            onFocus={onFocus}
            onBlur={onBlur}
            textAlign="right"
            returnKeyType="search"
            autoCorrect={false}
          />
          {query.length > 0 && (
            <TouchableOpacity onPress={() => setQuery('')} hitSlop={{ top: 8, bottom: 8, left: 8, right: 8 }}>
              <Text style={{ fontSize: 16, color: colors.textTertiary }}>✕</Text>
            </TouchableOpacity>
          )}
        </Animated.View>
      </View>

      {/* ── Body ───────────────────────────────────────────── */}
      {query.trim() === '' ? (
        /* Recent searches */
        <View style={styles.recentSection}>
          <Text style={[styles.sectionLabel, { color: colors.textTertiary }]}>عمليات البحث الأخيرة</Text>
          <View style={styles.recentChips}>
            {RECENT.map(r => (
              <TouchableOpacity
                key={r}
                style={[styles.recentChip, { backgroundColor: colors.bgCard, borderColor: colors.border }]}
                onPress={() => setQuery(r)}
              >
                <Text style={[styles.recentText, { color: colors.textSecondary }]}>🕐  {r}</Text>
              </TouchableOpacity>
            ))}
          </View>

          {/* Quick access */}
          <Text style={[styles.sectionLabel, { color: colors.textTertiary, marginTop: spacing.xxl }]}>
            وصول سريع
          </Text>
          <View style={styles.quickGrid}>
            {[
              { label: 'آية الكرسي', sub: 'البقرة ٢٥٥' },
              { label: 'سورة الكهف', sub: 'الجمعة — ١١٠ آية' },
              { label: 'المعوذتان', sub: 'الفلق والناس' },
              { label: 'سورة يس',   sub: 'مكية — ٨٣ آية' },
            ].map(item => (
              <TouchableOpacity
                key={item.label}
                style={[styles.quickCard, {
                  backgroundColor: colors.bgCard,
                  borderColor:     colors.border,
                  ...shadows.cardSm(colors.shadowColor),
                }]}
                onPress={() => setQuery(item.label)}
              >
                <Text style={[styles.quickLabel, { color: colors.textPrimary }]}>{item.label}</Text>
                <Text style={[styles.quickSub,   { color: colors.textTertiary }]}>{item.sub}</Text>
              </TouchableOpacity>
            ))}
          </View>
        </View>
      ) : (
        /* Results */
        <FlatList
          data={results}
          keyExtractor={(_, i) => String(i)}
          renderItem={({ item }) => (
            <ResultCard
              item={item}
              query={query}
              colors={colors}
              onPress={() =>
                navigation.navigate('QuranReading', { surah: item.surah })
              }
            />
          )}
          contentContainerStyle={[
            styles.resultsList,
            { paddingBottom: 100 + insets.bottom },
          ]}
          showsVerticalScrollIndicator={false}
          ListEmptyComponent={
            <View style={styles.noResult}>
              <Text style={[styles.noResultIcon]}>🔍</Text>
              <Text style={[styles.noResultText, { color: colors.textTertiary }]}>
                لا توجد نتائج لـ "{query}"
              </Text>
            </View>
          }
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  header: {
    paddingHorizontal: spacing.xxl,
    paddingBottom:     spacing.xxl,
  },
  pageTitle: {
    fontFamily:   fonts.bold,
    fontSize:     fontSizes.h2,
    marginBottom: spacing.xxs,
    textAlign:    'right',
  },
  pageSubtitle: {
    fontFamily:   fonts.regular,
    fontSize:     fontSizes.bodySm,
    marginBottom: spacing.xxl,
    textAlign:    'right',
  },
  searchBox: {
    flexDirection:   'row-reverse',
    alignItems:      'center',
    borderWidth:     1.5,
    borderRadius:    borderRadius.xl,
    paddingHorizontal: spacing.lg,
    height:          52,
    gap:             spacing.sm,
  },
  input: {
    flex:        1,
    fontFamily:  fonts.regular,
    fontSize:    fontSizes.body,
    textAlign:   'right',
  },
  recentSection: {
    paddingHorizontal: spacing.xxl,
    paddingTop:        spacing.md,
  },
  sectionLabel: {
    fontFamily:   fonts.medium,
    fontSize:     fontSizes.caption,
    letterSpacing: 1,
    textTransform: 'uppercase',
    marginBottom: spacing.md,
    textAlign:    'right',
  },
  recentChips: {
    flexDirection: 'row',
    flexWrap:      'wrap',
    gap:           spacing.sm,
    justifyContent:'flex-end',
  },
  recentChip: {
    borderWidth:       1,
    borderRadius:      borderRadius.full,
    paddingVertical:   spacing.xs,
    paddingHorizontal: spacing.md,
  },
  recentText: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.bodySm,
  },
  quickGrid: {
    flexDirection: 'row',
    flexWrap:      'wrap',
    gap:           spacing.sm,
  },
  quickCard: {
    flex:              1,
    minWidth:          '45%',
    borderWidth:       1,
    borderRadius:      borderRadius.xl,
    padding:           spacing.lg,
    gap:               spacing.xxs,
  },
  quickLabel: {
    fontFamily: fonts.semiBold,
    fontSize:   fontSizes.body,
    textAlign:  'right',
  },
  quickSub: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.caption,
    textAlign:  'right',
  },
  resultsList: {
    paddingHorizontal: spacing.lg,
    paddingTop:        spacing.md,
    gap:               spacing.sm,
  },
  resultCard: {
    borderWidth:   1,
    borderRadius:  borderRadius.xl,
    padding:       spacing.lg,
    marginVertical: spacing.xs,
    gap:           spacing.sm,
  },
  refRow: {
    flexDirection:  'row',
    justifyContent: 'space-between',
    alignItems:     'center',
  },
  refText: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.caption,
  },
  refAr: {
    fontFamily: fonts.quranBold,
    fontSize:   fontSizes.bodySm,
  },
  arabicVerse: {
    fontFamily:       fonts.quran,
    fontSize:         fontSizes.quranSM,
    lineHeight:       fontSizes.quranSM * 1.85,
    textAlign:        'right',
    writingDirection: 'rtl',
  },
  transSnippet: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.bodySm,
    lineHeight: fontSizes.bodySm * 1.6,
  },
  noResult: {
    paddingTop:    spacing['6xl'],
    alignItems:    'center',
    gap:           spacing.lg,
  },
  noResultIcon: { fontSize: 40 },
  noResultText: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.body,
    textAlign:  'center',
  },
});

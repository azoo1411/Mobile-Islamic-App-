import React, { useState, useMemo } from 'react';
import {
  View, Text, TextInput, FlatList, TouchableOpacity,
  StyleSheet, StatusBar,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useTheme } from '../context/ThemeContext';
import SurahCard from '../components/SurahCard';
import { surahs } from '../data/quranData';
import { fonts, fontSizes } from '../design-system/typography';
import { spacing, borderRadius } from '../design-system/spacing';

const FILTERS = [
  { key: 'all',     label: 'الكل'   },
  { key: 'Meccan',  label: 'مكية'  },
  { key: 'Medinan', label: 'مدنية' },
];

// Triple-dot ornament divider inside header
function OrnamentDivider() {
  return (
    <View style={styles.ornamentRow}>
      <View style={styles.ornamentLine} />
      <View style={styles.ornamentDots}>
        <View style={[styles.dot, { width: 3.5, height: 3.5, opacity: 0.4 }]} />
        <View style={[styles.dot, { width: 5.5, height: 5.5, opacity: 0.7 }]} />
        <View style={[styles.dot, { width: 3.5, height: 3.5, opacity: 0.4 }]} />
      </View>
      <View style={styles.ornamentLine} />
    </View>
  );
}

export default function SurahIndexScreen({ navigation }) {
  const { colors, isDark } = useTheme();
  const insets = useSafeAreaInsets();
  const [query,  setQuery]  = useState('');
  const [filter, setFilter] = useState('all');

  const filtered = useMemo(() => {
    let list = surahs;
    if (filter !== 'all') list = list.filter(s => s.type === filter);
    if (query.trim()) {
      const q = query.toLowerCase();
      list = list.filter(s =>
        s.nameEn.toLowerCase().includes(q) ||
        s.nameAr.includes(query) ||
        String(s.id).includes(q)
      );
    }
    return list;
  }, [query, filter]);

  function openSurah(surah) {
    navigation.navigate('QuranReading', { surah });
  }

  return (
    <View style={[styles.container, { backgroundColor: colors.bg }]}>
      <StatusBar barStyle="light-content" translucent backgroundColor="transparent" />

      {/* ── Header ─────────────────────────────────────────── */}
      <LinearGradient
        colors={isDark
          ? [colors.surahHeaderStart, colors.surahHeaderEnd]
          : ['#0D2420', '#1B4332']}
        style={[styles.header, { paddingTop: insets.top + spacing.lg }]}
      >
        {/* Title */}
        <Text style={styles.headerTitle}>القرآن الكريم</Text>
        <Text style={[styles.headerSub, { color: 'rgba(200,169,110,0.75)' }]}>
          ١١٤ سورة  ·  ٦٢٣٦ آية
        </Text>

        <OrnamentDivider />

        {/* Search bar — pill style */}
        <View style={styles.searchWrap}>
          <Text style={styles.searchIcon}>🔍</Text>
          <TextInput
            style={styles.searchInput}
            placeholder="ابحث عن سورة..."
            placeholderTextColor="rgba(255,255,255,0.40)"
            value={query}
            onChangeText={setQuery}
            textAlign="right"
            returnKeyType="search"
          />
        </View>

        {/* Filter chips */}
        <View style={styles.filterRow}>
          {FILTERS.map(f => {
            const active = filter === f.key;
            return (
              <TouchableOpacity
                key={f.key}
                style={[
                  styles.filterChip,
                  active
                    ? styles.filterChipActive
                    : { backgroundColor: 'rgba(255,255,255,0.10)', borderColor: 'rgba(255,255,255,0.18)' },
                ]}
                onPress={() => setFilter(f.key)}
                activeOpacity={0.75}
              >
                <Text style={[
                  styles.filterText,
                  { color: active ? '#1B4332' : 'rgba(255,255,255,0.80)' },
                ]}>
                  {f.label}
                </Text>
              </TouchableOpacity>
            );
          })}
        </View>
      </LinearGradient>

      {/* ── Surah list ─────────────────────────────────────── */}
      <FlatList
        data={filtered}
        keyExtractor={s => String(s.id)}
        renderItem={({ item }) => (
          <SurahCard surah={item} onPress={() => openSurah(item)} />
        )}
        contentContainerStyle={[
          styles.list,
          { paddingBottom: 100 + insets.bottom },
        ]}
        showsVerticalScrollIndicator={false}
        ListEmptyComponent={
          <View style={styles.empty}>
            <Text style={[styles.emptyText, { color: colors.textTertiary }]}>
              لا توجد نتائج
            </Text>
          </View>
        }
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },

  // ── Header ──────────────────────────────────────────────────
  header: {
    paddingHorizontal: spacing.xxl,
    paddingBottom:     spacing.xl,
  },
  headerTitle: {
    fontFamily:    fonts.quranBold,
    fontSize:      fontSizes.h1,
    color:         '#C8A96E',
    textAlign:     'center',
    letterSpacing: 2,
    marginBottom:  spacing.xxs,
  },
  headerSub: {
    fontFamily:    fonts.regular,
    fontSize:      fontSizes.caption,
    textAlign:     'center',
    letterSpacing: 1,
  },

  // ── Ornament ────────────────────────────────────────────────
  ornamentRow: {
    flexDirection:  'row',
    alignItems:     'center',
    marginVertical: spacing.lg,
  },
  ornamentLine: {
    flex:            1,
    height:          0.8,
    backgroundColor: 'rgba(200,169,110,0.35)',
  },
  ornamentDots: {
    flexDirection:  'row',
    alignItems:     'center',
    gap:            5,
    marginHorizontal: 10,
  },
  dot: {
    borderRadius:    20,
    backgroundColor: '#C8A96E',
  },

  // ── Search ──────────────────────────────────────────────────
  searchWrap: {
    flexDirection:     'row',
    alignItems:        'center',
    backgroundColor:   'rgba(255,255,255,0.11)',
    borderRadius:      borderRadius.full,
    borderWidth:       1,
    borderColor:       'rgba(200,169,110,0.30)',
    paddingHorizontal: spacing.lg,
    height:            46,
    marginBottom:      spacing.lg,
  },
  searchIcon: {
    fontSize:   15,
    marginLeft: spacing.xs,
    opacity:    0.7,
  },
  searchInput: {
    flex:        1,
    fontFamily:  fonts.regular,
    fontSize:    fontSizes.body,
    color:       '#FFFFFF',
    textAlign:   'right',
    marginRight: spacing.sm,
  },

  // ── Filter chips ────────────────────────────────────────────
  filterRow: {
    flexDirection:  'row',
    justifyContent: 'center',
    gap:            spacing.sm,
  },
  filterChip: {
    borderWidth:       1,
    borderRadius:      borderRadius.full,
    paddingVertical:   spacing.xs,
    paddingHorizontal: spacing.xl,
  },
  filterChipActive: {
    backgroundColor: '#C8A96E',
    borderColor:     '#C8A96E',
  },
  filterText: {
    fontFamily: fonts.semiBold,
    fontSize:   fontSizes.bodySm,
  },

  // ── List ────────────────────────────────────────────────────
  list: {
    paddingTop: spacing.xs,
  },
  empty: {
    paddingVertical: 80,
    alignItems:      'center',
  },
  emptyText: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.body,
  },
});

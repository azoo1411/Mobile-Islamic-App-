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
  { key: 'all',    label: 'الكل'    },
  { key: 'Meccan', label: 'مكية'   },
  { key: 'Medinan',label: 'مدنية'  },
];

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
      <StatusBar barStyle={isDark ? 'light-content' : 'dark-content'} translucent backgroundColor="transparent" />

      {/* ── Header ─────────────────────────────────────────── */}
      <LinearGradient
        colors={[colors.surahHeaderStart, colors.surahHeaderEnd]}
        style={[styles.header, { paddingTop: insets.top + spacing.lg }]}
      >
        <Text style={styles.headerTitle}>القرآن الكريم</Text>
        <Text style={[styles.headerSub, { color: colors.gold + 'CC' }]}>
          ١١٤ سورة  •  ٦٢٣٦ آية
        </Text>

        {/* Search bar */}
        <View style={[styles.searchBar, { backgroundColor: 'rgba(255,255,255,0.12)', borderColor: 'rgba(255,255,255,0.20)' }]}>
          <Text style={{ fontSize: 16, marginLeft: spacing.sm, color: 'rgba(255,255,255,0.6)' }}>🔍</Text>
          <TextInput
            style={[styles.searchInput, { color: '#FFFFFF' }]}
            placeholder="ابحث عن سورة..."
            placeholderTextColor="rgba(255,255,255,0.45)"
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
                  {
                    backgroundColor: active ? colors.gold : 'rgba(255,255,255,0.12)',
                    borderColor:     active ? colors.gold : 'rgba(255,255,255,0.20)',
                  },
                ]}
                onPress={() => setFilter(f.key)}
              >
                <Text style={[styles.filterText, { color: active ? '#FFFFFF' : 'rgba(255,255,255,0.75)' }]}>
                  {f.label}
                </Text>
              </TouchableOpacity>
            );
          })}
        </View>
      </LinearGradient>

      {/* ── Surah List ─────────────────────────────────────── */}
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
  header: {
    paddingHorizontal: spacing.xxl,
    paddingBottom:     spacing.xxl,
  },
  headerTitle: {
    fontFamily:  fonts.quranBold,
    fontSize:    fontSizes.h1,
    color:       '#FFFFFF',
    textAlign:   'center',
    letterSpacing: 2,
    marginBottom: spacing.xxs,
  },
  headerSub: {
    fontFamily:  fonts.regular,
    fontSize:    fontSizes.caption,
    textAlign:   'center',
    marginBottom: spacing.xxl,
    letterSpacing: 1,
  },
  searchBar: {
    flexDirection:   'row-reverse',
    alignItems:      'center',
    borderWidth:     1,
    borderRadius:    borderRadius.xl,
    paddingHorizontal: spacing.lg,
    height:          48,
    marginBottom:    spacing.lg,
  },
  searchInput: {
    flex:        1,
    fontFamily:  fonts.regular,
    fontSize:    fontSizes.body,
    textAlign:   'right',
    marginRight: spacing.sm,
  },
  filterRow: {
    flexDirection:  'row',
    justifyContent: 'center',
    gap:            spacing.sm,
  },
  filterChip: {
    borderWidth:       1,
    borderRadius:      borderRadius.full,
    paddingVertical:   spacing.xs,
    paddingHorizontal: spacing.lg,
  },
  filterText: {
    fontFamily: fonts.semiBold,
    fontSize:   fontSizes.bodySm,
  },
  list: {
    paddingTop: spacing.lg,
  },
  empty: {
    paddingVertical: spacing['6xl'],
    alignItems: 'center',
  },
  emptyText: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.body,
  },
});

import React, { useState } from 'react';
import {
  View, Text, TouchableOpacity, ScrollView,
  StyleSheet, StatusBar, FlatList,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useTheme } from '../context/ThemeContext';
import { poetryCategories, poetryContent } from '../data/poetryData';
import { fonts, fontSizes } from '../design-system/typography';
import { spacing, borderRadius } from '../design-system/spacing';

// Ornament divider
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

// Category tab chip
function CategoryChip({ category, active, onPress }) {
  return (
    <TouchableOpacity
      style={[
        styles.chip,
        active ? styles.chipActive : styles.chipInactive,
      ]}
      onPress={onPress}
      activeOpacity={0.75}
    >
      <Text style={[styles.chipText, { color: active ? '#1B4332' : 'rgba(255,255,255,0.80)' }]}>
        {category.titleAr}
      </Text>
    </TouchableOpacity>
  );
}

// Poem card
function PoemCard({ poem, onPress, colors }) {
  return (
    <TouchableOpacity
      style={[styles.poemCard, { backgroundColor: colors.bgCard, borderColor: colors.border }]}
      onPress={onPress}
      activeOpacity={0.82}
    >
      {/* Left gold accent */}
      <View style={styles.poemAccent} />

      <View style={styles.poemContent}>
        {/* Title + poet */}
        <View style={styles.poemHeader}>
          <Text style={[styles.poemTitle, { color: colors.textPrimary }]}>
            {poem.titleAr}
          </Text>
          <Text style={[styles.poemPoet, { color: colors.textGold }]}>
            {poem.poetAr}
          </Text>
          {poem.era ? (
            <Text style={[styles.poemEra, { color: colors.textTertiary }]}>
              {poem.era}
            </Text>
          ) : null}
        </View>

        {/* Preview — first verse */}
        <Text
          style={[styles.poemPreview, { color: colors.textSecondary }]}
          numberOfLines={2}
        >
          {poem.verses.filter(v => v.trim()).slice(0, 1).join('  ·  ')}
        </Text>

        <View style={[styles.readMoreRow]}>
          <Text style={[styles.readMore, { color: colors.gold }]}>اقرأ القصيدة ›</Text>
        </View>
      </View>
    </TouchableOpacity>
  );
}

// ── Full poem viewer ──────────────────────────────────────────────────────────
function PoemViewer({ poem, onClose, colors }) {
  const insets = useSafeAreaInsets();
  return (
    <View style={[StyleSheet.absoluteFill, { backgroundColor: colors.bg, zIndex: 50 }]}>
      <LinearGradient
        colors={['#0D2420', '#1B4332']}
        style={[styles.viewerHeader, { paddingTop: insets.top + spacing.md }]}
      >
        <TouchableOpacity onPress={onClose} style={styles.closeBtn} activeOpacity={0.75}>
          <Text style={styles.closeText}>‹  رجوع</Text>
        </TouchableOpacity>
        <Text style={styles.viewerTitle}>{poem.titleAr}</Text>
        <Text style={[styles.viewerPoet, { color: 'rgba(200,169,110,0.85)' }]}>
          {poem.poetAr}{poem.era ? `  ·  ${poem.era}` : ''}
        </Text>
      </LinearGradient>

      <ScrollView
        contentContainerStyle={[styles.viewerBody, { paddingBottom: 100 + insets.bottom }]}
        showsVerticalScrollIndicator={false}
      >
        {poem.verses.map((verse, i) => (
          verse.trim() === '' ? (
            <View key={i} style={{ height: spacing.xl }} />
          ) : (
            <Text key={i} style={[styles.verse, { color: colors.arabicPrimary }]}>
              {verse}
            </Text>
          )
        ))}
      </ScrollView>
    </View>
  );
}

// ── Main screen ───────────────────────────────────────────────────────────────
export default function PoetryScreen() {
  const { colors, isDark } = useTheme();
  const insets = useSafeAreaInsets();
  const [activeCat, setActiveCat] = useState(poetryCategories[0].id);
  const [viewingPoem, setViewingPoem] = useState(null);

  const poems = poetryContent[activeCat] || [];

  return (
    <View style={[styles.container, { backgroundColor: colors.bg }]}>
      <StatusBar barStyle="light-content" translucent backgroundColor="transparent" />

      {/* Full poem overlay */}
      {viewingPoem && (
        <PoemViewer
          poem={viewingPoem}
          onClose={() => setViewingPoem(null)}
          colors={colors}
        />
      )}

      {/* ── Header ─────────────────────────────────────────── */}
      <LinearGradient
        colors={isDark ? ['#0B2016', '#143825'] : ['#0D2420', '#1B4332']}
        style={[styles.header, { paddingTop: insets.top + spacing.lg }]}
      >
        <Text style={styles.headerTitle}>المكتبة الإسلامية</Text>
        <Text style={[styles.headerSub, { color: 'rgba(200,169,110,0.75)' }]}>
          شعر ومدائح وأناشيد
        </Text>
        <OrnamentDivider />

        {/* Category chips */}
        <ScrollView
          horizontal
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={styles.chipsRow}
        >
          {poetryCategories.map(cat => (
            <CategoryChip
              key={cat.id}
              category={cat}
              active={activeCat === cat.id}
              onPress={() => setActiveCat(cat.id)}
            />
          ))}
        </ScrollView>
      </LinearGradient>

      {/* ── Poem list ──────────────────────────────────────── */}
      <FlatList
        data={poems}
        keyExtractor={p => p.id}
        renderItem={({ item }) => (
          <PoemCard
            poem={item}
            onPress={() => setViewingPoem(item)}
            colors={colors}
          />
        )}
        contentContainerStyle={[
          styles.list,
          { paddingBottom: 100 + insets.bottom },
        ]}
        showsVerticalScrollIndicator={false}
        ListEmptyComponent={
          <View style={styles.empty}>
            <Text style={[styles.emptyText, { color: colors.textTertiary }]}>
              لا توجد قصائد
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
    fontFamily:   fonts.regular,
    fontSize:     fontSizes.caption,
    textAlign:    'center',
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
    flexDirection:    'row',
    alignItems:       'center',
    gap:              5,
    marginHorizontal: 10,
  },
  dot: {
    borderRadius:    20,
    backgroundColor: '#C8A96E',
  },

  // ── Category chips ──────────────────────────────────────────
  chipsRow: {
    flexDirection:  'row',
    gap:            spacing.sm,
    paddingRight:   spacing.xxl,
  },
  chip: {
    borderWidth:       1,
    borderRadius:      borderRadius.full,
    paddingVertical:   spacing.xs,
    paddingHorizontal: spacing.xl,
  },
  chipActive: {
    backgroundColor: '#C8A96E',
    borderColor:     '#C8A96E',
  },
  chipInactive: {
    backgroundColor: 'rgba(255,255,255,0.10)',
    borderColor:     'rgba(255,255,255,0.18)',
  },
  chipText: {
    fontFamily: fonts.semiBold,
    fontSize:   fontSizes.bodySm,
  },

  // ── List ────────────────────────────────────────────────────
  list: {
    paddingHorizontal: spacing.lg,
    paddingTop:        spacing.lg,
  },
  empty: {
    paddingVertical: 80,
    alignItems:      'center',
  },
  emptyText: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.body,
  },

  // ── Poem card ───────────────────────────────────────────────
  poemCard: {
    flexDirection:  'row',
    borderRadius:   borderRadius.xl,
    borderWidth:    1,
    overflow:       'hidden',
    marginBottom:   spacing.md,
  },
  poemAccent: {
    width:           3,
    backgroundColor: '#C8A96E',
  },
  poemContent: {
    flex:    1,
    padding: spacing.lg,
  },
  poemHeader: {
    marginBottom: spacing.md,
    alignItems:   'flex-end',
  },
  poemTitle: {
    fontFamily:   fonts.quranBold,
    fontSize:     fontSizes.h4,
    textAlign:    'right',
    marginBottom: 2,
  },
  poemPoet: {
    fontFamily: fonts.semiBold,
    fontSize:   fontSizes.bodySm,
    textAlign:  'right',
  },
  poemEra: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.caption,
    textAlign:  'right',
    marginTop:  2,
  },
  poemPreview: {
    fontFamily:   fonts.quran,
    fontSize:     fontSizes.quranXS,
    textAlign:    'right',
    lineHeight:   32,
    marginBottom: spacing.md,
  },
  readMoreRow: {
    alignItems: 'flex-end',
  },
  readMore: {
    fontFamily: fonts.semiBold,
    fontSize:   fontSizes.caption,
  },

  // ── Poem viewer ─────────────────────────────────────────────
  viewerHeader: {
    paddingHorizontal: spacing.xxl,
    paddingBottom:     spacing.xl,
  },
  closeBtn: {
    alignSelf:    'flex-start',
    marginBottom: spacing.lg,
  },
  closeText: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.body,
    color:      'rgba(255,255,255,0.75)',
  },
  viewerTitle: {
    fontFamily:   fonts.quranBold,
    fontSize:     fontSizes.h2,
    color:        '#FFFFFF',
    textAlign:    'right',
    marginBottom: spacing.xxs,
  },
  viewerPoet: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.bodySm,
    textAlign:  'right',
  },
  viewerBody: {
    paddingHorizontal: spacing.xxl,
    paddingTop:        spacing.xl,
  },
  verse: {
    fontFamily:  fonts.quran,
    fontSize:    fontSizes.quranSM,
    textAlign:   'center',
    lineHeight:  48,
  },
});

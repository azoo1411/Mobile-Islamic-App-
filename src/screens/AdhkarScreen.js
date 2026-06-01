import React from 'react';
import {
  View, Text, TouchableOpacity, FlatList,
  StyleSheet, StatusBar,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useTheme } from '../context/ThemeContext';
import { adhkarCategories } from '../data/adhkarData';
import { fonts, fontSizes } from '../design-system/typography';
import { spacing, borderRadius } from '../design-system/spacing';

// Ornament divider shared with SurahIndexScreen style
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

function CategoryCard({ category, onPress }) {
  return (
    <TouchableOpacity
      style={styles.cardWrap}
      onPress={onPress}
      activeOpacity={0.82}
    >
      <LinearGradient
        colors={[category.gradientStart, category.gradientEnd]}
        start={{ x: 0, y: 0 }}
        end={{ x: 1, y: 1 }}
        style={styles.card}
      >
        {/* Accent stripe */}
        <View style={[styles.accentStripe, { backgroundColor: category.accentColor + '55' }]} />

        <View style={styles.cardContent}>
          <Text style={styles.categoryTitle}>{category.titleAr}</Text>
          <Text style={[styles.categorySubtitle, { color: category.accentColor }]}>
            {category.subtitleAr}
          </Text>
          <View style={[styles.countBadge, { backgroundColor: category.accentColor + '33', borderColor: category.accentColor + '55' }]}>
            <Text style={[styles.countText, { color: category.accentColor }]}>
              {category.count} أذكار
            </Text>
          </View>
        </View>

        {/* Decorative circle */}
        <View style={[styles.decorCircle, { borderColor: category.accentColor + '22' }]} />
      </LinearGradient>
    </TouchableOpacity>
  );
}

export default function AdhkarScreen({ navigation }) {
  const { colors, isDark } = useTheme();
  const insets = useSafeAreaInsets();

  function openCategory(category) {
    navigation.navigate('AdhkarReader', { category });
  }

  const renderItem = ({ item, index }) => {
    // Two columns — pair items
    if (index % 2 !== 0) return null;
    const right = adhkarCategories[index];
    const left  = adhkarCategories[index + 1];
    return (
      <View style={styles.row}>
        <CategoryCard category={right} onPress={() => openCategory(right)} />
        {left ? (
          <CategoryCard category={left} onPress={() => openCategory(left)} />
        ) : (
          <View style={styles.cardWrap} />
        )}
      </View>
    );
  };

  return (
    <View style={[styles.container, { backgroundColor: colors.bg }]}>
      <StatusBar barStyle="light-content" translucent backgroundColor="transparent" />

      {/* ── Header ─────────────────────────────────────────── */}
      <LinearGradient
        colors={isDark ? ['#0B2016', '#143825'] : ['#0D2420', '#1B4332']}
        style={[styles.header, { paddingTop: insets.top + spacing.lg }]}
      >
        <Text style={styles.headerTitle}>حصن المسلم</Text>
        <Text style={[styles.headerSub, { color: 'rgba(200,169,110,0.75)' }]}>
          أذكار من الكتاب والسنة
        </Text>
        <OrnamentDivider />
        <Text style={[styles.headerHadith, { color: 'rgba(255,255,255,0.65)' }]}>
          ❝ أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ ❞
        </Text>
        <Text style={[styles.headerHadithSource, { color: 'rgba(200,169,110,0.55)' }]}>
          سورة الرعد: ٢٨
        </Text>
      </LinearGradient>

      {/* ── Category grid ──────────────────────────────────── */}
      <FlatList
        data={adhkarCategories}
        keyExtractor={item => item.id}
        renderItem={renderItem}
        contentContainerStyle={[
          styles.list,
          { paddingBottom: 100 + insets.bottom },
        ]}
        showsVerticalScrollIndicator={false}
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
    fontFamily:  fonts.regular,
    fontSize:    fontSizes.caption,
    textAlign:   'center',
    letterSpacing: 1,
    marginBottom: spacing.xs,
  },
  headerHadith: {
    fontFamily:  fonts.quran,
    fontSize:    fontSizes.bodySm,
    textAlign:   'center',
    lineHeight:  26,
    marginTop:   spacing.xs,
  },
  headerHadithSource: {
    fontFamily:  fonts.regular,
    fontSize:    fontSizes.caption,
    textAlign:   'center',
    marginTop:   spacing.xxs,
  },

  // ── Ornament ────────────────────────────────────────────────
  ornamentRow: {
    flexDirection:  'row',
    alignItems:     'center',
    marginVertical: spacing.md,
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

  // ── Grid ────────────────────────────────────────────────────
  list: {
    paddingHorizontal: spacing.lg,
    paddingTop:        spacing.lg,
  },
  row: {
    flexDirection: 'row',
    gap:           spacing.md,
    marginBottom:  spacing.md,
  },
  cardWrap: {
    flex: 1,
  },
  card: {
    borderRadius:  borderRadius.xl,
    overflow:      'hidden',
    paddingTop:    spacing.xl,
    paddingBottom: spacing.xl,
    paddingHorizontal: spacing.lg,
    minHeight:     140,
    position:      'relative',
  },
  accentStripe: {
    position: 'absolute',
    top:      0,
    right:    0,
    width:    4,
    bottom:   0,
    borderTopRightRadius:    borderRadius.xl,
    borderBottomRightRadius: borderRadius.xl,
  },
  cardContent: {
    alignItems: 'flex-end',
  },
  categoryTitle: {
    fontFamily:   fonts.quranBold,
    fontSize:     fontSizes.h4,
    color:        '#FFFFFF',
    textAlign:    'right',
    marginBottom: spacing.xxs,
  },
  categorySubtitle: {
    fontFamily:   fonts.regular,
    fontSize:     fontSizes.caption,
    textAlign:    'right',
    marginBottom: spacing.md,
    opacity:      0.9,
  },
  countBadge: {
    borderWidth:       1,
    borderRadius:      borderRadius.full,
    paddingVertical:   3,
    paddingHorizontal: spacing.md,
    alignSelf:         'flex-end',
  },
  countText: {
    fontFamily: fonts.semiBold,
    fontSize:   fontSizes.caption,
  },
  decorCircle: {
    position:     'absolute',
    bottom:       -30,
    left:         -30,
    width:        90,
    height:       90,
    borderRadius: 45,
    borderWidth:  1.5,
  },
});

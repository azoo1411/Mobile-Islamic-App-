import React, { useState } from 'react';
import {
  View, Text, ScrollView, StyleSheet, StatusBar, TouchableOpacity,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useTheme } from '../context/ThemeContext';
import NextPrayerCard from '../components/NextPrayerCard';
import PrayerRow     from '../components/PrayerRow';
import { fonts, fontSizes } from '../design-system/typography';
import { spacing, borderRadius } from '../design-system/spacing';

// ─── Static prayer data (replace with live API / calculation) ─────────────────
const PRAYERS_DATA = [
  { id: 'fajr',    nameAr: 'الفجر',   icon: '🌙', time: '٤:٠٨ ص', done: true,  bellOn: true  },
  { id: 'dhuhr',   nameAr: 'الظهر',   icon: '☀️', time: '١٢:١٩ م', done: true,  bellOn: false },
  { id: 'asr',     nameAr: 'العصر',   icon: '🌤', time: '٣:٤٢ م',  done: false, bellOn: true,  isNext: true },
  { id: 'maghrib', nameAr: 'المغرب',  icon: '🌅', time: '٧:٠٣ م',  done: false, bellOn: true  },
  { id: 'isha',    nameAr: 'العشاء',  icon: '🌙', time: '٨:٢٣ م',  done: false, bellOn: false },
];

const nextPrayer  = PRAYERS_DATA.find(p => p.isNext);
const prevPrayer  = PRAYERS_DATA[PRAYERS_DATA.findIndex(p => p.isNext) - 1];
const afterPrayer = PRAYERS_DATA[PRAYERS_DATA.findIndex(p => p.isNext) + 1];

// Hijri date (static for demo)
const HIJRI_DATE  = '٢٦ ذو القعدة ١٤٤٦';
const GREGORIAN   = 'الإثنين، ٢٦ مايو ٢٠٢٥';

export default function PrayerTimesScreen() {
  const { colors, isDark } = useTheme();
  const insets = useSafeAreaInsets();
  const [prayers, setPrayers] = useState(PRAYERS_DATA);

  function toggleBell(id) {
    setPrayers(prev =>
      prev.map(p => p.id === id ? { ...p, bellOn: !p.bellOn } : p)
    );
  }

  return (
    <View style={[styles.container, { backgroundColor: colors.bg }]}>
      <StatusBar barStyle={isDark ? 'light-content' : 'dark-content'} translucent backgroundColor="transparent" />

      {/* ── Page header ───────────────────────────────── */}
      <LinearGradient
        colors={isDark
          ? [colors.surahHeaderStart, colors.surahHeaderEnd]
          : [colors.green,            colors.greenMid]}
        style={[styles.pageHeader, { paddingTop: insets.top + spacing.lg }]}
      >
        {/* Title row */}
        <View style={styles.headerRow}>
          <TouchableOpacity style={styles.headerIconBtn}>
            <Text style={{ fontSize: 20, color: 'rgba(255,255,255,0.8)' }}>🧭</Text>
          </TouchableOpacity>

          <Text style={styles.headerTitle}>أوقات الصلاة</Text>

          <TouchableOpacity style={styles.headerIconBtn}>
            <Text style={{ fontSize: 20, color: 'rgba(255,255,255,0.8)' }}>🔔</Text>
          </TouchableOpacity>
        </View>

        {/* Location + date */}
        <View style={styles.locationRow}>
          <Text style={[styles.locationText, { color: 'rgba(255,255,255,0.60)' }]}>
            📍 مسقط، سلطنة عُمان
          </Text>
          <View style={[styles.locationDot, { backgroundColor: 'rgba(255,255,255,0.30)' }]} />
          <Text style={[styles.locationText, { color: 'rgba(255,255,255,0.60)' }]}>
            {HIJRI_DATE}
          </Text>
        </View>

        <Text style={[styles.gregorianDate, { color: 'rgba(255,255,255,0.38)' }]}>
          {GREGORIAN}
        </Text>
      </LinearGradient>

      <ScrollView
        showsVerticalScrollIndicator={false}
        contentContainerStyle={[
          styles.scrollContent,
          { paddingBottom: 100 + insets.bottom },
        ]}
      >
        {/* ── Next prayer card ──────────────────────── */}
        {nextPrayer && (
          <NextPrayerCard
            prayerName={nextPrayer.nameAr}
            prayerTime={nextPrayer.time}
            timeRemaining="١:٢٥"
            progress={0.42}
            prevPrayer={prevPrayer?.nameAr ?? ''}
            nextPrayer={afterPrayer?.nameAr ?? ''}
          />
        )}

        {/* ── Section label ─────────────────────────── */}
        <View style={styles.sectionHeader}>
          <View style={[styles.sectionLine, { backgroundColor: colors.border }]} />
          <Text style={[styles.sectionLabel, { color: colors.textTertiary }]}>
            مواقيت اليوم
          </Text>
          <View style={[styles.sectionLine, { backgroundColor: colors.border }]} />
        </View>

        {/* ── Prayer rows ───────────────────────────── */}
        {prayers.map(prayer => (
          <PrayerRow
            key={prayer.id}
            prayer={prayer}
            isNext={!!prayer.isNext}
            isCompleted={!!prayer.done && !prayer.isNext}
            onToggleBell={() => toggleBell(prayer.id)}
          />
        ))}

        {/* ── Qibla direction chip ──────────────────── */}
        <View style={[styles.qiblaCard, {
          backgroundColor: colors.bgCard,
          borderColor:     colors.border,
        }]}>
          <Text style={{ fontSize: 22 }}>🧭</Text>
          <View style={styles.qiblaInfo}>
            <Text style={[styles.qiblaTitle,  { color: colors.textPrimary }]}>
              اتجاه القبلة
            </Text>
            <Text style={[styles.qiblaSub, { color: colors.textTertiary }]}>
              شمال غرب · ٢٩٢°
            </Text>
          </View>
          <TouchableOpacity style={[styles.qiblaBtn, { backgroundColor: colors.green }]}>
            <Text style={styles.qiblaBtnText}>تحقق</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </View>
  );
}

// ─── Styles ───────────────────────────────────────────────────────────────────
const styles = StyleSheet.create({
  container: { flex: 1 },

  pageHeader: {
    paddingHorizontal: spacing.xxl,
    paddingBottom:     spacing.xxl,
  },
  headerRow: {
    flexDirection:  'row',
    alignItems:     'center',
    justifyContent: 'space-between',
    marginBottom:   spacing.md,
  },
  headerTitle: {
    fontFamily:    fonts.quranBold,
    fontSize:      fontSizes.h3,
    color:         '#FFFFFF',
    letterSpacing: 0.5,
  },
  headerIconBtn: {
    padding: spacing.xs,
  },
  locationRow: {
    flexDirection:  'row',
    alignItems:     'center',
    justifyContent: 'center',
    gap:            spacing.sm,
    marginBottom:   spacing.xxs,
  },
  locationText: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.caption,
  },
  locationDot: {
    width:        3,
    height:       3,
    borderRadius: borderRadius.full,
  },
  gregorianDate: {
    fontFamily: fonts.light,
    fontSize:   fontSizes.micro,
    textAlign:  'center',
    letterSpacing: 0.3,
  },

  scrollContent: {
    paddingTop: spacing.lg,
    gap:        0,
  },

  sectionHeader: {
    flexDirection:  'row',
    alignItems:     'center',
    marginHorizontal: spacing.xxl,
    marginVertical: spacing.xl,
    gap:            spacing.md,
  },
  sectionLine: {
    flex:   1,
    height: 0.75,
  },
  sectionLabel: {
    fontFamily:    fonts.medium,
    fontSize:      fontSizes.caption,
    letterSpacing: 1,
    textTransform: 'uppercase',
  },

  qiblaCard: {
    flexDirection:     'row',
    alignItems:        'center',
    marginHorizontal:  spacing.lg,
    marginTop:         spacing.xl,
    borderRadius:      borderRadius.xl,
    borderWidth:       1,
    padding:           spacing.lg,
    gap:               spacing.md,
  },
  qiblaInfo: {
    flex: 1,
    gap:  spacing.xxs,
  },
  qiblaTitle: {
    fontFamily: fonts.semiBold,
    fontSize:   fontSizes.body,
    textAlign:  'right',
  },
  qiblaSub: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.caption,
    textAlign:  'right',
  },
  qiblaBtn: {
    borderRadius:      borderRadius.lg,
    paddingVertical:   spacing.sm,
    paddingHorizontal: spacing.lg,
  },
  qiblaBtnText: {
    fontFamily: fonts.semiBold,
    fontSize:   fontSizes.bodySm,
    color:      '#FFFFFF',
  },
});

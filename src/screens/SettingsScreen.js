import React from 'react';
import {
  View, Text, Switch, TouchableOpacity, ScrollView,
  StyleSheet, StatusBar,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useTheme } from '../context/ThemeContext';
import { THEME_MODES, FONT_SIZES } from '../context/ThemeContext';
import { useUserPrefs, ADHAN_VOICES } from '../context/UserPrefsContext';
import { fonts, fontSizes } from '../design-system/typography';
import { spacing, borderRadius } from '../design-system/spacing';
import { shadows } from '../design-system/shadows';

// ─── Reusable components ──────────────────────────────────────────────────────

function SettingSection({ title, children, colors }) {
  return (
    <View style={styles.section}>
      <Text style={[styles.sectionTitle, { color: colors.textTertiary }]}>{title}</Text>
      <View style={[styles.sectionCard, { backgroundColor: colors.bgCard, borderColor: colors.border, ...shadows.cardSm(colors.shadowColor) }]}>
        {children}
      </View>
    </View>
  );
}

function SettingRow({ icon, label, sublabel, right, onPress, showDivider = true, colors }) {
  const Inner = onPress ? TouchableOpacity : View;
  return (
    <>
      <Inner style={styles.row} onPress={onPress} activeOpacity={0.7}>
        <View style={[styles.rowIcon, { backgroundColor: colors.bgMuted }]}>
          <Text style={{ fontSize: 16 }}>{icon}</Text>
        </View>
        <View style={styles.rowLabel}>
          <Text style={[styles.rowLabelText, { color: colors.textPrimary }]}>{label}</Text>
          {sublabel && (
            <Text style={[styles.rowSublabel, { color: colors.textTertiary }]}>{sublabel}</Text>
          )}
        </View>
        <View style={styles.rowRight}>{right}</View>
      </Inner>
      {showDivider && <View style={[styles.rowDivider, { backgroundColor: colors.divider }]} />}
    </>
  );
}

function ToggleRow({ icon, label, sublabel, value, onChange, colors, showDivider }) {
  return (
    <SettingRow
      icon={icon}
      label={label}
      sublabel={sublabel}
      colors={colors}
      showDivider={showDivider}
      right={
        <Switch
          value={value}
          onValueChange={onChange}
          trackColor={{ false: colors.border, true: colors.gold + 'AA' }}
          thumbColor={value ? colors.gold : colors.bgElevated}
          ios_backgroundColor={colors.border}
        />
      }
    />
  );
}

// Theme selector
function ThemeSelector({ current, onChange, colors }) {
  const options = [
    { key: THEME_MODES.LIGHT, icon: '☀️', label: 'فاتح'   },
    { key: THEME_MODES.DARK,  icon: '🌙', label: 'داكن'   },
    { key: THEME_MODES.AUTO,  icon: '⚙',  label: 'تلقائي' },
  ];
  return (
    <View style={styles.themeRow}>
      {options.map(o => {
        const active = current === o.key;
        return (
          <TouchableOpacity
            key={o.key}
            style={[
              styles.themeChip,
              { backgroundColor: active ? colors.gold : colors.bgMuted, borderColor: active ? colors.gold : colors.border, flex: 1 },
            ]}
            onPress={() => onChange(o.key)}
          >
            <Text style={{ fontSize: 16 }}>{o.icon}</Text>
            <Text style={[styles.themeLabel, { color: active ? '#FFFFFF' : colors.textSecondary }]}>
              {o.label}
            </Text>
          </TouchableOpacity>
        );
      })}
    </View>
  );
}

// Font size selector
function FontSizeSelector({ current, onChange, colors }) {
  const options = [
    { key: FONT_SIZES.SM, label: 'صغير',  arabicSample: 'أ' },
    { key: FONT_SIZES.MD, label: 'متوسط', arabicSample: 'أ' },
    { key: FONT_SIZES.LG, label: 'كبير',  arabicSample: 'أ' },
  ];
  return (
    <View style={styles.fontRow}>
      {options.map(o => {
        const active = current === o.key;
        return (
          <TouchableOpacity
            key={o.key}
            style={[
              styles.fontChip,
              { backgroundColor: active ? colors.goldMuted : colors.bgMuted, borderColor: active ? colors.gold : colors.border, flex: 1 },
            ]}
            onPress={() => onChange(o.key)}
          >
            <Text style={[styles.fontSample, { color: active ? colors.goldDark : colors.textSecondary, fontSize: o.key * 0.75 }]}>
              {o.arabicSample}
            </Text>
            <Text style={[styles.fontLabel, { color: active ? colors.goldDark : colors.textTertiary }]}>
              {o.label}
            </Text>
          </TouchableOpacity>
        );
      })}
    </View>
  );
}

// ── أوقات الصلاة — تفعيل الأذان ──────────────────────────────────────────────
const PRAYERS = [
  { key: 'fajr',    label: 'الفجر',   icon: '🌙' },
  { key: 'dhuhr',   label: 'الظهر',   icon: '☀️' },
  { key: 'asr',     label: 'العصر',   icon: '🌤' },
  { key: 'maghrib', label: 'المغرب',  icon: '🌇' },
  { key: 'isha',    label: 'العشاء',  icon: '🌃' },
];

function PrayerAlertsSection({ colors }) {
  const { prayerAlerts, togglePrayerAlert } = useUserPrefs();

  return (
    <SettingSection title="إشعارات الأذان" colors={colors}>
      {PRAYERS.map((p, i) => (
        <ToggleRow
          key={p.key}
          icon={p.icon}
          label={p.label}
          sublabel={prayerAlerts[p.key] ? 'مفعّل' : 'معطّل'}
          value={prayerAlerts[p.key]}
          onChange={() => togglePrayerAlert(p.key)}
          colors={colors}
          showDivider={i < PRAYERS.length - 1}
        />
      ))}
    </SettingSection>
  );
}

// ── صوت المؤذن ────────────────────────────────────────────────────────────────
function AdhanVoiceSection({ colors }) {
  const { adhanVoice, setAdhanVoice } = useUserPrefs();
  const current = ADHAN_VOICES.find(v => v.id === adhanVoice) || ADHAN_VOICES[0];

  return (
    <SettingSection title="صوت الأذان" colors={colors}>
      {ADHAN_VOICES.map((voice, i) => {
        const active = adhanVoice === voice.id;
        return (
          <React.Fragment key={voice.id}>
            <TouchableOpacity
              style={styles.row}
              onPress={() => setAdhanVoice(voice.id)}
              activeOpacity={0.7}
            >
              <View style={[styles.rowIcon, { backgroundColor: active ? colors.goldMuted : colors.bgMuted }]}>
                <Text style={{ fontSize: 16 }}>🎙</Text>
              </View>
              <View style={styles.rowLabel}>
                <Text style={[styles.rowLabelText, { color: active ? colors.gold : colors.textPrimary }]}>
                  {voice.nameAr}
                </Text>
              </View>
              {active && (
                <Text style={{ color: colors.gold, fontSize: 18, marginLeft: spacing.sm }}>✓</Text>
              )}
            </TouchableOpacity>
            {i < ADHAN_VOICES.length - 1 && (
              <View style={[styles.rowDivider, { backgroundColor: colors.divider }]} />
            )}
          </React.Fragment>
        );
      })}
    </SettingSection>
  );
}

// ── Main screen ───────────────────────────────────────────────────────────────
export default function SettingsScreen() {
  const {
    colors, isDark, themeMode, arabicFontSize,
    showTranslation, showTranslit,
    setThemeMode, setArabicFontSize,
    toggleTranslation, toggleTranslit,
  } = useTheme();

  const { setTheme, setArabicFontSize: syncFontSize,
          setShowTranslation, setShowTranslit } = useUserPrefs();
  const insets = useSafeAreaInsets();

  // Wrapper setters that update both ThemeContext (local) + Firestore (cloud)
  function handleThemeChange(mode) {
    setThemeMode(mode);
    setTheme(mode);
  }
  function handleFontSizeChange(size) {
    setArabicFontSize(size);
    syncFontSize(size);
  }
  function handleTranslationToggle(val) {
    toggleTranslation(val);
    setShowTranslation(val);
  }
  function handleTranslitToggle(val) {
    toggleTranslit(val);
    setShowTranslit(val);
  }

  return (
    <View style={[styles.container, { backgroundColor: colors.bg }]}>
      <StatusBar barStyle={isDark ? 'light-content' : 'dark-content'} translucent backgroundColor="transparent" />

      {/* Header */}
      <LinearGradient
        colors={[colors.surahHeaderStart, colors.surahHeaderEnd]}
        style={[styles.header, { paddingTop: insets.top + spacing.xl }]}
      >
        <Text style={styles.headerTitle}>الإعدادات</Text>
        <Text style={[styles.headerSub, { color: colors.gold + 'BB' }]}>
          تخصيص تجربة التطبيق
        </Text>
      </LinearGradient>

      <ScrollView
        showsVerticalScrollIndicator={false}
        contentContainerStyle={{ paddingBottom: 100 + insets.bottom, paddingTop: spacing.xxl }}
      >
        {/* ── المظهر ──────────────────────────────────────── */}
        <SettingSection title="المظهر" colors={colors}>
          <View style={styles.innerPad}>
            <Text style={[styles.subLabel, { color: colors.textSecondary }]}>وضع الألوان</Text>
            <ThemeSelector current={themeMode} onChange={handleThemeChange} colors={colors} />
          </View>
        </SettingSection>

        {/* ── القراءة ─────────────────────────────────────── */}
        <SettingSection title="القراءة" colors={colors}>
          <View style={styles.innerPad}>
            <Text style={[styles.subLabel, { color: colors.textSecondary }]}>حجم الخط القرآني</Text>
            <FontSizeSelector current={arabicFontSize} onChange={handleFontSizeChange} colors={colors} />

            <View style={[styles.previewBox, { backgroundColor: colors.bgMuted, borderColor: colors.border }]}>
              <Text style={[styles.previewText, { color: colors.arabicPrimary, fontSize: arabicFontSize, lineHeight: arabicFontSize * 1.85 }]}>
                بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ
              </Text>
            </View>
          </View>

          <View style={[styles.rowDivider, { backgroundColor: colors.divider }]} />

          <ToggleRow
            icon="🌐"
            label="الترجمة"
            sublabel="إظهار ترجمة الآيات"
            value={showTranslation}
            onChange={handleTranslationToggle}
            colors={colors}
            showDivider
          />
          <ToggleRow
            icon="🔤"
            label="النقحرة"
            sublabel="كتابة النص العربي بالحروف اللاتينية"
            value={showTranslit}
            onChange={handleTranslitToggle}
            colors={colors}
            showDivider={false}
          />
        </SettingSection>

        {/* ── إشعارات الأذان ──────────────────────────────── */}
        <PrayerAlertsSection colors={colors} />

        {/* ── صوت الأذان ──────────────────────────────────── */}
        <AdhanVoiceSection colors={colors} />

        {/* ── عن التطبيق ──────────────────────────────────── */}
        <SettingSection title="عن التطبيق" colors={colors}>
          <SettingRow
            icon="📖"
            label="المصحف الرقمي"
            sublabel="الإصدار 1.0.0 — مزامنة السحابة مفعّلة"
            colors={colors}
            showDivider={false}
            right={null}
          />
        </SettingSection>

      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  header: {
    paddingHorizontal: spacing.xxl,
    paddingBottom:     spacing.xxl,
    alignItems:        'center',
  },
  headerTitle: {
    fontFamily:   fonts.quranBold,
    fontSize:     fontSizes.h2,
    color:        '#FFFFFF',
    letterSpacing: 1,
    marginBottom: spacing.xxs,
  },
  headerSub: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.bodySm,
  },
  section: {
    marginHorizontal: spacing.lg,
    marginBottom:     spacing.xl,
  },
  sectionTitle: {
    fontFamily:    fonts.medium,
    fontSize:      fontSizes.caption,
    letterSpacing: 1,
    textTransform: 'uppercase',
    textAlign:     'right',
    marginBottom:  spacing.sm,
    marginRight:   spacing.sm,
  },
  sectionCard: {
    borderRadius: borderRadius.xl,
    borderWidth:  1,
    overflow:     'hidden',
  },
  innerPad: {
    padding: spacing.lg,
    gap:     spacing.md,
  },
  subLabel: {
    fontFamily: fonts.medium,
    fontSize:   fontSizes.bodySm,
    textAlign:  'right',
  },
  themeRow: {
    flexDirection: 'row',
    gap:           spacing.sm,
  },
  themeChip: {
    borderWidth:     1,
    borderRadius:    borderRadius.lg,
    paddingVertical: spacing.md,
    alignItems:      'center',
    gap:             spacing.xxs,
  },
  themeLabel: {
    fontFamily: fonts.semiBold,
    fontSize:   fontSizes.caption,
  },
  fontRow: {
    flexDirection: 'row',
    gap:           spacing.sm,
  },
  fontChip: {
    borderWidth:     1,
    borderRadius:    borderRadius.lg,
    paddingVertical: spacing.lg,
    alignItems:      'center',
    gap:             spacing.xs,
  },
  fontSample: {
    fontFamily: fonts.quranBold,
    lineHeight: 40,
  },
  fontLabel: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.caption,
  },
  previewBox: {
    borderWidth:  1,
    borderRadius: borderRadius.lg,
    padding:      spacing.lg,
    alignItems:   'center',
  },
  previewText: {
    fontFamily:       fonts.quranBold,
    textAlign:        'center',
    writingDirection: 'rtl',
  },
  row: {
    flexDirection:     'row-reverse',
    alignItems:        'center',
    paddingHorizontal: spacing.lg,
    paddingVertical:   spacing.md,
    gap:               spacing.md,
  },
  rowIcon: {
    width:          38,
    height:         38,
    borderRadius:   borderRadius.md,
    alignItems:     'center',
    justifyContent: 'center',
  },
  rowLabel: {
    flex: 1,
    gap:  2,
  },
  rowLabelText: {
    fontFamily: fonts.medium,
    fontSize:   fontSizes.body,
    textAlign:  'right',
  },
  rowSublabel: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.caption,
    textAlign:  'right',
  },
  rowRight: {
    alignItems:     'center',
    justifyContent: 'center',
  },
  rowDivider: {
    height:           0.75,
    marginHorizontal: spacing.lg,
    borderRadius:     1,
  },
});

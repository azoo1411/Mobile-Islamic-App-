import React, { useState } from 'react';
import {
  View, Text, Switch, TouchableOpacity, ScrollView,
  StyleSheet, StatusBar, Modal, Alert,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useTheme } from '../context/ThemeContext';
import { THEME_MODES, FONT_SIZES } from '../context/ThemeContext';
import { useAuth } from '../context/AuthContext';
import AuthScreen from './AuthScreen';
import { fonts, fontSizes } from '../design-system/typography';
import { spacing, borderRadius } from '../design-system/spacing';
import { shadows } from '../design-system/shadows';

// ─── Reusable setting components ─────────────────────────────────────────────

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
      <Inner
        style={styles.row}
        onPress={onPress}
        activeOpacity={0.7}
      >
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

// Theme selector pills
function ThemeSelector({ current, onChange, colors }) {
  const options = [
    { key: THEME_MODES.LIGHT, icon: '☀️', label: 'فاتح'  },
    { key: THEME_MODES.DARK,  icon: '🌙', label: 'داكن'  },
    { key: THEME_MODES.AUTO,  icon: '⚙',  label: 'تلقائي'},
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
              {
                backgroundColor: active ? colors.gold      : colors.bgMuted,
                borderColor:     active ? colors.gold       : colors.border,
                flex: 1,
              },
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
    { key: FONT_SIZES.SM, label: 'صغير', arabicSample: 'أ' },
    { key: FONT_SIZES.MD, label: 'متوسط', arabicSample: 'أ' },
    { key: FONT_SIZES.LG, label: 'كبير', arabicSample: 'أ' },
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
              {
                backgroundColor: active ? colors.goldMuted : colors.bgMuted,
                borderColor:     active ? colors.gold       : colors.border,
                flex: 1,
              },
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

// ─── Account section ─────────────────────────────────────────────────────────
function AccountSection({ colors }) {
  const { user, profile, isAnonymous, isLoggedIn, logout } = useAuth();
  const [showAuth, setShowAuth] = useState(false);

  async function handleLogout() {
    Alert.alert(
      'تسجيل الخروج',
      'هل تريد تسجيل الخروج من حسابك؟',
      [
        { text: 'إلغاء', style: 'cancel' },
        { text: 'خروج', style: 'destructive', onPress: logout },
      ]
    );
  }

  if (!isLoggedIn || isAnonymous) {
    return (
      <>
        <Modal visible={showAuth} animationType="slide" onRequestClose={() => setShowAuth(false)}>
          <AuthScreen onClose={() => setShowAuth(false)} />
        </Modal>

        <SettingSection title="الحساب" colors={colors}>
          <View style={styles.accountAnon}>
            <View style={[styles.accountAvatar, { backgroundColor: colors.goldMuted }]}>
              <Text style={[styles.accountAvatarText, { color: colors.gold }]}>👤</Text>
            </View>
            <Text style={[styles.accountAnonTitle, { color: colors.textPrimary }]}>
              تصفح بدون حساب
            </Text>
            <Text style={[styles.accountAnonSub, { color: colors.textTertiary }]}>
              سجّل دخولك لمزامنة المفضلة وتقدم القراءة
            </Text>
            <TouchableOpacity
              style={[styles.loginBtn, { backgroundColor: colors.green }]}
              onPress={() => setShowAuth(true)}
              activeOpacity={0.85}
            >
              <Text style={styles.loginBtnText}>تسجيل الدخول / إنشاء حساب</Text>
            </TouchableOpacity>
          </View>
        </SettingSection>
      </>
    );
  }

  const displayName = profile?.displayName || user?.displayName || user?.email;
  const initial     = displayName?.[0]?.toUpperCase() || '؟';

  return (
    <SettingSection title="الحساب" colors={colors}>
      <View style={styles.accountActive}>
        <View style={[styles.accountAvatarLg, { backgroundColor: colors.green }]}>
          <Text style={styles.accountInitial}>{initial}</Text>
        </View>
        <View style={styles.accountInfo}>
          <Text style={[styles.accountName, { color: colors.textPrimary }]}>{displayName}</Text>
          <Text style={[styles.accountEmail, { color: colors.textTertiary }]}>{user?.email}</Text>
          <View style={[styles.syncBadge, { backgroundColor: colors.greenMuted }]}>
            <Text style={[styles.syncText, { color: colors.greenLight }]}>● متزامن مع Firebase</Text>
          </View>
        </View>
      </View>
      <View style={[styles.rowDivider, { backgroundColor: colors.divider }]} />
      <SettingRow
        icon="🚪"
        label="تسجيل الخروج"
        sublabel={user?.email}
        colors={colors}
        showDivider={false}
        onPress={handleLogout}
        right={<Text style={{ fontSize: 16, color: colors.error }}>›</Text>}
      />
    </SettingSection>
  );
}

// ─── Main screen ─────────────────────────────────────────────────────────────
export default function SettingsScreen() {
  const {
    colors, isDark, themeMode, arabicFontSize,
    showTranslation, showTranslit,
    setThemeMode, setArabicFontSize,
    toggleTranslation, toggleTranslit,
  } = useTheme();
  const insets = useSafeAreaInsets();

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
          تخصيص تجربة القراءة
        </Text>
      </LinearGradient>

      <ScrollView
        showsVerticalScrollIndicator={false}
        contentContainerStyle={{ paddingBottom: 100 + insets.bottom, paddingTop: spacing.xxl }}
      >

        {/* ── Account ─────────────────────────────────────── */}
        <AccountSection colors={colors} />

        {/* ── Appearance ──────────────────────────────────── */}
        <SettingSection title="المظهر" colors={colors}>
          <View style={styles.innerPad}>
            <Text style={[styles.subLabel, { color: colors.textSecondary }]}>وضع الألوان</Text>
            <ThemeSelector current={themeMode} onChange={setThemeMode} colors={colors} />
          </View>
        </SettingSection>

        {/* ── Reading ─────────────────────────────────────── */}
        <SettingSection title="القراءة" colors={colors}>
          <View style={styles.innerPad}>
            <Text style={[styles.subLabel, { color: colors.textSecondary }]}>حجم الخط القرآني</Text>
            <FontSizeSelector current={arabicFontSize} onChange={setArabicFontSize} colors={colors} />

            {/* Live preview */}
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
            onChange={toggleTranslation}
            colors={colors}
            showDivider
          />
          <ToggleRow
            icon="🔤"
            label="النقحرة"
            sublabel="كتابة النص العربي بالحروف اللاتينية"
            value={showTranslit}
            onChange={toggleTranslit}
            colors={colors}
            showDivider={false}
          />
        </SettingSection>

        {/* ── Audio ───────────────────────────────────────── */}
        <SettingSection title="الصوت" colors={colors}>
          <SettingRow
            icon="🎙"
            label="القارئ الافتراضي"
            sublabel="مشاري راشد العفاسي"
            colors={colors}
            onPress={() => {}}
            right={<Text style={{ fontSize: 16, color: colors.textTertiary }}>›</Text>}
          />
          <SettingRow
            icon="🌍"
            label="لغة الترجمة"
            sublabel="English"
            colors={colors}
            onPress={() => {}}
            showDivider={false}
            right={<Text style={{ fontSize: 16, color: colors.textTertiary }}>›</Text>}
          />
        </SettingSection>

        {/* ── About ───────────────────────────────────────── */}
        <SettingSection title="عن التطبيق" colors={colors}>
          <SettingRow
            icon="📖"
            label="المصحف الرقمي"
            sublabel="الإصدار 1.0.0"
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
    borderWidth:      1,
    borderRadius:     borderRadius.lg,
    paddingVertical:  spacing.md,
    alignItems:       'center',
    gap:              spacing.xxs,
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
    borderWidth:   1,
    borderRadius:  borderRadius.lg,
    paddingVertical: spacing.lg,
    alignItems:    'center',
    gap:           spacing.xs,
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
    borderWidth:   1,
    borderRadius:  borderRadius.lg,
    padding:       spacing.lg,
    alignItems:    'center',
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
    alignItems: 'center',
    justifyContent: 'center',
  },
  rowDivider: {
    height:           0.75,
    marginHorizontal: spacing.lg,
    borderRadius:     1,
  },

  // ── Account styles ───────────────────────────────────────────────────────────
  accountAnon: {
    padding:     spacing.xl,
    alignItems:  'center',
    gap:         spacing.md,
  },
  accountAvatar: {
    width:          56,
    height:         56,
    borderRadius:   28,
    alignItems:     'center',
    justifyContent: 'center',
  },
  accountAvatarText: {
    fontSize: 24,
  },
  accountAnonTitle: {
    fontFamily: fonts.semiBold,
    fontSize:   fontSizes.body,
    textAlign:  'center',
  },
  accountAnonSub: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.caption,
    textAlign:  'center',
    lineHeight: 18,
  },
  loginBtn: {
    borderRadius:      borderRadius.full,
    paddingVertical:   spacing.md,
    paddingHorizontal: spacing.xxl,
    marginTop:         spacing.xs,
  },
  loginBtnText: {
    fontFamily: fonts.bold,
    fontSize:   fontSizes.bodySm,
    color:      '#FFFFFF',
  },
  accountActive: {
    flexDirection:  'row-reverse',
    alignItems:     'center',
    padding:        spacing.lg,
    gap:            spacing.md,
  },
  accountAvatarLg: {
    width:          50,
    height:         50,
    borderRadius:   25,
    alignItems:     'center',
    justifyContent: 'center',
  },
  accountInitial: {
    fontFamily: fonts.bold,
    fontSize:   fontSizes.h3,
    color:      '#FFFFFF',
  },
  accountInfo: {
    flex:       1,
    alignItems: 'flex-end',
    gap:        2,
  },
  accountName: {
    fontFamily: fonts.semiBold,
    fontSize:   fontSizes.body,
    textAlign:  'right',
  },
  accountEmail: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.caption,
    textAlign:  'right',
  },
  syncBadge: {
    borderRadius:      borderRadius.full,
    paddingVertical:   3,
    paddingHorizontal: spacing.md,
    marginTop:         spacing.xxs,
  },
  syncText: {
    fontFamily: fonts.semiBold,
    fontSize:   fontSizes.caption,
  },
});

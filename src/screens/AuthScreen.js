import React, { useState } from 'react';
import {
  View, Text, TextInput, TouchableOpacity,
  StyleSheet, StatusBar, ActivityIndicator,
  KeyboardAvoidingView, Platform, ScrollView,
  Alert,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useTheme } from '../context/ThemeContext';
import { useAuth }  from '../context/AuthContext';
import { fonts, fontSizes } from '../design-system/typography';
import { spacing, borderRadius } from '../design-system/spacing';

const TABS = { LOGIN: 'login', REGISTER: 'register' };

function InputField({ label, placeholder, value, onChangeText, secureTextEntry, keyboardType, colors }) {
  return (
    <View style={styles.inputWrap}>
      <Text style={[styles.inputLabel, { color: colors.textSecondary }]}>{label}</Text>
      <TextInput
        style={[styles.input, { backgroundColor: colors.bgMuted, borderColor: colors.border, color: colors.textPrimary }]}
        placeholder={placeholder}
        placeholderTextColor={colors.textTertiary}
        value={value}
        onChangeText={onChangeText}
        secureTextEntry={secureTextEntry}
        keyboardType={keyboardType}
        textAlign="right"
        autoCapitalize="none"
      />
    </View>
  );
}

export default function AuthScreen({ onClose }) {
  const { colors } = useTheme();
  const { loginWithEmail, registerWithEmail, loginAnonymously } = useAuth();
  const insets = useSafeAreaInsets();

  const [tab,      setTab]      = useState(TABS.LOGIN);
  const [email,    setEmail]    = useState('');
  const [password, setPassword] = useState('');
  const [name,     setName]     = useState('');
  const [loading,  setLoading]  = useState(false);

  async function handleSubmit() {
    if (!email.trim() || !password.trim()) {
      Alert.alert('', 'يرجى إدخال البريد الإلكتروني وكلمة المرور');
      return;
    }
    if (tab === TABS.REGISTER && !name.trim()) {
      Alert.alert('', 'يرجى إدخال اسمك');
      return;
    }
    setLoading(true);
    try {
      if (tab === TABS.LOGIN) {
        await loginWithEmail(email.trim(), password);
      } else {
        await registerWithEmail(email.trim(), password, name.trim());
      }
      onClose?.();
    } catch (err) {
      const msg = firebaseErrorMessage(err.code);
      Alert.alert('خطأ', msg);
    } finally {
      setLoading(false);
    }
  }

  async function handleAnonymous() {
    setLoading(true);
    try {
      await loginAnonymously();
      onClose?.();
    } catch (err) {
      Alert.alert('خطأ', 'تعذر الدخول بدون حساب. تحقق من اتصالك.');
    } finally {
      setLoading(false);
    }
  }

  return (
    <KeyboardAvoidingView
      style={{ flex: 1 }}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    >
      <View style={[styles.container, { backgroundColor: colors.bg }]}>
        <StatusBar barStyle="light-content" translucent backgroundColor="transparent" />

        {/* Header */}
        <LinearGradient
          colors={['#0D2420', '#1B4332']}
          style={[styles.header, { paddingTop: insets.top + spacing.lg }]}
        >
          {/* Close button */}
          {onClose && (
            <TouchableOpacity onPress={onClose} style={styles.closeBtn} activeOpacity={0.7}>
              <Text style={styles.closeText}>✕</Text>
            </TouchableOpacity>
          )}

          <Text style={styles.headerTitle}>حساب المستخدم</Text>
          <Text style={[styles.headerSub, { color: 'rgba(200,169,110,0.75)' }]}>
            {tab === TABS.LOGIN ? 'تسجيل الدخول' : 'إنشاء حساب جديد'}
          </Text>

          {/* Tab pills */}
          <View style={styles.tabRow}>
            {[
              { key: TABS.LOGIN,    label: 'دخول'   },
              { key: TABS.REGISTER, label: 'حساب جديد' },
            ].map(t => (
              <TouchableOpacity
                key={t.key}
                style={[styles.tabPill, tab === t.key && styles.tabPillActive]}
                onPress={() => setTab(t.key)}
                activeOpacity={0.8}
              >
                <Text style={[styles.tabLabel, { color: tab === t.key ? '#1B4332' : 'rgba(255,255,255,0.70)' }]}>
                  {t.label}
                </Text>
              </TouchableOpacity>
            ))}
          </View>
        </LinearGradient>

        <ScrollView
          contentContainerStyle={[styles.body, { paddingBottom: insets.bottom + 40 }]}
          keyboardShouldPersistTaps="handled"
          showsVerticalScrollIndicator={false}
        >
          {/* Form */}
          {tab === TABS.REGISTER && (
            <InputField
              label="الاسم"
              placeholder="اسمك الكامل"
              value={name}
              onChangeText={setName}
              colors={colors}
            />
          )}

          <InputField
            label="البريد الإلكتروني"
            placeholder="example@email.com"
            value={email}
            onChangeText={setEmail}
            keyboardType="email-address"
            colors={colors}
          />

          <InputField
            label="كلمة المرور"
            placeholder="••••••••"
            value={password}
            onChangeText={setPassword}
            secureTextEntry
            colors={colors}
          />

          {/* Submit button */}
          <TouchableOpacity
            style={[styles.submitBtn, loading && { opacity: 0.6 }]}
            onPress={handleSubmit}
            disabled={loading}
            activeOpacity={0.85}
          >
            <LinearGradient
              colors={['#1B4332', '#2D6A4F']}
              style={styles.submitGradient}
            >
              {loading
                ? <ActivityIndicator color="#FFF" />
                : <Text style={styles.submitText}>
                    {tab === TABS.LOGIN ? 'تسجيل الدخول' : 'إنشاء الحساب'}
                  </Text>
              }
            </LinearGradient>
          </TouchableOpacity>

          {/* Divider */}
          <View style={styles.dividerRow}>
            <View style={[styles.dividerLine, { backgroundColor: colors.divider }]} />
            <Text style={[styles.dividerText, { color: colors.textTertiary }]}>أو</Text>
            <View style={[styles.dividerLine, { backgroundColor: colors.divider }]} />
          </View>

          {/* Anonymous */}
          <TouchableOpacity
            style={[styles.anonBtn, { borderColor: colors.border, backgroundColor: colors.bgCard }]}
            onPress={handleAnonymous}
            disabled={loading}
            activeOpacity={0.8}
          >
            <Text style={[styles.anonText, { color: colors.textSecondary }]}>
              متابعة بدون حساب
            </Text>
          </TouchableOpacity>

          <Text style={[styles.note, { color: colors.textTertiary }]}>
            بإنشاء حساب تتمكن من مزامنة المفضلة وتقدم القراءة عبر أجهزتك
          </Text>
        </ScrollView>
      </View>
    </KeyboardAvoidingView>
  );
}

function firebaseErrorMessage(code) {
  const map = {
    'auth/invalid-email':          'البريد الإلكتروني غير صحيح',
    'auth/user-not-found':         'لا يوجد حساب بهذا البريد',
    'auth/wrong-password':         'كلمة المرور غير صحيحة',
    'auth/email-already-in-use':   'هذا البريد مستخدم بالفعل',
    'auth/weak-password':          'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
    'auth/too-many-requests':      'محاولات كثيرة. حاول لاحقاً',
    'auth/network-request-failed': 'تحقق من اتصال الإنترنت',
  };
  return map[code] || 'حدث خطأ. حاول مرة أخرى.';
}

const styles = StyleSheet.create({
  container: { flex: 1 },

  header: {
    paddingHorizontal: spacing.xxl,
    paddingBottom:     spacing.xl,
    alignItems:        'center',
    position:          'relative',
  },
  closeBtn: {
    position: 'absolute',
    top:      spacing.lg,
    left:     spacing.xxl,
    padding:  spacing.sm,
  },
  closeText: {
    fontSize:   18,
    color:      'rgba(255,255,255,0.70)',
    lineHeight: 24,
  },
  headerTitle: {
    fontFamily:   fonts.quranBold,
    fontSize:     fontSizes.h2,
    color:        '#C8A96E',
    textAlign:    'center',
    marginBottom: spacing.xxs,
  },
  headerSub: {
    fontFamily:   fonts.regular,
    fontSize:     fontSizes.bodySm,
    marginBottom: spacing.xl,
  },
  tabRow: {
    flexDirection:   'row',
    gap:             spacing.sm,
    backgroundColor: 'rgba(255,255,255,0.08)',
    borderRadius:    borderRadius.full,
    padding:         4,
  },
  tabPill: {
    flex:              1,
    paddingVertical:   spacing.sm,
    paddingHorizontal: spacing.xl,
    borderRadius:      borderRadius.full,
    alignItems:        'center',
  },
  tabPillActive: {
    backgroundColor: '#C8A96E',
  },
  tabLabel: {
    fontFamily: fonts.semiBold,
    fontSize:   fontSizes.bodySm,
  },

  body: {
    paddingHorizontal: spacing.xxl,
    paddingTop:        spacing.xxl,
    gap:               spacing.md,
  },
  inputWrap: {
    gap: spacing.xs,
  },
  inputLabel: {
    fontFamily: fonts.medium,
    fontSize:   fontSizes.bodySm,
    textAlign:  'right',
  },
  input: {
    borderWidth:       1,
    borderRadius:      borderRadius.lg,
    paddingHorizontal: spacing.lg,
    paddingVertical:   spacing.md,
    fontFamily:        fonts.regular,
    fontSize:          fontSizes.body,
    height:            50,
  },

  submitBtn: {
    borderRadius: borderRadius.xl,
    overflow:     'hidden',
    marginTop:    spacing.md,
  },
  submitGradient: {
    paddingVertical: spacing.lg,
    alignItems:      'center',
    justifyContent:  'center',
    minHeight:       54,
  },
  submitText: {
    fontFamily: fonts.bold,
    fontSize:   fontSizes.body,
    color:      '#FFFFFF',
    letterSpacing: 0.5,
  },

  dividerRow: {
    flexDirection: 'row',
    alignItems:    'center',
    gap:           spacing.md,
    marginVertical: spacing.sm,
  },
  dividerLine: {
    flex:   1,
    height: 0.75,
  },
  dividerText: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.caption,
  },

  anonBtn: {
    borderWidth:     1,
    borderRadius:    borderRadius.xl,
    paddingVertical: spacing.lg,
    alignItems:      'center',
  },
  anonText: {
    fontFamily: fonts.medium,
    fontSize:   fontSizes.body,
  },
  note: {
    fontFamily: fonts.regular,
    fontSize:   fontSizes.caption,
    textAlign:  'center',
    lineHeight: 18,
    marginTop:  spacing.sm,
  },
});

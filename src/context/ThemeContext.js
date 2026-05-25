import React, { createContext, useContext, useState, useEffect } from 'react';
import { useColorScheme } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { lightColors, darkColors } from '../design-system/colors';
import { fontSizes } from '../design-system/typography';
import { spacing, borderRadius } from '../design-system/spacing';
import { shadows } from '../design-system/shadows';

export const THEME_MODES = { LIGHT: 'light', DARK: 'dark', AUTO: 'auto' };
export const FONT_SIZES   = { SM: fontSizes.quranSM, MD: fontSizes.quranLG, LG: fontSizes.quranXL };

const ThemeContext = createContext(null);

export function ThemeProvider({ children }) {
  const system = useColorScheme();

  const [themeMode,       setThemeModeState]    = useState(THEME_MODES.AUTO);
  const [arabicFontSize,  setArabicFontSizeState] = useState(FONT_SIZES.MD);
  const [showTranslation, setShowTranslation]   = useState(true);
  const [showTranslit,    setShowTranslit]       = useState(false);
  const [focusMode,       setFocusMode]          = useState(false);
  const [loaded,          setLoaded]             = useState(false);

  useEffect(() => { load(); }, []);

  async function load() {
    try {
      const [tm, fs, st, stl] = await Promise.all([
        AsyncStorage.getItem('themeMode'),
        AsyncStorage.getItem('arabicFontSize'),
        AsyncStorage.getItem('showTranslation'),
        AsyncStorage.getItem('showTranslit'),
      ]);
      if (tm)  setThemeModeState(tm);
      if (fs)  setArabicFontSizeState(Number(fs));
      if (st != null) setShowTranslation(st === 'true');
      if (stl != null) setShowTranslit(stl === 'true');
    } catch (_) {}
    setLoaded(true);
  }

  const isDark =
    themeMode === THEME_MODES.DARK ||
    (themeMode === THEME_MODES.AUTO && system === 'dark');

  const colors = isDark ? darkColors : lightColors;

  async function setThemeMode(mode) {
    setThemeModeState(mode);
    await AsyncStorage.setItem('themeMode', mode);
  }

  async function setArabicFontSize(size) {
    setArabicFontSizeState(size);
    await AsyncStorage.setItem('arabicFontSize', String(size));
  }

  async function toggleTranslation(val) {
    setShowTranslation(val);
    await AsyncStorage.setItem('showTranslation', String(val));
  }

  async function toggleTranslit(val) {
    setShowTranslit(val);
    await AsyncStorage.setItem('showTranslit', String(val));
  }

  const theme = {
    colors,
    isDark,
    themeMode,
    arabicFontSize,
    showTranslation,
    showTranslit,
    focusMode,
    loaded,
    spacing,
    borderRadius,
    shadows,
    setThemeMode,
    setArabicFontSize,
    toggleTranslation,
    toggleTranslit,
    setFocusMode,
  };

  return <ThemeContext.Provider value={theme}>{children}</ThemeContext.Provider>;
}

export function useTheme() {
  const ctx = useContext(ThemeContext);
  if (!ctx) throw new Error('useTheme must be used inside ThemeProvider');
  return ctx;
}

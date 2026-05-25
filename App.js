import React, { useCallback } from 'react';
import { View, StyleSheet } from 'react-native';
import { StatusBar } from 'expo-status-bar';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import {
  useFonts,
  Amiri_400Regular,
  Amiri_400Regular_Italic,
  Amiri_700Bold,
} from '@expo-google-fonts/amiri';
import {
  Nunito_300Light,
  Nunito_400Regular,
  Nunito_500Medium,
  Nunito_600SemiBold,
  Nunito_700Bold,
  Nunito_800ExtraBold,
} from '@expo-google-fonts/nunito';
import * as SplashScreen from 'expo-splash-screen';

import { ThemeProvider, useTheme } from './src/context/ThemeContext';
import FloatingTabBar      from './src/components/FloatingTabBar';
import SurahIndexScreen    from './src/screens/SurahIndexScreen';
import QuranReadingScreen  from './src/screens/QuranReadingScreen';
import SearchScreen        from './src/screens/SearchScreen';
import RecitationScreen    from './src/screens/RecitationScreen';
import SettingsScreen      from './src/screens/SettingsScreen';

SplashScreen.preventAutoHideAsync();

const Stack = createNativeStackNavigator();
const Tab   = createBottomTabNavigator();

// ── Quran stack (Index → Reading) ────────────────────────────────────────────
function QuranStack() {
  return (
    <Stack.Navigator screenOptions={{ headerShown: false, animation: 'fade_from_bottom' }}>
      <Stack.Screen name="SurahIndex"    component={SurahIndexScreen}   />
      <Stack.Screen name="QuranReading"  component={QuranReadingScreen}  />
    </Stack.Navigator>
  );
}

// ── Bottom tab navigator with custom floating bar ─────────────────────────────
function MainTabs() {
  const { colors, isDark } = useTheme();

  return (
    <Tab.Navigator
      tabBar={props => <FloatingTabBar {...props} />}
      screenOptions={{ headerShown: false }}
    >
      <Tab.Screen name="Quran"      component={QuranStack}      />
      <Tab.Screen name="Search"     component={SearchScreen}    />
      <Tab.Screen name="Recitation" component={RecitationScreen} />
      <Tab.Screen name="Settings"   component={SettingsScreen}  />
    </Tab.Navigator>
  );
}

// ── Root ──────────────────────────────────────────────────────────────────────
function RootNavigator() {
  const { colors, isDark } = useTheme();

  return (
    <NavigationContainer
      theme={{
        dark:   isDark,
        colors: {
          primary:    colors.gold,
          background: colors.bg,
          card:       colors.bgCard,
          text:       colors.textPrimary,
          border:     colors.border,
          notification: colors.gold,
        },
      }}
    >
      <StatusBar style={isDark ? 'light' : 'dark'} translucent />
      <MainTabs />
    </NavigationContainer>
  );
}

// ── App entry — waits for fonts ───────────────────────────────────────────────
export default function App() {
  const [fontsLoaded, fontError] = useFonts({
    Amiri_400Regular,
    Amiri_400Regular_Italic,
    Amiri_700Bold,
    Nunito_300Light,
    Nunito_400Regular,
    Nunito_500Medium,
    Nunito_600SemiBold,
    Nunito_700Bold,
    Nunito_800ExtraBold,
  });

  const onLayoutRootView = useCallback(async () => {
    if (fontsLoaded || fontError) {
      await SplashScreen.hideAsync();
    }
  }, [fontsLoaded, fontError]);

  if (!fontsLoaded && !fontError) return null;

  return (
    <GestureHandlerRootView style={styles.root}>
      <SafeAreaProvider>
        <ThemeProvider>
          <View style={styles.root} onLayout={onLayoutRootView}>
            <RootNavigator />
          </View>
        </ThemeProvider>
      </SafeAreaProvider>
    </GestureHandlerRootView>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1 },
});

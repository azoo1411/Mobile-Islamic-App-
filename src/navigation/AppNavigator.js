import React from 'react';
import { Text, View, StyleSheet } from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { createNativeStackNavigator } from '@react-navigation/native-stack';

import HomeScreen from '../screens/HomeScreen';
import HajjGuideStartScreen from '../screens/HajjGuide/HajjGuideStartScreen';
import HajjGuideRitualScreen from '../screens/HajjGuide/HajjGuideRitualScreen';
import { Colors } from '../theme';

const Tab = createBottomTabNavigator();
const HajjStack = createNativeStackNavigator();

const TAB_ICONS = {
  Home: '🏠',
  'Hajj Guide': '🕋',
  Quran: '📖',
  Prayer: '🕌',
};

function TabIcon({ name, focused }) {
  return (
    <View style={styles.tabIconContainer}>
      <Text style={[styles.tabEmoji, focused && styles.tabEmojiFocused]}>
        {TAB_ICONS[name] || '☪️'}
      </Text>
    </View>
  );
}

function HajjGuideStack() {
  return (
    <HajjStack.Navigator screenOptions={{ headerShown: false, animation: 'slide_from_right' }}>
      <HajjStack.Screen name="HajjStart" component={HajjGuideStartScreen} />
      <HajjStack.Screen name="HajjRitual" component={HajjGuideRitualScreen} />
    </HajjStack.Navigator>
  );
}

export default function AppNavigator() {
  return (
    <NavigationContainer>
      <Tab.Navigator
        screenOptions={({ route }) => ({
          headerShown: false,
          tabBarIcon: ({ focused }) => <TabIcon name={route.name} focused={focused} />,
          tabBarStyle: styles.tabBar,
          tabBarActiveTintColor: Colors.primary,
          tabBarInactiveTintColor: Colors.textMuted,
          tabBarLabelStyle: styles.tabLabel,
        })}
      >
        <Tab.Screen name="Home" component={HomeScreen} />
        <Tab.Screen name="Hajj Guide" component={HajjGuideStack} />
      </Tab.Navigator>
    </NavigationContainer>
  );
}

const styles = StyleSheet.create({
  tabBar: {
    backgroundColor: Colors.surface,
    borderTopColor: Colors.border,
    borderTopWidth: 1,
    height: 72,
    paddingBottom: 12,
    paddingTop: 8,
  },
  tabLabel: {
    fontSize: 11,
    fontWeight: '600',
    marginTop: 2,
  },
  tabIconContainer: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  tabEmoji: {
    fontSize: 22,
    opacity: 0.6,
  },
  tabEmojiFocused: {
    opacity: 1,
    transform: [{ scale: 1.1 }],
  },
});

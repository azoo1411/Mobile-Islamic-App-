import React, { useState } from 'react';
import { View, Text, TouchableOpacity, StyleSheet, Animated } from 'react-native';
import { Colors, Spacing, BorderRadius } from '../theme';

export default function ChecklistItem({ text, index, initialChecked = false }) {
  const [checked, setChecked] = useState(initialChecked);

  return (
    <TouchableOpacity
      style={[styles.container, checked && styles.containerChecked]}
      onPress={() => setChecked(prev => !prev)}
      activeOpacity={0.7}
    >
      <View style={[styles.checkbox, checked && styles.checkboxChecked]}>
        {checked ? (
          <Text style={styles.checkmark}>✓</Text>
        ) : (
          <Text style={styles.stepNumber}>{index + 1}</Text>
        )}
      </View>
      <Text style={[styles.text, checked && styles.textChecked]} numberOfLines={4}>
        {text}
      </Text>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    backgroundColor: Colors.surface,
    borderRadius: BorderRadius.md,
    padding: Spacing.md,
    marginBottom: Spacing.sm,
    borderWidth: 1,
    borderColor: Colors.border,
    gap: Spacing.md,
  },
  containerChecked: {
    backgroundColor: Colors.primaryFade,
    borderColor: Colors.primary + '40',
  },
  checkbox: {
    width: 28,
    height: 28,
    borderRadius: BorderRadius.full,
    borderWidth: 2,
    borderColor: Colors.stepPending,
    alignItems: 'center',
    justifyContent: 'center',
    flexShrink: 0,
    backgroundColor: Colors.surface,
  },
  checkboxChecked: {
    backgroundColor: Colors.primary,
    borderColor: Colors.primary,
  },
  checkmark: {
    color: Colors.textOnDark,
    fontSize: 14,
    fontWeight: '700',
  },
  stepNumber: {
    color: Colors.textMuted,
    fontSize: 11,
    fontWeight: '700',
  },
  text: {
    flex: 1,
    fontSize: 14,
    lineHeight: 22,
    color: Colors.text,
    fontWeight: '400',
  },
  textChecked: {
    color: Colors.textMuted,
    textDecorationLine: 'line-through',
  },
});

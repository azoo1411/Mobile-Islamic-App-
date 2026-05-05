import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { Colors, Spacing, BorderRadius } from '../theme';

export default function ProgressIndicator({ current, total }) {
  const percentage = (current / total) * 100;

  return (
    <View style={styles.container}>
      <View style={styles.labelRow}>
        <Text style={styles.stepLabel}>Step {current} of {total}</Text>
        <Text style={styles.percentLabel}>{Math.round(percentage)}%</Text>
      </View>

      {/* Segmented dot track */}
      <View style={styles.segmentRow}>
        {Array.from({ length: total }, (_, i) => (
          <View
            key={i}
            style={[
              styles.segment,
              i < current ? styles.segmentDone : styles.segmentPending,
              i === current - 1 && styles.segmentCurrent,
            ]}
          />
        ))}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    paddingHorizontal: Spacing.md,
    paddingVertical: Spacing.sm,
  },
  labelRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: Spacing.xs,
  },
  stepLabel: {
    fontSize: 12,
    fontWeight: '600',
    color: Colors.primary,
    letterSpacing: 0.5,
  },
  percentLabel: {
    fontSize: 12,
    fontWeight: '500',
    color: Colors.textMuted,
  },
  segmentRow: {
    flexDirection: 'row',
    gap: 4,
    height: 6,
  },
  segment: {
    flex: 1,
    borderRadius: BorderRadius.full,
  },
  segmentDone: {
    backgroundColor: Colors.primary,
  },
  segmentCurrent: {
    backgroundColor: Colors.secondary,
  },
  segmentPending: {
    backgroundColor: Colors.stepPending,
  },
});

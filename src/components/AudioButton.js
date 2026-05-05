import React, { useState } from 'react';
import { TouchableOpacity, Text, StyleSheet, View, ActivityIndicator } from 'react-native';
import { Colors, Spacing, BorderRadius, Shadow } from '../theme';

/**
 * Audio playback button for dua recitation.
 * Wire `onPlay` and `onPause` to expo-av for real audio.
 */
export default function AudioButton({ label = 'Listen to Dua', onPlay, onPause }) {
  const [playing, setPlaying] = useState(false);
  const [loading, setLoading] = useState(false);

  const handlePress = async () => {
    if (loading) return;

    if (playing) {
      setPlaying(false);
      onPause && onPause();
    } else {
      setLoading(true);
      // Simulate load time; replace with real audio logic via expo-av
      await new Promise(r => setTimeout(r, 600));
      setLoading(false);
      setPlaying(true);
      onPlay && onPlay();
    }
  };

  return (
    <TouchableOpacity
      style={styles.button}
      onPress={handlePress}
      activeOpacity={0.8}
    >
      <View style={styles.iconCircle}>
        {loading ? (
          <ActivityIndicator size="small" color={Colors.textOnDark} />
        ) : (
          <Text style={styles.icon}>{playing ? '⏸' : '▶'}</Text>
        )}
      </View>
      <View>
        <Text style={styles.label}>{playing ? 'Pause' : label}</Text>
        <Text style={styles.sublabel}>Audio Recitation</Text>
      </View>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  button: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: Spacing.md,
    backgroundColor: Colors.primary,
    borderRadius: BorderRadius.xl,
    paddingVertical: Spacing.md,
    paddingHorizontal: Spacing.lg,
    ...Shadow.card,
  },
  iconCircle: {
    width: 36,
    height: 36,
    borderRadius: BorderRadius.full,
    backgroundColor: 'rgba(255,255,255,0.2)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  icon: {
    fontSize: 14,
    color: Colors.textOnDark,
  },
  label: {
    color: Colors.textOnDark,
    fontSize: 14,
    fontWeight: '700',
  },
  sublabel: {
    color: 'rgba(255,255,255,0.65)',
    fontSize: 11,
    marginTop: 1,
  },
});

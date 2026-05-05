import React, { useState, useEffect } from 'react';
import { TouchableOpacity, Text, StyleSheet, View, ActivityIndicator } from 'react-native';
import * as Speech from 'expo-speech';
import { Colors, Spacing, BorderRadius, Shadow } from '../theme';

export default function AudioButton({ duaText = '', label = 'استمع للدعاء' }) {
  const [playing, setPlaying] = useState(false);
  const [loading, setLoading] = useState(false);

  // Stop speech when component unmounts (user navigates away)
  useEffect(() => {
    return () => {
      Speech.stop();
    };
  }, []);

  // Stop previous dua if duaText changes (new ritual)
  useEffect(() => {
    Speech.stop();
    setPlaying(false);
  }, [duaText]);

  const handlePress = async () => {
    if (loading) return;

    if (playing) {
      await Speech.stop();
      setPlaying(false);
      return;
    }

    if (!duaText) return;

    setLoading(true);
    try {
      await Speech.stop(); // ensure nothing is running
      setLoading(false);
      setPlaying(true);

      Speech.speak(duaText, {
        language: 'ar-SA',
        rate: 0.75,       // slower = clearer for prayers
        pitch: 1.0,
        onDone: () => setPlaying(false),
        onError: () => setPlaying(false),
        onStopped: () => setPlaying(false),
      });
    } catch {
      setLoading(false);
      setPlaying(false);
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
        <Text style={styles.label}>{playing ? 'إيقاف' : label}</Text>
        <Text style={styles.sublabel}>
          {playing ? 'جاري التلاوة...' : 'اضغط للاستماع'}
        </Text>
      </View>

      {/* Animated pulse indicator while playing */}
      {playing && <View style={styles.playingDot} />}
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
  playingDot: {
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: Colors.secondary,
    marginLeft: 'auto',
  },
});

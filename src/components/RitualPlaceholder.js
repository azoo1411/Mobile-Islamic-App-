import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import Svg, { Circle, Rect, Path, Line, Polygon } from 'react-native-svg';

// ─── Brand colors ────────────────────────────────────────────────────────────
const G1 = '#1E4D2B';  // deep green
const G2 = '#2D6B3E';  // medium green
const AU = '#C9A227';  // gold
const AL = '#E8C84A';  // light gold
const WH = '#FFFFFF';  // white

// ─── 1. Ihram ─────────────────────────────────────────────────────────────────
// Two overlapping white cloth panels on a warm cream ground
function Ihram() {
  return (
    <Svg width="100%" height="220" viewBox="0 0 375 220" preserveAspectRatio="xMidYMid slice">
      {/* Shadow behind left cloth */}
      <Rect x="114" y="40" width="78" height="143" rx="3" fill="#C8BFB4" opacity="0.5" />
      {/* Left cloth */}
      <Rect x="107" y="33" width="78" height="143" rx="3" fill={WH} opacity="0.93" />
      {/* Right cloth */}
      <Rect x="162" y="40" width="78" height="143" rx="3" fill="#F5F0EB" opacity="0.87" />
      {/* Overlap seam */}
      <Line x1="162" y1="40" x2="162" y2="180" stroke="#DDD5CC" strokeWidth="1" />
      {/* Gold accent baseline */}
      <Line x1="72" y1="194" x2="303" y2="194" stroke={AU} strokeWidth="1.5" opacity="0.7" />
    </Svg>
  );
}

// ─── 2. Mina ──────────────────────────────────────────────────────────────────
// Four white tent peaks rising from a green valley floor
function Mina() {
  return (
    <Svg width="100%" height="220" viewBox="0 0 375 220" preserveAspectRatio="xMidYMid slice">
      {/* Valley floor */}
      <Rect x="0" y="175" width="375" height="45" fill={G1} opacity="0.28" />
      {/* Far-left tent (receded) */}
      <Polygon points="44,175 82,94 120,175" fill={WH} opacity="0.58" />
      {/* Left tent */}
      <Polygon points="98,175 142,76 186,175" fill={WH} opacity="0.93" />
      <Polygon points="98,175 142,76 186,175" fill="none" stroke={AU} strokeWidth="0.7" opacity="0.45" />
      {/* Right tent */}
      <Polygon points="164,175 208,80 252,175" fill={WH} opacity="0.93" />
      <Polygon points="164,175 208,80 252,175" fill="none" stroke={AU} strokeWidth="0.7" opacity="0.45" />
      {/* Far-right tent (receded) */}
      <Polygon points="233,175 270,99 307,175" fill={WH} opacity="0.58" />
    </Svg>
  );
}

// ─── 3. Arafat ────────────────────────────────────────────────────────────────
// Divine light rays descend onto a gentle hill — the peak of Hajj
function Arafat() {
  return (
    <Svg width="100%" height="220" viewBox="0 0 375 220" preserveAspectRatio="xMidYMid slice">
      {/* Light rays from top-center */}
      <Line x1="188" y1="-5" x2="50"  y2="218" stroke={AU} strokeWidth="1"   opacity="0.18" />
      <Line x1="188" y1="-5" x2="95"  y2="214" stroke={AU} strokeWidth="1"   opacity="0.27" />
      <Line x1="188" y1="-5" x2="140" y2="224" stroke={AU} strokeWidth="1.2" opacity="0.38" />
      <Line x1="188" y1="-5" x2="167" y2="228" stroke={AU} strokeWidth="1.5" opacity="0.52" />
      <Line x1="188" y1="-5" x2="188" y2="228" stroke={AU} strokeWidth="2"   opacity="0.62" />
      <Line x1="188" y1="-5" x2="209" y2="228" stroke={AU} strokeWidth="1.5" opacity="0.52" />
      <Line x1="188" y1="-5" x2="236" y2="224" stroke={AU} strokeWidth="1.2" opacity="0.38" />
      <Line x1="188" y1="-5" x2="281" y2="214" stroke={AU} strokeWidth="1"   opacity="0.27" />
      <Line x1="188" y1="-5" x2="326" y2="218" stroke={AU} strokeWidth="1"   opacity="0.18" />
      {/* Background hill */}
      <Path d="M -10 228 Q 188 55 385 228 Z" fill={G1} opacity="0.8" />
      {/* Foreground hill (lighter layer) */}
      <Path d="M -10 228 Q 188 102 385 228 Z" fill={G2} opacity="0.52" />
    </Svg>
  );
}

// ─── 4. Muzdalifah ────────────────────────────────────────────────────────────
// Crescent moon and stars over a dark open plain
function Muzdalifah() {
  const NIGHT = '#182538';
  return (
    <Svg width="100%" height="220" viewBox="0 0 375 220" preserveAspectRatio="xMidYMid slice">
      {/* Stars */}
      <Circle cx="42"  cy="28"  r="2.5" fill={AU} opacity="0.85" />
      <Circle cx="88"  cy="52"  r="1.5" fill={AL} opacity="0.70" />
      <Circle cx="26"  cy="70"  r="2"   fill={AU} opacity="0.60" />
      <Circle cx="138" cy="22"  r="1.5" fill={AL} opacity="0.90" />
      <Circle cx="170" cy="44"  r="2"   fill={AU} opacity="0.65" />
      <Circle cx="58"  cy="92"  r="1.5" fill={AL} opacity="0.50" />
      <Circle cx="318" cy="30"  r="2.5" fill={AU} opacity="0.80" />
      <Circle cx="296" cy="66"  r="1.5" fill={AL} opacity="0.65" />
      <Circle cx="350" cy="50"  r="2"   fill={AU} opacity="0.75" />
      <Circle cx="340" cy="16"  r="1.5" fill={AL} opacity="0.85" />
      <Circle cx="248" cy="38"  r="1.5" fill={AU} opacity="0.55" />
      <Circle cx="202" cy="14"  r="2"   fill={AL} opacity="0.70" />
      {/* Crescent moon — gold circle with night-coloured circle on top to cut the crescent */}
      <Circle cx="238" cy="86"  r="52"  fill={AU} opacity="0.88" />
      <Circle cx="266" cy="68"  r="44"  fill={NIGHT} />
      {/* Ground */}
      <Rect x="0" y="193" width="375" height="27" fill="#0E1820" />
      <Line x1="0" y1="193" x2="375" y2="193" stroke="#2A3D55" strokeWidth="1" />
    </Svg>
  );
}

// ─── 5. Jamarat ───────────────────────────────────────────────────────────────
// Three stone pillars beneath a bridge platform
function Jamarat() {
  return (
    <Svg width="100%" height="220" viewBox="0 0 375 220" preserveAspectRatio="xMidYMid slice">
      {/* Ground */}
      <Rect x="0" y="196" width="375" height="24" fill="#CEC4B0" opacity="0.85" />
      {/* Bridge platform */}
      <Rect x="66" y="58" width="243" height="9" rx="4" fill={AU} opacity="0.62" />
      {/* Left pillar — shadow then fill */}
      <Rect x="93"  y="68" width="40" height="128" rx="3" fill="#A8A098" opacity="0.4" />
      <Rect x="90"  y="66" width="40" height="130" rx="3" fill={G2}  opacity="0.74" />
      {/* Center pillar — tallest */}
      <Rect x="172" y="44" width="46" height="152" rx="3" fill="#A8A098" opacity="0.4" />
      <Rect x="168" y="41" width="46" height="155" rx="3" fill={G1} />
      {/* Right pillar */}
      <Rect x="252" y="68" width="40" height="128" rx="3" fill="#A8A098" opacity="0.4" />
      <Rect x="248" y="66" width="40" height="130" rx="3" fill={G2}  opacity="0.74" />
    </Svg>
  );
}

// ─── 6. Sacrifice ─────────────────────────────────────────────────────────────
// Stylised botanical leaf pair on a gold stem — symbol of offering
function Sacrifice() {
  return (
    <Svg width="100%" height="220" viewBox="0 0 375 220" preserveAspectRatio="xMidYMid slice">
      {/* Stem */}
      <Line x1="188" y1="208" x2="188" y2="70" stroke={AU} strokeWidth="3" strokeLinecap="round" />
      {/* Left leaf */}
      <Path
        d="M 188 188 C 136 156 118 104 150 60 C 163 98 178 148 188 188 Z"
        fill={G1}
        opacity="0.88"
      />
      {/* Right leaf */}
      <Path
        d="M 188 188 C 240 156 258 104 226 60 C 213 98 198 148 188 188 Z"
        fill={G2}
        opacity="0.70"
      />
      {/* Apex jewel */}
      <Circle cx="188" cy="58" r="12" fill={AU} opacity="0.92" />
      <Circle cx="188" cy="58" r="5"  fill={G1} />
    </Svg>
  );
}

// ─── 7. Halq — Hair ───────────────────────────────────────────────────────────
// Two open concentric arcs (open at top) — transformation and renewal
// Arc math: centre (188, 118), gap of 60° at top (start 300°, end 240°)
// r=75 → start (225.5, 53.1), end (150.5, 53.1)  large-arc=1, sweep=1
// r=52 → start (214.0, 73.0), end (162.0, 73.0)
function Halq() {
  return (
    <Svg width="100%" height="220" viewBox="0 0 375 220" preserveAspectRatio="xMidYMid slice">
      {/* Outer arc — dark green, 300 degrees */}
      <Path
        d="M 225.5 53.1 A 75 75 0 1 1 150.5 53.1"
        fill="none"
        stroke={G1}
        strokeWidth="7"
        strokeLinecap="round"
        opacity="0.85"
      />
      {/* Inner arc — gold, 270 degrees (larger gap at top) */}
      <Path
        d="M 214 73 A 52 52 0 1 1 162 73"
        fill="none"
        stroke={AU}
        strokeWidth="5"
        strokeLinecap="round"
        opacity="0.90"
      />
      {/* Centre circle */}
      <Circle cx="188" cy="118" r="16" fill={G1} />
      <Circle cx="188" cy="118" r="7"  fill={AU} />
    </Svg>
  );
}

// ─── 8. Tawaf ─────────────────────────────────────────────────────────────────
// Five concentric gold rings around a small Ka'bah — on a deep green field
function Tawaf() {
  return (
    <Svg width="100%" height="220" viewBox="0 0 375 220" preserveAspectRatio="xMidYMid slice">
      {/* Rings — outermost to innermost */}
      <Circle cx="188" cy="108" r="100" fill="none" stroke={AU} strokeWidth="1"   opacity="0.22" />
      <Circle cx="188" cy="108" r="80"  fill="none" stroke={AU} strokeWidth="1.5" opacity="0.38" />
      <Circle cx="188" cy="108" r="60"  fill="none" stroke={AU} strokeWidth="2"   opacity="0.58" />
      <Circle cx="188" cy="108" r="40"  fill="none" stroke={AU} strokeWidth="2.5" opacity="0.78" />
      <Circle cx="188" cy="108" r="21"  fill="none" stroke={AU} strokeWidth="3"   opacity="0.95" />
      {/* Ka'bah — small black square with gold border */}
      <Rect x="179" y="99"  width="18" height="18" rx="1" fill="#080F0A" />
      <Rect x="179" y="99"  width="18" height="18" rx="1" fill="none" stroke={AU} strokeWidth="1.5" />
    </Svg>
  );
}

// ─── 9. Sa'i ──────────────────────────────────────────────────────────────────
// Two overlapping green hills connected by a dashed gold path with endpoint markers
function Sai() {
  return (
    <Svg width="100%" height="220" viewBox="0 0 375 220" preserveAspectRatio="xMidYMid slice">
      {/* Back hill — Marwa (lighter) */}
      <Path d="M 125 228 Q 290 60 420 228 Z" fill={G2} opacity="0.50" />
      {/* Front hill — Safa (darker) */}
      <Path d="M -45 228 Q 115 60 270 228 Z" fill={G1} opacity="0.82" />
      {/* Ground base */}
      <Rect x="0" y="202" width="375" height="18" fill="#CEC4B0" opacity="0.55" />
      {/* Dashed path between the two hills */}
      <Line
        x1="60" y1="196"
        x2="315" y2="196"
        stroke={AU}
        strokeWidth="2.5"
        strokeDasharray="14 8"
      />
      {/* Safa start marker */}
      <Circle cx="60"  cy="196" r="8"  fill={G1} />
      <Circle cx="60"  cy="196" r="4"  fill={AU} />
      {/* Marwa end marker */}
      <Circle cx="315" cy="196" r="8"  fill={G1} />
      <Circle cx="315" cy="196" r="4"  fill={AU} />
    </Svg>
  );
}

// ─── Illustration registry ────────────────────────────────────────────────────
const REGISTRY = {
  1: { Component: Ihram,      bg: '#F2EBE0' },
  2: { Component: Mina,       bg: '#E8EEE8' },
  3: { Component: Arafat,     bg: '#FFF5D0' },
  4: { Component: Muzdalifah, bg: '#182538' },
  5: { Component: Jamarat,    bg: '#EDE5D8' },
  6: { Component: Sacrifice,  bg: '#E8F4EC' },
  7: { Component: Halq,       bg: '#F8F4EE' },
  8: { Component: Tawaf,      bg: '#1E4D2B' },
  9: { Component: Sai,        bg: '#F0E8DC' },
};

// ─── Public component ─────────────────────────────────────────────────────────
export default function RitualPlaceholder({ ritualId, dateHint }) {
  const { Component, bg } = REGISTRY[ritualId] ?? REGISTRY[1];

  return (
    <View style={[styles.container, { backgroundColor: bg }]}>
      <Component />
      {dateHint ? (
        <View style={styles.badge}>
          <Text style={styles.badgeText}>{dateHint}</Text>
        </View>
      ) : null}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    height: 220,
    width: '100%',
    overflow: 'hidden',
  },
  badge: {
    position: 'absolute',
    bottom: 14,
    right: 14,
    backgroundColor: 'rgba(0,0,0,0.32)',
    borderRadius: 20,
    paddingHorizontal: 12,
    paddingVertical: 4,
  },
  badgeText: {
    color: '#FFFFFF',
    fontSize: 11,
    fontWeight: '600',
    letterSpacing: 0.3,
  },
});

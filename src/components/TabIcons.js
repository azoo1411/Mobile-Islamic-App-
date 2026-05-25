/**
 * Unified SVG icon set for the bottom tab bar.
 * All icons share:
 *  - viewBox: 0 0 24 24
 *  - strokeWidth: 1.75
 *  - strokeLinecap / strokeLinejoin: 'round'
 *  - fill: 'none'  (pure stroke — no emoji, no bitmap)
 *
 * Color and size are always injected at call-site, never hardcoded.
 */

import React from 'react';
import Svg, { Path, Circle, Line, Rect } from 'react-native-svg';

const ICON_SIZE   = 23;
const STROKE_W    = 1.75;
const COMMON      = { fill: 'none', strokeLinecap: 'round', strokeLinejoin: 'round' };

/** Helper — injects stroke + strokeWidth into every child */
function Icon({ size = ICON_SIZE, color, strokeWidth = STROKE_W, children }) {
  return (
    <Svg width={size} height={size} viewBox="0 0 24 24">
      {React.Children.map(children, child =>
        React.cloneElement(child, {
          ...COMMON,
          stroke:      color,
          strokeWidth: strokeWidth,
        })
      )}
    </Svg>
  );
}

// ─── القرآن — open book ───────────────────────────────────────────────────────
export function IconQuran({ size, color }) {
  return (
    <Icon size={size} color={color}>
      <Path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20" />
      <Path d="M4 4.5A2.5 2.5 0 0 1 6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15z" />
      {/* Text lines on the page */}
      <Line x1="8" y1="7"  x2="16" y2="7"  />
      <Line x1="8" y1="11" x2="14" y2="11" />
    </Icon>
  );
}

// ─── الصلاة — clock ───────────────────────────────────────────────────────────
export function IconPrayer({ size, color }) {
  return (
    <Icon size={size} color={color}>
      <Circle cx="12" cy="12" r="9" />
      <Path d="M12 7v5l3.5 2" />
    </Icon>
  );
}

// ─── الأذكار — prayer beads (مسبحة) ──────────────────────────────────────────
//   Ring + 4 cardinal beads + tassel  — identical stroke weight to all others
export function IconAdhkar({ size, color }) {
  return (
    <Icon size={size} color={color}>
      {/* Main bead ring */}
      <Circle cx="12" cy="11" r="6.5" />
      {/* Cardinal beads — same strokeWidth, no separate fill */}
      <Circle cx="12" cy="4.5"  r="1.6" />   {/* top    */}
      <Circle cx="5.5"  cy="11" r="1.6" />   {/* left   */}
      <Circle cx="18.5" cy="11" r="1.6" />   {/* right  */}
      <Circle cx="12"   cy="17.5" r="1.6" /> {/* bottom */}
      {/* Tassel stem */}
      <Line x1="12" y1="19" x2="12" y2="22" />
      {/* Tassel tip arc */}
      <Path d="M10 21.5c.5.8 1.2 1.2 2 1.2s1.5-.4 2-1.2" />
    </Icon>
  );
}

// ─── البحث — magnifying glass ─────────────────────────────────────────────────
export function IconSearch({ size, color }) {
  return (
    <Icon size={size} color={color}>
      <Circle cx="11" cy="11" r="7.5" />
      <Line x1="17" y1="17" x2="21.5" y2="21.5" />
    </Icon>
  );
}

// ─── التلاوة — headphones ─────────────────────────────────────────────────────
export function IconRecitation({ size, color }) {
  return (
    <Icon size={size} color={color}>
      {/* Arc (headband) */}
      <Path d="M3 18v-6a9 9 0 0 1 18 0v6" />
      {/* Right ear cup */}
      <Rect x="17" y="16" width="4" height="5" rx="1.5" />
      {/* Left ear cup */}
      <Rect x="3"  y="16" width="4" height="5" rx="1.5" />
    </Icon>
  );
}

// ─── الإعدادات — three-line sliders ──────────────────────────────────────────
export function IconSettings({ size, color }) {
  return (
    <Icon size={size} color={color}>
      {/* Three horizontal track lines */}
      <Line x1="3" y1="6"  x2="21" y2="6"  />
      <Line x1="3" y1="12" x2="21" y2="12" />
      <Line x1="3" y1="18" x2="21" y2="18" />
      {/* Thumb circles (filled via a second pass below) */}
    </Icon>
  );
}

// ─── الإعدادات — alternate: sliders with knobs ────────────────────────────────
//   Uses a second Svg layer because Circle fill needs to match the stroke color.
export function IconSettingsKnobs({ size = ICON_SIZE, color }) {
  const s = { ...COMMON, stroke: color, strokeWidth: STROKE_W };
  return (
    <Svg width={size} height={size} viewBox="0 0 24 24">
      {/* Track lines */}
      <Line x1="3"  y1="6"  x2="21" y2="6"  {...s} />
      <Line x1="3"  y1="12" x2="21" y2="12" {...s} />
      <Line x1="3"  y1="18" x2="21" y2="18" {...s} />
      {/* Knobs — filled circles on each track */}
      <Circle cx="8"  cy="6"  r="2.2" fill={color} stroke="none" />
      <Circle cx="16" cy="12" r="2.2" fill={color} stroke="none" />
      <Circle cx="10" cy="18" r="2.2" fill={color} stroke="none" />
    </Svg>
  );
}

// ─── الرئيسية — home ──────────────────────────────────────────────────────────
export function IconHome({ size, color }) {
  return (
    <Icon size={size} color={color}>
      <Path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
      <Path d="M9 22V12h6v10" />
    </Icon>
  );
}

// ─── المكتبة — library / stacked books ───────────────────────────────────────
export function IconLibrary({ size, color }) {
  return (
    <Icon size={size} color={color}>
      {/* Three book spines */}
      <Rect x="2"  y="5"  width="4" height="16" rx="1" />
      <Rect x="8"  y="3"  width="4" height="18" rx="1" />
      <Rect x="14" y="6"  width="4" height="15" rx="1" />
      {/* Far right book (angled spine – just a line) */}
      <Path d="M20 7l2-.5v14l-2 .5" />
    </Icon>
  );
}

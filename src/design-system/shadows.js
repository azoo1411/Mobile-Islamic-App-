import { Platform } from 'react-native';

const iosShadow = (color, offsetY, opacity, radius) => ({
  shadowColor:   color,
  shadowOffset:  { width: 0, height: offsetY },
  shadowOpacity: opacity,
  shadowRadius:  radius,
});

const androidShadow = (elevation) => ({ elevation });

const shadow = (color, offsetY, opacity, radius, elevation) =>
  Platform.OS === 'ios'
    ? iosShadow(color, offsetY, opacity, radius)
    : androidShadow(elevation);

// Pre-built shadow presets
export const shadows = {
  none: {},

  // For cards and surfaces — warm gold tint in light mode
  cardSm:  (c = '#7A5C30') => shadow(c, 2,  0.06,  6,  2),
  cardMd:  (c = '#7A5C30') => shadow(c, 4,  0.09, 10,  4),
  cardLg:  (c = '#7A5C30') => shadow(c, 8,  0.12, 16,  8),

  // For floating elements (nav bar, FABs)
  floating: (c = '#000000') => shadow(c, 12, 0.22, 24, 16),
  floatingMd:(c = '#000000') => shadow(c, 6,  0.16, 14, 10),

  // For modals / sheets
  modal:   (c = '#000000') => shadow(c, -4, 0.18, 32, 24),

  // Soft glow (glass headers)
  glow:    (c = '#C8A96E') => shadow(c, 0,  0.18, 20,  0),
};

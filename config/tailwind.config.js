const defaultTheme = require('tailwindcss/defaultTheme')
const plugin = require('tailwindcss/plugin')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      animation: {
        'pulse-quick': 'pulse 200ms ease-in-out 3',
      },
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        'syntakt-green-fg': '#17DE6A',
        'syntakt-green-shadow': '#6BEFA2',
        'syntakt-red-fg': '#E69EA4',
        'syntakt-red-shadow': '#CC1F1F',
        'modes': {
          'lydian': '#FFEB3B',
          'ionian': '#FFC107',
          'mixolydian': '#FF9800',
          'dorian': '#8BC34A',
          'aeolian': '#009688',
          'phrygian': '#673AB7',
          'locrian': '#3E67C4',
        },
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
    plugin(function({ addVariant }) {
      addVariant('children', '& > *')
    }),
    plugin(function({ theme, addUtilities }) {
      const colors = theme('colors.modes');
      const colorUtilities = {};
      const highlightedNoteUtilities = {};
      const borderUtilities = {};

      Object.keys(colors).forEach((color) => {
        const value = colors[color];
        const className = `mode-shadow-${color}`;
        colorUtilities[`.${className}`] = {
          boxShadow: `0 0 30px ${value}`,
        }

        const highlightedNoteClassName = `highlighted-note-${color}`;
        highlightedNoteUtilities[`.${highlightedNoteClassName}`] = {
          boxShadow: `0 0 30px ${value}`,
        }
        highlightedNoteUtilities[`.${highlightedNoteClassName} div`] = {
          border: `2px solid ${value}`,
        }
        highlightedNoteUtilities[`.${highlightedNoteClassName} span`] = {
          color: `${value}`,
        }

        const borderClassName = `border-modes-${color}`;
        borderUtilities[`.${borderClassName}`] = {
          border: `2px solid ${value}`,
        }
      });

      addUtilities(colorUtilities);
      addUtilities(highlightedNoteUtilities);
      addUtilities(borderUtilities);
    }),
  ],
  safelist: [
    {
      pattern: /mode-shadow-.*/,
      variants: ['hover'],
    },
    {
      pattern: /highlighted-note-.*/,
    },
    {
      pattern: /border-modes-.*/,
      variants: ['hover'],
    },
    {
      pattern: /text-modes-.*/,
      variants: ['hover', 'group-hover'],
    },
    'animate-pulse-quick',
  ],
}

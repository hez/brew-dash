// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration
const plugin = require('tailwindcss/plugin');

module.exports = {
  content: [
    './js/**/*.js',
    '../lib/*_web.ex',
    '../lib/*_web/**/*.*ex',
    "../deps/home_dash/lib/home_dash_web.ex",
    "../deps/home_dash/lib/home_dash_web/**/*.*ex"
    // "../../home_dash/lib/home_dash_web.ex",
    // "../../home_dash/lib/home_dash_web/**/*.*ex"
  ],
  theme: {
    extend: {
      colors: {
        'muted-gray': '#373737',
        'dull-blue': '#2c5a7f'
      },
      spacing: {
        '98': '26rem'
      }
    }
  },
  plugins: [
    require('@tailwindcss/forms'),
    plugin(({addVariant}) => addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])),
    plugin(({addVariant}) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({addVariant}) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({addVariant}) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])),
    plugin(function ({ addUtilities }) {
      addUtilities({
        '.scrollbar-hide': {
          /* IE and Edge */
          '-ms-overflow-style': 'none',

          /* Safari and Chrome */
          '&::-webkit-scrollbar': {
            display: 'none'
          },

          /* Firefox */
          'scrollbar-width': 'none'
        },

        '.scrollbar-default': {
          /* IE and Edge */
          '-ms-overflow-style': 'auto',

          /* Firefox */
          'scrollbar-width': 'auto',

          /* Safari and Chrome */
          '&::-webkit-scrollbar': {
            display: 'block'
          }
        }
      }, ['responsive'])
    })
  ],
  darkMode: 'class'
}

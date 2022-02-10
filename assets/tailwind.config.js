// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration
module.exports = {
  content: [
    './js/**/*.js',
    '../lib/*_web.ex',
    '../lib/*_web/**/*.*ex'
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
    require('@tailwindcss/forms')
  ],
  darkMode: 'class'
}

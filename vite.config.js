import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import react from '@vitejs/plugin-react';

// steps para gumana si NGROK my boi 7 utos ni jani
//step 1 i comment si default config kasi dina sya need 
//step 2 uncomment si ngrok testing 
//step 3 npm run build/ run dev
//step 4 run php artisan serve
//step 5 run ngrok http 8000
//step 6 test 
//step 7 matulog na tayo 

// ngrok testing 
// export default defineConfig({
//     plugins: [
//         laravel({
//             input: 'resources/js/app.jsx',
//             refresh: true,
//         }),
//         react(),
//     ],
//     server: {
//         host: '0.0.0.0',
//         port: 5173,
//         allowedHosts: ['yauld-biparty-bert.ngrok-free.dev'],
//     },
// });

// deafult config
export default defineConfig({
    plugins: [
        laravel({
            input: 'resources/js/app.jsx',
            refresh: true,
        }),
        react(),
    ],
});


//di nagana pero wag burahin 
// export default defineConfig({
//   plugins: [react(), laravel()],
//   server: {
//     host: '0.0.0.0',
//     port: 5173,
//     proxy: {
//       '/api': 'http://127.0.0.1:8000',
//       '/sanctum': 'http://127.0.0.1:8000',
//     },
//   },
// })

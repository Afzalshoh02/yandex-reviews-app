// import { defineConfig } from 'vite'
// import laravel from 'laravel-vite-plugin'
// import vue from '@vitejs/plugin-vue'
//
// export default defineConfig({
//     server: {
//         host: '0.0.0.0', // доступ из Docker
//         port: 5173,
//         strictPort: true,
//         hmr: {
//             host: 'localhost',
//             port: 5173,
//         },
//     },
//     plugins: [
//         laravel({
//             input: ['resources/css/app.css', 'resources/js/app.js'],
//             refresh: true,
//         }),
//         vue({
//             template: {
//                 transformAssetUrls: {
//                     base: null,
//                     includeAbsolute: false,
//                 },
//             },
//         }),
//     ],
//     resolve: {
//         alias: {
//             '@': '/resources/js',
//             '~': '/resources',
//         },
//     },
// })

import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import vue from '@vitejs/plugin-vue';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
        }),
        vue({
            template: {
                transformAssetUrls: {
                    base: null,
                    includeAbsolute: false,
                },
            },
        }),
    ],
    build: {
        manifest: true,
        outDir: 'public/build',
        rollupOptions: {
            output: {
                assetFileNames: (assetInfo) => {
                    let extType = assetInfo.name.split('.')[1];
                    if (/png|jpe?g|svg|gif|tiff|bmp|ico/i.test(extType)) {
                        extType = 'img';
                    }
                    return `assets/${extType}/[name]-[hash][extname]`;
                },
                chunkFileNames: 'assets/js/[name]-[hash].js',
                entryFileNames: 'assets/js/[name]-[hash].js',
            },
        },
    },
    server: {
        hmr: {
            host: 'localhost',
        },
    },
});

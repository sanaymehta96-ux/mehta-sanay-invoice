'use strict';
const CACHE = 'mehta-sanay-invoice-v44-2';
const CACHE_PREFIX = 'mehta-sanay-invoice-';
const APP_SHELL = ['./manifest.json', './icon-192.png', './icon-512.png', './icon-512-maskable.png'];

self.addEventListener('install', event => {
  event.waitUntil((async () => {
    const cache = await caches.open(CACHE);

    // index.html is essential: fail installation rather than activate a worker
    // that cannot provide the app shell offline.
    const appResponse = await fetch('./index.html', { cache: 'reload' });
    const appType = appResponse.headers.get('content-type') || '';
    if (!appResponse.ok || appResponse.type !== 'basic' || !appType.includes('text/html')) {
      throw new Error('Required app shell (index.html) could not be cached.');
    }
    await cache.put('./index.html', appResponse.clone());

    // Supporting assets are useful but not required for app startup. Cache only
    // successful same-origin responses; a missing icon/manifest must not block install.
    for (const path of APP_SHELL) {
      try {
        const response = await fetch(path, { cache: 'reload' });
        if (response.ok && response.type === 'basic') {
          await cache.put(path, response.clone());
        }
      } catch (_) { /* optional resource; continue installation */ }
    }
    await self.skipWaiting();
  })());
});

self.addEventListener('activate', event => {
  event.waitUntil((async () => {
    const keys = await caches.keys();
    // Delete only prior caches belonging to this invoice app.
    await Promise.all(keys.filter(key => key.startsWith(CACHE_PREFIX) && key !== CACHE).map(key => caches.delete(key)));
    await self.clients.claim();
  })());
});

self.addEventListener('fetch', event => {
  const req = event.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);
  if (url.origin !== self.location.origin) return;

  if (req.mode === 'navigate') {
    event.respondWith((async () => {
      try {
        const response = await fetch(req);
        if (response && response.ok && response.type === 'basic') {
          const cache = await caches.open(CACHE);
          await cache.put('./index.html', response.clone()).catch(() => {});
        }
        return response;
      } catch (_) {
        return (await caches.match('./index.html')) || Response.error();
      }
    })());
    return;
  }

  // Cache-first for same-origin static resources, but cache successful responses only.
  // Never substitute index.html for a failed script, image, manifest, or data request.
  event.respondWith((async () => {
    const cached = await caches.match(req);
    if (cached) return cached;
    try {
      const response = await fetch(req);
      if (response && response.ok && response.type === 'basic') {
        const cache = await caches.open(CACHE);
        await cache.put(req, response.clone()).catch(() => {});
      }
      return response;
    } catch (_) {
      return Response.error();
    }
  })());
});

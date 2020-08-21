'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "index.html": "770f6852af61ee483543c9fb5a8a0880",
"/": "770f6852af61ee483543c9fb5a8a0880",
"main.dart.js": "1485ce3dad0d0b0834dd7af63ddc7aca",
"manifest.json": "2d3b1a4f33a1ba179f5ee4063343fb83",
"assets/images/bmc-new-btn-logo.svg": "54d226be88f149bb8cc3a929651a7152",
"assets/AssetManifest.json": "9a7e35508bd4bfbed7b9d56936f4c715",
"assets/NOTICES": "b25e1108231bb5ea0daacd710819d48d",
"assets/FontManifest.json": "18eda8e36dfa64f14878d07846d6e17f",
"assets/icons/icon-192.png": "0792ecaf016af7e3cd27ae5b6a0772a4",
"assets/icons/icon-384.png": "524de3247300a9eb27f4b32ed49f3faa",
"assets/icons/icon.svg": "f59b5b3e3b82038f7122af544ae4a470",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "2aa350bd2aeab88b601a593f793734c0",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "2bca5ec802e40d3f4b60343e346cedde",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "5a37ae808cf9f652198acde612b5328d",
"assets/packages/flutter_markdown/assets/logo.png": "67642a0b80f3d50277c44cde8f450e50",
"assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"assets/fonts/Roboto/Roboto-Medium.ttf": "58aef543c97bbaf6a9896e8484456d98",
"assets/fonts/Roboto/Roboto-Light.ttf": "88823c2015ffd5fa89d567e17297a137",
"assets/fonts/Roboto/Roboto-Regular.ttf": "11eabca2251325cfc5589c9c6fb57b46",
"assets/fonts/Roboto/Roboto-MediumItalic.ttf": "cf23e1bb619029496260760b72aebd30",
"assets/fonts/Roboto/Roboto-ThinItalic.ttf": "35a9c89aff1396595ad345e378a32aca",
"assets/fonts/Roboto/Roboto-BoldItalic.ttf": "5b44818d2b9eda3e23cd5edd7b49b7d5",
"assets/fonts/Roboto/Roboto-LightItalic.ttf": "a3ce4440f2abf76f4a1b14b83920138c",
"assets/fonts/Roboto/Roboto-Italic.ttf": "a720f17aa773e493a7ebf8b08459e66c",
"assets/fonts/Roboto/LICENSE.txt": "d273d63619c9aeaf15cdaf76422c4f87",
"assets/fonts/Roboto/Roboto-BlackItalic.ttf": "99682a78fa4fe61e1177b94757336bbf",
"assets/fonts/Roboto/Roboto-Bold.ttf": "e07df86cef2e721115583d61d1fb68a6",
"assets/fonts/Roboto/Roboto-Thin.ttf": "321de678e592d0b8f44f1a82d7ca4b62",
"assets/fonts/Roboto/Roboto-Black.ttf": "5ebb24ee1112dd9562629375c387879a"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      // Provide a no-cache param to ensure the latest version is downloaded.
      return cache.addAll(CORE.map((value) => new Request(value, {'cache': 'no-cache'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');

      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }

      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#')) {
    key = '/';
  }
  // If the URL is not the RESOURCE list, skip the cache.
  if (!RESOURCES[key]) {
    return event.respondWith(fetch(event.request));
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache. Ensure the resources are not cached
        // by the browser for longer than the service worker expects.
        var modifiedRequest = new Request(event.request, {'cache': 'no-cache'});
        return response || fetch(modifiedRequest).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    return self.skipWaiting();
  }

  if (event.message === 'downloadOffline') {
    downloadOffline();
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey in Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

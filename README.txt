MEHTA SANAY INVOICE — v44.1

PURPOSE
This is a focused PWA maintenance release based on v44. The invoice editor,
invoice layout, VAT calculations, pagination, and Google Drive sync engine are
preserved. Changes are limited to the app version title, service-worker
installation/cache resilience, Windows launcher readiness checks, and setup
instructions.

GITHUB PAGES DEPLOYMENT
Repository: sanaymehta96-ux/mehta-sanay-invoice
Pages app: https://sanaymehta96-ux.github.io/mehta-sanay-invoice/

Replace the existing root files with the files in this package:
index.html, manifest.json, sw.js, icon-192.png, icon-512.png,
START_INVOICE_APP.bat, README.txt
Keep all files together in the same published directory. Commit the changes
and allow GitHub Pages to deploy. Then open the app and hard-refresh it.

GOOGLE DRIVE / OAUTH SETUP (EXISTING V43+ CONFIGURATION)
The app uses Google Identity Services and the Google Drive appDataFolder scope.
It does not require a GitHub Personal Access Token or a client secret in the
browser.

Google Cloud Console settings for the existing OAuth client:
- OAuth client type: Web application
- Authorized JavaScript origin for GitHub Pages:
  https://sanaymehta96-ux.github.io
- For local testing, also add:
  http://localhost:8000
- Redirect URIs: leave empty for the current Google Identity Services token flow.
- OAuth consent screen / Audience: while the app is in Testing, add the Google
  account(s) that will use it under Test users.
- Google Drive API must be enabled.
- Drive scope used by the app:
  https://www.googleapis.com/auth/drive.appdata

Use the same Google account on desktop and mobile. On a device's first sync,
if a shared Drive invoice is found, choose the option to download/use the Drive
copy if you want the desktop invoice on that device. Do not choose to replace
Drive unless you intentionally want that device's local invoice to become the
shared copy.

LOCAL WINDOWS USE
Double-click START_INVOICE_APP.bat. It starts a local HTTP server and waits
until the invoice app responds before opening the browser. Keep the server
window running while using the local app. Python is preferred; Node.js/npx is
the fallback. If port 8000 is occupied by another app, close it or change PORT
near the top of the batch file.

DATA SAFETY / TROUBLESHOOTING
- This maintenance release does not intentionally clear browser storage or
  change the Drive data format.
- Do not clear browser site data or uninstall the PWA while troubleshooting;
  that can remove device-local invoice data.
- If the app looks stale after deployment, hard-refresh it and reopen it once
  online so the updated service worker can install.
- Google Drive sync requires internet access and a valid Google sign-in token.
  Offline edits remain local until a successful sync.

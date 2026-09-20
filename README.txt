MEHTA SANAY INVOICE v43
=======================

v43 is an installable offline-first PWA based on the working v40 invoice.
The invoice layout/engine is preserved; v43 adds PWA installation and Google Drive sync.

FIRST: GOOGLE CLOUD
-------------------
1. Your OAuth client is a Web application client.
2. Authorized JavaScript origin:
   http://localhost:8000
3. In Google Cloud -> Google Auth Platform -> Data Access, add this scope:
   https://www.googleapis.com/auth/drive.appdata
4. Save the Data Access settings.

The app does NOT need the client secret. Never put the client secret in the app folder.

RUN LOCALLY ON WINDOWS
----------------------
Double-click START_INVOICE_APP.bat.
It starts a local web server on port 8000 and opens:
http://localhost:8000

You must use the local web address, not double-click index.html directly.

FIRST DRIVE CONNECTION
----------------------
1. Open the app at http://localhost:8000.
2. Wait for the Drive status to say "Drive: ready to connect".
3. Click "Connect Drive".
4. Choose the Google account you used for the Cloud project.
5. Grant the requested Drive permission.
6. The app creates/updates one private app-data file in Google Drive.

SYNC MODEL
----------
- The invoice remains local/offline-first.
- Google Drive is the sync layer.
- Sync data contains invoice elements, client/transport/bank profiles and invoice settings.
- The app uses Google's hidden appDataFolder, not broad access to your Drive.
- The app uses a simple latest-timestamp comparison for this single-user setup.
- PDFs are NOT uploaded automatically in v43; PDF generation remains local.

IMPORTANT
---------
Keep invoice_editor_v40.html as the frozen fallback/master.
If anything behaves unexpectedly in v43, use v40 immediately and report the exact issue.

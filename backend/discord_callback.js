// ── Discord OAuth Callback Server ──────────────────────────────────────────
//
// Lightweight Node.js server that handles the Discord OAuth2 code exchange.
// Discord redirects here with ?code=..., this server exchanges it for a token,
// fetches the user's identity, and redirects to the app with the user info.
//
// Usage:
//   1. Copy .env.example to .env and fill in your Discord app credentials
//   2. npm install express node-fetch dotenv
//   3. node discord_callback.js
//   4. Server listens on PORT (default 3000)
//
// Endpoints:
//   GET  /auth/discord/callback   — Discord redirects here after user authorizes
//   POST /auth/discord/callback/exchange — App sends { code, redirect_uri } to
//                                          get user info (alternative to redirect)

const express = require('express');
const fetch   = (...args) => import('node-fetch').then(m => m.default(...args));
require('dotenv').config();

const app  = express();
const PORT = process.env.PORT || 3000;

// ── Config from environment ─────────────────────────────────────────────────

const CLIENT_ID     = process.env.DISCORD_CLIENT_ID;
const CLIENT_SECRET = process.env.DISCORD_CLIENT_SECRET;
const REDIRECT_URI  = process.env.DISCORD_REDIRECT_URI;   // This server's URL
const APP_SCHEME    = process.env.APP_DEEP_LINK || 'codcamp://auth';

if (!CLIENT_ID || !CLIENT_SECRET || !REDIRECT_URI) {
  console.error('Missing DISCORD_CLIENT_ID, DISCORD_CLIENT_SECRET, or DISCORD_REDIRECT_URI in .env');
  process.exit(1);
}

app.use(express.json());

// ── GET /auth/discord/callback ──────────────────────────────────────────────
//
// Discord redirects here with ?code=... after the user authorizes.
// We exchange the code for an access token, fetch the user, and redirect
// to the app's deep link with the user info as query params.

app.get('/auth/discord/callback', async (req, res) => {
  const { code, error, state } = req.query;

  // Determine where to redirect: web origin (from state param) or mobile deep link
  let returnBase = APP_SCHEME;
  if (state && state.startsWith('web:')) {
    returnBase = state.slice(4); // e.g. "http://localhost:60503"
  }

  if (error || !code) {
    return res.redirect(`${returnBase}?error=${error || 'no_code'}`);
  }

  try {
    // Exchange authorization code for access token
    const tokenRes = await fetch('https://discord.com/api/oauth2/token', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({
        client_id:     CLIENT_ID,
        client_secret: CLIENT_SECRET,
        grant_type:    'authorization_code',
        code:          code,
        redirect_uri:  REDIRECT_URI,
      }),
    });

    if (!tokenRes.ok) {
      const err = await tokenRes.text();
      console.error('Token exchange failed:', err);
      return res.redirect(`${returnBase}?error=token_exchange_failed`);
    }

    const tokenData = await tokenRes.json();

    // Fetch user identity
    const userRes = await fetch('https://discord.com/api/users/@me', {
      headers: { Authorization: `Bearer ${tokenData.access_token}` },
    });

    if (!userRes.ok) {
      return res.redirect(`${returnBase}?error=user_fetch_failed`);
    }

    const user = await userRes.json();

    // Redirect to the app with user info
    const params = new URLSearchParams({
      discord_id:  user.id,
      username:    user.username,
      global_name: user.global_name || '',
    });

    console.log(`Discord login: ${user.username} (${user.id})`);
    return res.redirect(`${returnBase}?${params.toString()}`);

  } catch (err) {
    console.error('OAuth callback error:', err);
    return res.redirect(`${returnBase}?error=server_error`);
  }
});

// ── POST /auth/discord/callback/exchange ────────────────────────────────────
//
// Alternative endpoint for the app to send the code directly (useful for web
// where deep links aren't needed). Returns user info as JSON instead of
// redirecting.

app.post('/auth/discord/callback/exchange', async (req, res) => {
  const { code, redirect_uri } = req.body;

  if (!code) {
    return res.status(400).json({ error: 'Missing code' });
  }

  try {
    const tokenRes = await fetch('https://discord.com/api/oauth2/token', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({
        client_id:     CLIENT_ID,
        client_secret: CLIENT_SECRET,
        grant_type:    'authorization_code',
        code:          code,
        redirect_uri:  redirect_uri || REDIRECT_URI,
      }),
    });

    if (!tokenRes.ok) {
      const err = await tokenRes.text();
      console.error('Token exchange failed:', err);
      return res.status(502).json({ error: 'Token exchange failed' });
    }

    const tokenData = await tokenRes.json();

    const userRes = await fetch('https://discord.com/api/users/@me', {
      headers: { Authorization: `Bearer ${tokenData.access_token}` },
    });

    if (!userRes.ok) {
      return res.status(502).json({ error: 'User fetch failed' });
    }

    const user = await userRes.json();

    console.log(`Discord login (exchange): ${user.username} (${user.id})`);
    return res.json({
      id:          user.id,
      username:    user.username,
      global_name: user.global_name || null,
      avatar:      user.avatar || null,
    });

  } catch (err) {
    console.error('Exchange error:', err);
    return res.status(500).json({ error: 'Server error' });
  }
});

// ── Health check ────────────────────────────────────────────────────────────

app.get('/health', (_, res) => res.json({ status: 'ok' }));

// ── Start ───────────────────────────────────────────────────────────────────

app.listen(PORT, () => {
  console.log(`Discord OAuth callback server running on port ${PORT}`);
  console.log(`Redirect URI: ${REDIRECT_URI}`);
  console.log(`App deep link: ${APP_SCHEME}`);
});

// ── CoD API Endpoint Tester ───────────────────────────────────────────────
//
// Tests the unofficial Activision API endpoints to see which ones
// are currently returning data for BO7 / Warzone.
//
// Usage: node test_cod_api.js [gamertag] [platform]
//   gamertag: Activision ID (default: test)
//   platform: uno | battle | steam | psn | xbl (default: uno)

const fetch = (...args) => import('node-fetch').then(m => m.default(...args));

const BASE = 'https://my.callofduty.com/api/papi-client';

// Known endpoint patterns (reverse-engineered)
const ENDPOINTS = [
  // Modern profile/stats endpoints
  { name: 'BO7 MP Stats (titleIdentity)', path: '/stats/cod/v1/title/bo7/platform/{platform}/gamer/{gamertag}/profile/type/mp' },
  { name: 'BO7 Ranked Stats', path: '/stats/cod/v1/title/bo7/platform/{platform}/gamer/{gamertag}/profile/type/ranked' },
  { name: 'BO6 MP Stats', path: '/stats/cod/v1/title/bo6/platform/{platform}/gamer/{gamertag}/profile/type/mp' },
  { name: 'MW3 MP Stats', path: '/stats/cod/v1/title/mw3/platform/{platform}/gamer/{gamertag}/profile/type/mp' },
  { name: 'Warzone Stats (wz2)', path: '/stats/cod/v1/title/wz2/platform/{platform}/gamer/{gamertag}/profile/type/wz' },
  { name: 'Warzone Stats (wzr)', path: '/stats/cod/v1/title/wzr/platform/{platform}/gamer/{gamertag}/profile/type/wz' },
  { name: 'Warzone Match History', path: '/crm/cod/v2/title/wz2/platform/{platform}/gamer/{gamertag}/matches/wz/start/0/end/0/details' },
  { name: 'BO7 Match History', path: '/crm/cod/v2/title/bo7/platform/{platform}/gamer/{gamertag}/matches/mp/start/0/end/0/details' },
  { name: 'BO6 Match History', path: '/crm/cod/v2/title/bo6/platform/{platform}/gamer/{gamertag}/matches/mp/start/0/end/0/details' },

  // Older format endpoints
  { name: 'General Profile Search', path: '/stats/cod/v1/title/bo6/platform/{platform}/gamer/{gamertag}/profile' },

  // Public endpoints (no auth needed historically)
  { name: 'Leaderboard (BO7 kills)', path: '/leaderboards/v2/title/bo7/platform/{platform}/time/alltime/type/core/mode/career/page/1' },
  { name: 'Leaderboard (BO6 kills)', path: '/leaderboards/v2/title/bo6/platform/{platform}/time/alltime/type/core/mode/career/page/1' },

  // Alternate API base
  { name: 'Alternate: cod.tracker profile', base: 'https://api.tracker.gg', path: '/api/v2/cod/standard/profile/{platform}/{gamertag}', altBase: true },
];

async function testEndpoint(ep, gamertag, platform) {
  const url = (ep.base || BASE) + ep.path
    .replace('{gamertag}', encodeURIComponent(gamertag))
    .replace('{platform}', platform);

  try {
    const res = await fetch(url, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        'Accept': 'application/json',
      },
      redirect: 'follow',
      timeout: 10000,
    });

    const contentType = res.headers.get('content-type') || '';
    let body;
    if (contentType.includes('json')) {
      body = await res.json();
    } else {
      const text = await res.text();
      body = text.substring(0, 200);
    }

    return {
      name: ep.name,
      status: res.status,
      ok: res.status === 200,
      hasData: res.status === 200 && typeof body === 'object' && body.status === 'success',
      bodyPreview: typeof body === 'object'
        ? JSON.stringify(body).substring(0, 300)
        : body,
    };
  } catch (err) {
    return {
      name: ep.name,
      status: 'ERROR',
      ok: false,
      hasData: false,
      bodyPreview: err.message,
    };
  }
}

async function main() {
  const gamertag = process.argv[2] || 'TestPlayer';
  const platform = process.argv[3] || 'uno'; // uno = Activision ID

  console.log('═══════════════════════════════════════════════════════');
  console.log('  CoD API Endpoint Tester');
  console.log(`  Gamertag: ${gamertag}  |  Platform: ${platform}`);
  console.log('═══════════════════════════════════════════════════════\n');

  for (const ep of ENDPOINTS) {
    const result = await testEndpoint(ep, gamertag, platform);
    const icon = result.ok ? (result.hasData ? '✅' : '⚠️') : '❌';
    console.log(`${icon} ${result.name}`);
    console.log(`   Status: ${result.status}`);
    console.log(`   Preview: ${result.bodyPreview?.substring(0, 200)}`);
    console.log('');
  }

  console.log('═══════════════════════════════════════════════════════');
  console.log('Key: ✅ = 200 + success  |  ⚠️ = 200 but no data  |  ❌ = error/blocked');
  console.log('═══════════════════════════════════════════════════════');
}

main();

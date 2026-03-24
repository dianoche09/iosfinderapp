export default async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });

  const { userKey, ...claudeBody } = req.body;

  if (!userKey || !userKey.startsWith('sk-ant-')) {
    return res.status(401).json({ error: 'Geçersiz API key' });
  }

  try {
    const response = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': userKey,
        'anthropic-version': '2023-06-01'
      },
      body: JSON.stringify(claudeBody)
    });

    const data = await response.json();
    if (!response.ok) return res.status(response.status).json(data);
    res.status(200).json(data);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
}

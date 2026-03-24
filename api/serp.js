export default async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });

  const { serpKey, query, engine = 'google', num = 10 } = req.body;

  if (!serpKey) return res.status(401).json({ error: 'SerpAPI key eksik' });

  try {
    const params = new URLSearchParams({
      api_key: serpKey,
      q: query,
      engine,
      num: String(num)
    });

    const response = await fetch(`https://serpapi.com/search?${params}`);
    const data = await response.json();
    if (!response.ok) return res.status(response.status).json(data);
    res.status(200).json(data);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
}

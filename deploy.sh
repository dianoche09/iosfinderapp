#!/bin/bash
set -e

# ── Renkler ──
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}"
echo "╔══════════════════════════════════════╗"
echo "║   iOS Opportunity Radar — Deploy     ║"
echo "╚══════════════════════════════════════╝"
echo -e "${NC}"

# ── 1. Kontroller ──
if ! command -v git &>/dev/null; then echo -e "${RED}✗ git bulunamadı${NC}"; exit 1; fi
if ! command -v gh &>/dev/null;  then echo -e "${RED}✗ GitHub CLI (gh) bulunamadı. brew install gh${NC}"; exit 1; fi
if ! command -v vercel &>/dev/null; then echo -e "${RED}✗ Vercel CLI bulunamadı. npm i -g vercel${NC}"; exit 1; fi

# ── 2. Klasör ──
REPO_NAME="ios-opportunity-radar"
mkdir -p "$REPO_NAME"
cd "$REPO_NAME"

# HTML dosyasını buraya koy (script ile aynı dizinde olmalı)
HTML_SRC="../ios-opportunity-finder.html"
if [ ! -f "$HTML_SRC" ]; then
  echo -e "${RED}✗ ios-opportunity-finder.html bulunamadı.${NC}"
  echo "   Script ile aynı klasöre koy ve tekrar çalıştır."
  exit 1
fi

cp "$HTML_SRC" index.html
echo -e "${GREEN}✓ index.html kopyalandı${NC}"

# ── 3. vercel.json ──
cat > vercel.json <<'EOF'
{
  "version": 2,
  "builds": [{ "src": "index.html", "use": "@vercel/static" }],
  "routes": [{ "src": "/(.*)", "dest": "/index.html" }]
}
EOF
echo -e "${GREEN}✓ vercel.json oluşturuldu${NC}"

# ── 4. .gitignore ──
cat > .gitignore <<'EOF'
.vercel
.DS_Store
node_modules
EOF

# ── 5. README ──
cat > README.md <<'EOF'
# iOS Opportunity Radar 📡

Twitter · Reddit · App Store · Indie Hackers verilerini Claude AI ile analiz ederek düşük rekabetli, yüksek MRR potansiyelli iOS uygulama fırsatları bulan araç.

## Kullanım
Claude API key'ini gir → Kategori seç → FIRSAT TARA

## Stack
- Vanilla HTML/CSS/JS
- Claude API (claude-sonnet)
- SheetJS (Excel export)
EOF

# ── 6. Git init & commit ──
git init -b main
git add .
git commit -m "🚀 Initial deploy — iOS Opportunity Radar"
echo -e "${GREEN}✓ Git commit hazır${NC}"

# ── 7. GitHub repo oluştur & push ──
echo -e "${CYAN}→ GitHub'da public repo oluşturuluyor...${NC}"
gh repo create "$REPO_NAME" --public --source=. --remote=origin --push
echo -e "${GREEN}✓ GitHub'a push edildi${NC}"

# ── 8. Vercel deploy ──
echo -e "${CYAN}→ Vercel'e deploy ediliyor...${NC}"
vercel --prod --yes

echo ""
echo -e "${GREEN}╔══════════════════════════════════════╗"
echo -e "║           DEPLOY TAMAMLANDI! 🎉      ║"
echo -e "╚══════════════════════════════════════╝${NC}"
echo ""
echo -e "GitHub : ${CYAN}https://github.com/$(gh api user --jq .login)/${REPO_NAME}${NC}"
echo -e "Vercel : ${CYAN}Yukarıdaki URL'e bak ↑${NC}"

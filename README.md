# PyDojo v2 (Duolingo-style Python Learning App) — Starter

Upgraded starter for an adult-focused, Duolingo-style Python learning app:
- Skill Tree with belts
- Lesson Player with multiple exercise types
- Katana durability (mistakes slash durability)
- Custom daily goal
- Projects track (scaffold)
- Streak share card scaffold (ShareLink)

Create an Xcode iOS App project named **PyDojo** and replace generated files with `ios/PyDojo/`.

## Requirements
- Xcode 15+ recommended
- iOS 17+ target (uses ShareLink & ImageRenderer)

## Backend (dev sandbox)
DEV ONLY. Executing code is dangerous. For production, use real sandboxing (gVisor/Firecracker).

Run backend:
```bash
cd backend
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn app:app --reload --port 8000
```

Configure iOS API: edit `AppConfig.swift` (`API_BASE_URL`).

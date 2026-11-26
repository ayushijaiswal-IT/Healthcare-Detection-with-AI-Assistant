<div align="center">

<img src="app/static/img/logo.svg" width="72" alt="logo">

# Healthcare Detection with AI Assistant

**Upload a medical report → get an explainable AI risk assessment, clear triage guidance, recovery tracking and a safe AI health assistant.**

FastAPI · scikit-learn · XGBoost · LightGBM · SHAP · pdfplumber/OCR · Claude (RAG) · SQLAlchemy · vanilla-JS SPA

</div>

> 💯 **100 % free & open-source stack.** Every library, the OCR engine (Tesseract), the database (SQLite) and the hosting options (local, Docker, Render free tier, Hugging Face Spaces) are free. The AI Health Assistant runs on a **free offline knowledge engine** by default. Adding a Claude API key is optional and is the only paid component.

> ⚠️ **Decision-support & educational project, not a medical device.** It does not diagnose or prescribe. The condition-pattern model is trained largely on synthetic data. Always consult a qualified doctor.

<p align="center">
  <img src="docs/screenshots/login.png" width="49%" alt="Sign in and demo session">
  <img src="docs/screenshots/result.png" width="49%" alt="Assessment result">
  <img src="docs/screenshots/assistant.png" width="49%" alt="AI Health Assistant">
  <img src="docs/screenshots/careplan.png" width="49%" alt="Care plan and recovery">
</p>

---

## ✨ Features

| | Feature | Details |
|---|---|---|
| 🔐 | **Patient accounts** | Register / sign in (bcrypt + JWT), consent capture, login rate-limiting. No doctor role: the patient owns the data. |
| ▶️ | **Demo session** | One click, no sign-up, 30 minutes. Analyzer and screenings work; **the AI chatbot, history, care plan and PDF export are disabled** (enforced server-side with `403 DEMO_RESTRICTED`). |
| 📄 | **Smart report reading** | PDF text layer → OCR fallback (Tesseract) for scans/photos (≈96 % field accuracy on phone photos, 99 % on scans). 25 analytes, 100+ aliases (SGPT→ALT, TLC→WBC…), unit conversion (mmol/L, µmol/L, °F, lakh/µL, g/L). The patient reviews values before analysis. |
| 🧪 | **Reference-range grading** | Every value graded Normal / Mild / Moderate / Critical with a plain-language meaning; sex-specific haemoglobin ranges. |
| 🤖 | **AI condition-pattern model** | Calibrated classifier for 23 diseases, aggregated to 9 organ systems (liver, renal, thyroid, metabolic, respiratory infection…). |
| 📊 | **Analytical Risk Score & triage** | 0-100 % score → **Low (0-35) / Medium (36-70) / Very High (71-100)** with doctor consultation, hospitalisation flag and **bed rest 0 / 5-7 / 14 days**, exactly as in the project's triage matrix. Every point is itemised. |
| 🔍 | **Explainability** | Per-patient counterfactual drivers ("if your bilirubin were normal, −27 pts") + SHAP plots from training. |
| ❤️ | **Screenings on real data** | Diabetes (Pima Indians) and heart disease (UCI Cleveland): 5-model comparison, calibration, recall-oriented thresholds. |
| 💬 | **AI Health Assistant "Arogya"** | RAG over a curated knowledge base + your own latest report. English & हिंदी. Emergency / self-harm guardrails, never gives doses. Uses **Claude** when an API key is set, otherwise an offline knowledge engine. |
| 🩺 | **Care plan & recovery** | Auto-created plan, daily check-ins, milestones (doctor, bed rest, medication, symptoms) → status **Healthy / Recovered**. Warning-sign escalation. |
| 📈 | **Dashboard, history, PDF** | Risk trend chart, report history with filters, professional PDF report download. |
| 🧠 | **Model Insights page** | Data audit, comparison tables, confusion matrices, ROC, calibration and SHAP figures inside the app. |
| 🛡️ | **Privacy by design** | Health data encrypted at rest (Fernet), uploaded files never stored, data export (JSON) and account deletion, audit log, strict CSP. |
| 🌗 | **Polished UI** | Responsive (mobile → desktop), dark mode, accessible forms, print-friendly results. |

---

## 🚀 Quick start

### Easiest: one-click start
* **Windows:** double-click **`start_windows.bat`**
* **Mac / Linux:** `bash start_mac_linux.sh`

It creates a private environment, installs the free libraries (first time only), starts the app and **opens your browser** at http://127.0.0.1:8000. Step-by-step help is in [HOW_TO_RUN.txt](HOW_TO_RUN.txt).

### Manual start

**Requirements:** Python 3.10+ (tested on 3.12/3.13/3.14). Built-in deep-learning OCR (RapidOCR) is included out of the box; Tesseract OCR is also supported as an optional fallback.

```bash
cd Healthcare_Detection_AI_Assistant
```

```bash
python -m venv .venv
```

```bash
source .venv/bin/activate        # Windows: .venv\Scripts\activate
```

```bash
pip install -r requirements.txt
```

```bash
python run.py
```

Open **http://127.0.0.1:8000** and click **Start demo session**, or create an account.
`run.py` trains the models automatically on first launch (about 5-10 minutes; use `python run.py --fast` for about 3 minutes).

### Optional: enable Claude for the AI assistant

```bash
cp .env.example .env             # then set ANTHROPIC_API_KEY=... in .env
```

Without a key, the assistant runs on the built-in offline knowledge engine, with the same guardrails and Hindi support.

### Docker

```bash
docker compose up --build
```

### Run the tests

```bash
pytest -q
```

---

## 🧭 Using the application

1. **Sign in / demo**: create an account (consent required) or start a demo session.
2. **Analyze Report**: choose *Upload report* (PDF/photo/TXT), *Enter values manually* or *Use a sample report*. Sample PDFs for testing uploads are in `data/samples/`.
3. **Review**: check the extracted values (fields turn amber/red when out of range), add age, sex, symptoms and any emergency warning signs.
4. **Result**: risk gauge and level, triage cards (doctor / rest / hospitalisation), abnormal findings, AI pattern with "why" drivers, score breakdown, precautions, PDF download.
5. **Care Plan**: daily check-ins and milestones until your status becomes **Healthy / Recovered**.
6. **AI Health Assistant**: ask "Explain my latest report", "What is SGPT?", "बुखार में क्या खाना चाहिए?"
7. **Profile & Privacy**: edit details, change password, export or delete all data.

---

## 🗂️ Project structure

```
Healthcare_Detection_AI_Assistant/
├── run.py                      # one-command launcher (train if needed → serve)
├── requirements.txt · Dockerfile · docker-compose.yml · .env.example
├── data/
│   ├── raw/Healthcare_10_Synthetic_Disease_Datasets/   # the provided dataset (unchanged)
│   └── samples/                # fictional sample lab reports (PDF + TXT)
├── ml/                         # training pipeline
│   ├── config.py               # paths, features, disease → organ-system map
│   ├── data_loader.py          # dataset loading & cleaning
│   ├── features.py             # feature engineering (shared by training & serving)
│   ├── modeling.py             # 5-model zoo, search spaces, metrics, threshold tuning
│   └── train_all.py            # audit → EDA → train/compare/tune/calibrate → SHAP → model card
├── models/                     # trained artifacts + model_card.json
├── reports/figures/            # EDA, confusion matrices, ROC, calibration, SHAP plots
├── app/
│   ├── main.py                 # FastAPI app, security headers, error handling, static SPA
│   ├── config.py · database.py · models.py · schemas.py · security.py · deps.py
│   ├── routers/                # auth · analysis · screening · careplan · chat · users · meta
│   ├── services/
│   │   ├── reference_ranges.py # 25 analytes: ranges, aliases, meanings
│   │   ├── report_parser.py    # PDF/OCR/text → structured values
│   │   ├── risk_engine.py      # Analytical Risk Score + triage matrix
│   │   ├── predictor.py        # model inference + counterfactual explanations
│   │   ├── analysis.py · care_plan.py · pdf_export.py · samples.py · clinical_knowledge.py
│   │   └── chatbot/            # guardrails · retriever (RAG) · llm (Claude) · assistant
│   ├── knowledge_base/         # curated Markdown health content for RAG
│   └── static/                 # index.html, css/app.css, js/ (SPA modules)
├── scripts/generate_sample_reports.py
├── tests/                      # pytest: risk engine, parser, API journey, chatbot
└── docs/                       # architecture, model card, report outline, viva Q&A, slides, ethics
```

---

## 🧠 Machine learning summary

| Model | Data | Selected | Key test metrics |
|---|---|---|---|
| Condition pattern (23 diseases → 9 organ systems) | Synthetic panel, 5,750 rows | Random Forest | Organ-system accuracy **0.762** · top-3 disease accuracy 0.676 · macro ROC-AUC **0.904** |
| Diabetes risk | Pima Indians (768, real) | LightGBM + sigmoid calibration | ROC-AUC **0.949** · recall **0.963** · specificity 0.79 (threshold 0.15) |
| Heart-disease risk | UCI Cleveland (303, real) | Logistic Regression + sigmoid calibration | ROC-AUC **0.959** · recall **1.00** · specificity 0.67 (threshold 0.33) |
| *Signal audit* | Ten balanced `*_synthetic.csv` | n/a | ROC-AUC ≈ **0.50**: no learnable signal, so excluded from prediction |

Full comparison tables (Logistic Regression, Random Forest, XGBoost, LightGBM, MLP), calibration and thresholds are in **[docs/MODEL_CARD.md](docs/MODEL_CARD.md)** (auto-generated) and on the in-app **Model Insights** page.

**Methodology highlights:**
* Stratified hold-out test set.
* `RandomizedSearchCV` with 5-fold stratified CV; the model is selected on CV score (never test).
* Pipelines with imputation and scaling, so nothing leaks.
* Class weights instead of SMOTE.
* Calibration method chosen by validation log-loss.
* F2-optimal decision threshold with a specificity floor.
* SHAP global importance.

---

## 🔌 API

Interactive OpenAPI docs: **http://127.0.0.1:8000/docs**

| Method | Endpoint | Access |
|---|---|---|
| POST | `/api/auth/register` · `/api/auth/login` · `/api/auth/demo` | public |
| POST | `/api/analysis/extract` (multipart) · `/api/analysis/run` | user + demo |
| POST | `/api/screening/diabetes` · `/api/screening/heart` | user + demo |
| GET/DELETE | `/api/assessments[/{id}]`, `/api/assessments/{id}/pdf` | user |
| GET/PATCH/POST | `/api/careplans`, `/api/careplans/{id}`, `/api/careplans/{id}/checkins` | user |
| GET/POST/DELETE | `/api/chat`, `/api/chat/history`, `/api/chat/status` | **user only** (demo → 403) |
| GET/PATCH/DELETE | `/api/users/me`, `/api/users/me/password`, `/api/users/me/export` | user |
| GET | `/api/health` · `/api/reference` · `/api/model-card` · `/api/dashboard` · `/api/samples` | public / session |

---

## 📦 Final deliverables

| Deliverable | File |
|---|---|
| 📘 Final project report (33 pages, Word, with figures & tables; fill in the `[placeholders]`) | [docs/Project_Report.docx](docs/Project_Report.docx) |
| 🎤 Presentation (16 slides with speaker notes) | [docs/Project_Presentation.pptx](docs/Project_Presentation.pptx) |
| 📓 Executed end-to-end notebook (EDA → audit → models → explainability → OCR → triage → chatbot → API) | [notebooks/Project_Walkthrough.ipynb](notebooks/Project_Walkthrough.ipynb) |
| 📊 Model card (auto-generated metrics) | [docs/MODEL_CARD.md](docs/MODEL_CARD.md) |
| 🧾 Execution log (clean install → train → serve → tests) | [docs/EXECUTION_LOG.md](docs/EXECUTION_LOG.md) |
| 🚀 Deployment guide (Docker, Render, Hugging Face Spaces) | [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md) |

Regenerate them at any time:

```bash
python -m ml.train_all                      # models, figures, model card
```

```bash
python -m scripts.evaluate_ocr              # OCR accuracy on scans & photos
```

```bash
python -m scripts.build_notebook            # executed notebook
```

```bash
node scripts/report/build_report.js         # Word report (npm install docx)
```

```bash
node scripts/report/build_presentation.js   # slides (npm install pptxgenjs react-icons react react-dom sharp)
```

---

## 📚 Documentation

* [Deployment guide](docs/DEPLOYMENT.md)
* [Architecture, DFD, use-case, ER & state diagrams, security controls](docs/ARCHITECTURE.md)
* [Model card (auto-generated metrics)](docs/MODEL_CARD.md)
* [Ethics, privacy, limitations & future scope](docs/ETHICS_PRIVACY_LIMITATIONS.md)
* [Project report outline](docs/REPORT_OUTLINE.md)
* [Viva questions & answers](docs/VIVA_QA.md)
* [Presentation outline & demo script](docs/PRESENTATION_OUTLINE.md)

---

## ⚖️ Disclaimer

This software is for education and research. It is **not** a substitute for professional medical advice, diagnosis or treatment. In an emergency in India call **112** (or **108** for an ambulance).

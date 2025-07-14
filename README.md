# 🧠 Smart Shell Assistant

> A natural language to shell command translator with fuzzy command history and safety validation — built with Bash.

---

## Overview

**SmartShell** is a terminal-based assistant that lets you type queries in plain English and translates them into real shell commands. It features:

- Natural language command translation using an LLM API
- Fuzzy-matched history suggestions for repeated queries
- Command safety confirmation before execution
- Automatic logging of all executed commands
- Modular Bash script architecture

---

## Project Structure

```bash
smart_shell/
├── scripts/
│   ├── smart.sh           # Main entry script
│   ├── llm_translate.sh   # Translates english to shell using LLM
│   ├── utils.sh           # Utility functions: logging, confirmation, etc.
│   └── ...
├── logs/                  # Auto-created log files
├── .env                   # Stores API key and config
└── README.md

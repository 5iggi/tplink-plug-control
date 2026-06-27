<p align="center">
  <img src="../../icons/icon_128.png" alt="TP-Link Plug Control Logo" width="96" height="96">
</p>

<h1 align="center">Installation</h1>

<p align="center">
  <a href="../index.md">Documentation index</a> ·
  <a href="README.md">Deutsch</a> ·
  <a href="../en/README.md">English</a> ·
  <a href="../../README.md">Repository README</a>
</p>

---

## Voraussetzungen

- LoxBerry mit Plugin-Verwaltung
- TP-Link/Kasa Smart Plug im lokalen Netzwerk
- Feste IP-Adresse oder DHCP-Reservierung empfohlen
- Optional: Loxone Config für XML-Import

## Installation

1. Plugin-ZIP über die LoxBerry Plugin-Verwaltung installieren.
2. Plugin öffnen.
3. Geräte per Autodiscovery suchen oder manuell eintragen.
4. Speichern.
5. Optional die Loxone XML-Dateien herunterladen und in Loxone Config importieren.

## Upgrade

Bei einem Upgrade wird die bestehende `devices.json` über die Upgrade-Hooks gesichert und wiederhergestellt.

## Konfiguration

```text
/opt/loxberry/config/plugins/tplink/devices.json
```

## Logdatei

```text
/opt/loxberry/log/plugins/tplink/tplink.log
```

---

<p align="center">
  <a href="README.md">⬅ Zurück zur Übersicht</a> ·
  <a href="../index.md">Dokumentation</a> ·
  <a href="https://github.com/5iggi/tplink-plug-control">GitHub</a>
</p>

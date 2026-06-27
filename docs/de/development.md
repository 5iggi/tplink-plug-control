<p align="center">
  <img src="../../icons/icon_128.png" alt="TP-Link Plug Control Logo" width="96" height="96">
</p>

<h1 align="center">Entwicklung</h1>

<p align="center">
  <a href="../index.md">Documentation index</a> ·
  <a href="README.md">Deutsch</a> ·
  <a href="../en/README.md">English</a> ·
  <a href="../../README.md">Repository README</a>
</p>

---

## Struktur

```text
bin/
webfrontend/htmlauth/
templates/
templates/lang/
icons/
docs/
uninstall/
```

## LoxBerry Hooks

```text
postinstall.sh
postroot.sh
preupgrade.sh
postupgrade.sh
uninstall/uninstall.sh
```

## Design-Entscheidungen

- Lokale Kommunikation zum Plug
- Keine TP-Link Cloud
- Loxone übernimmt Zeitprogramme und Automationen
- JQM-Buttons für LoxBerry-Icons
- Eigene `switch-ui` für Switch/LED-Toggle

## Tests

```bash
perl -c webfrontend/htmlauth/index.cgi
perl -c webfrontend/htmlauth/settings.cgi
perl -c webfrontend/htmlauth/control.cgi
perl -c webfrontend/htmlauth/status.cgi
perl -c bin/tplink_lib.pm
```

---

<p align="center">
  <a href="README.md">⬅ Zurück zur Übersicht</a> ·
  <a href="../index.md">Dokumentation</a> ·
  <a href="https://github.com/5iggi/tplink-plug-control">GitHub</a>
</p>

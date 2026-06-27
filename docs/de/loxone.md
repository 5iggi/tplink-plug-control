<p align="center">
  <img src="../../icons/icon_128.png" alt="TP-Link Plug Control Logo" width="96" height="96">
</p>

<h1 align="center">Loxone Integration</h1>

<p align="center">
  <a href="../index.md">Documentation index</a> ·
  <a href="README.md">Deutsch</a> ·
  <a href="../en/README.md">English</a> ·
  <a href="../../README.md">Repository README</a>
</p>

---

Das Plugin erzeugt zwei XML-Dateien:

```text
VO_TP-Link_Plug_Control.xml
VI_TP-Link_Plug_Control.xml
```

## Import

1. XML-Dateien im Plugin herunterladen.
2. In Loxone Config unter virtuelle Ein-/Ausgänge importieren.
3. In den URLs `username:password` ersetzen.
4. Virtuelle Befehle in die Programmierung ziehen.
5. Projekt speichern und in den Miniserver übertragen.

## Endpunkte

Virtual Output nutzt:

```text
/admin/plugins/tplink/control.cgi
```

Virtual Input HTTP nutzt:

```text
/admin/plugins/tplink/status.cgi
```

## Empfehlung

Zeitprogramme und Automationen sollten in Loxone umgesetzt werden. Interne Kasa-Regeln wie Schedule, Countdown und Away/Anti-Theft werden bewusst nicht vom Plugin verwaltet.

---

<p align="center">
  <a href="README.md">⬅ Zurück zur Übersicht</a> ·
  <a href="../index.md">Dokumentation</a> ·
  <a href="https://github.com/5iggi/tplink-plug-control">GitHub</a>
</p>

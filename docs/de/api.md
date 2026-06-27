<p align="center">
  <img src="../../icons/icon_128.png" alt="TP-Link Plug Control Logo" width="96" height="96">
</p>

<h1 align="center">HTTP API</h1>

<p align="center">
  <a href="../index.md">Documentation index</a> ·
  <a href="README.md">Deutsch</a> ·
  <a href="../en/README.md">English</a> ·
  <a href="../../README.md">Repository README</a>
</p>

---

## Steuerung

```text
/admin/plugins/tplink/control.cgi?ip=<IP>&command=<COMMAND>
/admin/plugins/tplink/control.cgi?device=<NAME>&command=<COMMAND>
```

## Kommandos

```text
on
off
state
info
led_on
led_off
time
power
voltage
current
energy
```

## Beispiele

```text
/admin/plugins/tplink/control.cgi?ip=192.168.222.217&command=on
/admin/plugins/tplink/control.cgi?ip=192.168.222.217&command=off
/admin/plugins/tplink/control.cgi?ip=192.168.222.217&command=info
/admin/plugins/tplink/control.cgi?device=kaffeemaschine&command=state
```

## Status JSON

```text
/admin/plugins/tplink/status.cgi
```

---

<p align="center">
  <a href="README.md">⬅ Zurück zur Übersicht</a> ·
  <a href="../index.md">Dokumentation</a> ·
  <a href="https://github.com/5iggi/tplink-plug-control">GitHub</a>
</p>

<p align="center">
  <img src="../../icons/icon_128.png" alt="TP-Link Plug Control Logo" width="96" height="96">
</p>

<h1 align="center">HTTP API</h1>

<p align="center">
  <a href="../index.md">Documentation index</a> ·
  <a href="README.md">English</a> ·
  <a href="../de/README.md">Deutsch</a> ·
  <a href="../../README.md">Repository README</a>
</p>

---

## Control

```text
/admin/plugins/tplink/control.cgi?ip=<IP>&command=<COMMAND>
/admin/plugins/tplink/control.cgi?device=<NAME>&command=<COMMAND>
```

## Commands

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

## Examples

```text
/admin/plugins/tplink/control.cgi?ip=192.168.222.217&command=on
/admin/plugins/tplink/control.cgi?ip=192.168.222.217&command=off
/admin/plugins/tplink/control.cgi?ip=192.168.222.217&command=info
```

## Status JSON

```text
/admin/plugins/tplink/status.cgi
```

---

<p align="center">
  <a href="README.md">⬅ Back to overview</a> ·
  <a href="../index.md">Documentation</a> ·
  <a href="https://github.com/5iggi/tplink-plug-control">GitHub</a>
</p>

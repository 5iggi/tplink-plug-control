<p align="center">
  <img src="../../icons/icon_128.png" alt="TP-Link Plug Control Logo" width="96" height="96">
</p>

<h1 align="center">Development</h1>

<p align="center">
  <a href="../index.md">Documentation index</a> ·
  <a href="README.md">English</a> ·
  <a href="../de/README.md">Deutsch</a> ·
  <a href="../../README.md">Repository README</a>
</p>

---

## Structure

```text
bin/
webfrontend/htmlauth/
templates/
templates/lang/
icons/
docs/
uninstall/
```

## LoxBerry hooks

```text
postinstall.sh
postroot.sh
preupgrade.sh
postupgrade.sh
uninstall/uninstall.sh
```

## Design decisions

- Local communication with the plug
- No TP-Link Cloud required
- Loxone handles schedules and automation
- JQM buttons for LoxBerry icons
- Custom `switch-ui` for Switch/LED toggle

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
  <a href="README.md">⬅ Back to overview</a> ·
  <a href="../index.md">Documentation</a> ·
  <a href="https://github.com/5iggi/tplink-plug-control">GitHub</a>
</p>

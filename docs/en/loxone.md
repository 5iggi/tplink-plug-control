<p align="center">
  <img src="../../icons/icon_128.png" alt="TP-Link Plug Control Logo" width="96" height="96">
</p>

<h1 align="center">Loxone integration</h1>

<p align="center">
  <a href="../index.md">Documentation index</a> ·
  <a href="README.md">English</a> ·
  <a href="../de/README.md">Deutsch</a> ·
  <a href="../../README.md">Repository README</a>
</p>

---

The plugin generates two XML files:

```text
VO_TP-Link_Plug_Control.xml
VI_TP-Link_Plug_Control.xml
```

## Import

1. Download the XML files from the plugin.
2. Import them in Loxone Config under virtual inputs/outputs.
3. Replace `username:password` in the URLs.
4. Drag the virtual commands into your program.
5. Save and transfer the project to the Miniserver.

## Endpoints

Virtual Output uses:

```text
/admin/plugins/tplink/control.cgi
```

Virtual Input HTTP uses:

```text
/admin/plugins/tplink/status.cgi
```

## Recommendation

Schedules and automation should be handled in Loxone. Internal Kasa rules such as Schedule, Countdown and Away/Anti-Theft are intentionally not managed by the plugin.

---

<p align="center">
  <a href="README.md">⬅ Back to overview</a> ·
  <a href="../index.md">Documentation</a> ·
  <a href="https://github.com/5iggi/tplink-plug-control">GitHub</a>
</p>

# HTTP API

## control.cgi

Basis:

```text
/admin/plugins/tplink/control.cgi?ip=<IP>&command=<COMMAND>
```

## Kommandos

### Relais einschalten

```text
/admin/plugins/tplink/control.cgi?ip=192.168.222.217&command=on
```

### Relais ausschalten

```text
/admin/plugins/tplink/control.cgi?ip=192.168.222.217&command=off
```

### Status auslesen

```text
/admin/plugins/tplink/control.cgi?ip=192.168.222.217&command=state
```

### Geräteinformationen

```text
/admin/plugins/tplink/control.cgi?ip=192.168.222.217&command=info
```

### LED ein/aus

```text
/admin/plugins/tplink/control.cgi?ip=192.168.222.217&command=led_on
/admin/plugins/tplink/control.cgi?ip=192.168.222.217&command=led_off
```

### Zeit auslesen

```text
/admin/plugins/tplink/control.cgi?ip=192.168.222.217&command=time
```

## status.cgi

```text
/admin/plugins/tplink/status.cgi
```

Liefert JSON für alle aktivierten Geräte.

Beispiel:

```json
{
  "dachboden_state": 1,
  "dachboden_online": 1,
  "dachboden_power": 0,
  "dachboden_voltage": 0,
  "dachboden_current": 0,
  "dachboden_energy": 0
}
```

## Konsolentest

```bash
sudo -u loxberry perl -I/opt/loxberry/bin/plugins/tplink \
-Mtplink_lib=tplink_cmd \
-e 'my ($ok,$obj,$raw)=tplink_cmd("192.168.222.217","info",undef,5); print "$raw\n";'
```

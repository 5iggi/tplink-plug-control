# Loxone Integration

Das Plugin stellt XML-Vorlagen für Loxone bereit.

## XML-Dateien

In der Plugin-Weboberfläche können diese Dateien heruntergeladen werden:

```text
VO_TP-Link_Plug_Control.xml
VI_TP-Link_Plug_Control.xml
```

## Virtual Output

Der Virtual Output dient zum Schalten der Plugs.

Beispiele für generierte HTTP-Kommandos:

```text
/admin/plugins/tplink/control.cgi?ip=192.168.222.217&command=on
/admin/plugins/tplink/control.cgi?ip=192.168.222.217&command=off
```

## Virtual Input HTTP

Der Virtual Input HTTP fragt zyklisch den Status-Endpunkt ab:

```text
/admin/plugins/tplink/status.cgi
```

Der Rückgabewert ist JSON.

Beispiel:

```json
{
  "dachboden_state": 1,
  "dachboden_online": 1,
  "dachboden_power": 12.3,
  "dachboden_voltage": 230.1,
  "dachboden_current": 0.08,
  "dachboden_energy": 1.42
}
```

## Import in Loxone Config

1. XML-Dateien aus dem Plugin herunterladen.
2. In Loxone Config unter virtuelle Ein-/Ausgänge importieren.
3. In den URLs diesen Platzhalter ersetzen:

```text
username:password
```

4. Prüfen, ob die LoxBerry-Adresse korrekt ist.
5. Virtuelle Befehle in die Programmierung ziehen.
6. Projekt speichern und in den Miniserver übertragen.

## Empfehlung

Zeitprogramme und Automationen sollten in Loxone umgesetzt werden. Die internen Kasa-Funktionen Schedule, Countdown und Away/Anti-Theft werden vom Plugin bewusst nicht verwaltet.

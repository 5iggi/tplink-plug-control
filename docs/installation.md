# Installation

## Voraussetzungen

- LoxBerry mit Plugin-Verwaltung
- TP-Link/Kasa Smart Plug im lokalen Netzwerk
- Feste IP-Adresse oder DHCP-Reservierung für jeden Plug empfohlen
- Optional: Loxone Config für XML-Import

## Installation über LoxBerry

1. Plugin-ZIP herunterladen.
2. In LoxBerry öffnen:

```text
Plugins → Plugin-Verwaltung → Plugin installieren
```

3. Plugin-ZIP auswählen und installieren.
4. Nach der Installation das Plugin öffnen.
5. Geräte per Autodiscovery suchen oder manuell eintragen.
6. Speichern.

## Upgrade

Bei einem Upgrade wird die bestehende `devices.json` über die Upgrade-Hooks gesichert und wiederhergestellt.

Relevante Dateien:

```text
preupgrade.sh
postupgrade.sh
```

## Konfigurationsdatei

Die Gerätekonfiguration wird im LoxBerry-Konfigurationsverzeichnis des Plugins gespeichert:

```text
/opt/loxberry/config/plugins/tplink/devices.json
```

Beispiel:

```json
{
  "devices": [
    {
      "id": "dachboden",
      "name": "Dachboden",
      "ip": "192.168.222.217",
      "type": "auto",
      "enabled": 1
    }
  ]
}
```

## Logdatei

Die Logdatei liegt unter:

```text
/opt/loxberry/log/plugins/tplink/tplink.log
```

Sie kann über den LoxBerry-Logviewer geöffnet werden.

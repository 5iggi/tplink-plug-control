# Entwicklung

## Ziel

Das Plugin soll TP-Link/Kasa Smart Plugs lokal über das klassische TP-Link-SmartHome-Protokoll steuern und für Loxone nutzbar machen.

## Design-Entscheidungen

### Keine Verwaltung von Kasa-internen Regeln

Die folgenden geräteinternen Funktionen werden bewusst nicht im Frontend verwaltet:

- Schedule
- Countdown
- Away / Anti-Theft

Begründung: In einem Loxone-Setup sollte Zeitlogik und Automation zentral in Loxone erfolgen.

### JQM-Buttons für LoxBerry-Icons

Die Oberfläche verwendet klassische LoxBerry/jQuery-Mobile-Buttons mit:

```html
data-role="button"
data-icon="info"
data-mini="true"
data-inline="true"
```

So werden die im LoxBerry vorhandenen Button-Icons genutzt.

### Switch-UI

Für Switch/LED wird ein eigenes Toggle-Element genutzt:

```html
<span class="switch-ui" aria-hidden="true"></span>
```

Der Toggle zeigt den Zustand. Der Text zeigt die Aktion.

## Hook-Skripte

Verwendete LoxBerry-Hooks:

```text
postinstall.sh
postroot.sh
preupgrade.sh
postupgrade.sh
uninstall/uninstall.sh
```

## Tests

Perl-Syntax prüfen:

```bash
perl -c webfrontend/htmlauth/index.cgi
perl -c webfrontend/htmlauth/settings.cgi
perl -c webfrontend/htmlauth/control.cgi
perl -c webfrontend/htmlauth/status.cgi
perl -c bin/tplink_lib.pm
```

Shell-Skripte prüfen:

```bash
bash -n postinstall.sh
bash -n preupgrade.sh
bash -n postupgrade.sh
bash -n uninstall/uninstall.sh
```

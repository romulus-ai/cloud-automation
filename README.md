# cloud

This Repo contains everything needed to deploy my Cloud Server on a Ubuntu Box, currently tested with Ubuntu 20.04.

The Folder "ansible" contains all the logic and playbooks to deploy everything needed and endup with a fully functional box.

The Folder "docker" contains all the description to deploy the single docker components needed, by using docker-compose.

The Folder "vagrant" contains a description for a vargant box that can be used to test everything.

Encrypt Strings containing sensitiv information:

```bash
ansible-vault encrypt_string --ask-vault-pass 'STRING TO ENCRYPT'
```

Using the Playbook to configure the cloud:

```bash
ansible-playbook -i inventory.test.yaml ./basic-install.yaml --ask-vault-pass
```

Restore the Cloud from a backup:

```bash
ansible-playbook -i inventory.test.yaml ./restore-nextcloud.yaml --ask-vault-pass
```

## TODOs

* Autodeployment (Idee):
  * unpriviligierten User anlegen der idealerweise in chroot umgebung ist
  * SSH key ohne passwort erstellen um Repo auszuchecken (für root auf cloud)
  * Gleichen SSH Key nutzen um auf cloud und raspi rootaccess zu bekommen
  * cronjob anlegen der prüft ob in chroot von unpriviligiertem User eine deploy datei erstellt wurde (diese kann schlüsselwörter wie "check" oder "prod" enthalten um den ansible mode zu bestimmen)
  * wenn die Datei existiert, wird ein deployment gestartet
  * Github Action erstellen die über unpriviligierten User die deploy datei anlegt
* Prometheus Exporter/Metriken hinzufügen:
  * Wechselrichter auslesen: https://github.com/tonobo/sma_exporter
    * Kapitel 8.4: https://files.sma.de/downloads/STP5-12TL-20-BE-de-15.pdf
* Überwachung auf neuere Docker Images bzw. neue Softwareversionen ("https://crazymax.dev/diun/providers/docker/)
  * Aufbau einer autodeploy Struktur, siehe u.a. branches hier
  * Erstellen eines Branches + PR über "update-docker-images.sh" skript
  * Automatische Mailbenachrichtigung via Github Actions
  * Via Github Actions nach dem Merge, eine Datei auf dem SRV anlegen (oder das repo regelmäßig pullen und bei änderungen, diese einspielen)
  * Wenn änderungen da sind, bzw. die Datei da ist, via ansible auf dem eigenen Server den Server aktualisieren

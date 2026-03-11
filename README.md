# OVH DynDNS Client (Deno) – Docker Compose

Ein schlanker DynDNS-Client für **OVH DynHost**, geschrieben in **TypeScript** und als **native Deno-Binary** kompiliert.  
Er überwacht deine öffentliche IP und aktualisiert automatisch deinen OVH DynHost A/AAAA Record.  
Enthält einen **HTTP Healthcheck** und **Status Endpoint**, perfekt für Docker/Kubernetes.

---

## Features

- DynDNS für **OVH DynHost**
- Docker-Ready mit Multi-Stage Build
- Native Deno Binary → kein Node/Bun nötig
- Einfach konfigurierbar via Environment-Variablen

---

## Docker Compose Vorlage

Datei: `docker-compose.yml`

```yaml id="x5k2hg"
services:
  dyndns:
    image: speedfighter/dyndns-updater-ovh:latest
    container_name: ovh-dyndns
    environment:
      OVH_HOST: home.example.com
      OVH_USER: dyndnsuser
      OVH_PASS: password
      INTERVAL: 300000       # optional, ms
    volumes:
      - ./data:/data
    restart: unless-stopped
```

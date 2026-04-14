# Checklist — Grabación del vídeo y día de la defensa

---

## PARTE 1: Día de grabación del vídeo

### Antes de encender las VMs

```text
[ ] OBS Studio instalado y configurado (1920×1080, 30 fps, bitrate ≥ 8000 kbps)
[ ] Hacer una grabación de prueba de 30 s → reproducir → confirmar que se lee el terminal
[ ] Fuente del terminal ajustada a 16–18 pt
[ ] Tema del terminal: fondo negro, texto verde o blanco
[ ] Reloj del host (barra de tareas) visible y en hora correcta
[ ] Disco duro con al menos 10 GB libres para la grabación
[ ] Micro externo conectado y probado (para la narración posterior)
[ ] Portátil conectado a corriente (no grabar con batería)
[ ] Cerrar todas las aplicaciones que no sean VMware, navegador y terminal
[ ] Desactivar notificaciones del sistema operativo (modo "no molestar")
```

### Encendido del laboratorio

```text
[ ] Iniciar VM-01 OPNsense → esperar menú de consola
[ ] Iniciar VM-02 FreeIPA → esperar prompt de login
[ ] Iniciar VM-03 Wazuh AIO → esperar a que los 3 contenedores estén Up:
      docker ps → manager, indexer, dashboard con status "Up"
[ ] Iniciar VM-04 Logs/BD → docker ps → MariaDB Up
      systemctl status rsyslog → active (running)
[ ] Iniciar VM-05 Cliente → verificar IP: ip addr show → 10.10.10.10
```

### Verificaciones pre-grabación

```text
[ ] Acceso a https://10.10.99.1  (OPNsense WebUI) → OK
[ ] Acceso a https://10.10.20.10 (FreeIPA WebUI) → OK
[ ] Acceso a https://10.10.20.20 (Wazuh Dashboard) → OK
[ ] Agente VM-05 aparece como Active en Wazuh Dashboard > Agents
[ ] nmap instalado en VM-05: nmap --version
[ ] hydra instalado en VM-05: hydra -h | head -1
[ ] IP 10.10.10.10 NO está bloqueada en VM-02:
      sudo iptables -L INPUT -n | grep 10.10.10.10   (no debe salir nada)
[ ] /etc/passwd en VM-05 no está modificado (o tiene backup):
      sudo cp /etc/passwd /etc/passwd.bak
[ ] Limpiar alertas antiguas en Wazuh Dashboard (opcional pero recomendado)
[ ] MariaDB responde: mysql -u analyst -p -h 127.0.0.1 siem_logs -e "SELECT 1;"
```

### Durante la grabación

```text
[ ] Grabar en el orden indicado en GUION_VIDEO_DEMO.md:
      B4 → B6 → B8 → B2+B3 → B7 → B5 → B1
[ ] Tras cada bloque, pausar OBS (no parar la grabación si se puede evitar)
[ ] Si Hydra falla o el timing no cuadra → repetir SOLO ese bloque
[ ] Entre B4 y B5, desbloquear 10.10.10.10 en VM-02:
      sudo iptables -D INPUT -s 10.10.10.10 -j DROP
[ ] Tras B6, restaurar /etc/passwd:
      sudo cp /etc/passwd.bak /etc/passwd
```

### Postproducción

```text
[ ] Añadir slides de carátula (B0) y cierre (B9)
[ ] Añadir título-overlay de 3 s al inicio de cada bloque:
      "BLOQUE 2 — PR-01: Segmentación de red"
      "BLOQUE 4 — PR-03: Fuerza bruta SSH + Respuesta automática"
      etc.
[ ] Si hay esperas largas (FIM, arranque) → acelerar ×2 con overlay "[acelerado ×2]"
[ ] Cortar tiempos muertos (errores de tecleo, cargas) EXCEPTO en secuencias causa-efecto
[ ] Grabar voz en off leyendo NARRACION_VOZ_EN_OFF.md
[ ] Sincronizar audio con vídeo
[ ] Exportar a MP4 (H.264, 1080p)
[ ] Reproducir el vídeo completo una vez antes de darlo por bueno
[ ] Verificar que se lee el terminal en una pantalla de portátil (simular proyector)
```

---

## PARTE 2: Día de la defensa

### Material que llevar

```text
[ ] Portátil con el PPTX cargado y probado
[ ] Cable HDMI / adaptador para el proyector del aula
[ ] Vídeo demostrativo en el portátil (no depender de Internet)
[ ] Copia del vídeo en USB de backup
[ ] Copia impresa de las speaker notes del PPTX
[ ] Copia impresa de BANCO_PREGUNTAS_TRIBUNAL.md (por si acaso)
[ ] Copia de la memoria (PDF) en el portátil por si el tribunal pide ver algo
[ ] Botella de agua
```

### Antes de entrar al aula

```text
[ ] Comprobar que el proyector funciona con el portátil
[ ] Comprobar que los colores de las slides se ven bien (el navy oscuro puede comer texto)
[ ] Abrir el PPTX en modo presentación
[ ] Tener el vídeo listo para reproducir (no buscar en carpetas durante la defensa)
[ ] Silenciar el móvil
```

### Durante la exposición

```text
[ ] Esperar a que el presidente dé la palabra
[ ] Saludo breve: "Buenos días / buenas tardes. Gracias."
[ ] No leer las slides — las slides son el esqueleto, tú pones la carne
[ ] Hablar al tribunal, no a la pantalla
[ ] Frases cortas, vocalizar, modular la voz
[ ] Dar datos numéricos concretos (3 s, 42 s, 1847 eventos, 9/9 pruebas)
[ ] Antes de proyectar el vídeo: "Con el permiso del tribunal..."
[ ] Al terminar: "Con esto concluyo y quedo a disposición del tribunal."
```

### Durante las preguntas

```text
[ ] Escuchar la pregunta completa antes de responder
[ ] Responder directo: dato → contexto → referencia a capítulo/sección
[ ] Si no sabes: "Eso no lo he explorado, pero sería una línea de trabajo futuro."
[ ] No polemizar, no justificar la justificación
[ ] Agrupar si hacen varias preguntas seguidas
[ ] Mantener el trato de "usted"
[ ] Al terminar el turno: agradecer al tribunal
```

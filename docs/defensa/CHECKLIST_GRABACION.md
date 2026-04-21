# Checklist — Grabación del vídeo, subida a Moodle y día de la defensa

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

### Extraer los 2 clips para la defensa en directo

```text
[ ] CLIP 1 — Hydra + active response (~90 s):
      Desde el inicio de B4 (pantalla triple) hasta la verificación del bloqueo en iptables.
      Exportar como fichero independiente: clip_pr03_hydra.mp4
[ ] CLIP 2 — Segregación MariaDB (~60 s):
      Desde el paso 7.3 (consulta analyst) hasta el paso 7.6 (error rsyslog SELECT).
      Exportar como fichero independiente: clip_pr08_segregacion.mp4
[ ] Reproducir ambos clips → confirmar que se leen bien y tienen audio
```

---

## PARTE 2: Subida a Moodle

### Tarea "Presentaciones y material de apoyo"

Según las instrucciones del centro, hay que subir:

```text
[ ] 1. Índice de la exposición
      → Exportar slide 2 del PPTX como PDF o imagen (indice_exposicion.pdf)

[ ] 2. PPTX de 16 slides
      → defensa_zerotrust_v2.pptx (o el nombre que le des)

[ ] 3. Esquema gráfico del sistema
      → Exportar slide 5 (diagrama de arquitectura) como imagen PNG
      → También vale el diagrama del README.md del repo

[ ] 4. Esquema de la base de datos
      → Exportar el esquema siem_logs (5 tablas 3FN)
      → Opción 1: captura de pantalla del modelo relacional
      → Opción 2: el fichero init.sql del repositorio

[ ] 5. Bibliografía
      → Extraer la sección "Bibliografía" de la memoria (páginas 101-102 del PDF)
      → Exportar como PDF independiente o incluir como última slide
```

### Tarea "Vídeos"

```text
[ ] 1. Subir el vídeo completo (~11 min) a una plataforma:
      → YouTube (como "no listado") — opción recomendada
      → Google Drive (compartir con enlace, acceso "cualquier persona con el enlace")
      → OneDrive como alternativa

[ ] 2. Copiar el enlace del vídeo

[ ] 3. Pegar el enlace en la tarea de Moodle "Vídeos para las presentaciones"

[ ] 4. Verificar que el enlace funciona desde otro navegador / modo incógnito
```

---

## PARTE 3: Día de la defensa

### Material que llevar

```text
[ ] Portátil con el PPTX cargado y probado
[ ] Cable HDMI / adaptador para el proyector del aula
[ ] Los 2 clips de vídeo en el portátil (clip_pr03_hydra.mp4 y clip_pr08_segregacion.mp4)
[ ] Vídeo completo en el portátil como backup (por si piden verlo)
[ ] Copia de todo en USB de emergencia
[ ] Copia impresa de las speaker notes del PPTX
[ ] Copia impresa de BANCO_PREGUNTAS_TRIBUNAL.md
[ ] Copia de la memoria (PDF) en el portátil por si piden ver algo
[ ] Botella de agua
```

### Antes de entrar al aula

```text
[ ] Llegar con antelación (puntualidad — lo pide el centro)
[ ] Comprobar que el proyector funciona con el portátil
[ ] Comprobar que los colores del PPTX se ven bien proyectados
[ ] Abrir el PPTX en modo presentación
[ ] Tener los 2 clips preparados para reproducir (no buscar en carpetas)
[ ] Probar el audio de los clips en el aula (si tienen narración)
[ ] Silenciar el móvil
```

### Durante la exposición (25 min máximo)

```text
[ ] Esperar a que el profesorado dé la palabra
[ ] Saludo breve: "Buenos días / buenas tardes. Gracias."
[ ] No leer las slides — las slides son el esqueleto, tú pones la carne
[ ] Hablar al tribunal, no a la pantalla
[ ] Frases cortas, vocalizar, modular la voz
[ ] Dar datos numéricos concretos (3 s, 42 s, 1.847 eventos, 528:1)
[ ] Antes de cada clip: "Voy a mostrar una grabación del laboratorio en funcionamiento."
[ ] Si un clip falla: describir lo que se vería, con datos concretos. No entrar en pánico.
[ ] Controlar el tiempo: ~1 min 30 s por slide, 2 clips de ~90 s y ~60 s
[ ] Al terminar: "Con esto concluyo y quedo a disposición del profesorado."
```

### Durante las preguntas

```text
[ ] Escuchar la pregunta completa antes de responder
[ ] Responder directo: dato → contexto → referencia a capítulo/sección
[ ] Si no sabes: "Eso no lo he explorado, pero sería una línea de trabajo futuro."
[ ] No polemizar, no justificar la justificación
[ ] Agrupar si hacen varias preguntas seguidas
[ ] Mantener el trato de "usted"
[ ] Al terminar el turno: agradecer al profesorado
```

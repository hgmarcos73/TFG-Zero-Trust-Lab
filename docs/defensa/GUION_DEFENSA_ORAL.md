# Guion de la defensa oral ante el tribunal

> **Duración máxima:** 25 minutos (exposición + clips de vídeo) + turno de preguntas  
> **Soporte visual:** PPTX de 16 slides  
> **Vídeo:** 2 clips cortos integrados durante la exposición (~2.5 min). Vídeo completo (~11 min) subido a Moodle.  
> **Normativa:** Instrucciones I.E.S. Al-Ándalus — Proyecto Intermodular ASIR

---

## Criterios de evaluación (según instrucciones del centro)

- Claridad expositiva
- Concisión
- Dominio del contenido
- Capacidad de síntesis
- Calidad técnica del proyecto
- Uso adecuado de recursos de apoyo
- Correcta demostración del sistema

---

## Antes de empezar

- No empezar hasta que el profesorado dé la palabra.
- Trato de "usted" con el tribunal en todo momento, incluido el turno de preguntas.
- Las speaker notes del PPTX contienen el guion completo. Llevar una copia impresa como backup.
- Tener los 2 clips de vídeo preparados para reproducir sin buscar en carpetas.
- Verificar con antelación que el proyector, el sonido y el PPTX funcionan correctamente.

---

## Estructura de la exposición — 16 slides + 2 clips

### Slide 1 — Carátula (30 s)

> Buenos días / buenas tardes. Gracias.
> Mi proyecto se titula "Implementación Avanzada de Arquitectura Zero Trust con SIEM, Base de Datos y Contenedores".
> El objetivo es demostrar que una arquitectura de ciberseguridad corporativa basada en el modelo Zero Trust es viable con software libre y hardware modesto.

### Slide 2 — Índice (30 s)

> La exposición sigue la estructura de la memoria: problema, diseño, implementación con demostración práctica, problemas encontrados y conclusiones.

### Slide 3 — Problema de partida (90 s)

> TechSecure Solutions es una consultora TI simulada. Su infraestructura inicial tenía cuatro vulnerabilidades críticas.
> Red plana: cualquier equipo comprometido accede a toda la red.
> Sin SIEM: los incidentes no se detectan.
> Sin identidad centralizada: no hay control de acceso.
> Sin trazabilidad: si pasa algo, no hay registros.
> El proyecto resuelve estos cuatro problemas con un stack 100 % open source.

### Slide 4 — ¿Qué es Zero Trust? (60 s)

> El modelo Zero Trust del NIST SP 800-207 propone eliminar la confianza implícita basada en la ubicación.
> En el modelo perimetral clásico, si estás dentro de la red, tienes acceso.
> En Zero Trust, cada acceso se verifica: quién eres, desde dónde, a qué recurso, con qué permisos.
> Cuatro principios clave: verificación explícita, mínimo privilegio, asumir la brecha y monitorización continua.

### Slide 5 — Arquitectura del laboratorio (90 s)

> La solución estructura la red en cinco zonas aisladas mediante VLANs sobre VMware Workstation Pro.
> Cinco máquinas virtuales. Todo el tráfico entre zonas pasa por OPNsense con política deny-by-default.
> VM-01 OPNsense: firewall, Suricata IDS y WireGuard VPN.
> VM-02 FreeIPA: identidad centralizada con LDAP, Kerberos y DNS.
> VM-03 Wazuh AIO en Docker: el SIEM con correlación y respuesta activa.
> VM-04 MariaDB en Docker más Rsyslog nativo: la base de datos de logs.
> VM-05: el cliente con agente Wazuh.
> El orden de arranque es obligatorio y está documentado.

### Slide 6 — Stack tecnológico (60 s)

> Siete herramientas, todas open source.
> Docker Compose gestiona Wazuh y MariaDB.
> Rsyslog se mantiene nativo: el módulo ommysql necesita acceso TCP directo a MariaDB y el socket UDP 514 tiene problemas de permisos dentro de contenedores.

### Slide 7 — Marco normativo (60 s)

> El proyecto cumple tres marcos normativos simultáneamente.
> NIST SP 800-207: siete principios Zero Trust cubiertos con evidencia.
> ENS categoría MEDIA: el perfil de riesgo de una PYME con datos internos. ALTA exigiría alta disponibilidad y cifrado extremo a extremo, que exceden el alcance del proyecto.
> RGPD: retención de logs limitada a 365 días con purga automática y segregación de privilegios en la base de datos.

### Slide 8 — Perímetro: OPNsense + Suricata (90 s)

> OPNsense gestiona cinco interfaces: WAN, LAN, Servidores, DMZ reservada y Gestión.
> La política es deny-by-default: desde la VLAN de clientes solo se permiten los puertos 1514 y 1515 hacia Wazuh. Nada más.
> Suricata corre en modo IPS inline: no solo detecta, bloquea en tiempo real con el ruleset ET Open.
> Los logs del firewall se reenvían a Wazuh por UDP 514.
> WireGuard da acceso VPN solo a la VLAN de gestión. AllowedIPs restringe el túnel a la 10.10.99.0/24.

### Slide 9 — Identidad: FreeIPA (60 s)

> FreeIPA centraliza la autenticación con LDAP, Kerberos y DNS propios.
> Cuatro usuarios, tres grupos.
> Las políticas HBAC determinan qué usuario puede acceder a qué máquina con qué servicio.
> Si un operador intenta hacer SSH al servidor de identidad, FreeIPA lo deniega antes de evaluar la contraseña.

### Slide 10 — SIEM: Wazuh AIO (60 s)

> Wazuh se despliega como All-in-One con Docker Compose: tres contenedores — Manager, Indexer y Dashboard.
> Las reglas personalizadas 100001 y 100002 detectan fuerza bruta SSH y escaneo de puertos.
> La respuesta activa bloquea al atacante en iptables en 3 segundos.
> Ahora voy a mostrar cómo funciona esto en la práctica.

**→ CLIP DE VÍDEO 1: Hydra + active response (~90 s)**

> Esto es una grabación del laboratorio en funcionamiento.
> A la izquierda el atacante lanzando Hydra contra el servidor FreeIPA.
> Arriba a la derecha el Dashboard de Wazuh en tiempo real.
> Abajo los logs SSH del servidor atacado.
> Tras seis intentos fallidos, Wazuh dispara la regla 100001, nivel 10, etiquetada como MITRE T1110 — fuerza bruta.
> La respuesta activa bloquea la IP del atacante en iptables. El ataque queda contenido en 3 segundos.

### Slide 11 — Logs y base de datos (60 s)

> Rsyslog recibe los logs por UDP 514 y los inserta en MariaDB mediante ommysql.
> El esquema tiene cinco tablas normalizadas hasta la tercera forma normal.
> La segregación de privilegios es clave: el usuario rsyslog solo inserta, el analyst solo lee, nadie puede borrar.

### Slide 12 — Flujo end-to-end (60 s)

> El flujo completo funciona de extremo a extremo.
> Un evento generado en el cliente es capturado por el agente, correlacionado por el Manager, visible en el Dashboard en menos de 30 segundos y persistido en MariaDB.
> 1.847 eventos registrados en 24 horas de operación continua.

### Slide 13 — Resultados de validación (60 s)

> Nueve pruebas funcionales, nueve resultados PASS.
> Ocho objetivos cumplidos con evidencia.
> Siete principios Zero Trust cubiertos.
> Para cerrar la demostración, muestro la segregación de privilegios en MariaDB.

**→ CLIP DE VÍDEO 2: Segregación en MariaDB (~60 s)**

> El usuario analyst consulta los registros sin problema.
> Cuando intenta insertar: error 1142, permiso denegado.
> Y al revés: el usuario rsyslog no puede leer lo que él mismo inserta.
> Mínimo privilegio verificado a nivel de base de datos.

### Slide 14 — Dificultades reales (90 s)

> Cinco problemas reales de integración, todos resueltos.
> pfSense descontinuó su edición Community: migré a OPNsense en 12 horas.
> El parámetro vm.max_map_count del kernel era insuficiente para el Indexer de Wazuh.
> Las reglas personalizadas se perdían sin volumen Docker mapeado.
> El FIM por defecto revisaba cada 12 horas: cambié a tiempo real con inotify, bajando a 42 segundos.
> Y el paquete rsyslog-mysql no viene instalado en Ubuntu 22.04: el error es silencioso.

### Slide 15 — Presupuesto (60 s)

> El proyecto ha costado 21 euros y 60 céntimos: solo consumo eléctrico.
> Todo el software es open source.
> Si una empresa contratara esto como consultoría, el coste sería de 11.400 euros.
> Ratio conocimiento-inversión: 528 a 1.

### Slide 16 — Conclusiones y trabajo futuro (60 s)

> Los ocho objetivos se han cumplido con evidencia empírica verificable.
> Zero Trust es viable con software libre y hardware modesto.
> Las líneas de trabajo futuro son cuatro: alta disponibilidad, automatización SOAR, microsegmentación por identidad y extensión a cloud.
>
> Con esto doy por concluida la exposición y quedo a disposición del profesorado para las preguntas que consideren oportunas.

---

## Distribución de tiempo

```
Slide 1   Carátula ..................  0:30
Slide 2   Índice ....................  0:30
Slide 3   Problema ..................  1:30
Slide 4   Zero Trust ................  1:00
Slide 5   Arquitectura ..............  1:30
Slide 6   Stack tecnológico .........  1:00
Slide 7   Marco normativo ...........  1:00
Slide 8   Perímetro OPNsense ........  1:30
Slide 9   Identidad FreeIPA .........  1:00
Slide 10  SIEM Wazuh ................  1:00
  → CLIP 1: Hydra + bloqueo ........  1:30
Slide 11  Logs + MariaDB ............  1:00
Slide 12  Flujo end-to-end ..........  1:00
Slide 13  Resultados ................  1:00
  → CLIP 2: Segregación BD .........  1:00
Slide 14  Dificultades ..............  1:30
Slide 15  Presupuesto ...............  1:00
Slide 16  Conclusiones + cierre .....  1:00
───────────────────────────────────────────
TOTAL ≈ 19 min 30 s
Margen para imprevistos: 5 min 30 s
```

---

## Notas de oratoria

- **No leer las slides.** Las slides son el esqueleto; tú pones la carne.
- **Hablar al tribunal**, no a la pantalla. Girar el cuerpo hacia ellos.
- **Frases cortas.** Vocalizar. Modular la voz.
- **Si te quedas en blanco**, mira la slide y retoma. Las speaker notes impresas son el salvavidas.
- **Dar datos numéricos concretos:** 3 s, 42 s, 1.847 eventos, 528:1. Los datos impresionan.
- **Referirse a capítulos** de la memoria si la pregunta lo requiere.
- **Antes de cada clip de vídeo:** "Voy a mostrar ahora una grabación del laboratorio en funcionamiento."
- **Si el vídeo falla:** describir lo que debería verse, con datos concretos. No entrar en pánico.

---

## Turno de preguntas — Reglas

- Escuchar la pregunta completa antes de responder.
- Responder directo: dato → contexto → referencia a la memoria.
- Si no sabes algo: "Eso no lo he explorado en este proyecto, pero sería una línea interesante de trabajo futuro."
- Agrupar respuestas si hacen varias preguntas seguidas.
- No polemizar. Humildad intelectual.
- Agradecer al profesorado al terminar.

Las preguntas probables están en `BANCO_PREGUNTAS_TRIBUNAL.md`.

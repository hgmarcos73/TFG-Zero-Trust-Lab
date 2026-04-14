# Guion de la defensa oral ante el tribunal

> **Duración objetivo:** 15–20 minutos (exposición) + turno de preguntas  
> **Soporte visual:** PPTX de 12 slides con paleta navy/teal  
> **Recurso adicional:** Vídeo demostrativo (10–12 min) proyectado tras la exposición o durante ella

---

## Antes de empezar

- No empezar hasta que el presidente del tribunal dé la palabra.
- Si el presidente ya ha presentado el título y el nombre del alumno, no repetirlo.
- Arranque: saludo breve y directo.
- Trato de "usted" con el tribunal en todo momento, incluido el turno de preguntas.
- Las speaker notes del PPTX contienen el guion completo. Llevar una copia impresa como backup.

---

## Estructura de la exposición

### Apertura (1 min) — Slide 1

> Buenos días / buenas tardes. Gracias.
> Mi proyecto se titula "Implementación Avanzada de Arquitectura Zero Trust con SIEM, Base de Datos y Contenedores".
> El objetivo es demostrar que una arquitectura de ciberseguridad corporativa basada en el modelo Zero Trust es viable con software libre y hardware modesto.

### Contexto y problema (2 min) — Slides 2–3

**Idea central:** Los firewalls perimetrales clásicos asumen que la red interna es segura. Con movilidad, cloud y ataques laterales, eso ya no vale.

> La empresa simulada, TechSecure Solutions, necesita una arquitectura que no confíe en ningún segmento de red por defecto.
> El modelo de referencia es el NIST SP 800-207: cada acceso se autentica, se autoriza y se registra.
> El marco normativo incluye el Esquema Nacional de Seguridad categoría MEDIA y el RGPD.

### Arquitectura del laboratorio (3 min) — Slides 4–5

**Apoyar en el diagrama de las 5 VMs y las VLANs.**

> El laboratorio consta de cinco máquinas virtuales sobre VMware Workstation.
> La red se segmenta en cuatro VLANs más la WAN.
> Todo el tráfico entre zonas pasa por OPNsense, que aplica deny-by-default.
>
> VM-01 OPNsense: firewall, Suricata IDS y WireGuard VPN.
> VM-02 FreeIPA: identidad centralizada con LDAP, Kerberos y DNS.
> VM-03 Wazuh AIO en Docker: el SIEM con correlación y respuesta activa.
> VM-04 MariaDB en Docker más Rsyslog nativo: la base de datos de logs.
> VM-05: cliente Ubuntu con el agente Wazuh.
>
> El orden de arranque es obligatorio: OPNsense primero porque da red, FreeIPA después porque da DNS, y así sucesivamente.

### Decisiones técnicas clave (4 min) — Slides 6–7

**Estos son los puntos que el tribunal va a preguntar. Adelantarse.**

> Dos cambios respecto al anteproyecto original:
>
> Primero, migré de pfSense a OPNsense. Netgate restringió pfSense Community Edition para entornos KVM. OPNsense integra Suricata de forma nativa.
>
> Segundo, MariaDB pasó de instalación nativa a contenedor Docker. Ventaja: versión fija con el tag mariadb diez punto once, y reproducibilidad total con docker-compose up.
>
> Rsyslog se mantiene nativo. El módulo ommysql necesita conectar a la base de datos por TCP en ciento veintisiete punto cero punto cero punto uno. Meterlo en Docker complicaba los sockets UDP y los permisos sin aportar valor real.
>
> El ENS se aplica en categoría MEDIA. El laboratorio simula una PYME con datos internos, sin datos clasificados. ALTA exigiría alta disponibilidad, cifrado extremo a extremo y auditoría continua permanente, que exceden el alcance de un TFG de ASIR.

### Pruebas y resultados (4 min) — Slides 8–9

> El plan de validación incluye nueve pruebas empíricas.
> Las nueve han sido superadas con resultado PASS.
>
> Destaco tres:
>
> PR-01: un escaneo nmap desde la VLAN de clientes demuestra que solo los puertos de Wazuh están accesibles. El resto aparece como filtered.
>
> PR-03: un ataque de fuerza bruta SSH con Hydra dispara la regla personalizada cien mil uno de Wazuh, nivel diez. La respuesta activa bloquea al atacante en iptables en tres segundos. Este ataque se ve en directo en el vídeo demostrativo.
>
> PR-08: la segregación de privilegios en MariaDB queda demostrada cuando el usuario analyst no puede insertar y el usuario rsyslog no puede leer.
>
> Durante las pruebas se detectaron cinco dificultades técnicas reales, todas documentadas con causa raíz y solución. Por ejemplo, las reglas personalizadas de Wazuh se perdían tras reiniciar los contenedores porque el volumen Docker no estaba mapeado.

**Si se proyecta el vídeo, aquí es el momento.** Decir:

> A continuación, con el permiso del tribunal, proyectaré el vídeo demostrativo del laboratorio en funcionamiento. Tiene una duración de aproximadamente once minutos.

### Conclusiones y trabajo futuro (2 min) — Slides 10–11

> Los ocho objetivos específicos se han cumplido con evidencia verificable.
>
> Lecciones aprendidas: la principal es que en entornos complejos con múltiples servicios, el orden de despliegue y la persistencia de configuraciones son críticos. Un volumen Docker mal configurado invalida horas de trabajo.
>
> Líneas de trabajo futuro: desplegar Wazuh en arquitectura distribuida con tres nodos independientes, integrar un motor SOAR para automatizar la respuesta a incidentes, y migrar el laboratorio a un entorno cloud con Terraform.

### Cierre (30 s) — Slide 12

> Con esto doy por concluida la exposición del proyecto y quedo a disposición del tribunal para las preguntas que consideren oportunas.

---

## Notas de oratoria

- **No leer las slides.** Las slides son el esqueleto; tú pones la carne.
- **Hablar al tribunal**, no a la pantalla. Girar el cuerpo hacia ellos.
- **Frases cortas.** Vocalizar. Modular la voz (un tono monocorde mata la atención).
- **Si te quedas en blanco**, mira la slide y retoma. Las speaker notes impresas son el salvavidas.
- **No abusar de siglas** sin explicarlas la primera vez (HBAC, FIM, AIO).
- **Si mencionas un dato numérico** (3 segundos de bloqueo, 42 segundos de FIM, 1847 eventos), da el número concreto. Los datos impresionan al tribunal.
- **Referirse a capítulos y secciones** de la memoria si la pregunta lo requiere: "esto está documentado en el Capítulo 4, sección cuatro punto cinco punto uno".

---

## Turno de preguntas — Reglas

- Escuchar la pregunta completa antes de responder.
- Responder directo: dato → contexto → referencia a la memoria.
- Si no sabes algo: "Eso no lo he explorado en este proyecto, pero sería una línea interesante de trabajo futuro."
- Agrupar respuestas si hacen varias preguntas seguidas.
- No polemizar. Humildad intelectual.
- Agradecer al tribunal al terminar.

Las preguntas probables están en `BANCO_PREGUNTAS_TRIBUNAL.md`.

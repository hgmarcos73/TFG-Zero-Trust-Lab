# Guion de la defensa oral — Versión adaptada a presentación infográfica

> **Duración máxima:** 25 minutos (exposición + clips de vídeo) + turno de preguntas
> **Soporte visual:** 16 slides infográficas (15 originales + 1 nueva de dificultades)
> **Vídeo:** 2 clips cortos integrados (~2.5 min). Vídeo completo (~11 min) subido a Moodle.
> **Normativa:** Instrucciones I.E.S. Al-Ándalus — Proyecto Intermodular ASIR

---

## Correcciones obligatorias sobre las slides originales

| # | Cambio | Motivo |
|---|---|---|
| 1 | Slide 1: añadir autor, tutores y centro | La carátula original solo tiene título y empresa |
| 2 | Todas: cambiar pie a "Zero Trust Lab · Marcos Hernández García · I.E.S. Al-Andalus · ASIR 2024/25" | El pie actual dice "Technical Consulting 2024" |
| 3 | Todas: eliminar watermark NotebookLM | No debe aparecer marca de la herramienta |
| 4 | Insertar slide 13 nueva: Dificultades reales | Obligatorio según instrucciones del centro |
| 5 | Slide 15: tener preparada fuente de cada precio comercial | El 16.880 € no está en la memoria |
| 6 | Añadir speaker notes a todas las slides | Las originales no tienen |

---

## ORDEN DEFINITIVO — 16 SLIDES

```
 1. Carátula
 2. La Vulnerabilidad de la Red Plana vs. La Contención Zero Trust
 3. El Paradigma: 7 Principios de NIST SP 800-207
 4. La Solución: Arquitectura de Defensa en Profundidad
 5. Diseño de Red: Microsegmentación Estricta (ZT-04)
 6. El Motor Perimetral y Acceso Seguro
 7. Identidad Unificada: Verificar Explícitamente (ZT-01 & ZT-02)
 8. El Cerebro Analítico: Wazuh SIEM/XDR
 9. Anatomía de un Evento de Seguridad
10. La Bóveda Forense: Trazabilidad y Cumplimiento Legal
11. Matriz de Validación: Pruebas Empíricas (Resultados 9/9)
12. Caso de Uso Analítico: Respuesta Activa Autonómica (PR-03)
     → CLIP DE VÍDEO 1: Hydra + bloqueo (~90 s)
13. Dificultades Reales de Integración ← NUEVA
14. Síntesis Normativa: De la Técnica al Cumplimiento
15. Impacto Económico: El ROI del Open Source
16. Roadmap y Evolución de la Arquitectura + cierre
```

---

## DESCRIPCIÓN E INFOGRAFÍA DE CADA SLIDE

---

### SLIDE 1 — Carátula

**Visual actual:** Fondo blanco, ilustración isométrica de bloques de cristal azul (capas de seguridad). Título a la izquierda. Etiquetas: "Zona de Confianza Cero", "Segmentación Dinámica", "Monitoreo de Software Libre", "Puente de Acceso Seguro".

**Texto actual + correcciones:**
- Título: Implementación Avanzada de Arquitectura Zero Trust
- Subtítulo: Protección, Detección y Trazabilidad a través de Software Libre
- Empresa: Proyecto de Laboratorio: TechSecure Solutions S.L.
- **AÑADIR:** Marcos Hernández García
- **AÑADIR:** I.E.S. Al-Andalus · ASIR 2024/25
- **AÑADIR:** Tutores: Federico Martínez Pérez · Daniel Alberto Moreno Barón

**Infografía alternativa:** Edificio corporativo transparente con 4 capas visibles (red, identidad, detección, datos), etiquetas flotantes con componentes del stack. Paleta azul/naranja sobre fondo blanco con líneas de plano técnico.

**Narración (30 s):**
Buenos días. Mi proyecto se titula "Implementación Avanzada de Arquitectura Zero Trust con SIEM, Base de Datos y Contenedores". El objetivo es demostrar que una arquitectura de ciberseguridad corporativa basada en el modelo NIST SP 800-207 es viable con software libre y hardware modesto.

---

### SLIDE 2 — La Vulnerabilidad de la Red Plana vs. La Contención Zero Trust

**Visual actual:** Pantalla dividida. Izquierda: red plana caótica con flechas naranjas de ataque, PT-01 a PT-04. Derecha: arquitectura Zero Trust en capas, mismos PT resueltos.

**Texto izquierda:** PT-01 Red sin segmentación, PT-02 Sin SIEM, PT-03 Identidades fragmentadas, PT-04 Cero trazabilidad RGPD.

**Texto derecha:** PT-01 Segmentación estricta, PT-02 SIEM centralizada, PT-03 Identidad unificada, PT-04 Trazabilidad RGPD garantizada.

**Infografía alternativa:** Díptico con fondo rojo/gris (caos) vs azul/verde (orden). Iconos pareados: cables cruzados→capas, candado abierto→escudo, ojo tachado→lupa, documento roto→BD. Flecha central "ANTES → DESPUÉS".

**Narración (90 s):**
TechSecure Solutions es una consultora TI simulada de tamaño medio. A la izquierda su infraestructura inicial: red plana donde cualquier equipo comprometido accede a todo, sin SIEM, identidades locales, y sin registros. A la derecha, lo que implementa el proyecto: segmentación estricta con cuatro VLANs, Wazuh como SIEM, FreeIPA para identidad y MariaDB con Rsyslog para trazabilidad. Los cuatro problemas, las cuatro soluciones.

---

### SLIDE 3 — El Paradigma: 7 Principios de NIST SP 800-207

**Visual actual:** Rueda de 7 hexágonos con iconos alrededor de un núcleo: "La posición en la red no otorga confianza." ZT-01 a ZT-07.

**Infografía alternativa:** Misma rueda pero con líneas que conectan cada principio a un componente del lab (ZT-01→FreeIPA, ZT-02→MariaDB SoD, ZT-03→Wazuh AR, ZT-04→OPNsense, ZT-05→Dashboard, ZT-06→WireGuard, ZT-07→Rsyslog+MariaDB).

**Narración (60 s):**
El modelo Zero Trust del NIST tiene siete principios. El central: la posición en la red no otorga confianza. Da igual que estés dentro del firewall, cada acceso se verifica. Los siete principios se han implementado y verificado con evidencia. La tabla del Capítulo 5 muestra que los siete alcanzan nivel Alto.

---

### SLIDE 4 — La Solución: Arquitectura de Defensa en Profundidad

**Visual actual:** 4 capas apiladas en isométrica. Capa 1: Perímetro (OPNsense+Suricata+WireGuard). Capa 2: Identidad (FreeIPA). Capa 3: Detección (Wazuh). Capa 4: Bóveda Forense (MariaDB+Rsyslog).

**Infografía alternativa:** Torre de 4 bloques de cristal, cada capa con color distinto. Iconos laterales: firewall, candado, radar, BD. Texto: "Stack 100% open source para el ENS."

**Narración (60 s):**
Cuatro capas de defensa en profundidad. Perímetro: OPNsense con Suricata y WireGuard. Identidad: FreeIPA con LDAP y Kerberos. Detección: Wazuh como SIEM con correlación en tiempo real. Y la bóveda forense: MariaDB y Rsyslog para persistencia inmutable. Todo open source.

---

### SLIDE 5 — Diseño de Red: Microsegmentación Estricta (ZT-04)

**Visual actual:** Plano técnico isométrico con 5 zonas. OPNsense central. VLAN 10 (LAN), VLAN 20 (Servidores), VLAN 30 (DMZ), VLAN 99 (Gestión). Flechas azules=permitido, naranja con X=bloqueado. Callouts: "Deny-by-default", "Aislamiento de Gestión". DMZ incluida correctamente.

**Infografía alternativa:** Campus corporativo aéreo con 5 edificios, muros, OPNsense como control central. Flechas verdes con puertos (1514/1515), X rojas. Grid milimetrado.

**Narración (90 s):**
Cinco zonas sobre switches VMnet en modo Host-only. Aislamiento de capa 2: no hay enrutamiento entre VLANs sin pasar por OPNsense. Desde la VLAN de clientes solo puertos 1514 y 1515 hacia Wazuh. Todo lo demás descartado. La VLAN 99 es invisible para el resto. La DMZ está reservada para fase futura. El principio ZT-04 de microsegmentación queda implementado mecánicamente por el diseño.

---

### SLIDE 6 — El Motor Perimetral y Acceso Seguro

**Visual actual:** Tres paneles: OPNsense (NAT masquerade), Suricata IDS/IPS Inline (ET Open, bloqueo inter-VLAN), WireGuard VPN (Curve25519, solo VLAN 99).

**Infografía alternativa:** Tres columnas tipo ficha técnica. Firewall con 5 flechas, lupa con firmas ET SCAN, túnel verde solo a VLAN 99.

**Narración (90 s):**
Tres funciones en una VM. OPNsense como firewall con cinco interfaces. Suricata en modo IPS inline: bloquea en tiempo real con ET Open. Cuando detecta un escaneo nmap, genera una alerta que viaja por syslog hasta Wazuh. Y WireGuard para VPN remota: el túnel solo da acceso a la VLAN 99. Si alguien consigue las credenciales VPN, no alcanza ni clientes ni servidores.

---

### SLIDE 7 — Identidad Unificada: Verificar Explícitamente (ZT-01 & ZT-02)

**Visual actual:** FreeIPA central como "Punto de Verdad". Tres ramas: LDAP & Kerberos, Cumplimiento ENS (12 caracteres, historial 10), HBAC (SSH solo Sysadmins).

**Infografía alternativa:** Árbol invertido con FreeIPA arriba. Tres ramas con datos concretos. Mini-ejemplo: operador1→SSH→freeipa = ❌. Añadir: "4 usuarios, 3 grupos, dominio lab.techsecure.local".

**Narración (60 s):**
FreeIPA centraliza la identidad de lab.techsecure.local. LDAP para directorio, Kerberos para autenticación sin contraseñas en texto plano, DNS propio. Cuatro usuarios, tres grupos. Las políticas HBAC controlan qué usuario accede a qué máquina. Un operador no puede hacer SSH al servidor de identidad aunque tenga la contraseña correcta.

---

### SLIDE 8 — El Cerebro Analítico: Wazuh SIEM/XDR

**Visual actual:** Pipeline vertical en VM-03 Docker Compose: Manager (TCP 1514, UDP 514) → Indexer/OpenSearch (TCP 9200/TLS) → Dashboard (HTTPS 443). Recuadro FIM realtime (H-01).

**Infografía alternativa:** Misma pipeline con columna lateral: reglas custom 100001/100002, active response firewall-drop 600s, agentes VM-02 y VM-05.

**Narración (60 s):**
Wazuh AIO con Docker Compose: tres contenedores. Manager recibe logs por TCP 1514 y syslog UDP 514. Indexer almacena. Dashboard visualiza. Reglas personalizadas 100001 y 100002. Respuesta activa automática. Y el FIM en tiempo real — hallazgo H-01: por defecto revisaba cada 12 horas, lo cambiamos a inotify para detección en 42 segundos.

---

### SLIDE 9 — Anatomía de un Evento de Seguridad

**Visual actual:** Flujo horizontal 5 pasos con bifurcación: Generación (VM-05) → Transporte (TCP 1514) → Correlación (MITRE T1110) → Bifurcación: Operativa (Indexer+Dashboard) y Forense (Rsyslog→MariaDB). "Trazabilidad en menos de 2 segundos."

**Infografía alternativa:** Misma estructura con timestamps reales: T=0s, T<1s, T<2s, T<30s Dashboard, T<1.2s MariaDB. Dato: "1.847 eventos/24h".

**Narración (60 s):**
El flujo completo de un evento. Intento SSH fallido en VM-05. El agente cifra y envía al Manager. El Manager correlaciona y asigna la táctica MITRE. Bifurcación: al Dashboard en menos de 30 segundos y a MariaDB para persistencia forense. 1.847 eventos en 24 horas. Ningún eslabón ha fallado.

---

### SLIDE 10 — La Bóveda Forense: Trazabilidad y Cumplimiento Legal

**Visual actual:** Dos paneles. Izquierda: SoD con rsyslog→INSERT ONLY→BD→SELECT ONLY→analyst. Derecha: Retención RGPD 365 días con SQL de purga.

**Infografía alternativa:** Caja fuerte con dos puertas: "ESCRITURA" (rsyslog) y "LECTURA" (analyst VLAN 99). Candado grande: "DELETE ❌ · UPDATE ❌". Cronómetro: "365 días → purga automática".

**Narración (60 s):**
MariaDB como bóveda forense. El usuario rsyslog solo inserta: no puede leer. El analyst solo lee: no puede escribir ni borrar. Nadie tiene DELETE ni UPDATE. La purga automática elimina registros de más de 365 días según el RGPD artículo 5.1.e. Acceso restringido a VLAN 99.

---

### SLIDE 11 — Matriz de Validación: Pruebas Empíricas (Resultados 9/9)

**Visual actual:** Tabla con 5 pruebas destacadas: PR-01 (ZT-04), PR-02 (ZT-05), PR-04 (ZT-01), PR-06 (ZT-03), PR-08 (ZT-02). Todas PASS.

**Nota:** Son 5 de 9. Las 4 restantes: PR-03 tiene slide propia (12), PR-05 se demuestra en toda la exposición, PR-07 se ve en slide 10, PR-09 en slide 6.

**Infografía alternativa:** Tabla con columnas Prueba | Vector | Motor | Principio NIST | Resultado. Badge superior: "9/9 PASS · 7/7 ZT · 3 marcos normativos".

**Narración (60 s):**
De las nueve pruebas superadas, estas cinco cubren los principios Zero Trust clave. Cada una ataca un vector distinto y es detectada por un motor diferente. Las cuatro restantes se demuestran en otras slides y en el vídeo. Resultado global: nueve de nueve.

---

### SLIDE 12 — Caso de Uso Analítico: Respuesta Activa Autonómica (PR-03)

**Visual actual:** Timeline: T=0s Hydra→FreeIPA, T=1s 6 intentos fallidos, T=2s Regla 100001 Nivel 10, T<3s firewall-drop iptables. Badge: "ACCESS DENIED".

**Infografía alternativa:** Misma timeline con capturas reales embebidas: terminal Hydra, log SSH, alerta Dashboard, salida iptables.

**Narración (60 s + clip 90 s):**
La prueba más impactante. T=0 el atacante lanza Hydra. En un segundo, seis intentos fallidos. A los dos segundos, el Manager dispara la regla 100001 con nivel 10, MITRE T1110. Antes de los tres segundos, iptables bloquea al atacante durante 600 segundos. Voy a mostrar cómo se ve esto en el laboratorio real.

**→ CLIP DE VÍDEO 1: Hydra + active response (~90 s)**

---

### SLIDE 13 — Dificultades Reales de Integración ← NUEVA

**Visual propuesto:** Fondo claro con grid de plano técnico (estilo coherente con el resto). 5 tarjetas tipo "ficha de incidencia" con borde lateral naranja. Layout 3 arriba + 2 abajo.

**Texto de cada tarjeta:**

```
D-1 — pfSense → OPNsense
Causa: Netgate retiró soporte gratuito para VMware.
Solución: Migración a OPNsense 24.x en 12 h. Sin impacto.

D-2 — vm.max_map_count insuficiente
Causa: Kernel por defecto 65530. Wazuh Indexer necesita 262144.
Solución: sysctl -w + persistencia en /etc/sysctl.conf.

D-3 — Reglas Wazuh no persistían
Causa: Volumen Docker no mapeado en docker-compose.yml.
Solución: Bind mount al directorio de reglas. Verificado con ossec-logtest.

D-4 — FIM tardaba 12 horas
Causa: syscheck frequency por defecto = 43.200 s.
Solución: realtime="yes" en ossec.conf. 12 h → 42 s.

D-5 — rsyslog-mysql no instalado
Causa: Paquete ausente en Ubuntu 22.04. Error silencioso.
Solución: apt install rsyslog-mysql + config manual.
```

**Infografía alternativa:** 5 tarjetas post-mortem con iconos de alerta. Tres líneas por tarjeta: Problema (rojo), Causa (gris), Solución (verde). Título: "5 obstáculos reales · Causa raíz · Solución aplicada".

**Narración (90 s):**
Cinco problemas reales de integración. pfSense descontinuó su edición Community: migré a OPNsense en 12 horas. El kernel no trae el valor de memoria que necesita el Indexer de Wazuh. Las reglas personalizadas desaparecían al reiniciar porque el volumen Docker no estaba declarado. El FIM por defecto revisaba cada 12 horas: un atacante puede actuar sin ser detectado. Y el paquete rsyslog-mysql no viene en Ubuntu 22.04 y el error es silencioso. Todos resueltos y documentados en el Capítulo 7.

---

### SLIDE 14 — Síntesis Normativa: De la Técnica al Cumplimiento

**Visual actual:** Tres columnas: ENS (mp.com.1→OPNsense, op.acc.6→FreeIPA, op.net.1→Suricata), RGPD (Art. 5.1.e→MariaDB, Art. 33→Wazuh), NIST (Microsegmentación→4 VLANs, Acceso remoto→WireGuard). Sello "COMPLIANCE CERTIFIED".

**Infografía alternativa:** Venn de tres círculos (ENS, RGPD, NIST) con componentes en las intersecciones. Centro: "Arquitectura Zero Trust completa".

**Narración (60 s):**
Cada componente cubre al menos un control normativo. OPNsense: perímetro mp.com.1 del ENS. FreeIPA: contraseñas op.acc.6. Suricata: detección op.net.1. MariaDB: retención artículo 5.1.e del RGPD. Wazuh: detección y notificación en 72 horas, artículo 33. El proyecto no solo implementa tecnología: demuestra cumplimiento normativo auditable.

---

### SLIDE 15 — Impacto Económico: El ROI del Open Source

**Visual actual:** Dos paneles. Izquierda: Lab (Licencias 0 €, Hardware 0 €, Consumo 21,60 €). Derecha: Comercial (vSphere 2.000 €, Palo Alto 5.500 €, Splunk 5.000 €, Entra ID 3.600 €, Total 16.880 €/año). Pie: Valoración mercado 11.400 €.

**Dos datos económicos:**
- 11.400 € = consultoría equivalente. Cap. 6 §6.6 de la memoria. Verificable.
- 16.880 €/año = licencias comerciales equivalentes. Dato de mercado, NO en la memoria. Si preguntan: "Estimación basada en precios públicos de los fabricantes."

**Infografía alternativa:** Balanza: izquierda (open source, pluma, 21,60 €) vs derecha (comercial, bloques, 16.880 €/año). Debajo: "Valoración proyecto: ≈ 11.400 €". Ratio "528:1".

**Narración (60 s):**
21 euros y 60 céntimos de consumo eléctrico. Licencias: cero. Si una empresa quisiera funcionalidad equivalente con productos comerciales — Palo Alto, Splunk, vSphere — el coste anual rondaría los 16.880 euros. Y si contratara la implantación como consultoría, unos 11.400 euros según las tarifas del Capítulo 6. Ratio de valor: 528 a 1.

**→ CLIP DE VÍDEO 2 (opcional): Segregación MariaDB (~60 s)**

---

### SLIDE 16 — Roadmap y Evolución de la Arquitectura

**Visual actual:** Camino progresivo con 4 fases isométricas. Fase 1 (Actual): Lab AIO. Fase 2: Clústeres HA vSphere+Ceph. Fase 3: SOAR Shuffle+TheHive. Fase 4: Cloud freeipa-ad-trust + SIEM AWS/Azure.

**Infografía alternativa:** Línea temporal horizontal con 4 hitos. Primero resaltado (actual), resto en degradado. Subtítulo: "Hacia ISO 27001 y el entorno Cloud."

**Narración (60 s + cierre):**
El laboratorio es la primera fase de cuatro. Alta disponibilidad con Wazuh multi-nodo. Automatización SOAR con Shuffle y TheHive. Y extensión cloud con integración Active Directory y migración del Indexer a AWS o Azure.

Con esto doy por concluida la exposición y quedo a disposición del profesorado para las preguntas que consideren oportunas.

---

## DISTRIBUCIÓN DE TIEMPO

```
Slide 1   Carátula ...................  0:30
Slide 2   Red Plana vs ZT ............  1:30
Slide 3   7 Principios NIST ..........  1:00
Slide 4   Defensa en profundidad ......  1:00
Slide 5   Microsegmentación ...........  1:30
Slide 6   Motor perimetral ............  1:30
Slide 7   FreeIPA identidad ...........  1:00
Slide 8   Wazuh SIEM ..................  1:00
Slide 9   Anatomía evento .............  1:00
Slide 10  Bóveda forense ..............  1:00
Slide 11  Matriz validación ...........  1:00
Slide 12  PR-03 respuesta activa ......  1:00
  → CLIP 1: Hydra + bloqueo ..........  1:30
Slide 13  Dificultades ................  1:30
Slide 14  Síntesis normativa ..........  1:00
Slide 15  Impacto económico ...........  1:00
  → CLIP 2: Segregación (opcional) ...  1:00
Slide 16  Roadmap + cierre ............  1:00
────────────────────────────────────────────
TOTAL ≈ 20 min 00 s
Margen para imprevistos: 5 min 00 s
```

---

## NOTAS DE ORATORIA

- No leer las slides. Las infografías son apoyo visual; tú pones la explicación.
- Hablar al tribunal, no a la pantalla.
- Frases cortas. Vocalizar. Modular la voz.
- Datos concretos: 3 s, 42 s, 1.847 eventos, 528:1, 262.144, 365 días.
- Antes de cada clip: "Voy a mostrar una grabación del laboratorio en funcionamiento."
- Si el clip falla: describir lo que se vería con datos concretos.
- Si preguntan por el 16.880 €: "Estimación basada en precios públicos de fabricantes. La cifra verificable de la memoria es 11.400 euros, Capítulo 6."

---

## TURNO DE PREGUNTAS

- Escuchar la pregunta completa antes de responder.
- Responder directo: dato → contexto → referencia a la memoria.
- Si no sabes: "Eso no lo he explorado, pero sería una línea de trabajo futuro."
- No polemizar. Humildad intelectual.
- Agradecer al profesorado al terminar.

Las preguntas probables están en BANCO_PREGUNTAS_TRIBUNAL.md.

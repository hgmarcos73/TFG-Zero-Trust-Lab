# Narración — Voz en off del vídeo demostrativo

> **Instrucciones de grabación:**  
> - Leer despacio y claro. Tono técnico pero natural, sin dramatismo.  
> - Usar un micro externo si es posible (incluso auriculares con micro).  
> - Las marcas `[PAUSA 2s]` indican silencios para que la imagen respire.  
> - Las marcas `[BLOQUE X]` coinciden con los títulos-overlay en edición.  
> - Tiempo total de narración: ~9 minutos (el vídeo puede tener silencios adicionales).

---

## [BLOQUE 0 — CARÁTULA]

*(Sin narración. Solo slide estática: 10 segundos.)*

---

## [BLOQUE 1 — PANORÁMICA DEL LABORATORIO]

El laboratorio se ejecuta sobre VMware Workstation Pro diecisiete con cinco máquinas virtuales.
El orden de arranque es obligatorio: primero OPNsense, que proporciona la red;
luego FreeIPA para DNS e identidad;
después Wazuh y la base de datos;
y por último el cliente.

[PAUSA 2s]

VM-01: OPNsense. El firewall y punto central de la arquitectura.
Aquí se ve el menú de consola con las cinco interfaces de red asignadas, una por cada zona de seguridad.

[PAUSA 2s]

VM-02: FreeIPA sobre Rocky Linux nueve.
El hostname confirmado es freeipa punto lab punto techsecure punto local.
Este servidor gestiona la identidad, el DNS y la autenticación Kerberos del dominio.

[PAUSA 2s]

VM-03: Wazuh All-in-One desplegado con Docker Compose.
Tres contenedores corriendo: Manager, Indexer y Dashboard.
Los tres muestran estado "Up" — el SIEM está operativo.

[PAUSA 2s]

VM-04: base de datos y logs.
MariaDB diez punto once corre en un contenedor Docker.
Rsyslog se ejecuta como servicio nativo del sistema — activo y corriendo.
Esta separación es intencionada: Rsyslog necesita el módulo ommysql que conecta a la base de datos por TCP en ciento veintisiete punto cero punto cero punto uno.

[PAUSA 2s]

VM-05: el cliente Linux en la VLAN diez, con IP diez punto diez punto diez punto diez.
Tiene instalado el agente Wazuh y es el origen de todas las pruebas de ataque.

---

## [BLOQUE 2 — SEGMENTACIÓN DE RED Y FIREWALL]

Accedo a la WebUI de OPNsense desde la VLAN de gestión, la noventa y nueve.
Este panel de administración no es accesible desde la red de clientes.

[PAUSA 2s]

En la vista de interfaces se ven las cinco zonas:
WAN para salida a Internet,
LAN para clientes en la diez punto diez punto diez,
Servidores en la diez punto diez punto veinte,
DMZ en la diez punto diez punto treinta,
y Gestión en la diez punto diez punto noventa y nueve.
Cada interfaz corresponde a un switch virtual VMnet configurado en modo Host-only.
El aislamiento es de capa dos: no hay enrutamiento posible entre zonas si no pasa por OPNsense.

[PAUSA 2s]

Las reglas de firewall de la VLAN de clientes son restrictivas.
Solo se permiten conexiones a los puertos mil quinientos catorce y mil quinientos quince de la VLAN de servidores.
Esos son los puertos de telemetría del agente Wazuh.
Todo lo demás se descarta en silencio, sin enviar respuesta al origen.

[PAUSA 2s]

Lanzo un escaneo nmap desde el cliente hacia el servidor Wazuh, probando siete puertos distintos.

[PAUSA 3s — esperar resultado nmap]

El resultado confirma la política deny-by-default:
solo los puertos mil quinientos catorce y mil quinientos quince aparecen como open.
SSH, HTTPS, MariaDB, el Indexer — todo filtrado.
Esto corresponde a la prueba PR-01 del plan de validación. Resultado: superada.

---

## [BLOQUE 3 — SURICATA DETECTA EL ESCANEO]

El escaneo nmap que acabamos de lanzar no ha pasado desapercibido.
Suricata, que corre en modo IPS inline dentro de OPNsense, lo ha interceptado.

En las alertas de Suricata se ve la firma ET SCAN Nmap TCP,
con IP de origen diez punto diez punto diez punto diez — la del cliente —
y un timestamp que coincide con el momento del escaneo.

[PAUSA 2s]

Ahora paso al Dashboard de Wazuh.
Filtro los eventos de seguridad por la IP del cliente.
Aquí está la correlación: regla personalizada cien mil dos, nivel ocho — escaneo de puertos detectado.
El log viajó de Suricata a OPNsense, de ahí por syslog UDP quinientos catorce al Manager de Wazuh,
y aparece clasificado en el Dashboard.
Prueba PR-02: superada.

---

## [BLOQUE 4 — FUERZA BRUTA SSH Y RESPUESTA AUTOMÁTICA]

Ahora voy a simular un ataque de fuerza bruta SSH.
Divido la pantalla en tres zonas para verlo todo en tiempo real:
a la izquierda el terminal del atacante en la VM-05,
arriba a la derecha el Dashboard de Wazuh,
y abajo a la derecha los logs SSH del servidor atacado.

[PAUSA 2s]

Lanzo Hydra con un diccionario contra el servicio SSH de FreeIPA en la diez punto diez punto veinte punto diez.

[PAUSA 3s — esperar que empiecen los intentos]

En los logs del servidor se ven los intentos fallidos:
"Failed password for admin from diez punto diez punto diez punto diez".
Uno, dos, tres, cuatro, cinco, seis...

[PAUSA 2s — Hydra pierde conexión]

Hydra pierde la conexión. El servidor ha dejado de responder al atacante.

[PAUSA 2s]

En el Dashboard de Wazuh aparece la alerta:
regla personalizada cien mil uno, nivel de severidad diez.
El sistema la ha etiquetado automáticamente con la técnica MITRE ATT&CK T mil ciento diez punto cero cero uno — fuerza bruta, adivinación de contraseñas.
El SIEM no solo detectó el ataque: lo clasificó según el marco de amenazas.

[PAUSA 2s]

Y en el servidor atacado, la respuesta activa de Wazuh ha inyectado una regla iptables
que descarta todo el tráfico procedente del atacante durante seiscientos segundos.
El ataque fue contenido automáticamente en tres segundos.

[PAUSA 2s]

Si intento conectar ahora por SSH desde el atacante... conexión rechazada.
El bloqueo está activo.
Prueba PR-03: superada.

---

## [BLOQUE 5 — FREEIPA: IDENTIDAD Y CONTROL DE ACCESO]

FreeIPA es el servidor de identidad del laboratorio.
Gestiona usuarios, grupos, DNS y Kerberos para el dominio lab punto techsecure punto local.

[PAUSA 2s]

Cuatro usuarios creados, cada uno con un rol diferente.
Tres grupos: administradores, operadores y auditores.

[PAUSA 2s]

Las políticas HBAC — Host-Based Access Control — controlan qué usuario puede acceder a qué máquina y con qué servicio.
En este caso, solo los administradores tienen acceso SSH al servidor de identidad.

[PAUSA 2s]

Si intento conectar como operador uno al servidor FreeIPA...
acceso denegado. La política HBAC ha intervenido antes de que FreeIPA evalúe la contraseña.

Y en el Dashboard de Wazuh aparece la alerta correspondiente:
regla cinco mil setecientos diez, nivel cinco — autenticación fallida.
Prueba PR-04: superada.

---

## [BLOQUE 6 — INTEGRIDAD DE ARCHIVOS]

Ahora voy a modificar un archivo crítico del sistema y comprobar que Wazuh lo detecta en tiempo real.

El módulo FIM — File Integrity Monitoring — vigila los cambios en el directorio etc con detección en tiempo real mediante inotify.

[PAUSA 2s]

Añado un comentario al fichero etc passwd.
Es un cambio mínimo, pero suficiente para alterar el hash SHA doscientos cincuenta y seis del archivo.

[PAUSA 5s — esperar alerta, puede tardar ~40 s]

En el Dashboard de Wazuh aparece la alerta:
regla quinientos cincuenta, nivel siete — integridad de archivo comprometida.
Wazuh muestra el hash SHA doscientos cincuenta y seis del archivo antes y después de la modificación.
El tiempo de detección ha sido inferior a cuarenta y cinco segundos.

Restauro el archivo original.
Prueba PR-06: superada.

---

## [BLOQUE 7 — PERSISTENCIA DE LOGS EN MARIADB]

MariaDB se ejecuta en un contenedor Docker en la VM-04.
Es la base de datos que almacena todos los logs recibidos por Rsyslog.

[PAUSA 2s]

Conecto con el usuario analyst, que solo tiene permisos de lectura.

La tabla SystemEvents contiene más de mil registros reales.

[PAUSA 2s]

Los diez eventos más recientes muestran el timestamp, el equipo de origen, la etiqueta del servicio y el mensaje.
Estos son logs reales recibidos por Rsyslog vía UDP quinientos catorce e insertados en MariaDB.

[PAUSA 2s]

Ahora compruebo la segregación de privilegios.
Si intento insertar datos como analyst...
error mil ciento cuarenta y dos: INSERT command denied.
El analyst solo lee, no escribe.

[PAUSA 2s]

Y al revés: si conecto como rsyslog — el usuario que inserta los logs — e intento leer...
error mil ciento cuarenta y dos: SELECT command denied.
El recolector no puede leer lo que él mismo inserta.

Esto es segregación de funciones aplicada a nivel de base de datos.
Mínimo privilegio verificado.
Pruebas PR-07 y PR-08: superadas.

---

## [BLOQUE 8 — VPN WIREGUARD]

Levanto un túnel VPN WireGuard desde un equipo externo al laboratorio.

[PAUSA 2s]

El comando wg show confirma el túnel establecido.
El handshake se completó en seis segundos.
La conexión está cifrada con Curve veinticinco mil quinientos diecinueve.

[PAUSA 2s]

Desde la VPN puedo acceder a la WebUI de OPNsense en la VLAN de gestión.
La petición HTTPS devuelve el HTML de OPNsense — acceso confirmado.

[PAUSA 2s]

Pero no puedo alcanzar la VLAN de clientes.
El ping a diez punto diez punto diez punto diez devuelve "Network is unreachable".
La directiva AllowedIPs del túnel solo permite tráfico hacia la VLAN noventa y nueve.

Esto es acceso remoto con mínimo privilegio: el administrador entra por VPN,
pero solo ve la red de gestión. El resto de la infraestructura permanece oculta.
Prueba PR-09: superada.

---

## [BLOQUE 9 — CIERRE]

Con esto concluye la demostración del laboratorio Zero Trust.

Se han ejecutado en directo ocho de las nueve pruebas del plan de validación.
La prueba PR-05, verificación visual del Dashboard, se ha mostrado de forma continua a lo largo de todo el vídeo.

Resultado global: nueve de nueve pruebas superadas.
Ocho de ocho objetivos cumplidos.

*(Silencio. Slide final visible 5 segundos.)*

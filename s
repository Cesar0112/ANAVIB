[33mcommit 7d2c2e905c1ec59116ab967a77501b74b30dd740[m[33m ([m[1;36mHEAD -> [m[1;32mmain[m[33m, [m[1;31morigin/main[m[33m, [m[1;31morigin/HEAD[m[33m)[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Mon Oct 30 23:12:18 2023 -0400

    Ya configure de forma global pasando el procedure cargarConfiguracion para metodoConfiguracion.pas

[33mcommit f4ea249aa467bc3fee89ba8723a3f5bfd83861ef[m
Merge: cfc7ebe 5561484
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Sat Oct 28 13:16:47 2023 -0400

    Merge branch 'main' of https://github.com/Cesar0112/ANAVIB

[33mcommit cfc7ebe6fa45c047c8fb8e0129ff4e8f549b5d48[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Sat Oct 28 13:15:43 2023 -0400

    Ya no se bloquea

[33mcommit 55614847ce8e696689d9548eff6c6e9b788f3c79[m
Merge: 31a77fe dcc57f1
Author: Cesar <98931642+Cesar0112@users.noreply.github.com>
Date:   Sat Oct 28 12:41:25 2023 -0400

    Merge pull request #2 from Cesar0112/tratamiento_bloqueo
    
    Tratamiento bloqueo

[33mcommit dcc57f1fe90e866650a9425f9ad7dca11b212c84[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Sat Oct 28 12:29:51 2023 -0400

    Merge branch 'main' into tratamiento_bloqueo

[33mcommit c49cab4da354cc3f48be2569d78a20ce0b5ba4a0[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Sat Oct 28 12:26:24 2023 -0400

    Aqui se bloquea la BD

[33mcommit a22158b551d605dc16231d9b610efcb86facf140[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Sat Oct 28 12:24:14 2023 -0400

    Resuelto el bloqueo de la base de datos
    
    El problema era que dejaba conectada la base de datos por el componente ZConnection en el formLogin, y al eliminar ese componente y redirigir la conexion del ZReadOnlyQuery al ZConnection del formPrincipal la bd solo se conecta desde el formPrincipal

[33mcommit 074ea5ec9000b5239b9ac28234afd865dcfe4749[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Sat Oct 28 10:37:54 2023 -0400

    Error de data_global solucionado
    
    1-Cambio del tipo de dato de data_global de TArray<Double> por ArrayOfDouble
    2-Ya se le pasa a la funcion insertarSenial data_global con datos dentro.
    3-Salta otro error me dice que la base de datos esta bloqueada

[33mcommit a2ecf5d2c9ec9690667afeeaab9a06c0fdf1918c[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Sat Oct 28 10:13:24 2023 -0400

    Update principal.pas
    
    1-cambie el nombre del parametro a insertarSenial, senial por signal.
    2-elimine el metodo btnEspectroClick.
    3-elimine el procedimiento btnPlayPausaClick.

[33mcommit 31a77fee5ecac42be4948f23efc8b76571c69218[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Mon Oct 9 23:17:15 2023 -0400

    Agregado boton play pausa

[33mcommit 28c1554238501f66aaa8efe9b68cbf181b717cf8[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Thu Oct 5 23:05:10 2023 -0400

    Ya se arreglo la conexion a la BD
    
    En la ventana de analisis tendenciario, pero la conexion la tengo q cambiar para que lea de forma dinamica la configuracion

[33mcommit 5c671b44edef93a43ef223034229f13c67326805[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Mon Oct 2 22:59:50 2023 -0400

    Ya funciona lo de la base de datos
    
    Lo que pasaba era que estaba usando un dll de 64 bits cuando debia usar uno de 32

[33mcommit 6eb3f560cab6206e195acadf0062b600b422f7b9[m
Merge: 9afb41e 903fc48
Author: Cesar <98931642+Cesar0112@users.noreply.github.com>
Date:   Sun Sep 3 00:11:34 2023 -0400

    Merge pull request #1 from Cesar0112/sin_problemas_atuenticacion
    
    Sin problemas atuenticacion

[33mcommit 903fc480d0036f8d282c13cdc788a8ab030cae90[m[33m ([m[1;32msalva_de_no_error[m[33m)[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Sat Sep 2 23:54:26 2023 -0400

    Ahora muestra la señal aleatoria y el espectro
    
    Tenia un problema con el config.cfg que no concordaban el nombre del .pas de la variable Frecuencia de mustreo porq estaban en minusculas

[33mcommit a506a6dc3f2db060d1a1876ff0fe5f3d1368ae31[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Sat Sep 2 23:02:21 2023 -0400

    Antes de que agregue el RandomGen y GenericReal

[33mcommit 923d443a80a1f5e5682ed58c3af9d9597fea8038[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Wed Aug 30 21:02:52 2023 -0400

    Cambio de Claro/Oscuro y ScrollBox
    
    Cambio claro/oscuro un boton q esta en la principal que permite por el momento cambiar solamente esta ventana de claro a oscuro
    el scroll box permite que cuando no se vez todo el contenido de la interfaz el usuario pueda desplazarse hasta visualizar todo o lo que desea

[33mcommit 72b24e8197605542564e56f24e277c35567c8168[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Sun Aug 27 17:36:27 2023 -0400

    Problema de autenticacion
    
    Parece que hay problemas a la hora de autenticarse

[33mcommit 39aa93e9118c04f0395e9148ec1f26c0eae26003[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Fri Aug 25 15:17:08 2023 -0400

    Archivos movidos a SRC/Visual
    
    Por alguna razon no encuentro Config.cfg

[33mcommit 7c99b58f930685e7aa687867ac94a17ed5191c2c[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Fri Aug 25 11:05:45 2023 -0400

    Movimiento de doc y Login
    
    Hice que el boton de visualizar la contraseña se oculte y visualice cuando halla contraseña que ver y moví los documentos de la tesis para la carpeta documentos

[33mcommit 4c6d94322c1749de8d22059c466b21b0115c64f0[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Tue Jul 25 21:10:33 2023 -0400

    Cambios desconocidos

[33mcommit cb946656e3ac054e7d6adf30fe4c88774f441cb2[m[33m ([m[1;31morigin/procesamientoFFT[m[33m)[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Sat Jul 22 15:33:24 2023 -0400

    Agregue el paquete DSPACK
    
    Para la FFT

[33mcommit 8b539422020360ebf8c6e9c2d4d3bec255db8335[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Thu Jul 20 20:13:36 2023 -0400

    Mejore el login
    
    Le falta que cuando ponga el mouse sobre el boton ingresar este aunque este inhabilitado muestre el Hint con el texto Datos erróneos

[33mcommit 04de6977b9e34d610c8852f9c2e2b3169f450729[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Wed Jul 19 03:59:18 2023 -0400

    dia antes exposicion

[33mcommit 50afcb97bd89957f4efc57a69aca4c7dc9e58b5c[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Wed Jul 19 03:36:19 2023 -0400

    El problema anterior resuelto

[33mcommit 7d1e461a469c136c785e80122d6190ba03e137ef[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Wed Jul 19 03:29:50 2023 -0400

    Funciona todo
    
    solo me falta arreglar q se crea y tambien muestra el mensaje no creado

[33mcommit fd1bf5f05ff8d83c16ebd840664a498f3c6a64e2[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Tue Jul 18 20:33:53 2023 -0400

    update info

[33mcommit 1116282f65eb7e18b5c41a992e7b4928dfcb2e4f[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Tue Jul 18 18:58:51 2023 -0400

    Funciona pasar medicion

[33mcommit 797837491bde0121e4bf644177d6ba7bd3408db2[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Tue Jul 18 13:55:53 2023 -0400

    Funciona pero falta el espectro
    
    Y perfeccionar los modos de medicion

[33mcommit 5fb9e4eaf74a3110151055622a776ce2f567a50d[m[33m ([m[1;31morigin/validaciones_entrada[m[33m)[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Tue Jul 18 01:51:20 2023 -0400

    Problemas con la autenticacion

[33mcommit 00cff0ab51b966768d9f377237ebf50575196b2c[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Mon Jul 17 23:45:09 2023 -0400

    Modifico el login y  BD
    
    Login se ve el mensaje error usuario/contrasenia
    BD se agregaron las fk y la tabla ruta_maquina para la relacion de muchos a muchos de rutas y maquinas

[33mcommit a74bba8fc5561fcc69fc36a8ac7a9b0c90d5d342[m[33m ([m[1;31morigin/sin_requisitos_funcionales[m[33m, [m[1;32msin_requisitos_funcionales[m[33m)[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Mon Jul 17 22:43:31 2023 -0400

    Cambio bobo

[33mcommit f794a9c309a5c78ab368ae4db45c83b6b6831563[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Mon Jul 17 12:46:10 2023 -0400

    Update Informe de las Prácticas Profesionales 1.1 .docx

[33mcommit 1f6de287a363dc411306ef123c3cdb58d2406382[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Mon Jul 17 12:45:46 2023 -0400

    agregado el resumem
    
    terminado sin jm

[33mcommit 57b2e813e19befe483eeda41b46a67a6ee24114a[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Mon Jul 17 00:53:43 2023 -0400

    Arreglado errores corregidos por Baster

[33mcommit 3bb640e59d4a688b82dad1d3f0e7530e5ba2b9b4[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Sun Jul 16 16:02:48 2023 -0400

    Terminado el cap 2 y 3
    
    Conclusiones y recomendaciones

[33mcommit a4d5c9aa21099831af77f36af42dac83291c2e0c[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Sun Jul 16 03:14:38 2023 -0400

    Falta por terminar  el cap 3

[33mcommit 8aa2c4d8b9fa24e3cc2ec4981c8865537a6755a4[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Sun Jul 16 00:58:55 2023 -0400

    Añadido 4 historias de usuario de insertar

[33mcommit bb5abe9226694914e7fa063cfc77d2e792476516[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Sat Jul 15 23:44:36 2023 -0400

    Conclui el cap2

[33mcommit dc2dc7abc09c319bc1a1f47ac52fddcad4fd230b[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Sat Jul 15 23:22:35 2023 -0400

    se agrego un disparador y se cambio el 2.1
    
    El disparador es para evitar que se ingresen maquinas con nombre similar.
    El 2.1 se cambio de Reglas del negocio a Explicación de la solucion

[33mcommit e3010f492fc268b7639f1f8592699f9c0319938f[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Sat Jul 15 22:43:04 2023 -0400

    Estoy en las conclusiones parciales.

[33mcommit bccf81f7835f11a436fa364a9ecf3f4ffa6a187e[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Sat Jul 15 15:57:39 2023 -0400

    Agregadas las imagenes de interfaz

[33mcommit 4ade7ee9845197acdd9307224d0b8b9c2e3dc9c6[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Sat Jul 15 13:30:33 2023 -0400

    Agregada autentica imagen

[33mcommit 492ca97d93b45a966a840f019d7c7eb68900840d[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Sat Jul 15 13:19:22 2023 -0400

    Agregado los diagramas de actividades
    
    rutas
    usuarios

[33mcommit d6f30f9749cba3a2c343c87b162bc9f32b938cbf[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Sat Jul 15 13:17:21 2023 -0400

    Creada la seccion de seguridad

[33mcommit 6b956207270061ad70f84721aa7934182c62d7d7[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Sat Jul 15 11:37:06 2023 -0400

    cambios en la ventana usuarios
    
    agregado los privilegios

[33mcommit b485ae87438084423665d11ebad6a55ca64bdb52[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Sat Jul 15 11:24:41 2023 -0400

    Create Informe de las Prácticas Profesionales 1.1 .docx

[33mcommit 80f5ce86d94f605ce8a7ed946c120898c6402015[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Sat Jul 15 02:26:15 2023 -0400

    Hasta diagrama de actividades

[33mcommit 142826d6a1d87cf58020e770c8c274fe1347598d[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Sat Jul 15 01:21:57 2023 -0400

    Hasta los modelos logicos y fisicos

[33mcommit b054079b6c7f99275910430057e16c8623ca7993[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Fri Jul 14 22:49:20 2023 -0400

    Agregado el diagrama de actividades de medicion

[33mcommit 84f158d924167db3c017f81cc9679c270b6dd8aa[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Fri Jul 14 15:04:37 2023 -0400

    cambiado el fiagrama de casos de uso
    
    se quito que el especialista detectaray capturar la señal directamente el sinp cuando se inicia el monitoreo

[33mcommit 9caa80639325d076f193c18db1bc2eed81a2e19a[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Fri Jul 14 12:31:55 2023 -0400

    Tabla de descripción de los actores del negocio

[33mcommit 9afb41e42b798e0d2c388cf014c1031107f6116d[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Fri Jul 14 11:32:32 2023 -0400

    Hecho el eqpigrafe del modelo del dominio

[33mcommit 27e56994b2b878e4272e9783267ff991bf8c61a8[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Fri Jul 14 09:31:28 2023 -0400

    Elimine fila del dominio y cree el diagrama
    
    Fila Receptor ya que el control lo puede realizar el Equipo si se desea

[33mcommit 3f58f4137cfd8ee7b15b2ffc945d0f5aa7ab4eb2[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Fri Jul 14 09:22:08 2023 -0400

    Agregue a la tabla del dominio
    
    1 Ruta
    2 Maquina

[33mcommit f2388141312cad8291cf9feddaa41d05b7cfbc3b[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Fri Jul 14 09:01:30 2023 -0400

    Principio del apartado Modelo del Dominio

[33mcommit a5f7dfd0e5b20a316edaedb9b05d2c08864cb6de[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Fri Jul 14 01:36:30 2023 -0400

    Hecho hasta usabilidad

[33mcommit 18529b18b8510ffc85eafad7232be2baa627b884[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Thu Jul 13 22:46:23 2023 -0400

    Falta hacer el analisis de tendencia

[33mcommit 35c364cfdedcf66621f190e5b15936834d6eda28[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Thu Jul 13 21:12:26 2023 -0400

    sirve la gestion de rutas

[33mcommit d9a04d4c1e250e6f7685a7954be60c9827c70fd0[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Thu Jul 13 20:32:24 2023 -0400

    Ya funciona el manejo de rutas apenas
    
    Sale la exception RangeCheckError
    cuando el camino de una ruta esta en blanco

[33mcommit 7cea32d429e5442832008e257e3eb4745de63055[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Thu Jul 13 16:34:25 2023 -0400

    funciona en el login que al apretar  enter ingresa

[33mcommit 1d825ead4b33c36163cc1d310786cf7bc5ca571b[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Thu Jul 13 16:03:01 2023 -0400

    Ya funciona la gestion de usuarios
    
    se oculta esa opcion cuando no es un admin el que esta controlando la situacion

[33mcommit 8ca05b7255f2a8c85153d2a60f999df35a57d83c[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Thu Jul 13 09:09:47 2023 -0400

    Creado el formUsuarios

[33mcommit eefd8e08c5b2f67e838bab4d0456e33036ad711b[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Thu Jul 13 08:27:44 2023 -0400

    Eliminado boton de insertar usuarios

[33mcommit eb42eec1cae46c0c3dbf1529a459a6e1937aedad[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Thu Jul 13 08:12:10 2023 -0400

    Update Login.pas

[33mcommit e544b14b6fbc40fe29e3cc0207131be3d4cfe9df[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Thu Jul 13 08:11:52 2023 -0400

    Funciona el login por encriptacion

[33mcommit 87526c497e2fffa2bedaf0b160ee193bdfaf5744[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Thu Jul 13 01:30:42 2023 -0400

    Todo funciona nuevamente

[33mcommit a53dd5e165b3364362bb0d82cda858afb49dd092[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Thu Jul 13 01:10:21 2023 -0400

    Update mydatabase.db

[33mcommit 7476441fa6947bb79216472c96556f4b8356b710[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Wed Jul 12 22:43:32 2023 -0400

    Si hizo la forma de registrar la señal
    
    La señal que esta en el grafico principal

[33mcommit 021c84d357ac33cd9ea0d93f75255a542975620f[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Tue Jul 11 02:45:14 2023 -0400

    cambie la base datos

[33mcommit 0d2b1f9c2ce4fd86e1f07dca79830ca445552001[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Tue Jul 11 00:39:20 2023 -0400

    Corregido los errores cogidos por Baster

[33mcommit 247e2a09c9ca02c05293a759073d5992b618da7d[m
Author: Cesar0112 <hectorfernandezdiaz6@gmail.com>
Date:   Mon Jul 10 13:15:49 2023 -0400

    Arreglado las siglas TI y OT y IIoT

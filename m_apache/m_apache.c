/*
   ----------------------------------------------------------------------------
   | m_apache                                                                 |
   | Copyright (c) 2004-2014 M/Gateway Developments Ltd,                      |
   | Surrey UK.                                                               |
   | All rights reserved.                                                     |
   |                                                                          |
   | http://www.mgateway.com                                                  |
   |                                                                          |
   | This program is free software: you can redistribute it and/or modify     |
   | it under the terms of the GNU Affero General Public License as           |
   | published by the Free Software Foundation, either version 3 of the       |
   | License, or (at your option) any later version.                          |
   |                                                                          |
   | This program is distributed in the hope that it will be useful,          |
   | but WITHOUT ANY WARRANTY; without even the implied warranty of           |
   | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            |
   | GNU Affero General Public License for more details.                      |
   |                                                                          |
   | You should have received a copy of the GNU Affero General Public License |
   | along with this program.  If not, see <http://www.gnu.org/licenses/>.    |
   ----------------------------------------------------------------------------
*/

/*
   Building
   ========

   Use one of the following methods:

   1) The Apache Group axps (APache eXtenSion) tool (recommended):

      Build this software using the following command:

      apxs -i -a -I<path_containing_/openssl/crypto.h> -o m_apache22.so -c m_apache.c

      Documentation: http://httpd.apache.org/docs/2.2/programs/apxs.html

   2) Build a shared object from first principles:

      Linux
      -----
      gcc -c -fpic -DLINUX=2 -D_REENTRANT -D_GNU_SOURCE -D_LARGEFILE64_SOURCE -I<path_containing_httpd.h> -I<path_containing_/openssl/crypto.h> -o m_apache22.o m_apache.c
      gcc -shared -rdynamic -o m_apache22.so m_apache22.o

      FreeBSD
      -------
      cc -c -DFREEBSD -I<path_containing_httpd.h> -I<path_containing_/openssl/crypto.h> -o m_apache22.o m_apache.c
      ld -G -o m_apache22.so m_apache22.o

      AIX
      ---
      xlc_r -c -DAIX -I<path_containing_httpd.h> -I<path_containing_/openssl/crypto.h> -o m_apache22.o m_apache.c
      xlc_r -G -H512 -T512 -bM:SRE m_apache22.o -berok -bexpall -bnoentry -o m_apache22.so

      Mac OS X
      --------
      gcc -c -fPIC -fno-common -DMACOSX -D_NOTHREADS -DDARWIN -I<path_containing_httpd.h> -I<path_containing_/openssl/crypto.h> -o m_apache22.o m_apache.c
      gcc -bundle -flat_namespace -undefined suppress m_apache22.o -o m_apache22.so

      HPUX64
      ------
      cc -c -DHPUX11 -DNET_SSL -D_HPUX_SOURCE -Ae +DA2.0W +z -DMCC_HTTPD -DSPAPI20 -I<path_containing_httpd.h> -I<path_containing_/openssl/crypto.h> -o m_apache22.o m_apache.c
      ld -b  m_apache22.o -o m_apache22.so

      Dec UNIX
      --------
      cc -c -DOSF1 -std0 -w -pthread -DIS_64 -ieee_with_inexact -I<path_containing_httpd.h> -I<path_containing_/openssl/crypto.h> -o m_apache22.o m_apache.c
      ld -all -shared -expect_unresolved "*" -taso m_apache22.o -o m_apache22.so

      Solaris SPARC32
      ---------------
      cc -c Xa -w -DSOLARIS -I<path_containing_httpd.h> -I<path_containing_/openssl/crypto.h> -o m_apache22.o m_apache.c
      ld -G m_apache22.o -o m_apache22.so

      Solaris SPARC64
      ---------------
      cc -c -Xa -w -xarch=v9 -KPIC -DBIT64PLAT -DSOLARIS -I<path_containing_httpd.h> -I<path_containing_/openssl/crypto.h> -o m_apache22.o m_apache.c
      ld -G m_apache22.o -o m_apache22.so


   Configuration
   =============

      m_apache is configured in the Apache configuration file: usually http.conf.

      The m_apache module (a shared object) is usually named as follows:

      Apache v1.3.x: m_apache13.so
      Apache v2.0.x: m_apache2.so
      Apache v2.2.x: m_apache22.so
      Apache v2.4.x: m_apache24.so

      Apache must be instructed to load the m_apache module using the following directive:

         LoadModule m_apache_module /usr/mgwsi/bin/m_apache22.so

      If you used 'apxs' to build and install this module, you will find that the shared object is installed in the
      preconfigured modules directory and the following line will have been added to the configuration:
 
         LoadModule m_apache_module modules/m_apache22.so

      By default, m_apache will response to requests for files of type: .mgwsi and .ewd.  Additional files can be specified using the
      following directive:

         MGWSIFileTypes .foo .bar

      To configure m_apache to respond to requests for ALL files in a path use the following directive:

         MGWSI On

      The maximum number of pooled connections to a server (per Apache child process) can be specified using the following directive:

         MGWSIMaxPooledConnections <max_no_connections>

      The default is 32 connections per process.

      By default, m_apache will attempt to communicate with a server running on the local machine.  The server, in this context, can be
      either the M/Gateway MGWSI Gateway (which is freely available but is not Open Source) or directly to an M installation.

      * The MGWSI Gateway usually listens on its default TCP port of 7040.
      * The corresponding M daemon (the %ZMGWSI routine) usually listens on its default TCP port of 7041.

      By default, m_apache will attempt to connect to a local server listening on port 7040.

      An alternative server can be specified as follows:

         SetEnv MGWSI_SERVER <ip_address>

      An alternative port can be specified as follows:

         SetEnv MGWSI_PORT <port>

      *******
      If the server is the MGWSI Gateway, you can specify the M server name as follows:

         SetEnv MGWSI_M_SERVER <server_name>

      where 'server_name' is the name assigned to the M server in the MGWSI Gateway configuration
      *******

      A UCI can be specified using:

         SetEnv MGWSI_M_UCI <uci_name>

      The M function to be used to process requests is specified using:

         SetEnv MGWSI_M_FUNCTION <m_function_name>

      For example:

         SetEnv MGWSI_M_FUNCTION TEST^WEB

      M functions defined here must accept two input parameters:

         <label>^<routine>(cgi, data)

      For example:

         TEST(cgi,data)


      CGI environment variables are placed in a One-Dimensional 'cgi' array. Posted content is
      placed in a Two-Dimensional 'data' array. Only Query strings and 'x-www-formurlencoded'
      posted content are pre-parsed.

      Example:

         POST /mgwsi/test.mgwsi?xxx=yyy1&xxx=yyy2 HTTP/1.1
         Host: 127.0.0.1
         Content-Length: 7
         a=b&c=d

      This will be dispatched to your function as:

         data(a,1)=b
         data(c,1)=d
         data(xxx,1)=yyy1
         data(xxx,2)=yyy2

      All other content types (e.g. XML) are placed in the following structure:

         data($CONTENT,1)=<content>

      Example:

         POST /mgwsi/test.mgwsi HTTP/1.1
         Host: 127.0.0.1
         Content-Length: 15
         <xml>test</xml>

      This will be dispatched to your function as:

         data($CONTENT,1)=<xml>test</xml>

      Large volumes of request data can be uploaded to the '^MGWSI' global:

         SetEnv MGWSI_M_STORAGE_MODE 1


   Configuration - putting it all together
   =======================================

      The following configuration block will instruct m_apache to forward all requests for default file types
      (.mgwsi, .ewd) in path '/mypath' to a local installation of M listening on TCP port 7041.  Requests will be processed by
      a M function called 'TEST^WEB'. 

         LoadModule m_apache_module /usr/mgwsi/bin/m_apache22.so
         <Location /mypath>
            SetEnv MGWSI_M_PORT 7041
            SetEnv MGWSI_M_FUNCTION TEST^WEB
         </Location>


      Apache should be restarted after making changes to its configuration.


   Operation
   =========

      Choose one of the following approaches:

      1.    xinetd with GT.M (RECOMMENDED)

            In this mode of operation the extended Unix superserver daemon (xinetd) is used to start M processes in response to demand from m_apache.

      1.1.  Create the following line in configuration file: /etc/services

            mgwsi           7041/tcp                # Service for MGWSI clients

      1.2.  Create a file called 'mgwsi' with the following contents in directory: /etc/xinetd.d/

            service mgwsi
            {
               disable     = no
               type        = UNLISTED
               port        = 7041
               socket_type = stream
               wait        = no
               user        = root
               server      = /usr/local/gtm/zmgwsi
            }

      1.3.  Create a script called 'zmgwsi' with the following contents in directory: /usr/local/gtm/

            #!/bin/bash
            cd /usr/local/gtm
            export gtm_dist=/usr/local/gtm
            export gtmroutines=/usr/local/gtm
            export gtmgbldir=mumps.gld
            $gtm_dist/mumps -r INETD^%ZMGWSIS


            Depending on installation, you may also have to include values for gtmver and gtmdir. For example:

            export gtmver=V6.0-002_x86
            export gtmdir=/root/.fis-gtm

      1.4.  Restart the xinetd daemon.  For example, by issuing the following command:

            /etc/init.d/xinetd restart


            You may wish to modify the 'user' (specified in 1.2), the tcp port (specified in 1.1 and 1.2),
            and paths as appropriate for your own installation.


      2.    inetd with GT.M (not as secure as 1)

            In this mode of operation the standard Unix superserver daemon (inetd) is used to start M processes in response to demand from m_apache.

      2.1.  Create the following line in configuration file: /etc/services

            mgwsi           7041/tcp                # Service for MGWSI clients

      2.2.  Create following line in configuration file: /etc/inetd.conf:

            mgwsi  stream  tcp nowait  root /usr/local/gtm/zmgwsi

      2.3.  Create a script called 'zmgwsi' with the following contents in directory: /usr/local/gtm/

            #!/bin/bash
            cd /usr/local/gtm
            export gtm_dist=/usr/local/gtm
            export gtmroutines=/usr/local/gtm
            export gtmgbldir=mumps.gld
            $gtm_dist/mumps -r INETD^%ZMGWSIS

            Depending on installation, you may also have to include values for gtmver and gtmdir. For example:

            export gtmver=V6.0-002_x86
            export gtmdir=/root/.fis-gtm

      2.4.  Restart the inetd daemon.  For example, by issuing the following command:

            /etc/init.d/inetd restart

            You may wish to modify the user (specified in 2.2), the tcp port (specified in 2.1),
            and paths as appropriate for your own installation.

      3.    Direct communication between m_apache.c and M (not recommended for GT.M)

               This approach of not recommended for GT.M because this server does not support concurrent TCP connectivity
               over a single TCP server port.
               If this mode is used then separate TCP ports will be used for each and every GT.M process started.

            The %ZMGWSI daemon must be running on the M server and waiting for incoming connections from m_apache.
            To start the %ZMGWSI daemon at the M prompt:

            D START^%ZMGWSI(<port>)

            To start the daemon on its default port of 7041, use zero for the port:

            D START^%ZMGWSI(0)


      Having configured the installation as described above, m_apache will now forward the following request to
      the TEST^WEB() function for onward processing.

         http://<web_server>/mypath/myfile.mgwsi


   WebSocket Support
   =================

   WebSockets (RFC 6455) are supported for build 50 (and later) of this module together with Apache v2.2 (and later).
   Also, you need build 11 (or later) of the %ZMGWSIS routine.  To check the version/build you have, run %ZMGWSIS:

      GTM>Do ^%ZMGWSIS

      M/Gateway Developments Ltd - Service Integration Gateway
      Version: 2.2; Revision 11 (9 December 2013)

   Use the 'MGWSI_M_WS_SERVER' environment variable to define the M routine representing the WebSocket Server.  For example:

      SetEnv MGWSI_M_WS_SERVER WS^%ZMGWSIS

   Study embedded sample WS^%ZMGWSIS to see how WebSocket servers are created.

   It is recommended that you experiment with the embedded sample (a simple WebSocket echo) before creating WebSocket applications of your own.
   The procedure for running the sample is as follows.

   1. Configure the Apache server to use WebSocket server WS^%ZMGWSIS for your path (/mypath/):

      <Location /mypath>
         SetEnv MGWSI_M_FUNCTION WEB^%ZMGWSIS
         SetEnv MGWSI_M_WS_SERVER WS^%ZMGWSIS
      </Location>

   2. Create the following HTML file (ws.html) in your Documents Root (/htdocs):
   
      <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
      <html>
      <head>
         <title>WebSocket Echo</title>
         <script type="text/javascript">
         <!--
            var ws;

            if ((typeof(WebSocket) == 'undefined') && (typeof(MozWebSocket) != 'undefined')) {
               WebSocket = MozWebSocket;
            }

            function init() {
               ws = new WebSocket(((window.location.protocol == "https:") ? "wss:" : "ws:") + "//" + window.location.host + "/mypath/wstest.mgwsi");
               ws.onopen = function(event) {
                  document.getElementById("main").style.visibility = "visible";
                  document.getElementById("connected").innerHTML = "Connected to WebSocket server";
               };
               ws.onmessage = function(event) {
                  document.getElementById("output").innerHTML = event.data;
               };
               ws.onerror = function(event) { alert("Received error"); };
               ws.onclose = function(event) {
                  ws = null;
                  document.getElementById("main").style.visibility = "hidden";
                  document.getElementById("connected").innerHTML = "Connection Closed";
               }
            }

            function send(message) {
               if (ws) {
                  ws.send(message);
               }
            }
         // -->
         </script>
      </head>
      <body onload="init();">
         <h1>WebSocket Echo</h1>
         <div id="connected">Not Connected</div>
         <div id="main" style="visibility:hidden">
         Enter Message: <input type="text" name="message" value="" size="80" onchange="send(this.value)"/><br/>
         Server says... <div id="output"></div>
         </div>
      </body>
      </html>


   3. Run the sample:

         http://<web_server>/ws.html


   Encryption functions
   ====================

   The m_apache module provides an interface to a number of useful system and encryption utilities.  The encryption utilities
   will only be available if the OpenSSL libraries are installed.

   These systems functions are provided to the M environment through the following URL:

      /mgwsi/sys/system_functions.mgwsi

   Access to these functions can be controlled via the following configuration block in httpd.conf:

      <Location "/mgwsi/sys/">
         Order deny,allow
         Allow from all
      </Location>

   Functions:

   All functions include a 'b64' flag which should be set to '1' if the result is to be base-64 encoded.
   The 'context' flag should be set to '1' if m_apache is providing the interface, otherwise it should be
   set to '0' if the MGWSI Gateway is providing the interface.


   1.    HMAC-SHA256

         set result=$$HMACSHA256^%ZMGWSIS(<string>, <key>, <b64>, <context>)

   2.    HMAC-SHA1

         set result=HMACSHA1^%ZMGWSIS(<string>, <key>, <b64>, <context>)

   3.    HMAC-SHA

         set result=HMACSHA^%ZMGWSIS(<string>, <key>, <b64>, <context>)

   4.    HMAC-MD5

         set result=HMACMD5^%ZMGWSIS(<string>, <key>, <b64>, <context>)

   5.    SHA256

         set result=SHA256^%ZMGWSIS(<string>, <b64>, <context>)

   6.    SHA1

         set result=SHA1^%ZMGWSIS(<string>, <b64>, <context>)

   7.    SHA

         set result=SHA^%ZMGWSIS(<string>, <b64>, <context>)

   8.    MD5

         set result=MD5^%ZMGWSIS(<string>, <b64>, <context>)

   9.    Encode to BASE64

         set result=B64^%ZMGWSIS(<string>, <context>)

   10.   Decode from BASE64

         set result=DB64^%ZMGWSIS(<string>, <context>)

   11.   Get time in milliseconds

         set result=TIME^%ZMGWSIS(<context>)

   12.   Get timestamp in milliseconds

         set result=ZTS^%ZMGWSIS(<context>)


   Example: Generate a SHA256 HMAC using m_apache and base-64 encode the result:

         set result=$$HMACSHA256^%ZMGWSIS("my data","my key",1,1)


*/

/*

v2.0.49: 1 July 2009:
   Persistence for [x]inetd support

v2.2.50: 16 December 2013:
   WebSocket support
   - WebSocket Server: SetEnv MGWSI_M_WS_SERVER WS^%ZMGWSIS

*/

#define MGWSI_VERSION               "2.2.50"
#define MGWSI_CLIENT_BUILD          50
#define MGWSI_CLIENT_TYPE           "m_apache"

#define MGWSI_SERVER                "127.0.0.1"
#define MGWSI_PORT                  7040

#define MGWSI_DEBUG                 0

#define MGWSI_M_SERVER              "LOCAL"
#define MGWSI_M_UCI                 ""
#define MGWSI_M_FUNCTION            "WEB^%ZMGWSIS"
#define MGWSI_M_WS_SERVER           "WS^%ZMGWSIS"

#define MGWSI_SSL                   1
#define MGWSI_SSL_SO                1

#define MGWSI_MIME_TYPE1            "application/x-mgwsi"
#define MGWSI_MIME_TYPE2            "text/mgwsi"
#define MGWSI_FILE_TYPES            ".mgwsi.ewd."

#define MGWSI_BUFSIZE               32768
#define MGWSI_BUFMAX                32767
#define MGWSI_MAXCON                32

#define MGWSI_T_VAR                 0
#define MGWSI_T_STRING              1
#define MGWSI_T_INTEGER             2
#define MGWSI_T_FLOAT               3
#define MGWSI_T_LIST                4

#define MGWSI_TX_DATA               0
#define MGWSI_TX_AKEY               1
#define MGWSI_TX_AREC               2
#define MGWSI_TX_EOD                3
#define MGWSI_TX_AREC_FORMATTED     9

#define MGWSI_ES_DELIM              0
#define MGWSI_ES_BLOCK              1

#define MGWSI_RECV_HEAD             8

#define MGWSI_CHUNK_SIZE_BASE       62

#define MGWCON_STATUS_FREE          0
#define MGWCON_STATUS_INUSE         1
#define MGWCON_CONSTATUS_DSCON      0
#define MGWCON_CONSTATUS_CON        1

#define MGWCON_DSCON_SOFT           0
#define MGWCON_DSCON_HARD           1

#define MGWSI_CON_GATEWAY           0
#define MGWSI_CON_M                 1
#define MGWSI_CON_DUNNO             -1


#if defined(_WIN32)
#ifndef MGWSI_WIN32
#define MGWSI_WIN32                 1
#endif
#define MGWSI_WINSOCK2              1
#if defined(_MSC_VER)
#if (_MSC_VER >= 1400)
#define _CRT_SECURE_NO_DEPRECATE    1
#define _CRT_NONSTDC_NO_DEPRECATE   1
#define MGWSI_IPV6                  1
#endif
#endif
#define MGWSI_LOG_FILE              "C:/m_apache.log"
#elif defined(VMS) || defined(_VMS) || defined(__VMS) || defined(MGWSI_VMS) /* VMS */
#ifndef MGWSI_VMS
#define MGWSI_VMS                   1
#endif
#define MGWSI_LOG_FILE              "/tmp/m_apache.log"
#else /* UNIX */
#ifndef MGWSI_UNIX
#define MGWSI_UNIX                  1
#endif
/*
#define MGWSI_IPV6                  1
*/
#define MGWSI_LOG_FILE              "/tmp/m_apache.log"
#endif

#define CORE_PRIVATE

#ifdef _WIN32
#ifdef MGWSI_WINSOCK2
#define INCL_WINSOCK_API_TYPEDEFS   1
#include <winsock2.h>
#include <ws2tcpip.h>
#endif
#endif

#include "httpd.h"
#include "http_config.h"
#include "http_core.h"
#include "http_log.h"
#include "http_main.h"
#include "http_protocol.h"
#include "util_script.h"


#if !defined(APACHE_RELEASE)
#include "http_request.h"
#include "http_connection.h"

#include "apr_base64.h"
#include "apr_sha1.h"
#include "util_ebcdic.h"

#include "apr_strings.h"
#if defined(AP_SERVER_MAJORVERSION_NUMBER) && defined(AP_SERVER_MINORVERSION_NUMBER)
#if AP_SERVER_MAJORVERSION_NUMBER >= 2 && AP_SERVER_MINORVERSION_NUMBER >= 4
#define MGWSI_APACHE_VERSION       24
#elif AP_SERVER_MAJORVERSION_NUMBER >= 2 && AP_SERVER_MINORVERSION_NUMBER >= 2
#define MGWSI_APACHE_VERSION        22
#else
#define MGWSI_APACHE_VERSION        20
#endif
#else
#define MGWSI_APACHE_VERSION        20
#endif
#else
#if APACHE_RELEASE < 1030000
#define MGWSI_APACHE_VERSION        12
#else
#define MGWSI_APACHE_VERSION        13
#endif
#endif


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <ctype.h>
#if defined(_WIN32)
#include <tchar.h>
#include <windows.h>
#include <winsock.h>
#include <fcntl.h>
#include <io.h>
#include <sys/timeb.h>
#elif defined(MGWSI_UNIX)
#include <sys/signal.h>
#include <sys/errno.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/param.h>
#include <sys/socket.h>
#include <fcntl.h>
#include <netdb.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <errno.h>
#include <dlfcn.h>
#elif defined(MGWSI_VMS)
#include <descrip.h>
#include <iodef.h>
#include <lib$routines.h>
#include <signal.h>
#include <unixio.h>
#include <errno.h>
#include <types.h>
#include <socket.h>
#include <ssdef.h>
#include <starlet.h>
#include <in.h>
#include <netdb.h>
#include <inet.h>
#endif


#ifdef MGWSI_SSL
#include <openssl/rsa.h>
#include <openssl/crypto.h>
#include <openssl/x509.h>
#include <openssl/pem.h>
#include <openssl/ssl.h>
#include <openssl/err.h>
#endif


#if MGWSI_APACHE_VERSION < 13
#define MGWSI_TABLE_GET                   table_get
#define MGWSI_TABLE_DO                    table_do
#define MGWSI_TABLE_SET                   table_set
#define MGWSI_TABLE_ADD                   table_add
#define MGWSI_TABLE_ADDN                  table_addn
#define MGWSI_PSTRCAT                     pstrcat
#define MGWSI_PSTRDUP                     pstrdup
#define MGWSI_PCALLOC                     pcalloc
#define MGWSI_RWRITE                      rwrite
#define MGWSI_RFLUSH                      rflush
#define MGWSI_RPRINTF                     rprintf
#define MGWSI_RPUTS                       rputs
#define MGWSI_SOFT_TIMEOUT                soft_timeout
#define MGWSI_RESET_TIMEOUT               reset_timeout
#define MGWSI_KILL_TIMEOUT                kill_timeout
#define MGWSI_SHOULD_CLIENT_BLOCK         should_client_block
#define MGWSI_SETUP_CLIENT_BLOCK          setup_client_block
#define MGWSI_ADD_CGI_VARS                add_cgi_vars
#define MGWSI_GET_CLIENT_BLOCK            get_client_block
#define MGWSI_ADD_COMMON_VARS             add_common_vars
#define MGWSI_MAKE_SUB_POOL               make_sub_pool
#define MGWSI_DESTROY_POOL                destroy_pool
#define MGWSI_MAKE_TABLE                  make_table
#define MGWSI_SEND_HTTP_HEADER            send_http_header
#define MGWSI_GET_MODULE_CONFIG           get_module_config
#else

#if MGWSI_APACHE_VERSION >= 20
typedef apr_pool_t                        pool;
typedef apr_table_t                       table;
#define SERVER_ERROR                      HTTP_INTERNAL_SERVER_ERROR
#endif

#if MGWSI_APACHE_VERSION >= 20
#define MGWSI_PCALLOC                     apr_pcalloc
#define MGWSI_TABLE_GET                   apr_table_get
#define MGWSI_TABLE_DO                    apr_table_do
#define MGWSI_TABLE_SET                   apr_table_set
#define MGWSI_TABLE_ADD                   apr_table_add
#define MGWSI_TABLE_ADDN                  apr_table_addn
#define MGWSI_PSTRCAT                     apr_pstrcat
#define MGWSI_PSTRDUP                     apr_pstrdup
#define MGWSI_MAKE_TABLE                  apr_table_make
#define MGWSI_MAKE_SUB_POOL               apr_create_pool
#define MGWSI_DESTROY_POOL                apr_pool_destroy
#else
#define MGWSI_PCALLOC                     ap_pcalloc
#define MGWSI_TABLE_GET                   ap_table_get
#define MGWSI_TABLE_DO                    ap_table_do
#define MGWSI_TABLE_SET                   ap_table_set
#define MGWSI_TABLE_ADD                   ap_table_add
#define MGWSI_TABLE_ADDN                  ap_table_addn
#define MGWSI_PSTRCAT                     ap_pstrcat
#define MGWSI_PSTRDUP                     ap_pstrdup
#define MGWSI_MAKE_TABLE                  ap_make_table
#define MGWSI_MAKE_SUB_POOL               ap_make_sub_pool
#define MGWSI_DESTROY_POOL                ap_destroy_pool
#endif

#define MGWSI_RWRITE                      ap_rwrite
#define MGWSI_RFLUSH                      ap_rflush
#define MGWSI_RPRINTF                     ap_rprintf
#define MGWSI_RPUTS                       ap_rputs
#define MGWSI_SOFT_TIMEOUT                ap_soft_timeout
#define MGWSI_RESET_TIMEOUT               ap_reset_timeout
#define MGWSI_KILL_TIMEOUT                ap_kill_timeout
#define MGWSI_SHOULD_CLIENT_BLOCK         ap_should_client_block
#define MGWSI_SETUP_CLIENT_BLOCK          ap_setup_client_block
#define MGWSI_ADD_CGI_VARS                ap_add_cgi_vars
#define MGWSI_GET_CLIENT_BLOCK            ap_get_client_block
#define MGWSI_ADD_COMMON_VARS             ap_add_common_vars
#define MGWSI_SEND_HTTP_HEADER            ap_send_http_header
#define MGWSI_GET_MODULE_CONFIG           ap_get_module_config
#endif

#if MGWSI_APACHE_VERSION >= 22
#if APR_HAS_THREADS || defined(DOXYGEN)
#define MGWSI_WEBSOCKETS                  1
#endif
#endif

/* WebSockets constants */

#define MGWSI_WS_BLOCK_DATA_SIZE              4096

#define MGWSI_WS_DATA_FRAMING_MASK               0
#define MGWSI_WS_DATA_FRAMING_START              1
#define MGWSI_WS_DATA_FRAMING_PAYLOAD_LENGTH     2
#define MGWSI_WS_DATA_FRAMING_PAYLOAD_LENGTH_EXT 3
#define MGWSI_WS_DATA_FRAMING_EXTENSION_DATA     4
#define MGWSI_WS_DATA_FRAMING_APPLICATION_DATA   5
#define MGWSI_WS_DATA_FRAMING_CLOSE              6

#define MGWSI_WS_FRAME_GET_FIN(BYTE)         (((BYTE) >> 7) & 0x01)
#define MGWSI_WS_FRAME_GET_RSV1(BYTE)        (((BYTE) >> 6) & 0x01)
#define MGWSI_WS_FRAME_GET_RSV2(BYTE)        (((BYTE) >> 5) & 0x01)
#define MGWSI_WS_FRAME_GET_RSV3(BYTE)        (((BYTE) >> 4) & 0x01)
#define MGWSI_WS_FRAME_GET_OPCODE(BYTE)      ( (BYTE)       & 0x0F)
#define MGWSI_WS_FRAME_GET_MASK(BYTE)        (((BYTE) >> 7) & 0x01)
#define MGWSI_WS_FRAME_GET_PAYLOAD_LEN(BYTE) ( (BYTE)       & 0x7F)

#define MGWSI_WS_FRAME_SET_FIN(BYTE)         (((BYTE) & 0x01) << 7)
#define MGWSI_WS_FRAME_SET_OPCODE(BYTE)       ((BYTE) & 0x0F)
#define MGWSI_WS_FRAME_SET_MASK(BYTE)        (((BYTE) & 0x01) << 7)
#define MGWSI_WS_FRAME_SET_LENGTH(X64, IDX)  (unsigned char)(((X64) >> ((IDX)*8)) & 0xFF)

#define MGWSI_WS_OPCODE_CONTINUATION 0x0
#define MGWSI_WS_OPCODE_TEXT         0x1
#define MGWSI_WS_OPCODE_BINARY       0x2
#define MGWSI_WS_OPCODE_CLOSE        0x8
#define MGWSI_WS_OPCODE_PING         0x9
#define MGWSI_WS_OPCODE_PONG         0xA

#define MGWSI_WS_WEBSOCKET_GUID "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
#define MGWSI_WS_WEBSOCKET_GUID_LEN 36

#define MGWSI_WS_STATUS_CODE_OK                1000
#define MGWSI_WS_STATUS_CODE_GOING_AWAY        1001
#define MGWSI_WS_STATUS_CODE_PROTOCOL_ERROR    1002
#define MGWSI_WS_STATUS_CODE_RESERVED          1004 /* Protocol 8: frame too large */
#define MGWSI_WS_STATUS_CODE_INVALID_UTF8      1007
#define MGWSI_WS_STATUS_CODE_POLICY_VIOLATION  1008
#define MGWSI_WS_STATUS_CODE_MESSAGE_TOO_LARGE 1009
#define MGWSI_WS_STATUS_CODE_INTERNAL_ERROR    1011

#define MGWSI_WS_MESSAGE_TYPE_INVALID  -1
#define MGWSI_WS_MESSAGE_TYPE_TEXT      0
#define MGWSI_WS_MESSAGE_TYPE_BINARY  128
#define MGWSI_WS_MESSAGE_TYPE_CLOSE   255
#define MGWSI_WS_MESSAGE_TYPE_PING    256
#define MGWSI_WS_MESSAGE_TYPE_PONG    257

#if !defined(APR_ARRAY_IDX)
#define APR_ARRAY_IDX(ary,i,type) (((type *)(ary)->elts)[i])
#endif
#if !defined(APR_ARRAY_PUSH)
#define APR_ARRAY_PUSH(ary,type) (*((type *)apr_array_push(ary)))
#endif

#define S0 0x000
#define T1 0x100
#define T2 0x200
#define S1 0x300
#define S2 0x400
#define T3 0x500
#define S3 0x600
#define S4 0x700
#define ER 0x800

#define UTF8_VALID   0x000
#define UTF8_INVALID 0x800

static const unsigned short validate_utf8[2048] = {
   /* S0 (0x000) */
   S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0, /* %x00-0F */
   S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0, /* %x10-1F */
   S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0, /* %x20-2F */
   S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0, /* %x30-3F */
   S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0, /* %x40-4F */
   S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0, /* %x50-5F */
   S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0, /* %x60-6F */
   S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0, /* %x70-7F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x80-8F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x90-9F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xA0-AF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xB0-BF */
   ER,ER,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1, /* %xC0-CF */
   T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1, /* %xD0-DF */
   S1,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,S2,T2,T2, /* %xE0-EF */
   S3,T3,T3,T3,S4,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xF0-FF */
   /* T1 (0x100) */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x00-0F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x10-1F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x20-2F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x30-3F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x40-4F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x50-5F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x60-6F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x70-7F */
   S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0, /* %x80-8F */
   S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0, /* %x90-9F */
   S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0, /* %xA0-AF */
   S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0,S0, /* %xB0-BF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xC0-CF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xD0-DF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xE0-EF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xF0-FF */
   /* T2 (0x200) */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x00-0F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x10-1F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x20-2F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x30-3F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x40-4F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x50-5F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x60-6F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x70-7F */
   T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1, /* %x80-8F */
   T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1, /* %x90-9F */
   T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1, /* %xA0-AF */
   T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1, /* %xB0-BF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xC0-CF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xD0-DF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xE0-EF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xF0-FF */
   /* S1 (0x300) */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x00-0F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x10-1F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x20-2F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x30-3F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x40-4F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x50-5F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x60-6F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x70-7F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x80-8F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x90-9F */
   T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1, /* %xA0-AF */
   T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1, /* %xB0-BF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xC0-CF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xD0-DF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xE0-EF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xF0-FF */
   /* S2 (0x400) */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x00-0F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x10-1F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x20-2F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x30-3F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x40-4F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x50-5F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x60-6F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x70-7F */
   T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1, /* %x80-8F */
   T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1,T1, /* %x90-9F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xA0-AF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xB0-BF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xC0-CF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xD0-DF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xE0-EF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xF0-FF */
   /* T3 (0x500) */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x00-0F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x10-1F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x20-2F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x30-3F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x40-4F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x50-5F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x60-6F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x70-7F */
   T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2, /* %x80-8F */
   T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2, /* %x90-9F */
   T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2, /* %xA0-AF */
   T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2, /* %xB0-BF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xC0-CF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xD0-DF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xE0-EF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xF0-FF */
   /* S3 (0x600) */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x00-0F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x10-1F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x20-2F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x30-3F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x40-4F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x50-5F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x60-6F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x70-7F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x80-8F */
   T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2, /* %x90-9F */
   T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2, /* %xA0-AF */
   T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2, /* %xB0-BF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xC0-CF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xD0-DF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xE0-EF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xF0-FF */
   /* S4 (0x700) */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x00-0F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x10-1F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x20-2F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x30-3F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x40-4F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x50-5F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x60-6F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x70-7F */
   T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2,T2, /* %x80-8F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %x90-9F */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xA0-AF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xB0-BF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xC0-CF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xD0-DF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xE0-EF */
   ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER,ER, /* %xF0-FF */
};

#undef S0
#undef T1
#undef T2
#undef S1
#undef S2
#undef T3
#undef S3
#undef S4
#undef ER


#ifdef MGWSI_WINSOCK2
#define MGWSI_NET_WSASOCKET               mgwsi_winsock.p_WSASocket
#define MGWSI_NET_WSAGETLASTERROR         mgwsi_winsock.p_WSAGetLastError
#define MGWSI_NET_WSASTARTUP              mgwsi_winsock.p_WSAStartup
#define MGWSI_NET_WSACLEANUP              mgwsi_winsock.p_WSACleanup
#define MGWSI_NET_WSAFDISET               mgwsi_winsock.p_WSAFDIsSet
#define MGWSI_NET_WSARECV                 mgwsi_winsock.p_WSARecv
#define MGWSI_NET_WSASEND                 mgwsi_winsock.p_WSASend
#define MGWSI_NET_CLOSESOCKET             mgwsi_winsock.p_closesocket
#define MGWSI_NET_GETHOSTBYNAME           mgwsi_winsock.p_gethostbyname
#define MGWSI_NET_GETADDRINFO             mgwsi_winsock.p_getaddrinfo
#define MGWSI_NET_FREEADDRINFO            mgwsi_winsock.p_freeaddrinfo
#define MGWSI_NET_HTONS                   mgwsi_winsock.p_htons
#define MGWSI_NET_HTONL                   mgwsi_winsock.p_htonl
#define MGWSI_NET_CONNECT                 mgwsi_winsock.p_connect
#define MGWSI_NET_INET_ADDR               mgwsi_winsock.p_inet_addr
#define MGWSI_NET_SOCKET                  mgwsi_winsock.p_socket
#define MGWSI_NET_SETSOCKOPT              mgwsi_winsock.p_setsockopt
#define MGWSI_NET_GETSOCKOPT              mgwsi_winsock.p_getsockopt
#define MGWSI_NET_SELECT                  mgwsi_winsock.p_select
#define MGWSI_NET_RECV                    mgwsi_winsock.p_recv
#define MGWSI_NET_SEND                    mgwsi_winsock.p_send
#define MGWSI_NET_SHUTDOWN                mgwsi_winsock.p_shutdown
#define MGWSI_NET_BIND                    mgwsi_winsock.p_bind

#define  MGWSI_NET_FD_ISSET(fd, set)      mgwsi_winsock.p_WSAFDIsSet((SOCKET)(fd), (fd_set FAR *)(set))

typedef int (WINAPI * LPFN_WSAFDISSET) (SOCKET, fd_set FAR *);

#else

#define MGWSI_NET_WSASOCKET               WSASocket
#define MGWSI_NET_WSAGETLASTERROR         WSAGetLastError
#define MGWSI_NET_WSASTARTUP              WSAStartup
#define MGWSI_NET_WSACLEANUP              WSACleanup
#define MGWSI_NET_WSAFDISET               WSAFDIsSet
#define MGWSI_NET_WSARECV                 WSARecv
#define MGWSI_NET_WSASEND                 WSASend
#define MGWSI_NET_CLOSESOCKET             closesocket
#define MGWSI_NET_GETHOSTBYNAME           gethostbyname
#define MGWSI_NET_GETADDRINFO             getaddrinfo
#define MGWSI_NET_FREEADDRINFO            freeaddrinfo
#define MGWSI_NET_HTONS                   htons
#define MGWSI_NET_HTONL                   htonl
#define MGWSI_NET_CONNECT                 connect
#define MGWSI_NET_INET_ADDR               inet_addr
#define MGWSI_NET_SOCKET                  socket
#define MGWSI_NET_SETSOCKOPT              setsockopt
#define MGWSI_NET_GETSOCKOPT              getsockopt
#define MGWSI_NET_SELECT                  select
#define MGWSI_NET_RECV                    recv
#define MGWSI_NET_SEND                    send
#define MGWSI_NET_SHUTDOWN                shutdown
#define MGWSI_NET_BIND                    bind

#define MGWSI_NET_FD_ISSET(fd, set)       FD_ISSET(fd, set)
#endif /* #ifdef MGWSI_WINSOCK2 */


typedef struct tagMGWSIWINSOCK {
   short                         winsock_loaded;
   short                         load_attempted;
   short                         ipv6;
   short                         wsastartup;
   short                         winsock;
#ifdef _WIN32
   WSADATA                       wsadata;
   HINSTANCE                     h_winsock;
#ifdef MGWSI_WINSOCK2
   LPFN_WSASOCKET                p_WSASocket;
   LPFN_WSAGETLASTERROR          p_WSAGetLastError; 
   LPFN_WSASTARTUP               p_WSAStartup;
   LPFN_WSACLEANUP               p_WSACleanup;
   LPFN_WSAFDISSET               p_WSAFDIsSet;
   LPFN_WSARECV                  p_WSARecv;
   LPFN_WSASEND                  p_WSASend;
   LPFN_CLOSESOCKET              p_closesocket;
   LPFN_GETHOSTBYNAME            p_gethostbyname;
#if defined(MGWSI_IPV6)
   LPFN_GETADDRINFO              p_getaddrinfo;
   LPFN_FREEADDRINFO             p_freeaddrinfo;
#else
   void *                        p_getaddrinfo;
   void *                        p_freeaddrinfo;
#endif
   LPFN_HTONS                    p_htons;
   LPFN_HTONL                    p_htonl;
   LPFN_CONNECT                  p_connect;
   LPFN_INET_ADDR                p_inet_addr;
   LPFN_SOCKET                   p_socket;
   LPFN_SETSOCKOPT               p_setsockopt;
   LPFN_GETSOCKOPT               p_getsockopt;
   LPFN_SELECT                   p_select;
   LPFN_RECV                     p_recv;
   LPFN_SEND                     p_send;
   LPFN_SHUTDOWN                 p_shutdown;
   LPFN_BIND                     p_bind;
#endif
#endif

} MGWSIWINSOCK, * LPMGWSIWINSOCK;


MGWSIWINSOCK mgwsi_winsock = {0, 0,  0,  0, 0};


#if defined(_WIN32)
typedef HINSTANCE       MGWSIHLIB;
typedef FARPROC         MGWSIPROC;
#else
typedef void            * MGWSIHLIB;
typedef void            * MGWSIPROC;
#endif

typedef struct tagMGWSISO {
   short       flags;
   MGWSIHLIB   h_library;
} MGWSISO, * LPMGWSISO;


#ifdef MGWSI_SSL
#ifdef MGWSI_SSL_SO
#define mgwsi_SSLeay_version                   mgwsi_ssl.p_SSLeay_version
#define mgwsi_HMAC                             mgwsi_ssl.p_HMAC
#define mgwsi_EVP_sha256                       mgwsi_ssl.p_EVP_sha256
#define mgwsi_EVP_sha1                         mgwsi_ssl.p_EVP_sha1
#define mgwsi_EVP_sha                          mgwsi_ssl.p_EVP_sha
#define mgwsi_EVP_md5                          mgwsi_ssl.p_EVP_md5
#define mgwsi_SHA256                           mgwsi_ssl.p_SHA256
#define mgwsi_SHA1                             mgwsi_ssl.p_SHA1
#define mgwsi_SHA                              mgwsi_ssl.p_SHA
#define mgwsi_MD5                              mgwsi_ssl.p_MD5
#else
#define mgwsi_SSLeay_version                   SSLeay_version
#define mgwsi_HMAC                             HMAC
#define mgwsi_EVP_sha256                       EVP_sha256
#define mgwsi_EVP_sha1                         EVP_sha1
#define mgwsi_EVP_sha                          EVP_sha
#define mgwsi_EVP_md5                          EVP_md5
#define mgwsi_SHA256                           SHA256
#define mgwsi_SHA1                             SHA1
#define mgwsi_SHA                              SHA
#define mgwsi_MD5                              MD5
#endif /* #ifdef MGWSI_SSL_SO */

typedef const char *    (* LPFN_SSLEAY_VERSION)                  (int type);
typedef unsigned char * (* LPFN_HMAC)                            (const EVP_MD *evp_md, const void *key, int key_len, const unsigned char *d, int n, unsigned char *md, unsigned int *md_len);

typedef const EVP_MD *  (* LPFN_EVP_SHA256)                      (void);
typedef const EVP_MD *  (* LPFN_EVP_SHA1)                        (void);
typedef const EVP_MD *  (* LPFN_EVP_SHA)                         (void);
typedef const EVP_MD *  (* LPFN_EVP_MD5)                         (void);

typedef unsigned char * (* LPFN_SHA256)                          (const unsigned char *d, unsigned long n, unsigned char *md);
typedef unsigned char * (* LPFN_SHA1)                            (const unsigned char *d, unsigned long n, unsigned char *md);
typedef unsigned char * (* LPFN_SHA)                             (const unsigned char *d, unsigned long n, unsigned char *md);
typedef unsigned char * (* LPFN_MD5)                             (const unsigned char *d, unsigned long n, unsigned char *md);

typedef struct tagMGWSSL {
   short                ssl;
   short                load_attempted;
   MGWSISO              so_ssl;
   MGWSISO              so_libeay;
   LPFN_SSLEAY_VERSION  p_SSLeay_version;
   LPFN_HMAC            p_HMAC;
   LPFN_EVP_SHA256      p_EVP_sha256;
   LPFN_EVP_SHA1        p_EVP_sha1;
   LPFN_EVP_SHA         p_EVP_sha;
   LPFN_EVP_MD5         p_EVP_md5;
   LPFN_SHA256          p_SHA256;
   LPFN_SHA1            p_SHA1;
   LPFN_SHA             p_SHA;
   LPFN_MD5             p_MD5;

} MGWSISSL, * LPMGWSISSL;

MGWSISSL             mgwsi_ssl;
#endif /* #ifdef MGWSI_SSL */



typedef struct mgwsi_config {
   int     cmode;                /* Environment to which record applies (directory,  */
                                 /* server, or combination).                         */
#define CONFIG_MODE_SERVER    1
#define CONFIG_MODE_DIRECTORY 2
#define CONFIG_MODE_COMBO     3  /* Shouldn't ever happen.                           */

   int     local;                /* Boolean: was "Example" directive declared here?  */
   int     congenital;           /* Boolean: did we inherit an "Example"?            */
   short   mgwsi_enabled;
   char    mgwsi_file_types[128];
   int     mgwsi_maxcon;
} mgwsi_config;



/*
 * Declare ourselves so the configuration routines can find and know us.
 * We'll fill it in at the end of the module.
 */


#if MGWSI_APACHE_VERSION >= 20
module AP_MODULE_DECLARE_DATA m_apache_module;
#else
module m_apache_module;
#endif

#ifdef _WIN32
static WORD VersionRequested;
#define MGWSI_GET_LAST_ERROR GetLastError()
#elif defined(MGWSI_UNIX)
extern int errno;
#define MGWSI_GET_LAST_ERROR errno
#elif defined(MGWSI_VMS)
extern int errno;
#define MGWSI_GET_LAST_ERROR errno
#endif



#define MGWSI_MAX_CGIEX          11
static char *cgi_env_vars_ex[] = {  "AUTH_PASSWORD",           /*  0 */
                                    "SCRIPT_NAME",             /*  1 */
                                    "PATH_TRANSLATED",         /*  2 */
                                    "HTTP_AUTHORIZATION",      /*  3 */
                                    "MGWSI_CLIENT_TYPE",       /*  4 */
                                    "MGWSI_CLIENT_BUILD",      /*  5 */
                                    "MGWSI_CON_ACTIVITY",      /*  6 */
                                    "MGWSI_PROC_ACTIVITY",     /*  7 */
                                    "MGWSI_PROC",              /*  8 */
                                    "MGWSI_CON_PORT",          /*  9 */
                                    "MGWSI_CON_NO",            /* 10 */
                                    NULL};



typedef struct tagMGWSISV {
   short    context;
   short    defined;
   void     *lp_req;
   void     *lp_buf;
   void     *lp_ctx;
} MGWSISV, *LPMGWSISV;


typedef struct tagMGWSIBUF {
   int      size;
   int      data_size;
   int      increment_size;
   char *   lp_buffer;
} MGWSIBUF, *LPMGWSIBUF;


typedef struct tagMGWSICON {
   short          status;
   short          con_status;
   short          eod;
   short          end_of_stream;
   short          con_type;
#ifdef _WIN32
   WSADATA        wsadata;
   SOCKET         sockfd;
#else
   int            sockfd;
#endif
   char           ip_address[128];
   int            base_port;
   int            port;
   int            child_port;

   char           mpid[32];
   char           base_uci[128];
   char           uci[128];
   char           dbtype[256];
   int            version;

   short          t_mode;
   char           b_term[8];
   char           b_term_overlap[8];
   unsigned long  b_term_len;
   unsigned long  b_term_overlap_len;

   unsigned long  activity;

} MGWSICON, *LPMGWSICON;


typedef struct tagMGWSIWS {
   short                status;
   int                  closing;

   int                  input_buffer_size;
   unsigned char *      input_buffer;
   int                  output_buffer_size;
   unsigned char *      output_buffer;

#if defined(MGWSI_WEBSOCKETS)
   apr_int64_t          protocol_version;
   request_rec *        r;
   apr_bucket_brigade * obb;
   ap_filter_t *        of;
   apr_thread_mutex_t * mutex;
   apr_array_header_t * protocols;
#endif

} MGWSIWS, *LPMGWSIWS;


typedef struct tagMGWSIWSFD {
#if defined(MGWSI_WEBSOCKETS)
   apr_uint64_t      application_data_offset;
#endif
   unsigned char *   application_data;
   unsigned char     fin;
   unsigned char     opcode;
   unsigned int      utf8_state;
} MGWSIWSFD, *LPMGWSIWSFD;

#if defined(MGWSI_WEBSOCKETS)
typedef struct tagMGWSIWSHD {
   ap_filter_t *        f;
   apr_bucket_brigade * bb;
} MGWSIWSHD, *LPMGWSIWSHD;
#endif


typedef struct tagMGWSIREQ {
   int               h_db;
   LPMGWSICON        lp_mgwsicon;
   char              ip_address[128];
   int               base_port;
   int               port;
   int               child_port;
   short             error_flag;
   char              error[256];
   char              error_redir[256];
   request_rec    *  r;
   char           *  lp_method;
   char              file[64];
   FILE           *  fp;
   LPMGWSIBUF        lp_cgi_buffer;
   short             soap;
   short             chunked;
   short             req_chunked;
   mgwsi_config   *  sconf;
   mgwsi_config   *  dconf;
   unsigned long     con_len;
   unsigned long     read_len;
   char              content_type[256];
   int               dbcon_status;
   int               send_no;
   int               recv_no;
   int               element_no;
   short             storage_mode;
   int               header_len;
   char              server[64];
   char              base_uci[128];
   char              uci[128];
   char              fun[128];
   char              ws_fun[128];
   LPMGWSIBUF        lp_trans_buffer;

   LPMGWSIWS         lp_websocket;
   unsigned char     websocket_upgrade;

} MGWSIREQ, *LPMGWSIREQ;


#if defined(_WIN32)
#define MGWSI_THREAD_TYPE           DWORD WINAPI
#define MGWSI_THREAD_RETURN         result
typedef LPTHREAD_START_ROUTINE      MGWSI_THREAD_START_ROUTINE;
#else
#define MGWSI_THREAD_TYPE           void *
#define MGWSI_THREAD_RETURN         NULL
typedef void  *(*MGWSI_THREAD_START_ROUTINE) (void *arg);
#endif

typedef struct tagMGWSITC {
   unsigned long     thread_id;
#if defined(_WIN32)
   DWORD             stack_size;
   HANDLE            hThread;
#else
   int               stack_size;
#endif
} MGWSITC, *LPMGWSITC;


static int                    request_no           = 0;
static unsigned long          activity             = 0;
static int                    mgwsi_maxcon         = MGWSI_MAXCON;
static int                    mgwsi_module_build   = MGWSI_CLIENT_BUILD;
static MGWSICON **            mgwsi_db_con         = NULL;

#if MGWSI_APACHE_VERSION >= 20
#if APR_HAS_THREADS || defined(DOXYGEN)
#define MGWSI_USE_THREADS       1
#endif

#if MGWSI_USE_THREADS
static apr_thread_mutex_t *   mgwsicon_lock        = NULL;
#endif
#endif

#if MGWSI_APACHE_VERSION >= 20
static apr_status_t     mgwsi_child_exit                    (void *data);
#else
static void             mgwsi_child_exit                    (server_rec *s, pool *p);
#endif
static const char *     mgwsi_cmd                           (cmd_parms *cmd, void *dconf, const char *args);

static size_t           mgwsi_ws_protocol_count             (MGWSIREQ *lp_request);
static const char *     mgwsi_ws_protocol_index             (MGWSIREQ *lp_request, const size_t index);
static void             mgwsi_ws_protocol_set               (MGWSIREQ *lp_request, const char *protocol);
static void             mgwsi_ws_handshake                  (MGWSIREQ *lp_request, const char *key);
static void             mgwsi_ws_parse_protocol             (MGWSIREQ *lp_request, const char *sec_websocket_protocol);
static int              mgwsi_ws_send_header                (void *data, const char *key, const char *val);
void                    mgwsi_ws_ap_send_interim_response   (request_rec *r, int send_headers);
int                     mgwsi_ws_test_request               (MGWSIREQ *lp_request, LPMGWSIBUF lp_cgievar);
int                     mgwsi_ws_client_send                (MGWSIREQ *lp_request, char *buffer, int len);
size_t                  mgwsi_ws_client_send_block          (MGWSIREQ *lp_request, const int type, unsigned char *buffer, const size_t buffer_size);
size_t                  mgwsi_ws_read_client_block          (MGWSIREQ *lp_request, char *buffer, size_t bufsiz);
void                    mgwsi_ws_data_framing               (MGWSIREQ *lp_request);
MGWSI_THREAD_TYPE       mgwsi_ws_read_from_db_async         (void *lp_parameters);
int                     mgwsi_ws_db_send                    (MGWSIREQ *lp_request, unsigned char *data, int size, short type);
int                     mgwsi_ws_db_receive                 (MGWSIREQ *lp_request, int *size, short *type);
int                     mgwsi_check_file_type               (MGWSIREQ *lp_request, char *type);
int                     mgwsi_get_configuration             (MGWSIREQ *lp_request);
int                     mgwsi_db_connect                    (MGWSIREQ *lp_request, short context);
int                     mgwsi_db_connect_ex                 (MGWSIREQ *lp_request);
int                     mgwsi_db_disconnect                 (MGWSIREQ *lp_request, short context);
int                     mgwsi_db_disconnect_ex              (MGWSIREQ *lp_request);
int                     mgwsi_db_send                       (MGWSIREQ *lp_request, LPMGWSIBUF lp_trans_buffer, int mode);
int                     mgwsi_db_send_ex                    (MGWSIREQ *lp_request, unsigned char * data, int size, int mode);
int                     mgwsi_db_receive                    (MGWSIREQ *lp_request, LPMGWSIBUF lp_trans_buffer, int size, int mode);
int                     mgwsi_db_receive_ex                 (MGWSIREQ *lp_request, unsigned char * data, int size, short mode);
int                     mgwsi_db_connect_init               (MGWSIREQ *lp_request);
int                     mgwsi_db_ayt                        (MGWSIREQ *lp_request);
int                     mgwsi_send_response_header          (MGWSIREQ *lp_request, char *header, short keepalive, short web_server_headers, short context);
int                     mgwsi_system_function               (MGWSIREQ *lp_request);
int                     mgwsi_return_error                  (MGWSIREQ *lp_request, char *error);
int                     mgwsi_client_send                   (MGWSIREQ *lp_request, void *buffer, int size, short context);
int                     mgwsi_server_variable               (void *rec, const char *key, const char *value);
int                     mgwsi_get_server_variable           (MGWSIREQ *lp_request, char *VariableName, LPMGWSIBUF lp_cgi_buffer);
int                     mgwsi_get_req_vars                  (MGWSIREQ *lp_request, LPMGWSIBUF lp_cgi_buffer);
int                     mgwsi_mem_init                      (LPMGWSIBUF lp_mem_obj, int size, int increment_size);
int                     mgwsi_mem_free                      (LPMGWSIBUF lp_mem_obj);
int                     mgwsi_mem_cpy                       (LPMGWSIBUF lp_mem_obj, char * buffer, unsigned long size);
int                     mgwsi_mem_cat                       (LPMGWSIBUF lp_mem_obj, char * buffer, unsigned long size);
int                     mgwsi_u_case                        (char *string);
int                     mgwsi_l_case                        (char *string);
int                     mgwsi_sleep                         (unsigned long msecs);
int                     mgwsi_log_event                     (char *event, char *title);
int                     mgwsi_log                           (MGWSIREQ *lp_request, char *buffer, int size);
int                     mgwsi_request_header                (MGWSIREQ *lp_request, LPMGWSIBUF lp_trans_buffer, char *command);
int                     mgwsi_parse_query_string            (MGWSIREQ *lp_request, LPMGWSIBUF lp_trans_buffer, LPMGWSIBUF lp_temp_buffer, unsigned char *query_string, int size);
int                     mgwsi_url_unescape                  (char *target);
int                     mgwsi_request_add                   (MGWSIREQ *lp_request, LPMGWSIBUF lp_trans_buffer, unsigned char *element, int size, short byref, short type);
int                     mgwsi_pow                           (int n10, int power);
int                     mgwsi_encode_size62                 (int n10);
int                     mgwsi_decode_size62                 (int nxx);
int                     mgwsi_encode_size                   (unsigned char *esize, int size, short base);
int                     mgwsi_decode_size                   (unsigned char *esize, int len, short base);
int                     mgwsi_encode_item_header            (unsigned char * head, int size, short byref, short type);
int                     mgwsi_decode_item_header            (unsigned char * head, int * size, short * byref, short * type);
int                     mgwsi_encode_ws_header              (unsigned char * head, int size, short type);
int                     mgwsi_decode_ws_header              (unsigned char * head, int * size, short * type);
unsigned long           mgwsi_proc_id                       (void);
double                  mgwsi_get_time                      (char * timestr);
char                    mgwsi_b64_ntc                       (unsigned char n);
unsigned char           mgwsi_b64_ctn                       (char c);
int                     mgwsi_b64_encode                    (char *from, char *to, int length, int quads);
int                     mgwsi_b64_decode                    (char *from, char *to, int length);
int                     mgwsi_b64_enc_buffer_size           (int l, int q);
int                     mgwsi_b64_strip_enc_buffer          (char *buf, int length);
int                     mgwsi_thread_create                 (LPMGWSITC lp_thread_control, MGWSI_THREAD_START_ROUTINE start_routine, void *arg);
int                     mgwsi_thread_terminate              (LPMGWSITC lp_thread_control);
int                     mgwsi_thread_detach                 (void);
int                     mgwsi_thread_join                   (LPMGWSITC lp_thread_control);
int                     mgwsi_thread_exit                   (void);
unsigned long           mgwsi_get_current_tid               (void);
unsigned long           mgwsi_get_current_pid               (void);
int                     mgwsi_load_net_library              (short context);
int                     mgwsi_unload_net_library            (short context);
int                     mgwsi_load_ssl_library              (short context);
int                     mgwsi_unload_ssl_library            (short context);
int                     mgwsi_so_load                       (MGWSISO *p_mgwsiso, char * library);
MGWSIPROC               mgwsi_so_sym                        (MGWSISO *p_mgwsiso, char * symbol);
int                     mgwsi_so_unload                     (MGWSISO *p_mgwsiso);


/* Process configuration directives (in httpd.conf) related to this module */

static const char *mgwsi_cmd(cmd_parms *cmd, void *dconf, const char *args)
{
   int n;
   short context;
   char *pname;
   char buffer1[64], buffer2[256];
   mgwsi_config *conf;

    /*
     * Determine from our context into which record to put the entry.
     * cmd->path == NULL means we're in server-wide context; otherwise,
     * we're dealing with a per-directory setting.
     */

   if (cmd->path == NULL) {
      context = 0;
      conf = (mgwsi_config *) MGWSI_GET_MODULE_CONFIG(cmd->server->module_config, &m_apache_module);
   }
   else {
      context = 1;
      conf = (mgwsi_config *) dconf;
   }

   pname = (char *) cmd->cmd->name;
   if (!pname || !args)
      return NULL;

   strncpy(buffer1, pname, 32);
   buffer1[32] = '\0';
   mgwsi_l_case(buffer1);

   if (!strcmp(buffer1, "mgwsifiletypes")) {
      strcpy(buffer2, ".");
      strncpy(buffer2 + 1, args, 126);
      buffer2[126] = '\0';
      strcat(buffer2, ".");
      for (n = 0; buffer2[n]; n ++) {
         if (buffer2[n] == ' ')
            buffer2[n] = '.';
      }
      mgwsi_l_case(buffer2);
      strcpy(conf->mgwsi_file_types, buffer2);

   }

   if (!strcmp(buffer1, "mgwsi")) {
      strncpy(buffer2, args, 7);
      buffer2[7] = '\0';
      mgwsi_l_case(buffer2);
      if (!strcmp(buffer2, "on"))
         conf->mgwsi_enabled = 1;
   }

   if (!strcmp(buffer1, "mgwsimaxpooledconnections") && context == 0) {
      strncpy(buffer2, args, 7);
      buffer2[7] = '\0';
      conf->mgwsi_maxcon = (int) strtol(buffer2, NULL, 10);
      if (conf->mgwsi_maxcon < -1 || conf->mgwsi_maxcon > 1024)
         conf->mgwsi_maxcon = MGWSI_MAXCON;
   }

   return NULL;
}



/* Main content handler for m_apache requests */

static int mgwsi_handler(request_rec *r)
{
   int retval, eod_found, n, len, send_mode, upgrade_connection;
   long n1;
   short server_gone, client_gone, con_close, con_keepalive, keepalive, trans_enc_chunked, web_server_headers, tries, system_function;
   char buffer[8192];
   unsigned char *lp_content, *p;
   MGWSIREQ request, *lp_request;
   MGWSIBUF cgi_buffer, trans_buffer, temp_buffer, response_buffer;
   LPMGWSIBUF lp_cgi_buffer, lp_trans_buffer, lp_temp_buffer, lp_response_buffer;
   MGWSISV mgwsisv;
   table *e = r->subprocess_env;
   time_t time_start, time_now, time_diff;

#if MGWSI_APACHE_VERSION >= 20

   apr_bucket_brigade *bb = NULL;
   apr_status_t rv = 0;
   conn_rec *c = r->connection;
   struct ap_filter_t *cur = NULL;

#endif

   lp_request = &request;
   lp_request->r = r;

   lp_request->error_flag = 0;
   lp_request->soap = 0;
   lp_request->con_len = 0;
   lp_request->send_no = 0;
   lp_request->recv_no = 0;
   lp_request->element_no = 0;
   lp_request->chunked = 0;

   lp_request->lp_mgwsicon = NULL;
   lp_request->lp_websocket = NULL;
   lp_request->lp_trans_buffer = NULL;

   server_gone = 0;
   client_gone = 0;
   system_function = 0;
   upgrade_connection = 0;

   time_start = time(NULL);

   lp_request->dconf = (mgwsi_config *) MGWSI_GET_MODULE_CONFIG(r->per_dir_config, &m_apache_module);
   lp_request->sconf = (mgwsi_config *) MGWSI_GET_MODULE_CONFIG(r->server->module_config, &m_apache_module);

   if (!r)
      return DECLINED;

   if (!r->uri)
      return DECLINED;
   n = (unsigned int) strlen(r->uri);
   if (!n)
      return DECLINED;

   n1 = 0;
   if (n > 0) {
      for (n --; n > 0; n --) {
         if (r->uri[n] == '.') {
            for (n ++; r->uri[n]; n ++) {
               if (r->uri[n] == '/' || r->uri[n] == '\\')
                  break;
               buffer[n1 ++] = r->uri[n];
            }
            break;
         }
      }
   }
   buffer[n1] = '\0';

   if (lp_request->dconf->mgwsi_enabled == 0) {

      if (!n1)
         return DECLINED;

      mgwsi_l_case(buffer);
      if (strcmp(r->handler, MGWSI_MIME_TYPE1) && strcmp(r->handler, MGWSI_MIME_TYPE2) && strcmp(r->handler, "mgwsi-handler-sa")) {

         if (!mgwsi_check_file_type(lp_request, buffer)) {

            short ok;
            char *p;

            ok = 0;

            p = strstr(r->uri, ".");
            if (p) {
               strncpy(buffer, p + 1, 10);
               buffer[10] = '\0'; 
               for (n = 0; buffer[n]; n ++) {
                  if (buffer[n] == '.' || buffer[n] == '/' || buffer[n] == '\\') {
                     buffer[n] = '\0';
                     break;
                  }
               }
               mgwsi_l_case(buffer);

               if (mgwsi_check_file_type(lp_request, buffer))
                  ok = 1;
            }

            if (!ok) {
               return DECLINED;
            }
         }
      }
   }

   if (!r->method) {
      return DECLINED;
   }

   if (strlen(r->method) > 16) {
      return DECLINED;
   }

   lp_cgi_buffer = &cgi_buffer;
   lp_trans_buffer = &trans_buffer;
   lp_temp_buffer = &temp_buffer;
   lp_response_buffer = &response_buffer;

   con_close = 0, con_keepalive = 0, keepalive = 0, trans_enc_chunked = 0, web_server_headers = 0;
   request_no ++;

   if ((retval = MGWSI_SETUP_CLIENT_BLOCK(r, REQUEST_CHUNKED_DECHUNK)))
      return retval;

   MGWSI_ADD_COMMON_VARS(r);
   MGWSI_ADD_CGI_VARS(r);

   lp_request->lp_method = (char *) r->method;

   strcpy(buffer, r->uri);
   mgwsi_l_case(buffer);
   if (!strcmp(buffer, "/mgwsi/sys/system_functions.mgwsi")) {
      system_function = 1;
      mgwsi_system_function(lp_request);
      return OK;
   }

   mgwsi_mem_init(lp_cgi_buffer, MGWSI_BUFSIZE, 256);
   mgwsi_mem_init(lp_trans_buffer, MGWSI_BUFSIZE, 256);
   mgwsi_mem_init(lp_temp_buffer, MGWSI_BUFSIZE, 256);
   mgwsi_mem_init(lp_response_buffer, 512, 256);

   lp_request->lp_cgi_buffer = lp_cgi_buffer;

   mgwsi_get_configuration(lp_request);
   mgwsi_get_req_vars(lp_request, lp_cgi_buffer);


   mgwsi_mem_cpy(lp_trans_buffer, "", 0);
   mgwsi_request_header(lp_request, lp_trans_buffer, "W");

   if (lp_request->websocket_upgrade) {
      mgwsi_request_add(lp_request, lp_trans_buffer, lp_request->ws_fun, strlen((char *) lp_request->ws_fun), (short) 0, (short) MGWSI_TX_DATA);
   }
   else {
      mgwsi_request_add(lp_request, lp_trans_buffer, lp_request->fun, strlen((char *) lp_request->fun), (short) 0, (short) MGWSI_TX_DATA);
   }

   mgwsi_request_add(lp_request, lp_trans_buffer, NULL, 0, 0, MGWSI_TX_AREC);


   for (n = 0; cgi_env_vars_ex[n]; n ++) {

      n1 = mgwsi_get_server_variable(lp_request, cgi_env_vars_ex[n], lp_cgi_buffer);

      if (!strcmp(cgi_env_vars_ex[n], "SCRIPT_NAME")) {

         strncpy(buffer, lp_cgi_buffer->lp_buffer, 200);
         buffer[200] = '\0';
         mgwsi_l_case(buffer);
      }

      if (n1 > -1) {

         if (n == 15 && strstr(lp_cgi_buffer->lp_buffer, "/xml"))
            lp_request->soap = 1;
         if (n == 21)
            lp_request->soap = 1;

         mgwsi_mem_cpy(lp_temp_buffer, "", 0);
         mgwsi_request_add(lp_request, lp_temp_buffer, cgi_env_vars_ex[n], strlen(cgi_env_vars_ex[n]), 0, MGWSI_TX_AKEY);
         mgwsi_request_add(lp_request, lp_temp_buffer, lp_cgi_buffer->lp_buffer, lp_cgi_buffer->data_size, 0, MGWSI_TX_DATA);
         mgwsi_request_add(lp_request, lp_trans_buffer, lp_temp_buffer->lp_buffer, lp_temp_buffer->data_size, 0, MGWSI_TX_AREC_FORMATTED);
      }
   }

   mgwsisv.context = 0;
   mgwsisv.lp_req = (void *) lp_request;
   mgwsisv.lp_buf = (void *) lp_trans_buffer;
   mgwsisv.lp_ctx = (void *) lp_temp_buffer;

   MGWSI_TABLE_DO(mgwsi_server_variable, (void *) &mgwsisv, e, NULL);

   mgwsi_request_add(lp_request, lp_trans_buffer, NULL, 0, 0, MGWSI_TX_EOD);

#if !defined(MGWSI_WEBSOCKETS)
   if (lp_request->websocket_upgrade) {
      mgwsi_log_event("This build of m_apache does not support WebSockets for this Web Server", "WebSocket Error");
      mgwsi_return_error(lp_request, "WebSocket Error: This build of m_apache does not support WebSockets");
      goto mgwsi_handler_exit2;
   }
#endif

#if defined(MGWSI_WEBSOCKETS)
   upgrade_connection = mgwsi_ws_test_request(lp_request, lp_cgi_buffer);
   if (upgrade_connection) {
      /* TODO : Need to serialize the connections to minimize a denial of service attack */
      int len;
      unsigned long dw_size;
      char header[2048];
      char host[128];
      char sec_websocket_key[256];
      char token[256], hash[256], sec_websocket_accept[256];
      int protocol_version = 0;
      char sec_websocket_protocol[32];
      ap_filter_t *input_filter;

      len = 0;
      dw_size = 0;
      *header = '\0';
      *sec_websocket_accept = '\0';
      *sec_websocket_key = '\0';
      *sec_websocket_protocol = '\0';
      *token = '\0';
      *hash = '\0';

      len = mgwsi_get_server_variable(lp_request, "SERVER_NAME", lp_cgi_buffer);
      strncpy(host, (char *) lp_cgi_buffer->lp_buffer, 120);
      host[120] = '\0';

      len = mgwsi_get_server_variable(lp_request, "HTTP_SEC_WEBSOCKET_KEY", lp_cgi_buffer);
      strncpy(sec_websocket_key, (char *) lp_cgi_buffer->lp_buffer, 250);
      sec_websocket_key[250] = '\0';

      len = mgwsi_get_server_variable(lp_request, "HTTP_SEC_WEBSOCKET_PROTOCOL", lp_cgi_buffer);
      strncpy(sec_websocket_protocol, (char *) lp_cgi_buffer->lp_buffer, 30);
      sec_websocket_protocol[30] = '\0';

      len = mgwsi_get_server_variable(lp_request, "HTTP_SEC_WEBSOCKET_VERSION", lp_cgi_buffer);
      protocol_version = (int) strtol((char *) lp_cgi_buffer->lp_buffer, NULL, 10);

      if (MGWSI_DEBUG) {
         char buffer[2048];
         sprintf(buffer, "host=%s; sec_websocket_key=%s; sec_websocket_protocol=%s; protocol_version=%d;", host, sec_websocket_key, sec_websocket_protocol, protocol_version);
         mgwsi_log_event(buffer, "WebSocket Diagnostic: Start");
      }

      if ((*host) && (*sec_websocket_key) && ((protocol_version == 7) || (protocol_version == 8) || (protocol_version == 13))) {
         /* const char *sec_websocket_origin = apr_table_get(pRCB->r->headers_in, "Sec-WebSocket-Origin"); */
         /* const char *origin = apr_table_get(pRCB->r->headers_in, "Origin"); */
         /* TODO : We need to validate the Host and Origin */

         lp_request->lp_websocket = (LPMGWSIWS) malloc(sizeof(MGWSIWS));
         lp_request->lp_websocket->status = 0;
         lp_request->lp_websocket->closing = 0;

         lp_request->lp_websocket->input_buffer_size = 0;
         lp_request->lp_websocket->input_buffer = NULL;
         lp_request->lp_websocket->output_buffer_size = 0;
         lp_request->lp_websocket->output_buffer = NULL;

         lp_request->lp_websocket->protocol_version = protocol_version;

         lp_request->lp_websocket->r = lp_request->r;
         lp_request->lp_websocket->obb = NULL;
         lp_request->lp_websocket->mutex = NULL;
         lp_request->lp_websocket->protocols = NULL;

         if (MGWSI_DEBUG) {
            char buffer[256];
            sprintf(buffer, "WebSocket Diagnostic: Connection: Protocol=%d;", protocol_version);
            mgwsi_log_event(lp_request->r->uri, buffer);
         }

         /*
          * Since we are handling a WebSocket connection, not a standard HTTP
          * connection, remove the HTTP input filter.
          */
         for (input_filter = lp_request->r->input_filters; input_filter != NULL; input_filter = input_filter->next) {
            if ((input_filter->frec != NULL) && (input_filter->frec->name != NULL) && !strcasecmp(input_filter->frec->name, "http_in")) {
               ap_remove_input_filter(input_filter);
               break;
            }
         }

         apr_table_clear(lp_request->r->headers_out);
         apr_table_setn(lp_request->r->headers_out, "Upgrade", "websocket");
         apr_table_setn(lp_request->r->headers_out, "Connection", "Upgrade");

         /* Set the expected acceptance response */
         mgwsi_ws_handshake(lp_request, sec_websocket_key);

         /* Handle the WebSocket protocol */
         if (sec_websocket_protocol != NULL) {
            /* Parse the WebSocket protocol entry */
            mgwsi_ws_parse_protocol(lp_request, sec_websocket_protocol);

            if (mgwsi_ws_protocol_count(lp_request) > 0) {
               /*
                * Default to using the first protocol in the list
                * (plugin should overide this in on_connect)
                */

               mgwsi_ws_protocol_set(lp_request, mgwsi_ws_protocol_index(lp_request, 0));
            }
         }

         apr_thread_mutex_create(&(lp_request->lp_websocket->mutex), APR_THREAD_MUTEX_DEFAULT, lp_request->r->pool);
         apr_thread_mutex_lock(lp_request->lp_websocket->mutex);

         /*
          * If the plugin supplies an on_connect function, it must
          * return non-null on success
          */
          /*
           * Now that the connection has been established,
           * disable the socket timeout
           */
         apr_socket_timeout_set(ap_get_module_config(lp_request->r->connection->conn_config, &core_module), -1);

         /* Set response status code and status line */
         lp_request->r->status = HTTP_SWITCHING_PROTOCOLS;
         lp_request->r->status_line = ap_get_status_line(lp_request->r->status);

         /* Send the headers */

         mgwsi_ws_ap_send_interim_response(lp_request->r, 1);

         lp_request->websocket_upgrade = 2;

         if (0) {
            /* The main data framing loop */

            mgwsi_ws_data_framing(lp_request);

            apr_thread_mutex_unlock(lp_request->lp_websocket->mutex);

            /* Disconnecting */
            lp_request->r->connection->keepalive = AP_CONN_CLOSE;

            /* Close the connection */
            ap_lingering_close(lp_request->r->connection);
            apr_thread_mutex_destroy(lp_request->lp_websocket->mutex);

            if (MGWSI_DEBUG) {
               char buffer[256];
               sprintf(buffer, "WebSocket Diagnostic: Disconnection: Protocol=%d;", protocol_version);
               mgwsi_log_event(lp_request->r->uri, buffer);
            }

            goto mgwsi_handler_exit2;
         }
      }
   }
#endif /* #if defined(MGWSI_WEBSOCKETS) */

   lp_request->dbcon_status = mgwsi_db_connect(lp_request, 0);

   if (!lp_request->dbcon_status) {
      mgwsi_return_error(lp_request, lp_request->error);
      goto mgwsi_handler_exit2;
   }


   lp_content = (unsigned char *) strstr(lp_trans_buffer->lp_buffer, "MGWSI_CON_ACTIVITY");
   if (lp_content) {
      sprintf(buffer, "%lu", lp_request->lp_mgwsicon->activity);
      len = strlen(buffer);
      p = buffer;
      if (len > 10) {
         n = len - 10;
         p += n;
         len = 10;
      }
      strncpy(lp_content + ((18 + 10 + 3) - len), p, len);
   }
   lp_content = (unsigned char *) strstr(lp_trans_buffer->lp_buffer, "MGWSI_PROC_ACTIVITY");
   if (lp_content) {
      sprintf(buffer, "%lu", activity);
      len = strlen(buffer);
      p = buffer;
      if (len > 10) {
         n = len - 10;
         p += n;
         len = 10;
      }
      strncpy(lp_content + ((19 + 10 + 3) - len), p, len);
   }
   lp_content = (unsigned char *) strstr(lp_trans_buffer->lp_buffer, "MGWSI_CON_PORT");
   if (lp_content) {
      sprintf(buffer, "%d", lp_request->lp_mgwsicon->port);
      len = strlen(buffer);
      p = buffer;
      if (len > 4) {
         n = len - 4;
         p += n;
         len = 4;
      }
      strncpy(lp_content + ((14 + 4 + 2) - len), p, len);
   }
   lp_content = (unsigned char *) strstr(lp_trans_buffer->lp_buffer, "MGWSI_CON_NO");
   if (lp_content) {
      sprintf(buffer, "%d", lp_request->h_db);
      len = strlen(buffer);
      p = buffer;
      if (len > 5) {
         n = len - 5;
         p += n;
         len = 5;
      }
      strncpy(lp_content + ((12 + 5 + 2) - len), p, len);
   }
   lp_content = NULL;

   lp_request->read_len = 0;

   mgwsi_request_add(lp_request, lp_trans_buffer, NULL, 0, 0, MGWSI_TX_AREC);

   mgwsi_get_server_variable(lp_request, "QUERY_STRING", lp_cgi_buffer);
   mgwsi_parse_query_string(lp_request, lp_trans_buffer, lp_temp_buffer, (unsigned char *) lp_cgi_buffer->lp_buffer, lp_cgi_buffer->data_size);

   mgwsi_mem_cpy(lp_cgi_buffer, "", 0);

#if MGWSI_APACHE_VERSION >= 20 && !defined(MGWSI_VMS)
   if (lp_request->con_len || lp_request->req_chunked) {

      const char * data;
      apr_size_t len;

      bb = apr_brigade_create(r->pool, r->connection->bucket_alloc);
      eod_found = 0;

      do {
         apr_bucket *bucket;

         rv = ap_get_brigade(r->input_filters, bb, AP_MODE_READBYTES, APR_BLOCK_READ, HUGE_STRING_LEN);

         if (rv != APR_SUCCESS) {
            break;
         }

#if MGWSI_APACHE_VERSION >= 22
         for (bucket = APR_BRIGADE_FIRST(bb); bucket != APR_BRIGADE_SENTINEL(bb); bucket = APR_BUCKET_NEXT(bucket)) {
#else
         APR_BRIGADE_FOREACH(bucket, bb) {
#endif

            if (APR_BUCKET_IS_EOS(bucket)) {
               eod_found = 1;
               break;
            }
            if (APR_BUCKET_IS_FLUSH(bucket)) {
               continue;
            }
            if (server_gone) {
               continue;
            }

            apr_bucket_read(bucket, &data, &len, APR_BLOCK_READ);

            mgwsi_mem_cat(lp_cgi_buffer, (char *) data, len);

            lp_request->read_len += len;

            if (!lp_request->req_chunked && lp_request->read_len >= lp_request->con_len) {
               eod_found = 1;
               break;
            }

         }
         apr_brigade_cleanup(bb);

      } while (!eod_found);
   }
#else
   eod_found = 0;

   if (MGWSI_SHOULD_CLIENT_BLOCK(r)) {

      if (lp_request->con_len || lp_request->req_chunked) {

         long read;
         char buffer[8192];

         for (;;) {
            read = MGWSI_GET_CLIENT_BLOCK(r, (char *) buffer, 8000);

            if (lp_request->req_chunked && read == 0) {
               eod_found = 1;
               break;
            }

            if (read < 0) {
               mgwsi_mem_free(lp_cgi_buffer);
               mgwsi_mem_free(lp_trans_buffer);
               mgwsi_mem_free(lp_temp_buffer);
               return SERVER_ERROR;
            }

            mgwsi_mem_cat(lp_cgi_buffer, buffer, read);

            lp_request->read_len += read;

            if (!lp_request->req_chunked && lp_request->read_len >= lp_request->con_len) {
               eod_found = 1;
               break;
            }
         }
      }
   }
#endif

   strcpy(buffer, lp_request->content_type);
   mgwsi_l_case(buffer);
   if (strstr(buffer, "x-www-form-urlencoded")) {
      mgwsi_parse_query_string(lp_request, lp_trans_buffer, lp_temp_buffer, (unsigned char *) lp_cgi_buffer->lp_buffer, lp_cgi_buffer->data_size);
      mgwsi_request_add(lp_request, lp_trans_buffer, NULL, 0, 0, MGWSI_TX_EOD);
   }
   else {
      mgwsi_mem_cpy(lp_temp_buffer, "", 0);
      mgwsi_request_add(lp_request, lp_temp_buffer, "$CONTENT", 8, 0, MGWSI_TX_AKEY);
      mgwsi_request_add(lp_request, lp_temp_buffer, "1", 1, 0, MGWSI_TX_AKEY);
      mgwsi_request_add(lp_request, lp_temp_buffer, lp_cgi_buffer->lp_buffer, lp_cgi_buffer->data_size, 0, MGWSI_TX_DATA);
      mgwsi_request_add(lp_request, lp_trans_buffer, lp_temp_buffer->lp_buffer, lp_temp_buffer->data_size, 0, MGWSI_TX_AREC_FORMATTED);

      mgwsi_request_add(lp_request, lp_trans_buffer, NULL, 0, 0, MGWSI_TX_EOD);
   }

   tries = 0;
   send_mode = 1;

retry:

   if (tries > 0) {

      if (tries > 1 || lp_request->send_no > 1 || lp_request->recv_no > 1)
         goto mgwsi_handler_exit1;

      lp_request->port = lp_request->base_port;
      lp_request->dbcon_status = mgwsi_db_connect(lp_request, 1);
      send_mode = 0;

      if (!lp_request->dbcon_status) {
         mgwsi_return_error(lp_request, lp_request->error);
         goto mgwsi_handler_exit2;
      }
   }

   tries ++;
   server_gone = 0;
   n = mgwsi_db_send(lp_request, lp_trans_buffer, send_mode);
   if (n < 0)
      goto retry;

   lp_content = NULL;
   mgwsi_mem_cpy(lp_cgi_buffer, "", 0);

   for (;;) {
      n = mgwsi_db_receive(lp_request, lp_temp_buffer, MGWSI_BUFSIZE, 0);

      if (n < 0) {
         server_gone = 1;
         break;
      }

      if (lp_request->error_flag == 1) {
         break;
      }

      mgwsi_mem_cat(lp_cgi_buffer, lp_temp_buffer->lp_buffer, lp_temp_buffer->data_size);
      lp_content = strstr(lp_cgi_buffer->lp_buffer, "\r\n\r\n");
      if (lp_content || lp_request->lp_mgwsicon->eod) {
         break;
      }
   }

#if defined(MGWSI_WEBSOCKETS)
   if (lp_request->lp_websocket) {
      mgwsi_mem_cpy(lp_response_buffer, lp_cgi_buffer->lp_buffer, lp_cgi_buffer->data_size);
      goto mgwsi_handler_websockets;
   }
#endif

   if (server_gone)
      goto retry;

   if (lp_request->error_flag) {
      server_gone = 1;
      mgwsi_return_error(lp_request, lp_request->error);
      goto mgwsi_handler_exit1;
   }

   len = lp_cgi_buffer->data_size;
   lp_request->read_len = 0;

   if (lp_content && !strncmp((char *) lp_cgi_buffer->lp_buffer, "HTTP/", 5)) {

      int n, hlen;
      double version;
      unsigned char chr;
      unsigned char *p, *p1, *pv;
      char head[256];

      lp_content += 4;
      chr = *lp_content;
      *(lp_content) = '\0';
      hlen = strlen((char *) lp_cgi_buffer->lp_buffer);

      len = lp_cgi_buffer->data_size - hlen;
      if (len > 0)
         mgwsi_mem_cpy(lp_trans_buffer, lp_cgi_buffer->lp_buffer + hlen, len);
      else
         mgwsi_mem_cpy(lp_trans_buffer, "", 0);

      con_close = 0, con_keepalive = 0, keepalive = 0, trans_enc_chunked = 0, web_server_headers = 0;
      version = 1.1;

      for (p = lp_cgi_buffer->lp_buffer, n = 0; ; n ++) {
         p1 = (unsigned char *) strstr((char *) p, "\r\n");
         if (!p1)
            break;
         *p1 = '\0';
         if (!strlen((char *) p)) {
            *p1 = '\r';
            break;
         }

         if (!n) {
            if (strstr((char *) p, "/1.0"))
               version = 1.0;
         }
         else {
            strncpy(head, (char *) p, 250);
            head[250] = '\0';

            mgwsi_l_case(head);

            if (strstr(head, "connection: close"))
               con_close = 1;
            else if (strstr(head, "connection: keep-alive"))
               con_keepalive = 1;
            else if (strstr(head, "mgwsi-transfer-encoding: chunked")) {
               lp_request->chunked = 1;
            }
            else if (strstr(head, "transfer-encoding: chunked")) {
               trans_enc_chunked = 1;
               lp_request->chunked = 1;
            }
            else if ((pv = (unsigned char *) strstr(head, "content-length: "))) {
               lp_request->con_len = (unsigned long) strtol((char *) (pv + 16), NULL, 10);
            }
            else if (strstr(head, "mgwsi-nph: false"))  
               web_server_headers = 1;
         }

         *p1 = '\r';

         p = p1 + 2;
      }

      if (version == 1.1 && !con_close) {
         keepalive = 1;
         web_server_headers = 1;
      }
      if (version == 1.0 && con_keepalive) {
         keepalive = 1;
         web_server_headers = 1;
      }

      mgwsi_send_response_header(lp_request, (char *) lp_cgi_buffer->lp_buffer, keepalive, web_server_headers, 1);

      *lp_content = chr;

      lp_request->read_len = len;

      if (len) {
         mgwsi_client_send(lp_request, lp_cgi_buffer->lp_buffer + hlen, len, 0);
         len = 0;
      }

   }
   else {

#if MGWSI_APACHE_VERSION >= 20

      /* get rid of all filters up through protocol...  since we
       * haven't parsed off the headers, there is no way they can
       * work
       */

      cur = r->proto_output_filters;
      while (cur && cur->frec->ftype < AP_FTYPE_CONNECTION) {
         cur = cur->next;
      }
      r->output_filters = r->proto_output_filters = cur;

#endif
      lp_request->read_len = len;
      mgwsi_client_send(lp_request, lp_trans_buffer->lp_buffer, len, 0);
      len = 0;
   }

   if (client_gone)
      goto mgwsi_handler_exit1;

   if (!lp_request->lp_mgwsicon->eod) {

      for (;;) {
         n = mgwsi_db_receive(lp_request, lp_trans_buffer, MGWSI_BUFSIZE, 0);

         if (lp_request->error_flag == 1) {
            break;
         }

         if (n < 0) {
            strcpy(lp_trans_buffer->lp_buffer, "");
            server_gone = 1;
            break;
         }

         if (lp_request->lp_mgwsicon->eod)
            break;

         lp_request->read_len += lp_trans_buffer->data_size;
         mgwsi_client_send(lp_request, lp_trans_buffer->lp_buffer, lp_trans_buffer->data_size, 0);

      }
   }

   if (lp_request->error_flag) {
      server_gone = 1;
      mgwsi_return_error(lp_request, lp_request->error);
      goto mgwsi_handler_exit1;
   }

   if (client_gone) {
      time_now = time(NULL);
      time_diff = (time_t) difftime(time_now, time_start);
   }


   /* WebSockets */
mgwsi_handler_websockets:

#if defined(MGWSI_WEBSOCKETS)
   if (lp_request->lp_websocket) {
      unsigned char ok;
      int n, result;
      MGWSITC thread_control;

      if (MGWSI_DEBUG) {
         mgwsi_log_event(lp_response_buffer->lp_buffer, "WebSockets Diagnostic: Response");
      }

      ok = 0;
      if (strstr((char *) lp_response_buffer->lp_buffer, "HTTP/1.1 200"))
         ok = 1;

      if (ok) {
         lp_request->lp_websocket->status = 1;

         /* The main data framing loop */

         thread_control.stack_size = 0;
         n = mgwsi_thread_create((LPMGWSITC) &thread_control, (MGWSI_THREAD_START_ROUTINE) mgwsi_ws_read_from_db_async, (void *) lp_request);

         mgwsi_ws_data_framing(lp_request);
         if (MGWSI_DEBUG) {
            char buffer[256];
            sprintf(buffer, "Has Returned from mgwsi_ws_data_framing(): lp_request->lp_websocket->status=%d", lp_request->lp_websocket->status);
            mgwsi_log_event(buffer, "WebSockets Diagnostic");
         }
         if (lp_request->lp_websocket->status == 1) {

            if (MGWSI_DEBUG) {
               mgwsi_log_event("WebSocket Terminated by client", "WebSockets Diagnostic");
            }

            mgwsi_ws_db_send(lp_request, NULL, 0, MGWSI_TX_EOD);

            server_gone = 1;
         }

         result = mgwsi_thread_terminate(&thread_control);
         server_gone = 1;
      }
      else {
         mgwsi_ws_client_send_block(lp_request, MGWSI_WS_MESSAGE_TYPE_CLOSE, (unsigned char *) "", 0);

         if (MGWSI_DEBUG) {
            mgwsi_log_event(lp_response_buffer->lp_buffer, "WebSocket Diagnostic: Error");
         }

         mgwsi_client_send(lp_request, lp_trans_buffer->lp_buffer, lp_trans_buffer->data_size, 0);

         server_gone = 1;
      }

      apr_thread_mutex_unlock(lp_request->lp_websocket->mutex);

      /* Disconnecting */
      lp_request->r->connection->keepalive = AP_CONN_CLOSE;

      /* Close the connection */
      ap_lingering_close(lp_request->r->connection);
      apr_thread_mutex_destroy(lp_request->lp_websocket->mutex);

      if (MGWSI_DEBUG) {
         char buffer[256];
         if (lp_request->lp_websocket->status == 1)
            sprintf(buffer, "WebSocket Diagnostic: Disconnection: Protocol=%d; Disconnected by Client;", (int) lp_request->lp_websocket->protocol_version);
         else
            sprintf(buffer, "WebSocket Diagnostic: Disconnection: Protocol=%d; Disconnected by Server;", (int) lp_request->lp_websocket->protocol_version);

         mgwsi_log_event(lp_request->r->uri, buffer);
      }

      server_gone = 1;
   }
#endif /* #if defined(MGWSI_WEBSOCKETS) */


mgwsi_handler_exit1:

   if (lp_request->lp_mgwsicon->con_type == MGWSI_CON_GATEWAY) {
/*
      n = mgwsi_db_disconnect(lp_request, MGWCON_DSCON_HARD);
*/
      if (server_gone)
         n = mgwsi_db_disconnect(lp_request, MGWCON_DSCON_HARD);
      else
         n = mgwsi_db_disconnect(lp_request, MGWCON_DSCON_SOFT);
   }
   else {
      if (server_gone)
         n = mgwsi_db_disconnect(lp_request, MGWCON_DSCON_HARD);
      else
         n = mgwsi_db_disconnect(lp_request, MGWCON_DSCON_SOFT);
   }

#if MGWSI_APACHE_VERSION < 20
   MGWSI_KILL_TIMEOUT (r);
#endif

mgwsi_handler_exit2:

   mgwsi_mem_free(lp_cgi_buffer);
   mgwsi_mem_free(lp_trans_buffer);
   mgwsi_mem_free(lp_temp_buffer);
   mgwsi_mem_free(lp_response_buffer);

   if (lp_request->lp_websocket) {

      if (lp_request->lp_websocket->input_buffer) {
         free((void *) lp_request->lp_websocket->input_buffer);
         lp_request->lp_websocket->input_buffer = NULL;
         lp_request->lp_websocket->input_buffer_size = 0;
      }

      if (lp_request->lp_websocket->output_buffer) {
         free((void *) lp_request->lp_websocket->output_buffer);
         lp_request->lp_websocket->output_buffer = NULL;
         lp_request->lp_websocket->output_buffer_size = 0;
      }

      free((void *) lp_request->lp_websocket);
      lp_request->lp_websocket = NULL;
   }

   return OK;
}



/* 
 * This function is called during server initialization.  Any information
 * that needs to be recorded must be in static cells, since there's no
 * configuration record.
 *
 */

#if MGWSI_APACHE_VERSION >= 20
static int mgwsi_init(apr_pool_t *pPool, apr_pool_t *pLog, apr_pool_t *pTemp, server_rec *s)
#else
static void mgwsi_init(server_rec *s, pool *p)
#endif
{
   char *sname = s->server_hostname;
   mgwsi_config *sconf;

   sconf = (mgwsi_config *) MGWSI_GET_MODULE_CONFIG(s->module_config, &m_apache_module);


#if MGWSI_APACHE_VERSION >= 20
   return OK;
#else
   return;
#endif

}



/* 
 * This function is called during server initialization when a heavy-weight
 * process (such as a child) is being initialised.  As with the
 * module-initialization function, any information that needs to be recorded
 * must be in static cells, since there's no configuration record.
 *
 * There is no return value.
 */

#if MGWSI_APACHE_VERSION >= 20
static void mgwsi_child_init(pool *p, server_rec *s)
#else
static void mgwsi_child_init(server_rec *s, pool *p)
#endif
{
   int n, retval;
   char *sname = s->server_hostname;
   mgwsi_config *sconf;

   retval = 0;
   sconf = NULL;

   sconf = (mgwsi_config *) MGWSI_GET_MODULE_CONFIG(s->module_config, &m_apache_module);
   if (sconf) {
      mgwsi_maxcon = sconf->mgwsi_maxcon;
      if (mgwsi_maxcon < 0) {
         mgwsi_maxcon = 0;
      }
   }

   mgwsi_db_con = NULL;
   if (mgwsi_maxcon > 0) {

#if MGWSI_USE_THREADS
      if (mgwsicon_lock == NULL) {
         retval = apr_thread_mutex_create((apr_thread_mutex_t **)  &mgwsicon_lock, (unsigned int) APR_THREAD_MUTEX_DEFAULT, (apr_pool_t *)  p);
         if (retval != APR_SUCCESS) {
            mgwsicon_lock = NULL;
         }
      }
#endif

      mgwsi_db_con = (MGWSICON **) malloc(sizeof(MGWSICON *) * mgwsi_maxcon);
      if (!mgwsi_db_con)
         mgwsi_maxcon = 0;
   }

   for (n = 0; n < mgwsi_maxcon; n ++) {
      mgwsi_db_con[n] = NULL;
   }

   mgwsi_load_net_library(0);
   mgwsi_load_ssl_library(0);

#if MGWSI_APACHE_VERSION >= 20
   apr_pool_cleanup_register(p, s, mgwsi_child_exit, mgwsi_child_exit);
#endif

   return;
}



/* 
 * This function is called when an heavy-weight process (such as a child) is
 * being run down or destroyed.  As with the child-initialization function,
 * any information that needs to be recorded must be in static cells, since
 * there's no configuration record.
 *
 */

#if MGWSI_APACHE_VERSION >= 20
static apr_status_t mgwsi_child_exit(void *data)
#else
static void mgwsi_child_exit(server_rec *s, pool *p)
#endif
{
   int n, retval;
   MGWSIREQ request, *lp_request;
#if MGWSI_APACHE_VERSION >= 20
   server_rec *s = data;
#endif

   char *sname = s->server_hostname;

   lp_request = &request;

   retval = 0;
   sname = (sname != NULL) ? sname : "";

   if (mgwsi_maxcon > 0) {
      for (n = 0; n < mgwsi_maxcon; n ++) {
         if (mgwsi_db_con[n]) {
            lp_request->h_db = n;
            lp_request->lp_mgwsicon = mgwsi_db_con[n];
            mgwsi_db_disconnect(lp_request, MGWCON_DSCON_HARD);
            free((void *) mgwsi_db_con[n]);
            mgwsi_db_con[n] = NULL;
         }
      }

      if (mgwsi_db_con) {
         free((void *) mgwsi_db_con);
         mgwsi_db_con = NULL;
      }
   }

   mgwsi_unload_ssl_library(0);
   mgwsi_unload_net_library(0);

#if MGWSI_USE_THREADS
   if (mgwsicon_lock)
      retval = apr_thread_mutex_destroy(mgwsicon_lock);
#endif

#if MGWSI_APACHE_VERSION >= 20
    return APR_SUCCESS;
#else
   return;
#endif
}



/*
 * This function gets called to create up a per-directory configuration
 * record.  This will be called for the "default" server environment, and for
 * each directory for which the parser finds any of our directives applicable.
 * If a directory doesn't have any of our directives involved (i.e., they
 * aren't in the .htaccess file, or a <Location>, <Directory>, or related
 * block), this routine will *not* be called - the configuration for the
 * closest ancestor is used.
 *
 * The return value is a pointer to the created module-specific
 * structure.
 */

static void *mgwsi_create_dir_config(pool *p, char *dirspec)
{
   mgwsi_config *cfg;
   char *dname = dirspec;

   /*
    * Allocate the space for our record from the pool supplied.
    */

   cfg = (mgwsi_config *) MGWSI_PCALLOC (p, sizeof(mgwsi_config));

   /*
    * Now fill in the defaults.  If there are any `parent' configuration
    * records, they'll get merged as part of a separate callback.
    */

   cfg->local = 0;
   cfg->congenital = 0;
   cfg->cmode = CONFIG_MODE_DIRECTORY;

   dname = (dname != NULL) ? dname : "";

   cfg->mgwsi_enabled = 0;

   cfg->mgwsi_maxcon = MGWSI_MAXCON;

   cfg->mgwsi_file_types[0] = '\0';

   return (void *) cfg;
}



/*
 * This function gets called to merge two per-directory configuration
 * records.  This is typically done to cope with things like .htaccess files
 * or <Location> directives for directories that are beneath one for which a
 * configuration record was already created.  The routine has the
 * responsibility of creating a new record and merging the contents of the
 * other two into it appropriately.  If the module doesn't declare a merge
 * routine, the record for the closest ancestor location (that has one) is
 * used exclusively.
 *
 * The routine MUST NOT modify any of its arguments!
 *
 * The return value is a pointer to the created module-specific structure
 * containing the merged values.
 */

static void *mgwsi_merge_dir_config(pool *p, void *parent_conf, void *newloc_conf)
{
   mgwsi_config *merged_config = (mgwsi_config *) MGWSI_PCALLOC (p, sizeof(mgwsi_config));
   mgwsi_config *pconf = (mgwsi_config *) parent_conf;
   mgwsi_config *nconf = (mgwsi_config *) newloc_conf;

   /*
    * Some things get copied directly from the more-specific record, rather
    * than getting merged.
    */

   merged_config->local = nconf->local;

   merged_config->mgwsi_enabled = nconf->mgwsi_enabled;

   merged_config->mgwsi_maxcon = nconf->mgwsi_maxcon;

   strcpy(merged_config->mgwsi_file_types, nconf->mgwsi_file_types);

   /*
    * Others, like the setting of the `congenital' flag, get ORed in.  The
    * setting of that particular flag, for instance, is TRUE if it was ever
    * true anywhere in the upstream configuration.
    */

   merged_config->congenital = (pconf->congenital | pconf->local);

   /*
    * If we're merging records for two different types of environment (server
    * and directory), mark the new record appropriately.  Otherwise, inherit
    * the current value.
    */

   merged_config->cmode = (pconf->cmode == nconf->cmode) ? pconf->cmode : CONFIG_MODE_COMBO;

   return (void *) merged_config;
}



/*
 * This function gets called to create a per-server configuration
 * record.  It will always be called for the "default" server.
 *
 * The return value is a pointer to the created module-specific
 * structure.
 */

static void *mgwsi_create_server_config(pool *p, server_rec *s)
{
   mgwsi_config *cfg;
   char    *sname = s->server_hostname;

   /*
    * As with the mgwsi_create_dir_config() routine, we allocate and fill in an
    * empty record.
    */

   cfg = (mgwsi_config *) MGWSI_PCALLOC (p, sizeof(mgwsi_config));
   cfg->local = 0;
   cfg->congenital = 0;
   cfg->cmode = CONFIG_MODE_SERVER;

   cfg->mgwsi_maxcon = MGWSI_MAXCON;

   sname = (sname != NULL) ? sname : "";

   return (void *) cfg;
}



/*
 * This function gets called to merge two per-server configuration
 * records.  This is typically done to cope with things like virtual hosts and
 * the default server configuration  The routine has the responsibility of
 * creating a new record and merging the contents of the other two into it
 * appropriately.  If the module doesn't declare a merge routine, the more
 * specific existing record is used exclusively.
 *
 * The routine MUST NOT modify any of its arguments!
 *
 * The return value is a pointer to the created module-specific structure
 * containing the merged values.
 */

static void *mgwsi_merge_server_config(pool *p, void *server1_conf, void *server2_conf)
{
   mgwsi_config *merged_config = (mgwsi_config *) MGWSI_PCALLOC (p, sizeof(mgwsi_config));
   mgwsi_config *s1conf = (mgwsi_config *) server1_conf;
   mgwsi_config *s2conf = (mgwsi_config *) server2_conf;

   /*
    * Our inheritance rules are our own, and part of our module's semantics.
    * Basically, just note whence we came.
    */

   merged_config->cmode = (s1conf->cmode == s2conf->cmode) ? s1conf->cmode : CONFIG_MODE_COMBO;
   merged_config->local = s2conf->local;
   merged_config->congenital = (s1conf->congenital | s1conf->local);
   merged_config->mgwsi_maxcon = s2conf->mgwsi_maxcon;

   return (void *) merged_config;
}


#if defined(MGWSI_WEBSOCKETS)

static size_t mgwsi_ws_protocol_count(MGWSIREQ *lp_request)
{
   size_t count = 0;

   if ((lp_request->lp_websocket != NULL) && (lp_request->lp_websocket->protocols != NULL) && !apr_is_empty_array(lp_request->lp_websocket->protocols)) {
      count = (size_t) lp_request->lp_websocket->protocols->nelts;
   }
   return count;
}


static const char * mgwsi_ws_protocol_index(MGWSIREQ *lp_request, const size_t index)
{
   if ((index >= 0) && (index < mgwsi_ws_protocol_count(lp_request))) {
      return APR_ARRAY_IDX(lp_request->lp_websocket->protocols, index, char *);
   }
   return NULL;
}

static void mgwsi_ws_protocol_set(MGWSIREQ *lp_request, const char *protocol)
{
   if ((lp_request->lp_websocket != NULL) && (protocol != NULL)) {
      MGWSIWS *state = lp_request->lp_websocket;

      if ((state != NULL) && (state->r != NULL)) {
         apr_table_setn(state->r->headers_out, "Sec-WebSocket-Protocol", apr_pstrdup(state->r->pool, protocol));
      }
   }
   return;
}


/*
 * Base64-encode the SHA-1 hash of the client-supplied key with the WebSocket
 * GUID appended to it.
 */
static void mgwsi_ws_handshake(MGWSIREQ *lp_request, const char *key)
{
   MGWSIWS *state = lp_request->lp_websocket;
   apr_byte_t response[32];
   apr_byte_t digest[APR_SHA1_DIGESTSIZE];
   apr_sha1_ctx_t context;
   int len;

   apr_sha1_init(&context);
   apr_sha1_update(&context, key, strlen(key));
   apr_sha1_update(&context, MGWSI_WS_WEBSOCKET_GUID, MGWSI_WS_WEBSOCKET_GUID_LEN);
   apr_sha1_final(digest, &context);

   len = apr_base64_encode_binary((char *)response, digest, sizeof(digest));
   response[len] = '\0';

   apr_table_setn(state->r->headers_out, "Sec-WebSocket-Accept", apr_pstrdup(state->r->pool, (const char *)response));
   return;
}

/*
 * The client-supplied WebSocket protocol entry consists of a list of
 * client-side supported protocols. Parse the list, and create an array
 * containing those protocol names.
 */
static void mgwsi_ws_parse_protocol(MGWSIREQ *lp_request, const char *sec_websocket_protocol)
{
   MGWSIWS *state = lp_request->lp_websocket;
   apr_array_header_t *protocols = apr_array_make(state->r->pool, 1, sizeof(char *));
   char *protocol_state = NULL;
   char *protocol = apr_strtok(apr_pstrdup(state->r->pool, sec_websocket_protocol), ", \t", &protocol_state);

   while (protocol != NULL) {
      APR_ARRAY_PUSH(protocols, char *) = protocol;
      protocol = apr_strtok(NULL, ", \t", &protocol_state);
   }
   if (!apr_is_empty_array(protocols)) {
      state->protocols = protocols;
   }
   return;
}


static int mgwsi_ws_send_header(void *data, const char *key, const char *val)
{
   ap_fputstrs(((MGWSIWSHD *) data)->f, ((MGWSIWSHD *) data)->bb, key, ": ", val, CRLF, NULL);
   return 1;
}

void mgwsi_ws_ap_send_interim_response(request_rec *r, int send_headers)
{
#if 0

   ap_send_interim_response(r, send_headers);

#else

   MGWSIWSHD x;
   char *status_line = NULL;
   request_rec *rr;

   if (r->proto_num < 1001) {
      /* don't send interim response to HTTP/1.0 Client */
      return;
   }
   if (!ap_is_HTTP_INFO(r->status)) {
      ap_log_rerror(APLOG_MARK, APLOG_DEBUG, 0, r, "Status is %d - not sending interim response", r->status);
      return;
   }

   /* if we send an interim response, we're no longer in a state of
    * expecting one.  Also, this could feasibly be in a subrequest,
    * so we need to propagate the fact that we responded.
    */
   for (rr = r; rr != NULL; rr = rr->main) {
      rr->expecting_100 = 0;
   }

   status_line = apr_pstrcat(r->pool, AP_SERVER_PROTOCOL, " ", r->status_line, CRLF, NULL);
   ap_xlate_proto_to_ascii(status_line, strlen(status_line));

   x.f = r->connection->output_filters;
   x.bb = apr_brigade_create(r->pool, r->connection->bucket_alloc);

   ap_fputs(x.f, x.bb, status_line);
   if (send_headers) {
      apr_table_do(mgwsi_ws_send_header, &x, r->headers_out, NULL);
      apr_table_clear(r->headers_out);
   }
   ap_fputs(x.f, x.bb, CRLF);
   ap_fflush(x.f, x.bb);
   apr_brigade_destroy(x.bb);

#endif

   return;
}


int mgwsi_ws_test_request(MGWSIREQ *lp_request, LPMGWSIBUF lp_cgievar)
{
   short phase;
   int upgrade_connection;

   phase = 0;
   upgrade_connection = 0;

   if (lp_request->r && (lp_request->r->method_number == M_GET) && (lp_request->r->parsed_uri.path != NULL) && (lp_request->r->headers_in != NULL)) {
      const char *upgrade = apr_table_get(lp_request->r->headers_in, "Upgrade");
      const char *connection = apr_table_get(lp_request->r->headers_in, "Connection");

      if ((upgrade != NULL) && (connection != NULL) && !strcasecmp(upgrade, "WebSocket")) {
         upgrade_connection = !strcasecmp(connection, "Upgrade");
         if (!upgrade_connection) {
            char *token = ap_get_token(lp_request->r->pool, &connection, 0);

            while (token && *token) { /* Parse the Connection value */

               upgrade_connection = !strcasecmp(token, "Upgrade");
               if (upgrade_connection) {
                  break;
               }
               while (*connection == ';') {
                  ++ connection;
                  ap_get_token(lp_request->r->pool, &connection, 0); /* Skip parameters */
               }
               if (*connection ++ != ',') {
                  break; /* Invalid without comma */
               }
               token = (*connection) ? ap_get_token(lp_request->r->pool, &connection, 0) : NULL;
            }
         }
      }
   }

   return upgrade_connection;

}


int mgwsi_ws_client_send(MGWSIREQ *lp_request, char *buffer, int len)
{
   int result, n;
   unsigned long dw_size;

   result = 0;
   dw_size = 0;
   n = 0;

   if (ap_fwrite(lp_request->lp_websocket->of, lp_request->lp_websocket->obb, (const char *) buffer, (apr_size_t) len) == APR_SUCCESS) { /* Payload Data */
      result = len;
   }

   return result;
}


size_t mgwsi_ws_client_send_block(MGWSIREQ *lp_request, const int type, unsigned char *buffer, const size_t buffer_size)
{
   int result;
   unsigned long dw_size;
   apr_uint64_t payload_length = (apr_uint64_t) ((buffer != NULL) ? buffer_size : 0);
   size_t written = 0;

   result = 0;
   dw_size = 0;

   /* Deal with size more that 63 bits - FIXME */

   if (lp_request->lp_websocket != NULL) {
      MGWSIWS *state = lp_request->lp_websocket;

      apr_thread_mutex_lock(state->mutex);

      if ((state->r != NULL) && (state->obb != NULL) && !state->closing) {

         unsigned char header[32];
         size_t pos = 0;
         unsigned char opcode;

         state->of = state->r->connection->output_filters;

         switch (type) {
            case MGWSI_WS_MESSAGE_TYPE_TEXT:
               opcode = MGWSI_WS_OPCODE_TEXT;
               break;
            case MGWSI_WS_MESSAGE_TYPE_BINARY:
               opcode = MGWSI_WS_OPCODE_BINARY;
               break;
            case MGWSI_WS_MESSAGE_TYPE_PING:
               opcode = MGWSI_WS_OPCODE_PING;
               break;
            case MGWSI_WS_MESSAGE_TYPE_PONG:
               opcode = MGWSI_WS_OPCODE_PONG;
               break;
            case MGWSI_WS_MESSAGE_TYPE_CLOSE:
            default:
               state->closing = 1;
               opcode = MGWSI_WS_OPCODE_CLOSE;
               break;
         }
         header[pos++] = MGWSI_WS_FRAME_SET_FIN(1) | MGWSI_WS_FRAME_SET_OPCODE(opcode);
         if (payload_length < 126) {
            header[pos++] = MGWSI_WS_FRAME_SET_MASK(0) | MGWSI_WS_FRAME_SET_LENGTH(payload_length, 0);
         }
         else {
            if (payload_length < 65536) {
               header[pos++] = MGWSI_WS_FRAME_SET_MASK(0) | 126;
            }
            else {
               header[pos++] = MGWSI_WS_FRAME_SET_MASK(0) | 127;
               header[pos++] = MGWSI_WS_FRAME_SET_LENGTH(payload_length, 7);
               header[pos++] = MGWSI_WS_FRAME_SET_LENGTH(payload_length, 6);
               header[pos++] = MGWSI_WS_FRAME_SET_LENGTH(payload_length, 5);
               header[pos++] = MGWSI_WS_FRAME_SET_LENGTH(payload_length, 4);
               header[pos++] = MGWSI_WS_FRAME_SET_LENGTH(payload_length, 3);
               header[pos++] = MGWSI_WS_FRAME_SET_LENGTH(payload_length, 2);
            }
            header[pos++] = MGWSI_WS_FRAME_SET_LENGTH(payload_length, 1);
            header[pos++] = MGWSI_WS_FRAME_SET_LENGTH(payload_length, 0);
         }

         mgwsi_ws_client_send(lp_request, (char *) header, (int) pos); /* Header */
         if (payload_length > 0) {
            if (mgwsi_ws_client_send(lp_request, (char *) buffer, (int) buffer_size) > 0) { /* Payload Data */
               written = buffer_size;
            }
         }
         if (ap_fflush(state->of, state->obb) != APR_SUCCESS) {
            written = 0;
         }
      }

      apr_thread_mutex_unlock(state->mutex);
   }

   return written;
}

/*
 * Read a buffer of data from the input stream.
 */
size_t mgwsi_ws_read_client_block(MGWSIREQ *lp_request, char *buffer, size_t bufsiz)
{
   apr_status_t rv;
   apr_bucket_brigade *bb;
   apr_size_t readbufsiz = 0;

   bb = apr_brigade_create(lp_request->r->pool, lp_request->r->connection->bucket_alloc);
   if (bb != NULL) {
      if ((rv = ap_get_brigade(lp_request->r->input_filters, bb, AP_MODE_READBYTES, APR_BLOCK_READ, (apr_size_t) bufsiz)) == APR_SUCCESS) {
         if ((rv = apr_brigade_flatten(bb, buffer, (apr_size_t *) &bufsiz)) == APR_SUCCESS) {
            readbufsiz = (apr_size_t) bufsiz;
         }
      }
      apr_brigade_destroy(bb);
   }
   return (size_t) readbufsiz;
}


/*
 * The data framing handler requires that the server state mutex is locked by
 * the caller upon entering this function. It will be locked when leaving too.
 */
void mgwsi_ws_data_framing(MGWSIREQ *lp_request)
{
   int result;
   apr_int64_t payload_limit;
   MGWSIWS *state = lp_request->lp_websocket;
   request_rec *r = state->r;
   apr_bucket_brigade *obb = apr_brigade_create(r->pool, r->connection->bucket_alloc);

   result = 0;
   payload_limit = 32 * 1024 * 1024;

   if (obb != NULL) {
      unsigned char block[MGWSI_WS_BLOCK_DATA_SIZE];
      apr_int64_t block_size;
      apr_int64_t extension_bytes_remaining = 0;
      apr_int64_t payload_length = 0;
      apr_int64_t mask_offset = 0;
      int framing_state = MGWSI_WS_DATA_FRAMING_START;
      int payload_length_bytes_remaining = 0;
      int mask_index = 0, masking = 0;
      unsigned char mask[4] = { 0, 0, 0, 0 };
      unsigned char fin = 0, opcode = 0xFF;
      MGWSIWSFD control_frame = { 0, NULL, 1, 8, UTF8_VALID };
      MGWSIWSFD message_frame = { 0, NULL, 1, 0, UTF8_VALID };
      MGWSIWSFD *frame = &control_frame;
      unsigned short status_code = MGWSI_WS_STATUS_CODE_OK;
      unsigned char status_code_buffer[2];

      /* Allow the plugin to now write to the client */
      state->obb = obb;
      apr_thread_mutex_unlock(state->mutex);

      while ((framing_state != MGWSI_WS_DATA_FRAMING_CLOSE) && ((block_size = mgwsi_ws_read_client_block(lp_request, (char *) block, sizeof(block))) > 0)) {
         apr_int64_t block_offset = 0;

         while (block_offset < block_size) {
            switch (framing_state) {
               case MGWSI_WS_DATA_FRAMING_START:
                  /*
                   * Since we don't currently support any extensions,
                   * the reserve bits must be 0
                   */
                  if ((MGWSI_WS_FRAME_GET_RSV1(block[block_offset]) != 0) ||
                      (MGWSI_WS_FRAME_GET_RSV2(block[block_offset]) != 0) ||
                      (MGWSI_WS_FRAME_GET_RSV3(block[block_offset]) != 0)) {
                     framing_state = MGWSI_WS_DATA_FRAMING_CLOSE;
                     status_code = MGWSI_WS_STATUS_CODE_PROTOCOL_ERROR;
                     break;
                  }
                  fin = MGWSI_WS_FRAME_GET_FIN(block[block_offset]);
                  opcode = MGWSI_WS_FRAME_GET_OPCODE(block[block_offset++]);

                  framing_state = MGWSI_WS_DATA_FRAMING_PAYLOAD_LENGTH;

                  if (opcode >= 0x8) { /* Control frame */
                     if (fin) {
                        frame = &control_frame;
                        frame->opcode = opcode;
                        frame->utf8_state = UTF8_VALID;
                     }
                     else {
                        framing_state = MGWSI_WS_DATA_FRAMING_CLOSE;
                        status_code = MGWSI_WS_STATUS_CODE_PROTOCOL_ERROR;
                        break;
                     }
                  }
                  else { /* Message frame */
                     frame = &message_frame;
                     if (opcode) {
                        if (frame->fin) {
                           frame->opcode = opcode;
                           frame->utf8_state = UTF8_VALID;
                        }
                        else {
                           framing_state = MGWSI_WS_DATA_FRAMING_CLOSE;
                           status_code = MGWSI_WS_STATUS_CODE_PROTOCOL_ERROR;
                           break;
                        }
                     }
                     else if (frame->fin || ((opcode = frame->opcode) == 0)) {
                        framing_state = MGWSI_WS_DATA_FRAMING_CLOSE;
                        status_code = MGWSI_WS_STATUS_CODE_PROTOCOL_ERROR;
                        break;
                     }
                     frame->fin = fin;
                  }
                  payload_length = 0;
                  payload_length_bytes_remaining = 0;

                  if (block_offset >= block_size) {
                     break; /* Only break if we need more data */
                  }
               case MGWSI_WS_DATA_FRAMING_PAYLOAD_LENGTH:
                  payload_length = (apr_int64_t) MGWSI_WS_FRAME_GET_PAYLOAD_LEN(block[block_offset]);
                  masking = MGWSI_WS_FRAME_GET_MASK(block[block_offset++]);

                  if (payload_length == 126) {
                     payload_length = 0;
                     payload_length_bytes_remaining = 2;
                  }
                  else if (payload_length == 127) {
                     payload_length = 0;
                     payload_length_bytes_remaining = 8;
                  }
                  else {
                     payload_length_bytes_remaining = 0;
                  }
                  if ((masking == 0) ||   /* Client-side mask is required */
                      ((opcode >= 0x8) && /* Control opcodes cannot have a payload larger than 125 bytes */
                      (payload_length_bytes_remaining != 0))) {
                    framing_state = MGWSI_WS_DATA_FRAMING_CLOSE;
                    status_code = MGWSI_WS_STATUS_CODE_PROTOCOL_ERROR;
                    break;
                  }
                  else {
                     framing_state = MGWSI_WS_DATA_FRAMING_PAYLOAD_LENGTH_EXT;
                  }
                  if (block_offset >= block_size) {
                     break;  /* Only break if we need more data */
                  }
               case MGWSI_WS_DATA_FRAMING_PAYLOAD_LENGTH_EXT:
                  while ((payload_length_bytes_remaining > 0) && (block_offset < block_size)) {
                     payload_length *= 256;
                     payload_length += block[block_offset++];
                     payload_length_bytes_remaining--;
                  }
                  if (payload_length_bytes_remaining == 0) {
                     if ((payload_length < 0) ||
                         (payload_length > payload_limit)) {
                        /* Invalid payload length */
                        framing_state = MGWSI_WS_DATA_FRAMING_CLOSE;
                        status_code = (state->protocol_version >= 13) ? MGWSI_WS_STATUS_CODE_MESSAGE_TOO_LARGE : MGWSI_WS_STATUS_CODE_RESERVED;
                        break;
                      }
                      else if (masking != 0) {
                         framing_state = MGWSI_WS_DATA_FRAMING_MASK;
                      }
                      else {
                         framing_state = MGWSI_WS_DATA_FRAMING_EXTENSION_DATA;
                         break;
                      }
                  }
                  if (block_offset >= block_size) {
                     break;  /* Only break if we need more data */
                  }
               case MGWSI_WS_DATA_FRAMING_MASK:
                  while ((mask_index < 4) && (block_offset < block_size)) {
                     mask[mask_index++] = block[block_offset++];
                  }
                  if (mask_index == 4) {
                     framing_state = MGWSI_WS_DATA_FRAMING_EXTENSION_DATA;
                     mask_offset = 0;
                     mask_index = 0;
                     if ((mask[0] == 0) && (mask[1] == 0) && (mask[2] == 0) && (mask[3] == 0)) {
                        masking = 0;
                     }
                  }
                  else {
                     break;
                  }
                  /* Fall through */
               case MGWSI_WS_DATA_FRAMING_EXTENSION_DATA:
                  /* Deal with extension data when we support them -- FIXME */
                  if (extension_bytes_remaining == 0) {
                     if (payload_length > 0) {
                        frame->application_data = (unsigned char *) realloc(frame->application_data, (size_t) (frame->application_data_offset + payload_length));
                        if (frame->application_data == NULL) {
                           framing_state = MGWSI_WS_DATA_FRAMING_CLOSE;
                           status_code = (state->protocol_version >= 13) ? MGWSI_WS_STATUS_CODE_INTERNAL_ERROR : MGWSI_WS_STATUS_CODE_GOING_AWAY;
                           break;
                        }
                     }
                     framing_state = MGWSI_WS_DATA_FRAMING_APPLICATION_DATA;
                  }
                  /* Fall through */
               case MGWSI_WS_DATA_FRAMING_APPLICATION_DATA:
                  {
                     apr_int64_t block_data_length;
                     apr_int64_t block_length = 0;
                     apr_uint64_t application_data_offset = frame->application_data_offset;
                     unsigned char *application_data = frame->application_data;

                     block_length = block_size - block_offset;
                     block_data_length = (payload_length > block_length) ? block_length : payload_length;

                     if (masking) {
                        apr_int64_t i;

                        if (opcode == MGWSI_WS_OPCODE_TEXT) {
                           unsigned int utf8_state = frame->utf8_state;
                           unsigned char c;

                           for (i = 0; i < block_data_length; i++) {
                              c = block[block_offset++] ^mask[mask_offset++ & 3];
                              utf8_state = validate_utf8[utf8_state + c];
                              if (utf8_state == UTF8_INVALID) {
                                 payload_length = block_data_length;
                                 break;
                              }
                              application_data[application_data_offset++] = c;
                           }
                           frame->utf8_state = utf8_state;
                        }
                        else {
                           /* Need to optimize the unmasking -- FIXME */
                           for (i = 0; i < block_data_length; i++) {
                              application_data[application_data_offset++] = block[block_offset++] ^mask[mask_offset++ & 3];
                           }
                        }
                     }
                     else if (block_data_length > 0) {
                        memcpy(&application_data[application_data_offset], &block[block_offset], (size_t) block_data_length);
                        if (opcode == MGWSI_WS_OPCODE_TEXT) {
                           apr_int64_t i, application_data_end = application_data_offset + block_data_length;
                           unsigned int utf8_state = frame->utf8_state;

                           for (i = application_data_offset; i < application_data_end; i++) {
                              utf8_state = validate_utf8[utf8_state + application_data[i]];
                              if (utf8_state == UTF8_INVALID) {
                                 payload_length = block_data_length;
                                 break;
                              }
                           }
                           frame->utf8_state = utf8_state;
                        }
                        application_data_offset += block_data_length;
                        block_offset += block_data_length;
                     }
                     payload_length -= block_data_length;

                     if (payload_length == 0) {
                        int message_type = MGWSI_WS_MESSAGE_TYPE_INVALID;

                        switch (opcode) {
                           case MGWSI_WS_OPCODE_TEXT:
                              if ((fin && (frame->utf8_state != UTF8_VALID)) || (frame->utf8_state == UTF8_INVALID)) {
                                 framing_state = MGWSI_WS_DATA_FRAMING_CLOSE;
                                 status_code = MGWSI_WS_STATUS_CODE_INVALID_UTF8;
                              }
                              else {
                                 message_type = MGWSI_WS_MESSAGE_TYPE_TEXT;
                              }
                              break;
                           case MGWSI_WS_OPCODE_BINARY:
                              message_type = MGWSI_WS_MESSAGE_TYPE_BINARY;
                              break;
                           case MGWSI_WS_OPCODE_CLOSE:
                              framing_state = MGWSI_WS_DATA_FRAMING_CLOSE;
                              status_code = MGWSI_WS_STATUS_CODE_OK;
                              break;
                           case MGWSI_WS_OPCODE_PING:
                              mgwsi_ws_client_send_block(lp_request, MGWSI_WS_MESSAGE_TYPE_PONG, (unsigned char *) application_data, (size_t) application_data_offset);
                              break;
                           case MGWSI_WS_OPCODE_PONG:
                              break;
                           default:
                              framing_state = MGWSI_WS_DATA_FRAMING_CLOSE;
                              status_code = MGWSI_WS_STATUS_CODE_PROTOCOL_ERROR;
                              break;
                        }
                        if (fin && (message_type != MGWSI_WS_MESSAGE_TYPE_INVALID)) { /* CMT1060 */

                           int result, timeout;

                           timeout = 60;

                           if (MGWSI_DEBUG) {
                              char buffer[256];
                              strncpy(buffer, (char *) application_data, (int) application_data_offset);
                              buffer[application_data_offset] = '\0';
                              mgwsi_log_event(buffer, "WebSocket Diagnostic: Data Received from Client");
                           }


                           if (lp_request->lp_mgwsicon) {
/*
                              result = mgwsi_db_send_ex(lp_request, (unsigned char *) application_data, (int) application_data_offset, 0);
*/
                              result = mgwsi_ws_db_send(lp_request, (unsigned char *) application_data, (int) application_data_offset, MGWSI_TX_DATA);
                           }
                        }
                        if (framing_state != MGWSI_WS_DATA_FRAMING_CLOSE) {
                           framing_state = MGWSI_WS_DATA_FRAMING_START;

                           if (fin) {
                              if (frame->application_data != NULL) {
                                 free(frame->application_data);
                                 frame->application_data = NULL;
                              }
                              application_data_offset = 0;
                           }
                        }
                    }
                    frame->application_data_offset = application_data_offset;
                  }
                  break;
               case MGWSI_WS_DATA_FRAMING_CLOSE:
                  block_offset = block_size;
                  break;
               default:
                  framing_state = MGWSI_WS_DATA_FRAMING_CLOSE;
                  status_code = MGWSI_WS_STATUS_CODE_PROTOCOL_ERROR;
                  break;
            }
         }
      }
      if (message_frame.application_data != NULL) {
         free(message_frame.application_data);
      }
      if (control_frame.application_data != NULL) {
         free(control_frame.application_data);
      }

      /* Send server-side closing handshake */
      status_code_buffer[0] = (status_code >> 8) & 0xFF;
      status_code_buffer[1] = status_code & 0xFF;
      mgwsi_ws_client_send_block(lp_request, MGWSI_WS_MESSAGE_TYPE_CLOSE, (unsigned char *) status_code_buffer, sizeof(status_code_buffer));

      /* We are done with the bucket brigade */
      apr_thread_mutex_lock(state->mutex);
      state->obb = NULL;
      apr_brigade_destroy(obb);
   }
}


MGWSI_THREAD_TYPE mgwsi_ws_read_from_db_async(void *lp_parameters)
{
   short type;
   int result, timeout;
   size_t ret;
   int size;
   //unsigned char data[256];
   MGWSIREQ *lp_request;

   result = 0;
   ret = 0;
   lp_request = (MGWSIREQ *) lp_parameters;

   timeout = 60000;
   for (;;) {

      result = mgwsi_ws_db_receive(lp_request, &size, &type);

      if (MGWSI_DEBUG) {
         char buffer[256];
         if (result >= 0) {
            sprintf(buffer, "WebSocket Diagnostic: Read from M: result=%d; type=%d", result, type);
            mgwsi_log_event((char *) lp_request->lp_websocket->output_buffer, buffer);
         }
      }

      if (type == MGWSI_TX_EOD) {
         lp_request->lp_websocket->status = 11;

         if (MGWSI_DEBUG) {
            mgwsi_log_event("WebSocket gracefully closed on Cache side", "WebSocket Diagnostic");
         }

         mgwsi_ws_client_send_block(lp_request, MGWSI_WS_MESSAGE_TYPE_CLOSE, (unsigned char *) "", 0);
         break;
      }
      if (result < 0) {
         lp_request->lp_websocket->status = 21;

         if (MGWSI_DEBUG) {
            mgwsi_log_event("WebSocket forcefully closed on Cache side", "WebSocket Diagnostic");
         }

         mgwsi_ws_client_send_block(lp_request, MGWSI_WS_MESSAGE_TYPE_CLOSE, (unsigned char *) "", 0);
         break;
      }

      size = result;
      ret = mgwsi_ws_client_send_block(lp_request, MGWSI_WS_MESSAGE_TYPE_TEXT, (unsigned char *) lp_request->lp_websocket->output_buffer, (size_t) size);
   }


   mgwsi_thread_exit();

   return MGWSI_THREAD_RETURN;

}

/*
int                     mgwsi_encode_ws_header        (unsigned char * head, int size, short type);
int                     mgwsi_decode_ws_header        (unsigned char * head, int * size, short * type);
*/

int mgwsi_ws_db_send(MGWSIREQ *lp_request, unsigned char *data, int size, short type)
{
   if (lp_request->lp_websocket->input_buffer_size < (size + 5 + 256)) {
      free((void *) lp_request->lp_websocket->input_buffer);
      lp_request->lp_websocket->input_buffer = (unsigned char *) malloc(sizeof(char) * (size + 5 + 256));
      lp_request->lp_websocket->input_buffer_size = size + 5 + 256;
   }

   mgwsi_encode_ws_header((unsigned char *) lp_request->lp_websocket->input_buffer, size, type);
   if (size) {
   memcpy((void *) (lp_request->lp_websocket->input_buffer + 5), (void *) data, size);
   }
   lp_request->lp_websocket->input_buffer[size + 5] = '\0';

   return mgwsi_db_send_ex(lp_request, (unsigned char *) lp_request->lp_websocket->input_buffer, (int) (size + 5), 0);
}


int mgwsi_ws_db_receive(MGWSIREQ *lp_request, int *size, short *type)
{
   int result;
   unsigned char head[16];

   result = mgwsi_db_receive_ex(lp_request, (unsigned char *) head, 5, 0);
   if (result < 5) {
      return -1;
   }

   mgwsi_decode_ws_header((unsigned char *) head, size, type);

   if (lp_request->lp_websocket->output_buffer_size < (*size + 5 + 256)) {
      free((void *) lp_request->lp_websocket->output_buffer);
      lp_request->lp_websocket->output_buffer = (unsigned char *) malloc(sizeof(char) * (*size + 5 + 256));
      lp_request->lp_websocket->output_buffer_size = *size + 5 + 256;
   }

   result = mgwsi_db_receive_ex(lp_request, (unsigned char *) lp_request->lp_websocket->output_buffer, *size, 0);
   if (result != *size) {
      result = -1;
   }

   return result;
}


#endif /* #if defined(MGWSI_WEBSOCKETS) */


#if MGWSI_APACHE_VERSION >= 20

/*--------------------------------------------------------------------------*/
/*                                                                          */
/* Which functions are responsible for which hooks in the server.           */
/*                                                                          */
/*--------------------------------------------------------------------------*/
/* 
 * Each function our module provides to handle a particular hook is
 * specified here.  The functions are registered using 
 * ap_hook_foo(name, predecessors, successors, position)
 * where foo is the name of the hook.
 *
 * The args are as follows:
 * name         -> the name of the function to call.
 * predecessors -> a list of modules whose calls to this hook must be
 *                 invoked before this module.
 * successors   -> a list of modules whose calls to this hook must be
 *                 invoked after this module.
 * position     -> The relative position of this module.  One of
 *                 APR_HOOK_FIRST, APR_HOOK_MIDDLE, or APR_HOOK_LAST.
 *                 Most modules will use APR_HOOK_MIDDLE.  If multiple
 *                 modules use the same relative position, Apache will
 *                 determine which to call first.
 *                 If your module relies on another module to run first,
 *                 or another module running after yours, use the 
 *                 predecessors and/or successors.
 *
 * The number in brackets indicates the order in which the routine is called
 * during request processing.  Note that not all routines are necessarily
 * called (such as if a resource doesn't have access restrictions).
 * The actual delivery of content to the browser [9] is not handled by
 * a hook; see the handler declarations below.
 */

static void mgwsi_register_hooks(apr_pool_t *p)
{

   ap_hook_post_config(mgwsi_init, NULL, NULL, APR_HOOK_MIDDLE);
   ap_hook_child_init(mgwsi_child_init, NULL, NULL, APR_HOOK_MIDDLE);
   ap_hook_handler(mgwsi_handler, NULL, NULL, APR_HOOK_MIDDLE);

   return;
}

#endif


/*--------------------------------------------------------------------------*/
/*                                                                          */
/* All of the routines have been declared now.  Here's the list of          */
/* directives specific to our module, and information about where they      */
/* may appear and how the command parser should pass them to us for         */
/* processing.  Note that care must be taken to ensure that there are NO    */
/* collisions of directive names between modules.                           */
/*                                                                          */
/*--------------------------------------------------------------------------*/
/* 
 * List of directives specific to our module.
 */

#if MGWSI_APACHE_VERSION >= 20
static const command_rec mgwsi_commands [] = {
   AP_INIT_RAW_ARGS("MGWSIFileTypes", mgwsi_cmd, NULL, OR_FILEINFO,
      "optional list of file types (by extension) to be processed by MGWSI"),
   AP_INIT_RAW_ARGS("MGWSI", mgwsi_cmd, NULL, OR_FILEINFO,
      "set to 'On' to enable the entire location to be processed with MGWSI"),
   AP_INIT_RAW_ARGS("MGWSIMaxPooledConnections", mgwsi_cmd, NULL, OR_FILEINFO,
      "set to the maximum number of pooled connections to the MGWSI Daemon per child process; set to 0 to disable connection pooling"),
   { NULL }
};
#else
static const command_rec mgwsi_commands[] = {
   {"MGWSIFileTypes", mgwsi_cmd, NULL, OR_FILEINFO, RAW_ARGS,
      "optional list of file types (by extension) to be processed by MGWSI"},
   {"MGWSI", mgwsi_cmd, NULL, OR_FILEINFO, RAW_ARGS,
      "set to 'On' to enable the entire location to be processed with MGWSI"},
   {"MGWSIMaxPooledConnections", mgwsi_cmd, NULL, OR_FILEINFO, RAW_ARGS,
      "set to the maximum number of pooled connections to the MGWSI Daemon per child process; set to 0 to disable connection pooling"},
   { NULL }
};
#endif


/*--------------------------------------------------------------------------*/
/*                                                                          */
/* Now the list of content handlers available from this module.             */
/*                                                                          */
/*--------------------------------------------------------------------------*/
/* 
 * List of content handlers our module supplies.  Each handler is defined by
 * two parts: a name by which it can be referenced (such as by
 * {Add,Set}Handler), and the actual routine name.  The list is terminated by
 * a NULL block, since it can be of variable length.
 *
 * Note that content-handlers are invoked on a most-specific to least-specific
 * basis; that is, a handler that is declared for "text/plain" will be
 * invoked before one that was declared for "text / *".  Note also that
 * if a content-handler returns anything except DECLINED, no other
 * content-handlers will be called.
 */

#if MGWSI_APACHE_VERSION < 20
static const handler_rec mgwsi_handlers[] = {
   { "mgwsi-handler",        mgwsi_handler },
   { MGWSI_MIME_TYPE1,      mgwsi_handler },
   { MGWSI_MIME_TYPE2,      mgwsi_handler },
   { NULL }
};
#endif


/*--------------------------------------------------------------------------*/
/*                                                                          */
/* Finally, the list of callback routines and data structures that          */
/* provide the hooks into our module from the other parts of the server.    */
/*                                                                          */
/*--------------------------------------------------------------------------*/
/* 
 * Module definition for configuration.  If a particular callback is not
 * needed, replace its routine name below with the word NULL.
 *
 * The number in brackets indicates the order in which the routine is called
 * during request processing.  Note that not all routines are necessarily
 * called (such as if a resource doesn't have access restrictions).
 */

#if MGWSI_APACHE_VERSION >= 20
module AP_MODULE_DECLARE_DATA m_apache_module = {

   STANDARD20_MODULE_STUFF,
   mgwsi_create_dir_config,        /* per-directory config creater */
   mgwsi_merge_dir_config,         /* dir config merger - default is to override */
   mgwsi_create_server_config,     /* server config creator */
   mgwsi_merge_server_config,      /* server config merger */
   mgwsi_commands,                 /* command table */
   mgwsi_register_hooks,           /* set up other request processing hooks */
};
#else
module m_apache_module = {
   STANDARD_MODULE_STUFF,
   mgwsi_init,                     /* module initializer */
   mgwsi_create_dir_config,        /* per-directory config creater */
   mgwsi_merge_dir_config,         /* dir config merger - default is to override */
   mgwsi_create_server_config,     /* server config creator */
   mgwsi_merge_server_config,      /* server config merger */
   mgwsi_commands,                 /* command table */
   mgwsi_handlers,                 /* [6] list of handlers */
   NULL,                         /* [1] filename-to-URI translation */

   NULL,
   NULL,
   NULL,                         /* [3] check access by host address, etc. */
   NULL,                         /* [6] MIME type checker/setter */
   NULL,                         /* [7] fixups */
   NULL,                         /* [9] logger */
   NULL,                         /* [2] header parser */
#if MGWSI_APACHE_VERSION == 13
   mgwsi_child_init,               /* process initializer */
   mgwsi_child_exit,               /* process exit/cleanup */
   NULL                          /* [1] post read_request handling */
#endif
};
#endif


/* Functions responsible for communicating with the server follow */

int mgwsi_check_file_type(MGWSIREQ *lp_request, char *type)
{
   int result;
   char buffer[32];

   if (strlen(type) > 9)
      return 0;

   strcpy(buffer, ".");
   strcat(buffer, type);
   strcat(buffer, ".");

   if (strstr(MGWSI_FILE_TYPES, buffer))
      result = 1;
   else if (lp_request->dconf && lp_request->dconf->mgwsi_file_types[0] && (strstr(lp_request->dconf->mgwsi_file_types, buffer) || strstr(lp_request->dconf->mgwsi_file_types, ".*.")))
      result = 2;
   else if (lp_request->sconf && lp_request->sconf->mgwsi_file_types[0] && (strstr(lp_request->sconf->mgwsi_file_types, buffer) || strstr(lp_request->dconf->mgwsi_file_types, ".*.")))
      result = 3;
   else
      result = 0;

   return result;
}


int mgwsi_get_configuration(MGWSIREQ *lp_request)
{
   int len, len1;
   char buffer[128], tcp_port[128];

   strcpy(lp_request->ip_address, MGWSI_SERVER);
   strcpy(lp_request->server, MGWSI_M_SERVER);
   strcpy(lp_request->fun, MGWSI_M_FUNCTION);
   strcpy(lp_request->ws_fun, MGWSI_M_WS_SERVER);
   lp_request->port = MGWSI_PORT;
   lp_request->base_port = MGWSI_PORT;
   strcpy(lp_request->uci, MGWSI_M_UCI);
   strcpy(lp_request->base_uci, MGWSI_M_UCI);

   lp_request->storage_mode = 0;

   len = 0;
   *tcp_port = '\0';
   *buffer = '\0';

   len = mgwsi_get_server_variable(lp_request, "MGWSI_DOWN_ERROR_PAGE", lp_request->lp_cgi_buffer);
   if (len > 0)
      strcpy(lp_request->error_redir, lp_request->lp_cgi_buffer->lp_buffer);
   else
      strcpy(lp_request->error_redir, "");

   len = mgwsi_get_server_variable(lp_request, "MGWSI_SERVER", lp_request->lp_cgi_buffer);
   if (len > 0)
      strcpy(lp_request->ip_address, lp_request->lp_cgi_buffer->lp_buffer);

   len = mgwsi_get_server_variable(lp_request, "MGWSI_M_SERVER", lp_request->lp_cgi_buffer);
   if (len > 0)
      strcpy(lp_request->server, lp_request->lp_cgi_buffer->lp_buffer);

   len = mgwsi_get_server_variable(lp_request, "MGWSI_M_FUNCTION", lp_request->lp_cgi_buffer);
   if (len > 0)
      strcpy(lp_request->fun, lp_request->lp_cgi_buffer->lp_buffer);

   len = mgwsi_get_server_variable(lp_request, "MGWSI_M_WS_SERVER", lp_request->lp_cgi_buffer);
   if (len > 0)
      strcpy(lp_request->ws_fun, lp_request->lp_cgi_buffer->lp_buffer);

   len = mgwsi_get_server_variable(lp_request, "MGWSI_M_UCI", lp_request->lp_cgi_buffer);
   if (len > 0) {
      strcpy(lp_request->uci, lp_request->lp_cgi_buffer->lp_buffer);
      strcpy(lp_request->base_uci, lp_request->lp_cgi_buffer->lp_buffer);
   }
   len = mgwsi_get_server_variable(lp_request, "MGWSI_M_STORAGE_MODE", lp_request->lp_cgi_buffer);
   if (len > 0)
      lp_request->storage_mode = (int) strtol(lp_request->lp_cgi_buffer->lp_buffer, NULL, 10);

   len = mgwsi_get_server_variable(lp_request, "MGWSI_PORT", lp_request->lp_cgi_buffer);
   if (len > 0) {
      len1 = (int) strtol(lp_request->lp_cgi_buffer->lp_buffer, NULL, 10);
      if (len1) {
         lp_request->port = len1;
         lp_request->base_port = len1;
      }
   }

   return 1;
}


int mgwsi_db_connect(MGWSIREQ *lp_request, short context)
{
   short iter, newcon, reuse, con_type;
   int n, h_db, h_db_free, retval, result;
   static struct sockaddr_in cli_addr, srv_addr;

   if (context == 1)
      goto mgwsi_db_connect_reconnect;

   retval = 0;

   strcpy(lp_request->error, "");

   con_type = MGWSI_CON_DUNNO;

   lp_request->lp_mgwsicon = NULL;
   lp_request->h_db = -1;
   h_db = -1;
   h_db_free = -1;
   newcon = 0;
   reuse = 0;

   if (mgwsi_maxcon > 0) {
#if MGWSI_USE_THREADS
      if (mgwsicon_lock)
         retval = apr_thread_mutex_lock(mgwsicon_lock);
#endif
      activity ++;

      for (n = 0; n < mgwsi_maxcon; n ++) {
         if (mgwsi_db_con[n]) {
            if (mgwsi_db_con[n]->base_port == lp_request->base_port && !strcmp(mgwsi_db_con[n]->ip_address, lp_request->ip_address) && !strcmp(mgwsi_db_con[n]->uci, lp_request->uci)) {
               con_type = mgwsi_db_con[n]->con_type;

               if (mgwsi_db_con[n]->status == MGWCON_STATUS_FREE) {

                  mgwsi_db_con[n]->status = MGWCON_STATUS_INUSE;
                  h_db = n;
                  reuse = 1;
                  break;
               }
            }
            if (mgwsi_db_con[n]->status == MGWCON_STATUS_FREE && mgwsi_db_con[n]->con_status == MGWCON_CONSTATUS_DSCON && h_db_free == -1) {
               h_db_free = n;
            }
         }
         else {
            if (h_db_free == -1) {
               h_db_free = n;
            }
         }
      }

      if (h_db != -1) { /* Reuse connection */
         lp_request->h_db = h_db;
         lp_request->lp_mgwsicon = mgwsi_db_con[h_db];
      }

      if (h_db_free != -1) { /* Create new connection in pool */
         if (!mgwsi_db_con[h_db_free]) {
            mgwsi_db_con[h_db_free] = (MGWSICON *) malloc(sizeof(MGWSICON));
         }
         if (mgwsi_db_con[h_db_free]) {
            mgwsi_db_con[h_db_free]->status = MGWCON_STATUS_INUSE;
            lp_request->h_db = h_db_free;
            lp_request->lp_mgwsicon = mgwsi_db_con[h_db_free];
            newcon = 1;
         }
      }

#if MGWSI_USE_THREADS
      if (mgwsicon_lock)
         retval = apr_thread_mutex_unlock(mgwsicon_lock);
#endif
   }
   else {
      activity ++;
   }

   if (!lp_request->lp_mgwsicon) { /* Create new connection for this request */
      lp_request->h_db = -1;
      lp_request->lp_mgwsicon = (MGWSICON *) malloc(sizeof(MGWSICON));
      newcon = 1;
   }

   if (!lp_request->lp_mgwsicon) { /* Unable to allocate memory */
      return 0;
   }

   if (newcon) {
      lp_request->lp_mgwsicon->status = MGWCON_STATUS_INUSE;
      lp_request->lp_mgwsicon->con_type = MGWSI_CON_DUNNO;
      lp_request->lp_mgwsicon->mpid[0] = '\0';
      lp_request->lp_mgwsicon->uci[0] = '\0';
      lp_request->lp_mgwsicon->base_uci[0] = '\0';
      lp_request->lp_mgwsicon->dbtype[0] = '\0';
      lp_request->lp_mgwsicon->version = 0;
      lp_request->lp_mgwsicon->child_port = 0;
      lp_request->lp_mgwsicon->activity = 0;
   }

   lp_request->lp_mgwsicon->activity ++;
   if (reuse && mgwsi_db_con[h_db]->con_status == MGWCON_CONSTATUS_CON) {
      return 2;
   }

   strcpy(lp_request->lp_mgwsicon->ip_address, lp_request->ip_address);
   lp_request->lp_mgwsicon->base_port = lp_request->base_port;
   lp_request->lp_mgwsicon->port = lp_request->port;
   strcpy(lp_request->lp_mgwsicon->base_uci, lp_request->base_uci);
   strcpy(lp_request->lp_mgwsicon->uci, lp_request->uci);

   lp_request->lp_mgwsicon->con_type = con_type;

mgwsi_db_connect_reconnect:


   for (iter = 0; iter < 2; iter ++) {
      result = mgwsi_db_connect_ex(lp_request);

      if (result)
         break;
      mgwsi_sleep(1000);
   }

   if (result && lp_request->lp_mgwsicon->con_type != MGWSI_CON_GATEWAY) {

      result = mgwsi_db_connect_init(lp_request);

      if (result == 1) {
         lp_request->lp_mgwsicon->con_type = MGWSI_CON_M;
      }
      else if (result == 2) {
         lp_request->lp_mgwsicon->con_type = MGWSI_CON_GATEWAY;
         result = 1;
      }

      if (result) {
         if (lp_request->lp_mgwsicon->con_type == MGWSI_CON_M && lp_request->lp_mgwsicon->child_port != 0) {

            /* Old non-concurrent server: get dedicated server TCP port and connect to it */

            mgwsi_db_disconnect_ex(lp_request);
            lp_request->lp_mgwsicon->port = lp_request->lp_mgwsicon->child_port;
            lp_request->port = lp_request->lp_mgwsicon->child_port;

            for (iter = 0; iter < 4; iter ++) {
               result = mgwsi_db_connect_ex(lp_request);

               if (result)
                  break;
               mgwsi_sleep((iter + 1) * 1000);
            }
            if (result) {
               result = mgwsi_db_connect_init(lp_request);
            }
            else {
               mgwsi_db_disconnect(lp_request, MGWCON_DSCON_HARD);
            }
         }
      }
      else {
         mgwsi_db_disconnect(lp_request, MGWCON_DSCON_HARD);
      }
   }

/*
   if (result)
      mgwsi_db_ayt(lp_request);
*/
   if (!result) {
      lp_request->lp_mgwsicon->status = MGWCON_STATUS_FREE;
   }

   return result;

}


int mgwsi_db_connect_ex(MGWSIREQ *lp_request)
{
   short ipv6, getaddrinfo_ok, connected;
   const int on = 1;
   int n, flag;
   static struct sockaddr_in cli_addr, srv_addr;

   getaddrinfo_ok = 0;
   connected = 0;

   lp_request->lp_mgwsicon->con_status = MGWCON_CONSTATUS_DSCON;

   mgwsi_load_net_library(0);
#ifdef _WIN32
   if (mgwsi_winsock.wsastartup != 0) {
      sprintf(lp_request->error, "Microsoft WSAStartup Failed (%d)", MGWSI_GET_LAST_ERROR);
      return 0;
   }
#endif

   ipv6 = mgwsi_winsock.ipv6;

#if defined(MGWSI_IPV6)
   if (ipv6) {
      short mode;
      struct addrinfo hints, *res;
      struct addrinfo *ai;
      char port_str[32];
	   int off = 0;
	   int ipv6_v6only = 27;

      res = NULL;
      sprintf(port_str, "%d", lp_request->port);
      connected = 0;

      for (mode = 0; mode < 3; mode ++) {

         if (res) {
            MGWSI_NET_FREEADDRINFO(res);
            res = NULL;
         }

         memset(&hints, 0, sizeof hints);
         hints.ai_family = AF_UNSPEC;
         hints.ai_socktype = SOCK_STREAM;
         if (mode == 0)
#ifdef MGWSI_VMS
            continue;
#else
            hints.ai_flags = AI_NUMERICHOST | AI_CANONNAME;
#endif
         else if (mode == 1)
            hints.ai_flags = AI_CANONNAME;
         else if (mode == 2) {
            hints.ai_flags = AI_CANONNAME;
            hints.ai_family = AF_INET6;
         }
         else
            break;

         n = MGWSI_NET_GETADDRINFO(lp_request->ip_address, port_str, &hints, &res);
         if (n != 0) {
            continue;
         }

         getaddrinfo_ok = 1;
         for (ai = res; ai != NULL; ai = ai->ai_next) {

	         if (ai->ai_family != AF_INET && ai->ai_family != AF_INET6) {
               continue;
            }
	         lp_request->lp_mgwsicon->sockfd = MGWSI_NET_SOCKET(ai->ai_family, ai->ai_socktype, ai->ai_protocol);
            n = MGWSI_NET_CONNECT(lp_request->lp_mgwsicon->sockfd, ai->ai_addr, (int) (ai->ai_addrlen));
            if (n < 0) {
               sprintf(lp_request->error, "Cannot Connect to the MGWSI Gateway (%s:%d): Error Code: %d", lp_request->lp_mgwsicon->ip_address, lp_request->lp_mgwsicon->port, MGWSI_GET_LAST_ERROR);
               mgwsi_db_disconnect_ex(lp_request);
               continue;
            }
            else {
               /* Disable Nagle Algorithm */
               flag = 1;
               MGWSI_NET_SETSOCKOPT(lp_request->lp_mgwsicon->sockfd, IPPROTO_TCP, TCP_NODELAY, (const char *) &flag, sizeof(int));

               connected = 1;
               break;
            }
         }
         if (connected)
            break;
      }
      if (res) {
         MGWSI_NET_FREEADDRINFO(res);
         res = NULL;
      }
   }
#endif

   if (ipv6) {
      if (connected) {

         lp_request->lp_mgwsicon->con_status = MGWCON_CONSTATUS_CON;

         return 1;
      }
      else {
#ifdef MGWSI_VMS
         if (getaddrinfo_ok) {
            sprintf(lp_request->error, "Cannot identify server: Error Code: %d", MGWSI_GET_LAST_ERROR);
            mgwsi_db_disconnect_ex(lp_request);
            return 0;
         }
         else {
            sprintf(lp_request->error, "m_apache: Cannot connect over IPv6 - will try to use the IPv4 stack instead (%s:%d): Error Code: %d", lp_request->ip_address, lp_request->port, MGWSI_GET_LAST_ERROR);
#if MGWSI_APACHE_VERSION >= 20
            ap_log_rerror(APLOG_MARK, APLOG_NOTICE, 0, lp_request->r, "%s", lp_request->error);
#endif
            strcpy(lp_request->error, "");
         }
#else
         if (getaddrinfo_ok) {
            sprintf(lp_request->error, "Cannot identify server: Error Code: %d", MGWSI_GET_LAST_ERROR);
            mgwsi_db_disconnect_ex(lp_request);
            return 0;
         }
         else {
            sprintf(lp_request->error, "m_apache: Cannot connect over IPv6 - will try to use the IPv4 stack instead (%s:%d): Error Code: %d", lp_request->ip_address, lp_request->port, MGWSI_GET_LAST_ERROR);
#if MGWSI_APACHE_VERSION >= 20
            ap_log_rerror(APLOG_MARK, APLOG_NOTICE, 0, lp_request->r, "%s", lp_request->error);
#endif
            strcpy(lp_request->error, "");
         }
#endif
      }
   }

   ipv6 = 0;

#if defined(MGWSI_UNIX) || defined(MGWSI_VMS)
   bzero((char *) &srv_addr, sizeof(srv_addr));
#endif

   srv_addr.sin_port = MGWSI_NET_HTONS((unsigned short) lp_request->port);
   srv_addr.sin_family = AF_INET;
   srv_addr.sin_addr.s_addr = MGWSI_NET_INET_ADDR(lp_request->ip_address);

   lp_request->lp_mgwsicon->sockfd = MGWSI_NET_SOCKET(AF_INET, SOCK_STREAM, 0);
   if (lp_request->lp_mgwsicon->sockfd < 0) {
      sprintf(lp_request->error, "Cannot open a stream-socket to the server (%d)", MGWSI_GET_LAST_ERROR);
      return 0;
   }

   /* Disable Nagle Algorithm */
   flag = 1;
   MGWSI_NET_SETSOCKOPT(lp_request->lp_mgwsicon->sockfd, IPPROTO_TCP, TCP_NODELAY, (const char *) &flag, sizeof(int));

#if defined(MGWSI_UNIX) || defined(MGWSI_VMS)
   bzero((char *) &cli_addr, sizeof(cli_addr));
#endif

   cli_addr.sin_family = AF_INET;
   cli_addr.sin_addr.s_addr = MGWSI_NET_HTONL(INADDR_ANY);
   cli_addr.sin_port = MGWSI_NET_HTONS(0);

   n = MGWSI_NET_BIND(lp_request->lp_mgwsicon->sockfd, (struct sockaddr *) &cli_addr, sizeof(cli_addr));
   if (n < 0) {
      sprintf(lp_request->error, "Cannot bind to local address for server access (%d)", MGWSI_GET_LAST_ERROR);
      mgwsi_db_disconnect_ex(lp_request);
      return 0;
   }

   n = MGWSI_NET_CONNECT(lp_request->lp_mgwsicon->sockfd, (struct sockaddr *) &srv_addr, sizeof(srv_addr));

   if (n < 0) {
      sprintf(lp_request->error, "Unable to connect to the server (%d)",  MGWSI_GET_LAST_ERROR);
      mgwsi_db_disconnect_ex(lp_request);
      return 0;
   }

   lp_request->lp_mgwsicon->con_status = MGWCON_CONSTATUS_CON;

   return 1;
}


int mgwsi_db_disconnect(MGWSIREQ *lp_request, short context)
{
   if (!lp_request->lp_mgwsicon)
      return -1;

   if (context == MGWCON_DSCON_SOFT && lp_request->h_db != -1) {
      lp_request->h_db = -1;
      lp_request->lp_mgwsicon->status = MGWCON_STATUS_FREE;

      return 1;

   }

   if (lp_request->lp_mgwsicon->con_type == MGWSI_CON_M && lp_request->lp_mgwsicon->child_port > 0) {
      int n;
      MGWSIBUF request;

      mgwsi_mem_init(&request, 256, 256);
      mgwsi_mem_cpy(&request, "^X^\n", 4);

      n = mgwsi_db_send(lp_request, &request, 0);

      mgwsi_mem_free(&request);

   }

   mgwsi_db_disconnect_ex(lp_request);

   if (lp_request->h_db == -1) {
      free((void *) lp_request->lp_mgwsicon);
      lp_request->lp_mgwsicon = NULL;
   }
   else {
      lp_request->h_db = -1;
      lp_request->lp_mgwsicon->con_status = MGWCON_CONSTATUS_DSCON;
      lp_request->lp_mgwsicon->status = MGWCON_STATUS_FREE;
      lp_request->lp_mgwsicon = NULL;
   }

   return 1;
}



int mgwsi_db_disconnect_ex(MGWSIREQ *lp_request)
{
#ifndef _WIN32
   int n;
   struct linger ling;
   ling.l_onoff = 1;
   ling.l_linger = 0;
#endif

   lp_request->lp_mgwsicon->activity = 0;

   if (lp_request->lp_mgwsicon->con_status == MGWCON_CONSTATUS_DSCON)
      return 0;

#ifdef _WIN32
   MGWSI_NET_CLOSESOCKET(lp_request->lp_mgwsicon->sockfd);
#else
   n = MGWSI_NET_SETSOCKOPT(lp_request->lp_mgwsicon->sockfd, SOL_SOCKET, SO_LINGER, (void *) &ling, sizeof(ling));
   close(lp_request->lp_mgwsicon->sockfd);
#endif

   lp_request->lp_mgwsicon->con_status = MGWCON_CONSTATUS_DSCON;

   return 1;
}



int mgwsi_db_send(MGWSIREQ *lp_request, LPMGWSIBUF lp_trans_buffer, int mode)
{
   int result, len;
   unsigned char esize[8];

   result = 1;
   *esize = '\0';

   lp_request->send_no ++;
   lp_request->lp_mgwsicon->eod = 0;
   lp_request->lp_mgwsicon->end_of_stream = 0;
   lp_request->lp_mgwsicon->t_mode = 0;
   lp_request->lp_mgwsicon->b_term_len = 0;
   lp_request->lp_mgwsicon->b_term_overlap_len = 0;

   if (mode) {
      len = mgwsi_encode_size(esize, lp_trans_buffer->data_size - lp_request->header_len, MGWSI_CHUNK_SIZE_BASE);
      strncpy(lp_trans_buffer->lp_buffer + (lp_request->header_len - 6) + (5 - len), esize, len);
   }

   result = mgwsi_db_send_ex(lp_request, (unsigned char *) lp_trans_buffer->lp_buffer, lp_trans_buffer->data_size, mode);

   return result;
}


int mgwsi_db_send_ex(MGWSIREQ *lp_request, unsigned char * data, int size, int mode)
{
   int result, n, n1, total;

   if (!lp_request->lp_mgwsicon)
      return -2;

   result = 0;
   total = 0;
   n1= 0;

   for (;;) {
      n = MGWSI_NET_SEND(lp_request->lp_mgwsicon->sockfd, data + total, size - total, 0);
      if (n < 0) {
         result = 0;
         break;
      }

      total += n;

      if (total == size)
         break;

      n1 ++;
      if (n1 > 100000)
         break;

   }
   return result;
}


int mgwsi_db_receive(MGWSIREQ *lp_request, LPMGWSIBUF lp_trans_buffer, int size, int mode)
{
   int result, n;
   unsigned long len, total, ssize;
   char s_buffer[16], stype[4];
   char *p;

   p = NULL;
   result = 0;
   ssize = 0;
   s_buffer[0] = '\0';
   lp_request->recv_no ++;
   lp_trans_buffer->lp_buffer[0] = '\0';
   lp_trans_buffer->data_size = 0;

   if (lp_request->lp_mgwsicon->eod) {
      return 0;
   }
   lp_request->lp_mgwsicon->eod = 0;

restart:

   if (lp_request->lp_mgwsicon->t_mode == 1) {

      if (lp_request->lp_mgwsicon->end_of_stream) {
         lp_request->lp_mgwsicon->eod = 1;
         return 0;
      }

      len = 0;
      total = size - 64;

      if (lp_request->lp_mgwsicon->b_term_overlap_len > 0) {
         memcpy((void *) lp_trans_buffer->lp_buffer, (void *) lp_request->lp_mgwsicon->b_term_overlap, lp_request->lp_mgwsicon->b_term_overlap_len);
         len = lp_request->lp_mgwsicon->b_term_overlap_len;
         lp_trans_buffer->data_size = len;
         lp_request->lp_mgwsicon->b_term_overlap_len = 0;
      }

      for (;;) {
         n = mgwsi_db_receive_ex(lp_request, lp_trans_buffer->lp_buffer + len, total - len, 1);
         if (n < 1) {
            lp_request->lp_mgwsicon->eod = 1;
            len = -1;
            break;
         }
         len += n;

         lp_trans_buffer->lp_buffer[len] = '\0';

         if (len > lp_request->lp_mgwsicon->b_term_len && !strncmp(lp_trans_buffer->lp_buffer + (len - lp_request->lp_mgwsicon->b_term_len), lp_request->lp_mgwsicon->b_term, lp_request->lp_mgwsicon->b_term_len)) {
            len -= lp_request->lp_mgwsicon->b_term_len;
            lp_request->lp_mgwsicon->end_of_stream = 1;
            break;
         }

         if (len >= total) {
            memcpy((void *) lp_request->lp_mgwsicon->b_term_overlap, lp_trans_buffer->lp_buffer + (total - lp_request->lp_mgwsicon->b_term_len), lp_request->lp_mgwsicon->b_term_len);
            lp_request->lp_mgwsicon->b_term_overlap[lp_request->lp_mgwsicon->b_term_len] = '\0';
            len -= lp_request->lp_mgwsicon->b_term_len;
            lp_request->lp_mgwsicon->b_term_overlap_len = lp_request->lp_mgwsicon->b_term_len;
            lp_trans_buffer->lp_buffer[len] = '\0';
            break;
         }

      }

      if (len >= 0)
         lp_trans_buffer->data_size = len;

      return len;
   }

   len = mgwsi_db_receive_ex(lp_request, s_buffer, MGWSI_RECV_HEAD, 0);
   if (len != MGWSI_RECV_HEAD) {
      lp_request->lp_mgwsicon->eod = 1;
      return -1;
   }


   if (!strncmp(s_buffer + 5, "sc", 2)) {
      for (n = 0; n < 8; n ++) {
         if (s_buffer[n] == '0')
            break;
         lp_request->lp_mgwsicon->b_term[n] = s_buffer[n];
         s_buffer[n] = '0';
      }
      lp_request->lp_mgwsicon->b_term[n] = '\0';
      lp_request->lp_mgwsicon->b_term_len = n;
      lp_request->lp_mgwsicon->b_term_overlap_len = 0;

      if (lp_request->lp_mgwsicon->b_term_len > 0) {
         lp_request->lp_mgwsicon->t_mode = 1;
         goto restart;
      }
   }

   ssize = mgwsi_decode_size(s_buffer, 5, MGWSI_CHUNK_SIZE_BASE);

   stype[0] = s_buffer[5];
   stype[1] = s_buffer[6];
   stype[2] = '\0';

   if (!strcmp(stype, "ce") || ssize > MGWSI_BUFSIZE) {
      lp_request->error_flag = 1;
      lp_request->lp_mgwsicon->eod = 1;
   }
   else if (!strcmp(stype, "cv")) {
      lp_request->lp_mgwsicon->eod = 1;
   }
   else if (strcmp(stype, "sc") || ssize > MGWSI_BUFSIZE) {
      lp_request->error_flag = 1;
      lp_request->lp_mgwsicon->eod = 1;
      return 0;
   }

   if (ssize == 0) {

      lp_request->lp_mgwsicon->eod = 1;
      return 0;
   }

   len = 0;
   total = ssize;

   n = mgwsi_db_receive_ex(lp_request, lp_trans_buffer->lp_buffer, total, 0);

   if (n < 0) {
      result = len;
      lp_request->lp_mgwsicon->eod = 1;
   }
   if (n < 1) {
      result = len;
      lp_request->lp_mgwsicon->eod = 1;
   }

   len += n;
   lp_trans_buffer->data_size += n;
   lp_trans_buffer->lp_buffer[len] = '\0';
   result = len;

   if (lp_request->error_flag) {
      strncpy(lp_request->error, lp_trans_buffer->lp_buffer, 250);
      lp_request->error[250] = '\0';
   }

   return result;
}


int mgwsi_db_receive_ex(MGWSIREQ *lp_request, unsigned char * data, int size, short mode)
{
   int n, len;

   if (mode) {
      len = MGWSI_NET_RECV(lp_request->lp_mgwsicon->sockfd, data, size, 0);
   }
   else {
      len = 0;
      for (;;) {
         
         n = MGWSI_NET_RECV(lp_request->lp_mgwsicon->sockfd, data + len, size - len, 0);
         
	 //smh - fix the bug of 100% cpu apache processes which don't die! 
     //This part of the routine does not check if the connection is broken
     //and then get out. I do that here. See below for broken conditions.
     //
	 //http://publib.boulder.ibm.com/infocenter/iseries/v5r3/index.jsp?topic=%2Fapis%2Frecv.htm
         
	 if (n == 0) {  //CONNECTION IS BROKEN!
	    //errno has the error code, but it isn't useful to check
            len = n;
	    break;
         }
	//end smh changes

         /* DLW - recv returns 0 for orderly shutdowns of remote sockets
          * need to break on that condition to prevent an infinite loop
            if (n < 0) {
         */

         if (n < 1) {
            len = n;
            break;
         }
         len += n;
         if (len >= size) {
            break;
         }
      }
   }

   if (len > 0)
      data[len] = '\0';

   return len;
}


int mgwsi_db_connect_init(MGWSIREQ *lp_request)
{
   int result = 0, n, len, buffer_actual_size, child_port;
   char buffer[512], buffer1[256];
   char *p, *p1;
   MGWSIBUF request;

   len = 0;

   lp_request->lp_mgwsicon->child_port = 0;

   mgwsi_mem_init(&request, 1024, 1024);

   sprintf(buffer, "^S^version=%s&timeout=%d&nls=%s&uci=%s\n", MGWSI_VERSION, 0, "", lp_request->base_uci);

   mgwsi_mem_cpy(&request, buffer, strlen(buffer));

   n = mgwsi_db_send(lp_request, &request, 0);

   strcpy(buffer, "");
   buffer_actual_size = 0;
   n = mgwsi_db_receive(lp_request, &request, 1024, 0);
   if (n > 0)
      buffer_actual_size += n;

   strcpy(buffer, request.lp_buffer);
   buffer[buffer_actual_size] = '\0';

      p = strstr(buffer, "pid=");
      if (!p) {
         return 2;
      }
      if (p) {
         result = 1;
         p +=4;
         p1 = strstr(p, "&");
         if (p1)
            *p1 = '\0';
         strcpy(lp_request->lp_mgwsicon->mpid, p);
         if (p1)
            *p1 = '&';
      }
      p = strstr(buffer, "uci=");
      if (p) {
         p +=4;
         p1 = strstr(p, "&");
         if (p1)
            *p1 = '\0';
         if (p1)
            *p1 = '&';
      }
      p = strstr(buffer, "server_type=");
      if (p) {
         p +=12;
         p1 = strstr(p, "&");
         if (p1)
            *p1 = '\0';
         strcpy(lp_request->lp_mgwsicon->dbtype, p);
         if (p1)
            *p1 = '&';
      }
      p = strstr(buffer, "version=");
      if (p) {
         p +=8;
         p1 = strstr(p, "&");
         if (p1)
            *p1 = '\0';
         strcpy(buffer1, p);
         if (p1)
            *p1 = '&';
         lp_request->lp_mgwsicon->version = (int) strtol(buffer1, NULL, 10);
      }
      p = strstr(buffer, "child_port=");
      if (p) {
         p +=11;
         p1 = strstr(p, "&");
         if (p1)
            *p1 = '\0';
         strcpy(buffer1, p);
         if (p1)
            *p1 = '&';
         child_port = (int) strtol(buffer1, NULL, 10);

         if (child_port == 1)
            child_port = 0;

         if (child_port) {
            lp_request->lp_mgwsicon->child_port = child_port;
            result = -120;
         }
      }

   return 1;
}


int mgwsi_db_ayt(MGWSIREQ *lp_request)
{
   int result, n, len, buffer_actual_size;
   char buffer[512];
   MGWSIBUF request;

   result = 0;
   len = 0;
   buffer_actual_size = 0;

   mgwsi_mem_init(&request, 1024, 1024);

   strcpy(buffer, "^A^A0123456789^^^^^\n");
   mgwsi_mem_cpy(&request, buffer, strlen(buffer));

   n = mgwsi_db_send(lp_request, &request, 0);

   strcpy(buffer, "");

   n = mgwsi_db_receive(lp_request, &request, 1024, 0);
   if (n > 0)
      buffer_actual_size += n;

   strcpy(buffer, request.lp_buffer);
   buffer[buffer_actual_size] = '\0';

   lp_request->send_no = 0;
   lp_request->recv_no = 0;

   if (buffer_actual_size > 0)
      result = 1;

   return result;
}


int mgwsi_send_response_header(MGWSIREQ *lp_request, char *header, short keepalive, short web_server_headers, short context)
{

#if MGWSI_APACHE_VERSION >= 20
   conn_rec *c;
   struct ap_filter_t *cur;
#endif

   if (keepalive)
      web_server_headers = 1;

   if (web_server_headers) {

      int n, status;
      double version;
      char *p, *p1, *p2, *p3;
      char pvers[32], stat[32], desc[32];

      version = 1.1;
      status = 200;
      strcpy(desc, "OK");

      for (p = header, n = 0;; n ++) {
         p1 = strstr(p, "\r\n");
         if (!p1)
            break;
         *p1 = '\0';
         if (!strlen(p))
            break;

         if (!n) {
            p2 = strstr(p, "/");
            p3 = strstr(p, " ");
            if (p3) {
               *p3 = '\0';
               strcpy(pvers, p2 + 1);
               version = (double) strtod(pvers, NULL);
               if (!version)
                  version = 1.1;
               *p3 = ' ';
               while (*p3 == ' ')
                  p3 ++;
               p2 = strstr(p3, " ");
               if (p2)
                  *p2 = '\0';
               strcpy(stat, p3);
               if (p2) {
                  *p2 = ' ';
                  while (*p2 == ' ')
                     p2 ++;
                  strcpy(desc, p2);
                  if (!strlen(desc))
                     strcpy(desc, "OK");
               }
               status = (int) strtol(stat, NULL, 10);
               if (!status)
                  status = 200;

               lp_request->r->status = status;
            }
         }
         else {
            p2 = strstr(p, ":");
            if (p2) {
               *p2 = '\0';
               p3 = p2 + 1;
               while (*p3 == ' ')
                  p3 ++;

               mgwsi_l_case(p);
               if (!strcmp(p, "content-type"))
                  lp_request->r->content_type = p3;
               else {
                  MGWSI_TABLE_SET(lp_request->r->headers_out, p, p3);
               }

               *p2 = ':';
            }
         }

         p = p1 + 2;
      }


#if MGWSI_APACHE_VERSION == 13
      ap_send_http_header(lp_request->r);
#endif


   }
   else {
      int status;
      char *p;

#if MGWSI_APACHE_VERSION >= 20
      c = lp_request->r->connection;
      cur = lp_request->r->proto_output_filters;
      while (cur && cur->frec->ftype < AP_FTYPE_CONNECTION) {
         cur = cur->next;
      }
      lp_request->r->output_filters = lp_request->r->proto_output_filters = cur;
#endif

      p = strstr(header, " ");
      if (p) {
         p += 1;
         status = strtol(p, NULL, 10);
         if (status) {
            lp_request->r->status = status;
         }
      }

      mgwsi_client_send(lp_request, header, strlen(header), 0);

   }

   return 1;

}


int mgwsi_system_function(MGWSIREQ *lp_request)
{
   int content_length, len;
   MGWSIBUF req, *lp_req;
   MGWSIBUF response, *lp_response;
   char header[MGWSI_BUFSIZE], fun[64], key[1024];
   char *p, *p1;

   lp_req = &req;
   lp_response = &response;

   *fun = '\0';
   *key = '\0';
   *header = '\0';

   mgwsi_mem_init(lp_req, 2046, 1024);
   mgwsi_mem_init(lp_response, 2046, 1024);

   mgwsi_mem_cpy(lp_req, "", 0);
   mgwsi_mem_cpy(lp_response, "", 0);

   mgwsi_get_server_variable(lp_request, "CONTENT_LENGTH", lp_req);
   content_length = (int) strtol(lp_req->lp_buffer, NULL, 10);
   mgwsi_get_server_variable(lp_request, "QUERY_STRING", lp_req);

   mgwsi_mem_cpy(lp_response, lp_req->lp_buffer, lp_req->data_size);
   mgwsi_u_case(lp_response->lp_buffer);

   p = strstr(lp_response->lp_buffer, "FUN=");
   if (p) {
      p += 4;
      p1 = strstr(p, "&");
      if (!p1)
         p1 = (lp_response->lp_buffer + lp_response->data_size);
      len = (int) (p1 - p);
      if (len > 60)
         len = 60;
      if (len)
         strncpy(fun, p, len);
      fun[len] = '\0';
      mgwsi_url_unescape(fun);
   }
   p = strstr(lp_response->lp_buffer, "KEY=");
   if (p) {
      p += 4;
      p1 = strstr(p, "&");
      if (!p1)
         p1 = (lp_response->lp_buffer + lp_response->data_size);
      len = (int) (p1 - p);
      if (len > 1000)
         len = 1000;
      p = (lp_req->lp_buffer + (p - lp_response->lp_buffer));
      if (len)
         strncpy(key, p, len);
      key[len] = '\0';
      mgwsi_url_unescape(key);
   }
   p = strstr(lp_response->lp_buffer, "DATA=");
   if (p) {
      p += 5;
      p1 = strstr(p, "&");
      if (!p1)
         p1 = (lp_response->lp_buffer + lp_response->data_size);
      len = (int) (p1 - p);
      if (len > 1000)
         len = 1000;
      p = (lp_req->lp_buffer + (p - lp_response->lp_buffer));
      if (len) {
         strncpy(header, p, len);
         header[len] = '\0';
         len = mgwsi_url_unescape(header);
         mgwsi_mem_cpy(lp_req, header, len);
      }
   }

   if (content_length) {

#if MGWSI_APACHE_VERSION >= 20 && !defined(MGWSI_VMS)
      int rlen, eod_found;
      const char * data;
      apr_size_t len;
      apr_bucket_brigade *bb = NULL;
      apr_status_t rv = 0;

      mgwsi_mem_cpy(lp_req, "", 0);
      rlen = 0;

      bb = apr_brigade_create(lp_request->r->pool, lp_request->r->connection->bucket_alloc);
      eod_found = 0;

      do {
         apr_bucket *bucket;

         rv = ap_get_brigade(lp_request->r->input_filters, bb, AP_MODE_READBYTES, APR_BLOCK_READ, HUGE_STRING_LEN);

         if (rv != APR_SUCCESS) {
            break;
         }

#if MGWSI_APACHE_VERSION >= 22
         for (bucket = APR_BRIGADE_FIRST(bb); bucket != APR_BRIGADE_SENTINEL(bb); bucket = APR_BUCKET_NEXT(bucket)) {
#else
         APR_BRIGADE_FOREACH(bucket, bb) {
#endif

            if (APR_BUCKET_IS_EOS(bucket)) {
               eod_found = 1;
               break;
            }
            if (APR_BUCKET_IS_FLUSH(bucket)) {
               continue;
            }
            apr_bucket_read(bucket, &data, &len, APR_BLOCK_READ);

            mgwsi_mem_cat(lp_req, (char *) data, len);
            rlen += len;

            if (rlen >= content_length) {
               eod_found = 1;
               break;
            }

         }
         apr_brigade_cleanup(bb);

      } while (!eod_found);

#else
      int rlen, eod_found;
      long read;
      char buffer[8192];

      mgwsi_mem_cpy(lp_req, "", 0);

      eod_found = 0;
      rlen = 0;

      if (MGWSI_SHOULD_CLIENT_BLOCK(lp_request->r)) {

         for (;;) {
            read = MGWSI_GET_CLIENT_BLOCK(lp_request->r, (char *) buffer, 8000);

            if (lp_request->req_chunked && read == 0) {
               eod_found = 1;
               break;
            }

            if (read < 0) {
               break;
            }

            rlen += read;
            mgwsi_mem_cat(lp_req, buffer, read);

            if (rlen >= content_length) {
               eod_found = 1;
               break;
            }
         }
      }
#endif
   }

   if (!strlen(fun)) {
      mgwsi_mem_cpy(lp_response, "no function", 11);
   }
#ifdef MGWSI_SSL
   else if (mgwsi_ssl.ssl && !strncmp(fun, "HMAC-SHA256", 11)) {

      short b64;
      int n;
      int key_len, msg_len, mac_len;
      unsigned char mac[MGWSI_BUFSIZE];
      char base64[MGWSI_BUFSIZE];

      if (strstr(fun, "B64"))
         b64 = 1;
      else
         b64 = 0;

      msg_len = lp_req->data_size;
      key_len = strlen(key);
      mac_len = 0;

      memset(mac, 0, MGWSI_BUFSIZE - 1);
      mgwsi_HMAC(mgwsi_EVP_sha256(), key, key_len, lp_req->lp_buffer, msg_len, mac, &mac_len);

      if (b64) {
         n = mgwsi_b64_encode((char *) mac, base64, mac_len, 0);
         base64[n] = '\0';
         mgwsi_mem_cpy(lp_response, (char *) base64, n);
         content_length = n;
      }
      else {
         mgwsi_mem_cpy(lp_response, (char *) mac, mac_len);
         content_length = mac_len;
      }
   }
   else if (mgwsi_ssl.ssl && !strncmp(fun, "HMAC-SHA1", 9)) {

      short b64;
      int n;
      int key_len, msg_len, mac_len;
      unsigned char mac[MGWSI_BUFSIZE];
      char base64[MGWSI_BUFSIZE];

      if (strstr(fun, "B64"))
         b64 = 1;
      else
         b64 = 0;

      msg_len = lp_req->data_size;
      key_len = strlen(key);
      mac_len = 0;

      memset(mac, 0, MGWSI_BUFSIZE - 1);
      mgwsi_HMAC(mgwsi_EVP_sha1(), key, key_len, lp_req->lp_buffer, msg_len, mac, &mac_len);

      if (b64) {
         n = mgwsi_b64_encode((char *) mac, base64, mac_len, 0);
         base64[n] = '\0';
         mgwsi_mem_cpy(lp_response, (char *) base64, n);
         content_length = n;
      }
      else {
         mgwsi_mem_cpy(lp_response, (char *) mac, mac_len);
         content_length = mac_len;
      }
   }
   else if (mgwsi_ssl.ssl && !strncmp(fun, "HMAC-SHA", 8)) {

      short b64;
      int n;
      int key_len, msg_len, mac_len;
      unsigned char mac[MGWSI_BUFSIZE];
      char base64[MGWSI_BUFSIZE];

      if (strstr(fun, "B64"))
         b64 = 1;
      else
         b64 = 0;

      msg_len = lp_req->data_size;
      key_len = strlen(key);
      mac_len = 0;

      memset(mac, 0, MGWSI_BUFSIZE - 1);
      mgwsi_HMAC(mgwsi_EVP_sha(), key, key_len, lp_req->lp_buffer, msg_len, mac, &mac_len);

      if (b64) {
         n = mgwsi_b64_encode((char *) mac, base64, mac_len, 0);
         base64[n] = '\0';
         mgwsi_mem_cpy(lp_response, (char *) base64, n);
         content_length = n;
      }
      else {
         mgwsi_mem_cpy(lp_response, (char *) mac, mac_len);
         content_length = mac_len;
      }
   }
   else if (mgwsi_ssl.ssl && !strncmp(fun, "HMAC-MD5", 8)) {

      short b64;
      int n;
      int key_len, msg_len, mac_len;
      unsigned char mac[MGWSI_BUFSIZE];
      char base64[MGWSI_BUFSIZE];

      if (strstr(fun, "B64"))
         b64 = 1;
      else
         b64 = 0;

      msg_len = lp_req->data_size;
      key_len = strlen(key);
      mac_len = 0;

      memset(mac, 0, MGWSI_BUFSIZE - 1);
      mgwsi_HMAC(mgwsi_EVP_md5(), key, key_len, lp_req->lp_buffer, msg_len, mac, &mac_len);

      if (b64) {
         n = mgwsi_b64_encode((char *) mac, base64, mac_len, 0);
         base64[n] = '\0';
         mgwsi_mem_cpy(lp_response, (char *) base64, n);
         content_length = n;
      }
      else {
         mgwsi_mem_cpy(lp_response, (char *) mac, mac_len);
         content_length = mac_len;
      }
   }
   else if (mgwsi_ssl.ssl && !strncmp(fun, "SHA256", 6)) {

      short b64;
      int n;
      size_t msg_len, mac_len;
      unsigned char mac[MGWSI_BUFSIZE];
      char base64[MGWSI_BUFSIZE];

      if (strstr(fun, "B64"))
         b64 = 1;
      else
         b64 = 0;

      msg_len = lp_req->data_size;
      mac_len = 0;

      memset(mac, 0, MGWSI_BUFSIZE - 1);
      mgwsi_SHA256((const unsigned char *) lp_req->lp_buffer, msg_len, mac);
      mac_len = strlen((char *) mac);


      if (b64) {
         n = mgwsi_b64_encode((char *) mac, base64, mac_len, 0);
         base64[n] = '\0';

         mgwsi_mem_cpy(lp_response, (char *) base64, n);
         content_length = n;
      }
      else {
         mgwsi_mem_cpy(lp_response, (char *) mac, mac_len);
         content_length = mac_len;
      }
   }
   else if (mgwsi_ssl.ssl && !strncmp(fun, "SHA1", 4)) {

      short b64;
      int n;
      size_t msg_len, mac_len;
      unsigned char mac[MGWSI_BUFSIZE];
      char base64[MGWSI_BUFSIZE];

      if (strstr(fun, "B64"))
         b64 = 1;
      else
         b64 = 0;

      msg_len = lp_req->data_size;
      mac_len = 0;

      memset(mac, 0, MGWSI_BUFSIZE - 1);
      mgwsi_SHA1((const unsigned char *) lp_req->lp_buffer, msg_len, mac);
      mac_len = strlen((char *) mac);

      if (b64) {
         n = mgwsi_b64_encode((char *) mac, base64, mac_len, 0);
         base64[n] = '\0';
         mgwsi_mem_cpy(lp_response, (char *) base64, n);
         content_length = n;
      }
      else {
         mgwsi_mem_cpy(lp_response, (char *) mac, mac_len);
         content_length = mac_len;
      }
   }
   else if (mgwsi_ssl.ssl && !strncmp(fun, "SHA", 3)) {

      short b64;
      int n;
      size_t msg_len, mac_len;
      unsigned char mac[MGWSI_BUFSIZE];
      char base64[MGWSI_BUFSIZE];

      if (strstr(fun, "B64"))
         b64 = 1;
      else
         b64 = 0;

      msg_len = lp_req->data_size;
      mac_len = 0;

      memset(mac, 0, MGWSI_BUFSIZE - 1);
      mgwsi_SHA((const unsigned char *) lp_req->lp_buffer, msg_len, mac);
      mac_len = strlen((char *) mac);

      if (b64) {
         n = mgwsi_b64_encode((char *) mac, base64, mac_len, 0);
         base64[n] = '\0';
         mgwsi_mem_cpy(lp_response, (char *) base64, n);
         content_length = n;
      }
      else {
         mgwsi_mem_cpy(lp_response, (char *) mac, mac_len);
         content_length = mac_len;
      }
   }
   else if (mgwsi_ssl.ssl && !strncmp(fun, "MD5", 3)) {

      short b64;
      int n;
      size_t msg_len, mac_len;
      unsigned char mac[MGWSI_BUFSIZE];
      char base64[MGWSI_BUFSIZE];

      if (strstr(fun, "B64"))
         b64 = 1;
      else
         b64 = 0;

      msg_len = lp_req->data_size;
      mac_len = 0;

      memset(mac, 0, MGWSI_BUFSIZE - 1);
      mgwsi_MD5((const unsigned char *) lp_req->lp_buffer, msg_len, mac);
      mac_len = strlen((char *) mac);

      if (b64) {
         n = mgwsi_b64_encode((char *) mac, base64, mac_len, 0);
         base64[n] = '\0';
         mgwsi_mem_cpy(lp_response, (char *) base64, n);
         content_length = n;
      }
      else {
         mgwsi_mem_cpy(lp_response, (char *) mac, mac_len);
         content_length = mac_len;
      }
   }
#endif /* #ifdef MGWSI_SSL */
   else if (!strncmp(fun, "B64", 3)) {

      int n;
      size_t msg_len;
      char base64[MGWSI_BUFSIZE];

      msg_len = lp_req->data_size;

      memset(base64, 0, MGWSI_BUFSIZE - 1);
      n = mgwsi_b64_encode((char *) lp_req->lp_buffer, base64, msg_len, 0);
      base64[n] = '\0';

      mgwsi_mem_cpy(lp_response, (char *) base64, n);
      content_length = n;

   }
   else if (!strncmp(fun, "D-B64", 5)) {

      int n;
      size_t msg_len;
      char d_base64[MGWSI_BUFSIZE];

      msg_len = lp_req->data_size;

      memset(d_base64, 0, MGWSI_BUFSIZE - 1);
      n = mgwsi_b64_decode((char *) lp_req->lp_buffer, d_base64, msg_len);
      d_base64[n] = '\0';

      mgwsi_mem_cpy(lp_response, (char *) d_base64, n);
      content_length = n;

   }
   else if (!strncmp(fun, "TIME", 4)) {

      int n;
      double time;
      char timestr[256];

      time = mgwsi_get_time(timestr);

      n = strlen(timestr);

      mgwsi_mem_cpy(lp_response, (char *) timestr, n);
      content_length = n;

   }
   else {
      mgwsi_mem_cpy(lp_response, "dunno", 5);
   }

   strcpy(header, "HTTP/1.1 200 OK\r\n");
   strcat(header, "Content-type: text/plain\r\n");
   sprintf(key, "Content-length: %d\r\n", lp_response->data_size);
   strcat(header, key);
   strcat(header, "Connection: close\r\n\r\n");

   mgwsi_send_response_header(lp_request, header, 0, 0, 0);

   mgwsi_client_send(lp_request, (void *) lp_response->lp_buffer, lp_response->data_size, 0);

   mgwsi_mem_free(lp_req);
   mgwsi_mem_free(lp_response);

   return 1;
}


int mgwsi_return_error(MGWSIREQ *lp_request, char *error)
{

   char buffer[4096];
   MGWSIBUF response, *lp_response;

   lp_response = &response;
   mgwsi_mem_init(lp_response, 2046, 1024);
   mgwsi_mem_cpy(lp_response, "", 0);

   if (lp_request && lp_request->soap) {

      strcpy(buffer, "HTTP/1.1 200 OK\r\n");
      strcat(buffer, "Content-type: text/xml\r\n");
      strcat(buffer, "Connection: close\r\n");
      strcat(buffer, "Expires: Thu, 29 Oct 1998 17:04:19 GMT\r\n");
      strcat(buffer, "Cache-Control: no-cache\r\n");
      strcat(buffer, "Pragma: no-cache\r\n");
      strcat(buffer, "\r\n");

      mgwsi_send_response_header(lp_request, buffer, 0, 0, 0);
 
      strcpy(buffer, "<?xml version='1.0' encoding='UTF-8' standalone='no' ?>\r\n");
      mgwsi_mem_cat(lp_response, buffer, 0);

      strcpy(buffer, "<SOAP-ENV:Envelope xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:s='http://www.w3.org/2001/XMLSchema' SOAP-ENV:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'>\r\n");
      mgwsi_mem_cat(lp_response, buffer, 0);

      mgwsi_mem_cat(lp_response, "<SOAP-ENV:Body>\r\n", 0);
      mgwsi_mem_cat(lp_response, "<SOAP-ENV:Fault>\r\n", 0);
      mgwsi_mem_cat(lp_response, "<faultcode>SOAP-ENV:Server</faultcode>\r\n", 0);

      strcpy(buffer, "<faultstring>m_apache error</faultstring>\r\n");
      mgwsi_mem_cat(lp_response, buffer, 0);

      mgwsi_mem_cat(lp_response, "<detail>\r\n", 0);
      mgwsi_mem_cat(lp_response, "<error xmlns='http://tempuri.org' >\r\n", 0);

      mgwsi_mem_cat(lp_response, "<special>\r\n", 0);
      mgwsi_mem_cat(lp_response, "Service Availability Error", 0);
      mgwsi_mem_cat(lp_response, "\r\n</special>\r\n", 0);

      mgwsi_mem_cat(lp_response, "<text>\r\n", 0);
      mgwsi_mem_cat(lp_response, error, 0);
      mgwsi_mem_cat(lp_response, "\r\n</text>\r\n", 0);

      mgwsi_mem_cat(lp_response, "</error>\r\n", 0);
      mgwsi_mem_cat(lp_response, "</detail>\r\n", 0);
      mgwsi_mem_cat(lp_response, "</SOAP-ENV:Fault>\r\n", 0);
      mgwsi_mem_cat(lp_response, "</SOAP-ENV:Body>\r\n", 0);
      mgwsi_mem_cat(lp_response, "</SOAP-ENV:Envelope>\r\n", 0);
   }
   else {
      strcpy(buffer, "HTTP/1.1 503 Service Unavailable\r\n");
      strcat(buffer, "Content-type: text/html\r\n");
      strcat(buffer, "Connection: close\r\n\r\n");

      mgwsi_send_response_header(lp_request, buffer, 0, 0, 0);

      mgwsi_mem_cat(lp_response, "<HTML>\r\n", 0);
      mgwsi_mem_cat(lp_response, "<HEAD><TITLE>Service Availability Error</TITLE></HEAD>\r\n", 0);
      mgwsi_mem_cat(lp_response, "<BODY>\r\n", 0);
      mgwsi_mem_cat(lp_response, "<H2>Service unavailable.</H2>\r\n", 0);
      mgwsi_mem_cat(lp_response, "<P>Please try again later.\r\n", 0);
      mgwsi_mem_cat(lp_response, "</BODY>\r\n", 0);
      mgwsi_mem_cat(lp_response, "</HTML>\r\n", 0);
   }

   mgwsi_client_send(lp_request, (void *) lp_response->lp_buffer, lp_response->data_size, 0);
   mgwsi_mem_free(lp_response);

   return 1;
}


int mgwsi_client_send(MGWSIREQ *lp_request, void *buffer, int size, short context)
{
   int written, flushed;

   if ((written = MGWSI_RWRITE(buffer, size, lp_request->r)) == EOF)
	   return 0;
   else
      flushed = MGWSI_RFLUSH(lp_request->r);

   return 1;

}


int mgwsi_server_variable(void *rec, const char *key, const char *value)
{
   short ok;
   int n;
   char *pvar;
   char buffer[128];
   MGWSISV * p_mgwsisv;
   MGWSIREQ *lp_request;
   LPMGWSIBUF lp_cgi_buffer, lp_trans_buffer, lp_temp_buffer;

   if (!rec || !key || !value)
      return 0;

   p_mgwsisv = (MGWSISV *) rec;
   lp_request = (MGWSIREQ *) p_mgwsisv->lp_req;

   if (p_mgwsisv->context == 0) {
      lp_trans_buffer = (LPMGWSIBUF) p_mgwsisv->lp_buf;
      lp_temp_buffer = (LPMGWSIBUF) p_mgwsisv->lp_ctx;
      if (strstr((char *) key, "CONTENT_TYPE") && strstr((char *) value, "/xml"))
         lp_request->soap = 1;
      if (strstr((char *) key, "HTTP_SOAPACTION"))
         lp_request->soap = 1;
      ok = 1;
      for (n = 0; n < MGWSI_MAX_CGIEX; n ++) {
         if (!strcmp(cgi_env_vars_ex[n], (char *) key)) {
            ok = 0;
            break;
         }

      }
      if (ok) {
         mgwsi_mem_cpy(lp_temp_buffer, "", 0);
         mgwsi_request_add(lp_request, lp_temp_buffer, (unsigned char *) key, strlen((char *) key), 0, MGWSI_TX_AKEY);
         mgwsi_request_add(lp_request, lp_temp_buffer, (unsigned char *) value, strlen((char *) value), 0, MGWSI_TX_DATA);
         mgwsi_request_add(lp_request, lp_trans_buffer, lp_temp_buffer->lp_buffer, lp_temp_buffer->data_size, 0, MGWSI_TX_AREC_FORMATTED);
      }
   }
   else if (p_mgwsisv->context == 1) {
      lp_cgi_buffer = (LPMGWSIBUF) p_mgwsisv->lp_buf;
      mgwsi_mem_cpy(lp_cgi_buffer, (char *) key, strlen(key));
      mgwsi_mem_cat(lp_cgi_buffer, "=", 1);
      mgwsi_mem_cat(lp_cgi_buffer, (char *) value, strlen(value));
      mgwsi_mem_cat(lp_cgi_buffer, "<BR>", 4);
   }
   else if (p_mgwsisv->context == 2) {
      lp_cgi_buffer = (LPMGWSIBUF) p_mgwsisv->lp_buf;
      pvar = (char *) p_mgwsisv->lp_ctx;

      strncpy(buffer, (char *) key, 120);
      buffer[120] = '\0';
      mgwsi_l_case((char *) buffer);

      if (!strcmp(pvar, buffer)) {
         p_mgwsisv->defined = 1;
         mgwsi_mem_cpy(lp_cgi_buffer, (char *) value, strlen(value));
      }
   }

   return 1;
}


int mgwsi_get_server_variable(MGWSIREQ *lp_request, char *VariableName, LPMGWSIBUF lp_cgi_buffer)
{
   int ok;
   table *e;
   char *result;
   const char *sent_pw;

   ok = 0;
   e = lp_request->r->subprocess_env;
   result = NULL;

   mgwsi_mem_cpy(lp_cgi_buffer, "", 0);

   if (!strcmp(VariableName, "ALL_ENV")) {
      MGWSISV mgwsisv;

      mgwsisv.context = 1;
      mgwsisv.lp_req = (void *) lp_request;
      mgwsisv.lp_buf = (void *) lp_cgi_buffer;

      MGWSI_TABLE_DO(mgwsi_server_variable, (void *) &mgwsisv, e, NULL);
      ok = 1;
   }

   else if (!strcmp(VariableName, "MGWSI_CLIENT_TYPE")) {
      mgwsi_mem_cpy(lp_cgi_buffer, MGWSI_CLIENT_TYPE, strlen(MGWSI_CLIENT_TYPE));
      ok = 1;
      return lp_cgi_buffer->data_size;
   }
   else if (!strcmp(VariableName, "MGWSI_CLIENT_BUILD")) {
      char buffer[32];

      sprintf(buffer, "%d", mgwsi_module_build);
      mgwsi_mem_cpy(lp_cgi_buffer, buffer, strlen(buffer));
      ok = 1;
      return lp_cgi_buffer->data_size;
   }
   else if (!strcmp(VariableName, "MGWSI_CON_ACTIVITY") || !strcmp(VariableName, "MGWSI_PROC_ACTIVITY")) {
      mgwsi_mem_cpy(lp_cgi_buffer, "0000000000", 10);
      ok = 1;
      return lp_cgi_buffer->data_size;
   }
   else if (!strcmp(VariableName, "MGWSI_CON_PORT")) {
      mgwsi_mem_cpy(lp_cgi_buffer, "0000", 4);
      ok = 1;
      return lp_cgi_buffer->data_size;
   }
   else if (!strcmp(VariableName, "MGWSI_CON_NO")) {
      mgwsi_mem_cpy(lp_cgi_buffer, "00000", 5);
      ok = 1;
      return lp_cgi_buffer->data_size;
   }
   else if (!strcmp(VariableName, "MGWSI_PROC")) {
      sprintf(lp_cgi_buffer->lp_buffer, "%lu", mgwsi_proc_id());
      lp_cgi_buffer->data_size = strlen(lp_cgi_buffer->lp_buffer);
      ok = 1;
      return lp_cgi_buffer->data_size;
   }

   if (!strcasecmp(VariableName, "UNMAPPED_REMOTE_USER")) {
      result = (char *) MGWSI_TABLE_GET(e, "REMOTE_USER");
      ok = 1;
   }
   else if (!strcasecmp(VariableName, "AUTH_PASSWORD")) {

      int res;

      if ((res = ap_get_basic_auth_pw(lp_request->r, &sent_pw)) == OK)
         result = (char *) sent_pw;
   }
   else if (!strcasecmp(VariableName, "HTTP_AUTHORIZATION")) {

      table *e_head;
      MGWSISV mgwsisv;

      e_head = lp_request->r->headers_in;
      mgwsisv.context = 2;
      mgwsisv.defined = 0;
      mgwsisv.lp_req = (void *) lp_request;
      mgwsisv.lp_buf = (void *) lp_cgi_buffer;
      mgwsisv.lp_ctx = (void *) "authorization";

      MGWSI_TABLE_DO(mgwsi_server_variable, (void *) &mgwsisv, e_head, NULL);
      if (mgwsisv.defined)
         ok = lp_cgi_buffer->data_size;
      else
         ok = -1;

      return ok;
   }
   else if (!strcasecmp(VariableName, "SERVER_PORT_SECURE")) {
      result = "0";
      ok = 1;
   }
   else if (!strcasecmp(VariableName, "URL") || !strcasecmp(VariableName, "SCRIPT_NAME")) {
	   result = lp_request->r->uri;
   }
   else if (!strcasecmp(VariableName, "PATH_TRANSLATED")) {

	   result = (char *) MGWSI_TABLE_GET(e, "DOCUMENT_ROOT");
      if (result) {
         mgwsi_mem_cpy(lp_cgi_buffer, result, strlen(result));
         if (lp_request->r->uri)
            mgwsi_mem_cat(lp_cgi_buffer, lp_request->r->uri, strlen(lp_request->r->uri));

         ok = 1;
         return lp_cgi_buffer->data_size;

      }
      else
   	   result = (char *) MGWSI_TABLE_GET(e, VariableName);

   }
   else {
	   result = (char *) MGWSI_TABLE_GET(e, VariableName);
   }

   if (result) {
      mgwsi_mem_cpy(lp_cgi_buffer, result, strlen(result));
      ok = 1;
   }
   else if (!strcasecmp(VariableName, "CONTENT_LENGTH")) {
      mgwsi_mem_cpy(lp_cgi_buffer, "0", 1);
      ok = 1;
   }


   if (ok)
      ok = (int) lp_cgi_buffer->data_size;
   else
      ok = -1;

   return ok;

}


int mgwsi_get_req_vars(MGWSIREQ *lp_request, LPMGWSIBUF lp_cgi_buffer)
{
   int result;
   char request_transfer_encoding[32], upgrade[32];

   result = 1;

   lp_request->con_len = 0;
   lp_request->req_chunked = 0;
   lp_request->websocket_upgrade = 0;
   request_transfer_encoding[0] = '\0';

   mgwsi_get_server_variable(lp_request, "CONTENT_LENGTH", lp_cgi_buffer);
   lp_request->con_len = strtol(lp_cgi_buffer->lp_buffer, NULL, 10);

   if (mgwsi_get_server_variable(lp_request, "CONTENT_TYPE", lp_cgi_buffer) < 128) {
      strncpy(lp_request->content_type, (char *) lp_cgi_buffer->lp_buffer, 250);
      lp_request->content_type[250] = '\0';
   }

   if (mgwsi_get_server_variable(lp_request, "HTTP_TRANSFER_ENCODING", lp_cgi_buffer) < 128) {
      strncpy(request_transfer_encoding, (char *) lp_cgi_buffer->lp_buffer, 31);
      request_transfer_encoding[31] = '\0';
   }

   if (mgwsi_get_server_variable(lp_request, "HTTP_UPGRADE", lp_cgi_buffer) < 128) {
      strncpy(upgrade, (char *) lp_cgi_buffer->lp_buffer, 30);
      upgrade[30] = '\0';
      mgwsi_l_case(upgrade);
      if (!strcmp(upgrade, "websocket")) {
         lp_request->websocket_upgrade = 1;
      }
   }

   if (*request_transfer_encoding) {
      mgwsi_l_case(request_transfer_encoding);
      if (strstr(request_transfer_encoding, "chunked")) {
         lp_request->req_chunked = 1;
      }
   }
   return result;
}



int mgwsi_mem_init(LPMGWSIBUF lp_mem_obj, int size, int increment_size)
{
   int result;

   lp_mem_obj->lp_buffer = (char *) malloc(sizeof(char) * (size + 1));
   if (lp_mem_obj->lp_buffer) {
      *(lp_mem_obj->lp_buffer) = '\0';
      result = 1;
   }
   else {
      result = 0;
      lp_mem_obj->lp_buffer = (char *) malloc(sizeof(char));
      if (lp_mem_obj->lp_buffer) {
         *(lp_mem_obj->lp_buffer) = '\0';
         size = 1;
      }
      else
         size = 0;
   }

   lp_mem_obj->size = size;
   lp_mem_obj->increment_size = increment_size;
   lp_mem_obj->data_size = 0;

   return result;
}


int mgwsi_mem_free(LPMGWSIBUF lp_mem_obj)
{
   if (lp_mem_obj->lp_buffer)
      free((void *) lp_mem_obj->lp_buffer);

   lp_mem_obj->lp_buffer = NULL;
   lp_mem_obj->size = 0;
   lp_mem_obj->increment_size = 0;
   lp_mem_obj->data_size = 0;

   return 1;
}



int mgwsi_mem_cpy(LPMGWSIBUF lp_mem_obj, char *buffer, unsigned long size)
{
   int result, req_size, csize, increment_size;

   result = 1;

   if (size == 0)
      size = strlen(buffer);

   if (size == 0) {
      lp_mem_obj->data_size = 0;
      lp_mem_obj->lp_buffer[lp_mem_obj->data_size] = '\0';
      return result;
   }

   req_size = size;
   if (req_size > lp_mem_obj->size) {
      csize = lp_mem_obj->size;
      increment_size = lp_mem_obj->increment_size;
      while (req_size > csize)
         csize = csize + lp_mem_obj->increment_size;
      mgwsi_mem_free(lp_mem_obj);
      result = mgwsi_mem_init(lp_mem_obj, size, increment_size);
   }
   if (result) {
      memcpy((void *) lp_mem_obj->lp_buffer, (void *) buffer, size);
      lp_mem_obj->data_size = req_size;
      lp_mem_obj->lp_buffer[lp_mem_obj->data_size] = '\0';
   }

   return result;
}


int mgwsi_mem_cat(LPMGWSIBUF lp_mem_obj, char *buffer, unsigned long size)
{
   int result, req_size, csize, tsize, increment_size;
   char *lp_temp;

   result = 1;

   if (size == 0)
      size = strlen(buffer);

   if (size == 0)
      return result;

   lp_temp = NULL;
   req_size = (size + lp_mem_obj->data_size);
   tsize = lp_mem_obj->data_size;
   if (req_size > lp_mem_obj->size) {
      csize = lp_mem_obj->size;
      increment_size = lp_mem_obj->increment_size;
      while (req_size > csize)
         csize = csize + lp_mem_obj->increment_size;
      lp_temp = lp_mem_obj->lp_buffer;
      result = mgwsi_mem_init(lp_mem_obj, csize, increment_size);
      if (result) {
         if (lp_temp) {
            memcpy((void *) lp_mem_obj->lp_buffer, (void *) lp_temp, tsize);
            lp_mem_obj->data_size = tsize;
            free((void *) lp_temp);
         }
      }
      else
         lp_mem_obj->lp_buffer = lp_temp;
   }
   if (result) {
      memcpy((void *) (lp_mem_obj->lp_buffer + tsize), (void *) buffer, size);
      lp_mem_obj->data_size = req_size;
      lp_mem_obj->lp_buffer[lp_mem_obj->data_size] = '\0';
   }

   return result;
}



int mgwsi_u_case(char *string)
{
#if defined(_WIN32) && defined(_UNICODE)
   CharUpper(string);
   return 1;
#else
   int n, chr;

   n = 0;
   while (string[n] != '\0') {
      chr = (int) string[n];
      if (chr >= 97 && chr <= 122)
         string[n] = (char) (chr - 32);
      n ++;
   }
   return 1;
#endif
}


int mgwsi_l_case(char *string)
{

#if defined(_WIN32) && defined(_UNICODE)
   CharLower(string);
   return 1;
#else

   int n, chr;

   n = 0;
   while (string[n] != '\0') {
      chr = (int) string[n];
      if (chr >= 65 && chr <= 90)
         string[n] = (char) (chr + 32);
      n ++;
   }
   return 1;
#endif

}


int mgwsi_sleep(unsigned long msecs)
{

#if defined(_WIN32)
   Sleep(msecs);
#else
   int secs;
   secs = msecs / 1000;
   if (secs == 0)
      secs = 1;
   sleep(secs);
#endif

   return 1;
}


int mgwsi_log_event(char *event, char *title)
{
   int n;
   FILE *fp = NULL;
   char timestr[64], heading[256];
   time_t now = 0;

   now = time(NULL);
   sprintf(timestr, "%s", ctime(&now));
   for (n = 0; timestr[n] != '\0'; n ++) {
      if ((unsigned int) timestr[n] < 32) {
         timestr[n] = '\0';
         break;
      }
   }

   sprintf(heading, ">>> Time: %s; Build: %d", timestr, mgwsi_module_build);

   fp = fopen(MGWSI_LOG_FILE, "a");
   if (fp) {

      fputs(heading, fp);
      fputs("\r\n    ", fp);
      fputs(title, fp);
      fputs("\r\n    ", fp);
      fputs(event, fp);
      fputs("\r\n    ", fp);

      fclose(fp);
   }

   return 1;

}


int mgwsi_log(MGWSIREQ *lp_request, char *buffer, int size)
{

   lp_request->fp = fopen(lp_request->file, "ab");
   if (lp_request->fp) {
      fputs(buffer,  lp_request->fp);
      fclose(lp_request->fp);
      lp_request->fp = NULL;
   }

   return 1;
}


int mgwsi_request_header(MGWSIREQ *lp_request, LPMGWSIBUF lp_trans_buffer, char *command)
{
   char buffer[256];

   sprintf(buffer, "PHPh^P^%s#%s#0###%s#%d^%s^00000\n", lp_request->server, lp_request->uci, MGWSI_VERSION, lp_request->storage_mode, command);
   lp_request->header_len = strlen(buffer);

   mgwsi_mem_cpy(lp_trans_buffer, buffer, strlen(buffer));

   return 1;
}


int mgwsi_parse_query_string(MGWSIREQ *lp_request, LPMGWSIBUF lp_trans_buffer, LPMGWSIBUF lp_temp_buffer, unsigned char *query_string, int size)
{
   short eod;
   unsigned char *p, *pe, *pz;
   unsigned char end;
   char buffer[256];

   end = *(query_string + size);

   *(query_string + size) = '\0';

   eod = 0;
   p = query_string;
   for (;;) {
      pe = strstr(p, "=");
      if (!pe)
         break;
      pz = strstr(p, "&");

      if (!pz) {
         pz = query_string + size;
         eod = 1;
      }

      *pz = '\0';
      *pe = '\0';
      pe ++;

      lp_request->element_no ++;
      sprintf(buffer, "%d", lp_request->element_no);

      mgwsi_mem_cpy(lp_temp_buffer, "", 0);
      mgwsi_request_add(lp_request, lp_temp_buffer, p, strlen(p), 0, MGWSI_TX_AKEY);
      mgwsi_request_add(lp_request, lp_temp_buffer, buffer, strlen(buffer), 0, MGWSI_TX_AKEY);
      mgwsi_request_add(lp_request, lp_temp_buffer, pe, strlen(pe), 0, MGWSI_TX_DATA);

      mgwsi_request_add(lp_request, lp_trans_buffer, lp_temp_buffer->lp_buffer, lp_temp_buffer->data_size, 0, MGWSI_TX_AREC_FORMATTED);

      if (eod)
         break;

      p = pz + 1;
   }

   *(query_string + size) = end;

   return 1;
}


int mgwsi_url_unescape(char *target)
{
   char *temp;
   char c1, c2;
   int len, k, j;

   len = strlen(target);
   temp = target;

   for (j = 0, k = 0; j < len; j ++, k ++) {
      switch(temp[j]) {
         case '+':
            target[k]=' ';
            break;
         case '%':
            c1 = tolower(temp[++j]);
            if (isdigit(c1)) {
               c1 -= '0';
            }
            else {
               c1 = c1 - 'a' + 10;
            }
            c2 = tolower(temp[++ j]);
            if (isdigit(c2)) {
               c2 -= '0';
            }
            else {
               c2 = c2 - 'a' + 10;
            }
            target[k] = c1 * 16 + c2;
            break;
         default:
            target[k] = temp[j];
            break;
      }
   }
   target[k] = '\0';

   return k;
}


int mgwsi_request_add(MGWSIREQ *lp_request, LPMGWSIBUF lp_trans_buffer, unsigned char *element, int size, short byref, short type)
{
   int hlen;
   unsigned char head[16];

   if (type == MGWSI_TX_AREC_FORMATTED) {
      mgwsi_mem_cat(lp_trans_buffer, element, size);
      return 1;
   }
   hlen = mgwsi_encode_item_header(head, size, byref, type);
   mgwsi_mem_cat(lp_trans_buffer, head, hlen);
   if (size)
      mgwsi_mem_cat(lp_trans_buffer, element, size);
   return 1;
}


int mgwsi_pow(int n10, int power)
{
#ifdef _WIN32
   return (int) pow((double) n10, (double) power);
#else
   int n, result;
   if (power == 0)
      return 1;
   result = 1;
   for (n = 1; n <= power; n ++)
      result = result * n10;
   return result;
#endif
}


int mgwsi_encode_size62(int n10)
{
   if (n10 >= 0 && n10 < 10)
      return (48 + n10);
   if (n10 >= 10 && n10 < 36)
      return (65 + (n10 - 10));
   if (n10 >= 36 && n10 < 62)
      return  (97 + (n10 - 36));

   return 0;
}


int mgwsi_decode_size62(int nxx)
{
   if (nxx >= 48 && nxx < 58)
      return (nxx - 48);
   if (nxx >= 65 && nxx < 91)
      return ((nxx - 65) + 10);
   if (nxx >= 97 && nxx < 123)
      return ((nxx - 97) + 36);

   return 0;
}


int mgwsi_encode_size(unsigned char *esize, int size, short base)
{
   if (base == 10) {
      sprintf(esize, "%d", size);
      return strlen(esize);
   }
   else {
      int n, n1, x;
      char buffer[32];

      n1 = 31;
      buffer[n1 --] = '\0';
      buffer[n1 --] = mgwsi_encode_size62(size % base);

      for (n = 1;; n ++) {
         x = (size / mgwsi_pow(base, n));
         if (!x)
            break;
         buffer[n1 --] = mgwsi_encode_size62(x % base);
      }
      n1 ++;
      strcpy((char *) esize, buffer + n1);
      return strlen(esize);
   }
}


int mgwsi_decode_size(unsigned char *esize, int len, short base)
{
   int size;
   unsigned char c;

   if (base == 10) {
      c = *(esize + len);
      *(esize + len) = '\0';
      size = (int) strtol(esize, NULL, 10);
      *(esize + len) = c;
   }
   else {
      int n, x;

      size = 0;
      for (n = len - 1; n >= 0; n --) {

         x = (int) esize[n];
         size = size + mgwsi_decode_size62(x) * mgwsi_pow(base, (len - (n + 1)));
      }
   }

   return size;
}


int mgwsi_encode_item_header(unsigned char * head, int size, short byref, short type)
{
   int slen, hlen;
   unsigned int code;
   unsigned char esize[16];

   slen = mgwsi_encode_size(esize, size, 10);

   code = slen + (type * 8) + (byref * 64);
   head[0] = (unsigned char) code;
   strncpy(head + 1, esize, slen);

   hlen = slen + 1;
   head[hlen] = '0';

   return hlen;
}


int mgwsi_decode_item_header(unsigned char * head, int * size, short * byref, short * type)
{
   int slen, hlen;
   unsigned int code;

   code = (unsigned int) head[0];

   *byref = code / 64;
   *type = (code % 64) / 8;
   slen = code % 8;

   *size = mgwsi_decode_size(head + 1, slen, 10);

   hlen = slen + 1;

   return hlen;
}


int mgwsi_encode_ws_header(unsigned char * head, int size, short type)
{
   int slen;
   unsigned char esize[16];

   sprintf((char *) head, "0000%d", type);
 
   slen = mgwsi_encode_size(esize, size, 62);

   strncpy((char *) (head + (4 - slen)), (char *) esize, slen);

   return 5;
}


int mgwsi_decode_ws_header(unsigned char * head, int * size, short * type)
{
   *type = (short) strtol((char *) (head + 4), NULL, 10);

   *size = mgwsi_decode_size(head, 4, 62);

   return 5;
}


unsigned long mgwsi_proc_id(void)
{
#ifdef _WIN32
   return (unsigned long) GetCurrentProcessId();
#else
   return (unsigned long) getpid();
#endif
}


double mgwsi_get_time(char * timestr)
{
   int tv_msec;
   double tms;
   time_t t_now, t;
   char *timeline, *p;
   char buffer[32];

#if !defined(_WIN32)

   int n;
   struct timeval tv; 

   n = gettimeofday(&tv, 0);

   t = tv.tv_sec % 86400; 
   tms = t + ((double) tv.tv_usec / 1000000);
   t_now = tv.tv_sec;
   tv_msec = tv.tv_usec / 1000;

#else

#ifdef _WIN32
   struct _timeb timebuffer;
#else
   struct timeb timebuffer;
#endif

#ifdef _WIN32
   _ftime(&timebuffer);
#else
   ftime(&timebuffer);
#endif

   t = timebuffer.time % 86400; 
   tms = t + ((double) timebuffer.millitm / 1000);
   t_now = timebuffer.time;
   tv_msec = timebuffer.millitm;

#endif

   if (timestr) {
      timeline = ctime(&t_now);
      p = strstr(timeline, ":");
      if (p) {
         p -= 2;
         strncpy(buffer, p, 8);
         buffer[8] = '\0';
         sprintf(timestr, "%s.%03d", buffer, tv_msec);
      }
   }

   return tms;

}


char mgwsi_b64_ntc(unsigned char n)
{
   if (n < 26)
      return 'A' + n;
   if (n < 52)
      return 'a' - 26 + n;

   if (n < 62)
      return '0' - 52 + n;
   if (n == 62)
      return '+';

   return '/';
}


unsigned char mgwsi_b64_ctn(char c)
{

   if (c == '/')
      return 63;
   if (c == '+')
      return 62;
   if ((c >= 'A') && (c <= 'Z'))
      return c - 'A';
   if ((c >= 'a') && (c <= 'z'))
      return c - 'a' + 26;
   if ((c >= '0') && (c <= '9'))
      return c - '0' + 52;
   if (c == '=')
      return 80;
   return 100;
}



int mgwsi_b64_encode(char *from, char *to, int length, int quads)
{
   int i = 0;
   char *tot = to;
   int qc = 0;
   unsigned char c;
   unsigned char d;

   while (i < length) {
      c = from[i];
      *to++ = (char) mgwsi_b64_ntc((unsigned char) (c / 4));
      c = c * 64;
     
      i++;

      if (i >= length) {
         *to++ = mgwsi_b64_ntc((unsigned char) (c / 4));
         *to++ = '=';
         *to++ = '=';
         break;
      }
      d = from[i];
      *to++ = mgwsi_b64_ntc((unsigned char) (c / 4 + d / 16));
      d = d * 16;

      i++;


      if (i >= length) {
         *to++ = mgwsi_b64_ntc((unsigned char) (d / 4));
         *to++ = '=';
         break;
      }
      c = from[i];
      *to++ = mgwsi_b64_ntc((unsigned char) (d / 4 + c / 64));
      c=c * 4;

      i++;

      *to++ = mgwsi_b64_ntc((unsigned char) (c / 4));

      qc ++;
      if (qc == quads) {
         *to++ = '\n';
         qc = 0;
      }
   }

   return ((int) (to - tot));
}


int mgwsi_b64_decode(char *from, char *to, int length)
{
   unsigned char c, d, e, f;
   char A, B, C;
   int i;
   int add;
   char *tot = to;

   for (i = 0; i + 3 < length;) {
      add = 0;
      A = B = C = 0;
      c = d = e = f = 100;

      while ((c == 100) && (i < length))
         c = mgwsi_b64_ctn(from[i++]);
      while ((d == 100) && (i < length))
         d = mgwsi_b64_ctn(from[i++]);
      while ((e == 100) && (i < length))
         e = mgwsi_b64_ctn(from[i++]);
      while ((f == 100) && (i < length))
         f = mgwsi_b64_ctn(from[i++]);

      if (f == 100)
         return -1;

      if (c < 64) {
         A += c * 4;
         if (d < 64) {
            A += d / 16;

            B += d * 16;

            if (e < 64) {
               B += e / 4;
               C += e * 64;

               if (f < 64) {
                  C += f;
                  to[2] = C;
                  add += 1;

               }
               to[1] = B;
               add += 1;

            }
            to[0] = A;
            add += 1;
         }
      }
      to += add;

      if (f == 80)
         return ((int) (to - tot));
   }
   return ((int) (to - tot));
}


int mgwsi_b64_enc_buffer_size(int l, int q)
{
   int ret;

   ret = (l / 3) * 4;
   if (l % 3 != 0)
      ret += 4;
   if (q != 0) {
      ret += (ret / (q * 4));

   }
   return ret;
}


int mgwsi_b64_strip_enc_buffer(char *buf, int length)
{
   int i;
   int ret = 0;

   for (i = 0;i < length;i ++)
      if (mgwsi_b64_ctn(buf[i]) != 100)
         buf[ret++] = buf[i];
 
   return ret;

}



#if defined(MGWSI_WEBSOCKETS)

int mgwsi_thread_create(LPMGWSITC lp_thread_control, MGWSI_THREAD_START_ROUTINE start_routine, void *arg)
{
   int result;

#if defined(_WIN32)
   int n;
   long hThread;
   DWORD CreationFlags, StackSize;
   LPSECURITY_ATTRIBUTES lpThreadAttributes;

   n = 0;
   result = 0;
   StackSize = 0;
   hThread = 0;

   lpThreadAttributes = NULL;
   CreationFlags = 0;

   lp_thread_control->hThread = CreateThread(lpThreadAttributes, StackSize, (MGWSI_THREAD_START_ROUTINE) start_routine, (void *) arg, CreationFlags, (LPDWORD) &(lp_thread_control->thread_id));
/*
   if (lp_thread_control->hThread) {
      result = 0;

      n = cspMutexLock(CoreData.lp_memlockTH, 0, NULL);

      for (n = 0; n < CoreData.max_connections; n ++) {
         if (!thread_handles[n]) {
            thread_handles[n] = lp_thread_control->hThread;
            break;
         }
      }

      cspMutexUnlock(CoreData.lp_memlockTH);

   }
   else
      result = -1;
*/

#else
   size_t StackSize, newStackSize;
   pthread_attr_t attr;

   StackSize = 0;
   newStackSize = 0;

   pthread_attr_init(&attr);

   pthread_attr_getstacksize(&attr, &StackSize);

   newStackSize = 0x40000; /* 262144 */

   pthread_attr_setstacksize(&attr, newStackSize);

   result = pthread_create(&(lp_thread_control->thread_id), &attr, (MGWSI_THREAD_START_ROUTINE) start_routine, (void *) arg);

   pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, NULL); /* CMT1052 */

#endif

   return result;

}



int mgwsi_thread_terminate(LPMGWSITC lp_thread_control)
{
   int result;

   result = 1;

#ifdef _WIN32
   if (lp_thread_control->hThread)
      TerminateThread(lp_thread_control->hThread, 0);
#else
   pthread_kill(lp_thread_control->thread_id, SIGINT);
#endif

   return result;

}



int mgwsi_thread_detach(void)
{
   int result;

   result = 1;

#if defined(_WIN32)
#else
   result = pthread_detach(pthread_self());
#endif

   return result;
}


int mgwsi_thread_join(LPMGWSITC lp_thread_control)
{
   int result;

   result = 1;

#if defined(_WIN32)
   result = (int) WaitForSingleObject(lp_thread_control->hThread, INFINITE);
#else
   result = pthread_join(lp_thread_control->thread_id, NULL);
#endif

   return result;
}


int mgwsi_thread_exit(void)
{
#if defined(_WIN32)
   ExitThread(0);
#else
   pthread_exit(NULL);
#endif

   return 1;
}

#endif /* #if defined(MGWSI_WEBSOCKETS) */


unsigned long mgwsi_get_current_tid(void)
{
#if defined(_WIN32)
   return ((unsigned long) GetCurrentThreadId());
#else
   return ((unsigned long) pthread_self());
#endif
}


unsigned long mgwsi_get_current_pid(void)
{
#if defined(_WIN32)
   return (unsigned long) GetCurrentProcessId();
#else
   return ((unsigned long) getpid());
#endif
}


int mgwsi_load_net_library(short context) 
{
#ifdef _WIN32
   int result, retval;
   WORD VersionRequested;
   char buffer[1024], path[32];

   result = 1;
   retval = 0;
   *buffer = '\0';
   *path = '\0';

#ifdef MGWSI_WINSOCK2

   if (mgwsi_winsock.load_attempted)
      return result;

#if MGWSI_USE_THREADS
   if (context == 0) {
      if (mgwsicon_lock)
         retval = apr_thread_mutex_lock(mgwsicon_lock);
   }
#endif

   if (mgwsi_winsock.load_attempted)
      goto mgwsi_load_net_library_exit;

   mgwsi_winsock.winsock_loaded = 0;

#if defined(MGWSI_IPV6)
   mgwsi_winsock.ipv6 = 1;
#else
   mgwsi_winsock.ipv6 = 0;
#endif

   /* Try to Load the Winsock 2 library */

   mgwsi_winsock.winsock = 2;
   strcpy(path, "WS2_32.DLL");
   mgwsi_winsock.h_winsock = LoadLibrary(path);
   if (!mgwsi_winsock.h_winsock) {
      mgwsi_winsock.winsock = 1;
      strcpy(path, "WSOCK32.DLL");
      mgwsi_winsock.h_winsock = LoadLibrary(path);
   }

   if (!mgwsi_winsock.h_winsock) {
#if MGWSI_APACHE_VERSION >= 20
      ap_log_error(APLOG_MARK, APLOG_NOTICE, 0, NULL, "m_apache: Initialization Error: Cannot load Winsock library");
#endif
      goto mgwsi_load_net_library_exit;
   }

   mgwsi_winsock.p_WSASocket             = (LPFN_WSASOCKET)              GetProcAddress(mgwsi_winsock.h_winsock, "WSASocketA");
   mgwsi_winsock.p_WSAGetLastError       = (LPFN_WSAGETLASTERROR)        GetProcAddress(mgwsi_winsock.h_winsock, "WSAGetLastError");
   mgwsi_winsock.p_WSAStartup            = (LPFN_WSASTARTUP)             GetProcAddress(mgwsi_winsock.h_winsock, "WSAStartup");
   mgwsi_winsock.p_WSACleanup            = (LPFN_WSACLEANUP)             GetProcAddress(mgwsi_winsock.h_winsock, "WSACleanup");
   mgwsi_winsock.p_WSAFDIsSet            = (LPFN_WSAFDISSET)             GetProcAddress(mgwsi_winsock.h_winsock, "__WSAFDIsSet");
   mgwsi_winsock.p_WSARecv               = (LPFN_WSARECV)                GetProcAddress(mgwsi_winsock.h_winsock, "WSARecv");
   mgwsi_winsock.p_WSASend               = (LPFN_WSASEND)                GetProcAddress(mgwsi_winsock.h_winsock, "WSASend");
   mgwsi_winsock.p_closesocket           = (LPFN_CLOSESOCKET)            GetProcAddress(mgwsi_winsock.h_winsock, "closesocket");
   mgwsi_winsock.p_gethostbyname         = (LPFN_GETHOSTBYNAME)          GetProcAddress(mgwsi_winsock.h_winsock, "gethostbyname");

#if defined(MGWSI_IPV6)
   mgwsi_winsock.p_getaddrinfo           = (LPFN_GETADDRINFO)            GetProcAddress(mgwsi_winsock.h_winsock, "getaddrinfo");
   mgwsi_winsock.p_freeaddrinfo          = (LPFN_FREEADDRINFO)           GetProcAddress(mgwsi_winsock.h_winsock, "freeaddrinfo");
#else
   mgwsi_winsock.p_getaddrinfo           = NULL;
   mgwsi_winsock.p_freeaddrinfo          = NULL;
#endif

   mgwsi_winsock.p_htons                 = (LPFN_HTONS)                  GetProcAddress(mgwsi_winsock.h_winsock, "htons");
   mgwsi_winsock.p_htonl                 = (LPFN_HTONL)                  GetProcAddress(mgwsi_winsock.h_winsock, "htonl");
   mgwsi_winsock.p_connect               = (LPFN_CONNECT)                GetProcAddress(mgwsi_winsock.h_winsock, "connect");
   mgwsi_winsock.p_inet_addr             = (LPFN_INET_ADDR)              GetProcAddress(mgwsi_winsock.h_winsock, "inet_addr");
   mgwsi_winsock.p_socket                = (LPFN_SOCKET)                 GetProcAddress(mgwsi_winsock.h_winsock, "socket");
   mgwsi_winsock.p_setsockopt            = (LPFN_SETSOCKOPT)             GetProcAddress(mgwsi_winsock.h_winsock, "setsockopt");
   mgwsi_winsock.p_getsockopt            = (LPFN_GETSOCKOPT)             GetProcAddress(mgwsi_winsock.h_winsock, "getsockopt");
   mgwsi_winsock.p_select                = (LPFN_SELECT)                 GetProcAddress(mgwsi_winsock.h_winsock, "select");
   mgwsi_winsock.p_recv                  = (LPFN_RECV)                   GetProcAddress(mgwsi_winsock.h_winsock, "recv");
   mgwsi_winsock.p_send                  = (LPFN_SEND)                   GetProcAddress(mgwsi_winsock.h_winsock, "send");
   mgwsi_winsock.p_shutdown              = (LPFN_SHUTDOWN)               GetProcAddress(mgwsi_winsock.h_winsock, "shutdown");
   mgwsi_winsock.p_bind                  = (LPFN_BIND)                   GetProcAddress(mgwsi_winsock.h_winsock, "bind");


   if (   (mgwsi_winsock.p_WSASocket              == NULL && mgwsi_winsock.winsock == 2)
       ||  mgwsi_winsock.p_WSAGetLastError        == NULL
       ||  mgwsi_winsock.p_WSAStartup             == NULL
       ||  mgwsi_winsock.p_WSACleanup             == NULL
       ||  mgwsi_winsock.p_WSAFDIsSet             == NULL
       || (mgwsi_winsock.p_WSARecv                == NULL && mgwsi_winsock.winsock == 2)
       || (mgwsi_winsock.p_WSASend                == NULL && mgwsi_winsock.winsock == 2)
       ||  mgwsi_winsock.p_closesocket            == NULL
       ||  mgwsi_winsock.p_gethostbyname          == NULL
       ||  mgwsi_winsock.p_htons                  == NULL
       ||  mgwsi_winsock.p_htonl                  == NULL
       ||  mgwsi_winsock.p_connect                == NULL
       ||  mgwsi_winsock.p_inet_addr              == NULL
       ||  mgwsi_winsock.p_socket                 == NULL
       ||  mgwsi_winsock.p_setsockopt             == NULL
       ||  mgwsi_winsock.p_getsockopt             == NULL
       ||  mgwsi_winsock.p_select                 == NULL
       ||  mgwsi_winsock.p_recv                   == NULL
       ||  mgwsi_winsock.p_send                   == NULL
       ||  mgwsi_winsock.p_shutdown               == NULL
       ||  mgwsi_winsock.p_bind                   == NULL
      ) {

      sprintf(buffer, "m_apache: Initialization Error: Cannot use Winsock library (WSASocket=%x; WSAGetLastError=%x; WSAStartup=%x; WSACleanup=%x; WSAFDIsSet=%x; WSARecv=%x; WSASend=%x; closesocket=%x; gethostbyname=%x; getaddrinfo=%x; freeaddrinfo=%x; htons=%x; htonl=%x; connect=%x; inet_addr=%x; socket=%x; setsockopt=%x; getsockopt=%x; select=%x; recv=%x; p_send=%x; shutdown=%x; bind=%x)",
            mgwsi_winsock.p_WSASocket,
            mgwsi_winsock.p_WSAGetLastError,
            mgwsi_winsock.p_WSAStartup,
            mgwsi_winsock.p_WSACleanup,
            mgwsi_winsock.p_WSAFDIsSet,
            mgwsi_winsock.p_WSARecv,
            mgwsi_winsock.p_WSASend,
            mgwsi_winsock.p_closesocket,
            mgwsi_winsock.p_gethostbyname,
            mgwsi_winsock.p_getaddrinfo,
            mgwsi_winsock.p_freeaddrinfo,
            mgwsi_winsock.p_htons,
            mgwsi_winsock.p_htonl,
            mgwsi_winsock.p_connect,
            mgwsi_winsock.p_inet_addr,
            mgwsi_winsock.p_socket,
            mgwsi_winsock.p_setsockopt,
            mgwsi_winsock.p_getsockopt,
            mgwsi_winsock.p_select,
            mgwsi_winsock.p_recv,
            mgwsi_winsock.p_send,
            mgwsi_winsock.p_shutdown,
            mgwsi_winsock.p_bind
            );
#if MGWSI_APACHE_VERSION >= 20
      ap_log_error(APLOG_MARK, APLOG_NOTICE, 0, NULL, buffer);
#endif
      FreeLibrary(mgwsi_winsock.h_winsock);
   }
   else {
      mgwsi_winsock.winsock_loaded = 1;
   }

   result = mgwsi_winsock.winsock_loaded;
   mgwsi_winsock.load_attempted = 1;
   mgwsi_winsock.wsastartup = -1;

   if (mgwsi_winsock.p_getaddrinfo == NULL ||  mgwsi_winsock.p_freeaddrinfo == NULL)
      mgwsi_winsock.ipv6 = 0;

mgwsi_load_net_library_exit:

#if MGWSI_USE_THREADS
   if (context == 0) {
      if (mgwsicon_lock)
         retval = apr_thread_mutex_unlock(mgwsicon_lock);
   }
#endif

   if (result) {

      if (mgwsi_winsock.winsock == 2)
         VersionRequested = MAKEWORD(2, 2);
      else
         VersionRequested = MAKEWORD(1, 1);

      mgwsi_winsock.wsastartup = MGWSI_NET_WSASTARTUP(VersionRequested, &(mgwsi_winsock.wsadata));
      if (mgwsi_winsock.wsastartup != 0 && mgwsi_winsock.winsock == 2) {
         VersionRequested = MAKEWORD(2, 0);
         mgwsi_winsock.wsastartup = MGWSI_NET_WSASTARTUP(VersionRequested, &(mgwsi_winsock.wsadata));
         if (mgwsi_winsock.wsastartup != 0) {
            mgwsi_winsock.winsock = 1;
            VersionRequested = MAKEWORD(1, 1);
            mgwsi_winsock.wsastartup = MGWSI_NET_WSASTARTUP(VersionRequested, &(mgwsi_winsock.wsadata));
         }
      }
      if (mgwsi_winsock.wsastartup == 0) {
         if ((mgwsi_winsock.winsock == 2 && LOBYTE(mgwsi_winsock.wsadata.wVersion) != 2)
               || (mgwsi_winsock.winsock == 1 && (LOBYTE(mgwsi_winsock.wsadata.wVersion) != 1 || HIBYTE(mgwsi_winsock.wsadata.wVersion) != 1))) {
  
            sprintf(buffer, "m_apache: Initialization Error: Wrong version of Winsock library (%d.%d)", path, LOBYTE(mgwsi_winsock.wsadata.wVersion), HIBYTE(mgwsi_winsock.wsadata.wVersion));
#if MGWSI_APACHE_VERSION >= 20
            ap_log_error(APLOG_MARK, APLOG_NOTICE, 0, NULL, buffer);
#endif
            MGWSI_NET_WSACLEANUP();
            mgwsi_winsock.wsastartup = -1;
         }
         else {
            if (strlen(path))
               sprintf(buffer, "m_apache: Initialization: Windows Sockets library loaded (%s) Version: %d.%d%s", path, LOBYTE(mgwsi_winsock.wsadata.wVersion), HIBYTE(mgwsi_winsock.wsadata.wVersion), mgwsi_winsock.ipv6 ? " (IPv6 Enabled)" : "");
            else
               sprintf(buffer, "m_apache: Initialization: Windows Sockets library Version: %d.%d%s", LOBYTE(mgwsi_winsock.wsadata.wVersion), HIBYTE(mgwsi_winsock.wsadata.wVersion), mgwsi_winsock.ipv6 ? " (IPv6 Enabled)" : "");

#if MGWSI_APACHE_VERSION >= 20
            ap_log_error(APLOG_MARK, APLOG_NOTICE, 0, NULL, buffer);
#endif
         }
      }
      else {
#if MGWSI_APACHE_VERSION >= 20
         ap_log_error(APLOG_MARK, APLOG_NOTICE, 0, NULL, "m_apache: Initialization Error: Unusable Winsock library");
#endif
      }
   }

#else

   if (mgwsi_winsock.winsock)
      return 1;

   mgwsi_winsock.ipv6 = 0;
   mgwsi_winsock.winsock = 1;
   mgwsi_winsock.wsastartup = -1;

   VersionRequested = MAKEWORD(1, 1);
   mgwsi_winsock.wsastartup = MGWSI_NET_WSASTARTUP(VersionRequested, &(mgwsi_winsock.wsadata));
   if (mgwsi_winsock.wsastartup == 0) {
      if (LOBYTE(mgwsi_winsock.wsadata.wVersion) != 1 || HIBYTE(mgwsi_winsock.wsadata.wVersion) != 1) {
         sprintf(buffer, "m_apache: Initialization Error: Wrong version of Winsock library (%d.%d)", path, LOBYTE(mgwsi_winsock.wsadata.wVersion), HIBYTE(mgwsi_winsock.wsadata.wVersion));
#if MGWSI_APACHE_VERSION >= 20
         ap_log_error(APLOG_MARK, APLOG_NOTICE, 0, NULL, buffer);
#endif
         MGWSI_NET_WSACLEANUP();
         mgwsi_winsock.wsastartup = -1;
      }
      else {
         sprintf(buffer, "m_apache: Initialization: Windows Sockets library Version: %d.%d", LOBYTE(mgwsi_winsock.wsadata.wVersion), HIBYTE(mgwsi_winsock.wsadata.wVersion));
#if MGWSI_APACHE_VERSION >= 20
         ap_log_error(APLOG_MARK, APLOG_NOTICE, 0, NULL, buffer);
#endif
      }
   }
   else {
#if MGWSI_APACHE_VERSION >= 20
      ap_log_error(APLOG_MARK, APLOG_NOTICE, 0, NULL, "m_apache: Initialization Error: Unusable Winsock library");
#endif
   }


#endif /* #ifdef MGWSI_WINSOCK2 */

#else

   if (mgwsi_winsock.load_attempted)
      return 1;
   mgwsi_winsock.load_attempted = 1;

#if defined(MGWSI_IPV6)
   mgwsi_winsock.ipv6 = 1;
#else
   mgwsi_winsock.ipv6 = 0;
#endif

#endif /* #ifdef _WIN32 */

   return 1;

}


int mgwsi_unload_net_library(short context)
{
#ifdef _WIN32
#ifdef MGWSI_WINSOCK2
   if (mgwsi_winsock.winsock_loaded) {
      if (mgwsi_winsock.wsastartup == 0)
         MGWSI_NET_WSACLEANUP();

      FreeLibrary(mgwsi_winsock.h_winsock);
   }
#else
   if (mgwsi_winsock.wsastartup == 0)
      MGWSI_NET_WSACLEANUP();
#endif
   mgwsi_winsock.wsastartup = -1;
#endif
   return 1;
}



int mgwsi_load_ssl_library(short context)
{
   int result, result1, result2, n;
   char buffer[256], path1[256], path2[256], message[256];

   result = 0;
   result1= 0;
   result2 = 0;

   n = 0;
   *path1 = '\0';
   *path2 = '\0';
   *message = '\0';
   *buffer = '\0';

#ifdef MGWSI_SSL

   mgwsi_ssl.ssl = 0;
   mgwsi_ssl.so_ssl.flags = 0;
   mgwsi_ssl.so_libeay.flags = 0;

#ifdef MGWSI_SSL_SO

   /* Try to Load the SSL libraries */

   mgwsi_ssl.ssl = 0;
   strcpy(buffer, "");

#ifdef _WIN32

   strcpy(path1, "ssleay32.dll");
   result1 = mgwsi_so_load(&(mgwsi_ssl.so_ssl), path1);

   strcpy(path2, "libeay32.dll");
   result2 = mgwsi_so_load(&(mgwsi_ssl.so_libeay), path2);


#else

   result1 = 0;

   strcpy(path1, "libssl.so");
   result1 = mgwsi_so_load(&(mgwsi_ssl.so_ssl), path1);
   if (!result1) {
      strcpy(path1, "libssl.sl");
      result1 = mgwsi_so_load(&(mgwsi_ssl.so_ssl), path1);
      if (!result1) {
         strcpy(path1, "libssl.dylib");
         result1 = mgwsi_so_load(&(mgwsi_ssl.so_ssl), path1);
      }
   }

   result2 = 0;

   strcpy(path2, "libcrypto.so");
   result2 = mgwsi_so_load(&(mgwsi_ssl.so_libeay), path2);
   if (!result2) {
      strcpy(path2, "libcrypto.sl");
      result2 = mgwsi_so_load(&(mgwsi_ssl.so_libeay), path2);
      if (!result2) {
         strcpy(path2, "libcrypto.dylib");
         result2 = mgwsi_so_load(&(mgwsi_ssl.so_libeay), path2);
      }
   }

#endif


   if (!result1) {
#ifdef _WIN32
      strcpy(message, "m_apache: Initialization: Information: The OpenSSL library (SSLEAY32) is not available on this system");
#else
      strcpy(message, "m_apache: Initialization: Information: The OpenSSL library (libssl) is not available on this system");
#endif
      goto ssl_init_end;
   }


   if (!result2) {
#ifdef _WIN32
      strcpy(message, "m_apache: Initialization: Information: The OpenSSL library (LIBEAY32) is not available on this system");
#else
      strcpy(message, "m_apache: Initialization: Information: The OpenSSL library (libcrypto) is not available on this system");
#endif
      goto ssl_init_end;
   }


   mgwsi_ssl.p_SSLeay_version = (LPFN_SSLEAY_VERSION) mgwsi_so_sym(&(mgwsi_ssl.so_libeay), "SSLeay_version");
   if (!mgwsi_ssl.p_SSLeay_version) {
      strcpy(buffer,  "SSLeay_version");
      goto ssl_init_end;
   }

   mgwsi_ssl.p_HMAC = (LPFN_HMAC) mgwsi_so_sym(&(mgwsi_ssl.so_libeay), "HMAC");
   if (!mgwsi_ssl.p_HMAC) {
      strcpy(buffer,  "HMAC");
      goto ssl_init_end;
   }

   mgwsi_ssl.p_EVP_sha256 = (LPFN_EVP_SHA256) mgwsi_so_sym(&(mgwsi_ssl.so_libeay), "EVP_sha256");
   if (!mgwsi_ssl.p_EVP_sha256) {
      strcpy(buffer,  "EVP_sha256");
      goto ssl_init_end;
   }

   mgwsi_ssl.p_EVP_sha1 = (LPFN_EVP_SHA1) mgwsi_so_sym(&(mgwsi_ssl.so_libeay), "EVP_sha1");
   if (!mgwsi_ssl.p_EVP_sha1) {
      strcpy(buffer,  "EVP_sha1");
      goto ssl_init_end;
   }

   mgwsi_ssl.p_EVP_sha = (LPFN_EVP_SHA) mgwsi_so_sym(&(mgwsi_ssl.so_libeay), "EVP_sha");
   if (!mgwsi_ssl.p_EVP_sha) {
      strcpy(buffer,  "EVP_sha");
      goto ssl_init_end;
   }

   mgwsi_ssl.p_EVP_md5 = (LPFN_EVP_MD5) mgwsi_so_sym(&(mgwsi_ssl.so_libeay), "EVP_md5");
   if (!mgwsi_ssl.p_EVP_md5) {
      strcpy(buffer,  "EVP_md5");
      goto ssl_init_end;
   }

   mgwsi_ssl.p_SHA256 = (LPFN_SHA1) mgwsi_so_sym(&(mgwsi_ssl.so_libeay), "SHA256");
   if (!mgwsi_ssl.p_SHA256) {
      strcpy(buffer,  "SHA256");
      goto ssl_init_end;
   }

   mgwsi_ssl.p_SHA1 = (LPFN_SHA1) mgwsi_so_sym(&(mgwsi_ssl.so_libeay), "SHA1");
   if (!mgwsi_ssl.p_SHA1) {
      strcpy(buffer,  "SHA1");
      goto ssl_init_end;
   }

   mgwsi_ssl.p_SHA = (LPFN_SHA) mgwsi_so_sym(&(mgwsi_ssl.so_libeay), "SHA");
   if (!mgwsi_ssl.p_SHA) {
      strcpy(buffer,  "SHA");
      goto ssl_init_end;
   }

   mgwsi_ssl.p_MD5 = (LPFN_MD5) mgwsi_so_sym(&(mgwsi_ssl.so_libeay), "MD5");
   if (!mgwsi_ssl.p_MD5) {
      strcpy(buffer,  "MD5");
      goto ssl_init_end;
   }

   result = 1;

ssl_init_end:

   if (result) {
      mgwsi_ssl.ssl = 1;

#ifdef _WIN32
      sprintf(message, "m_apache: Initialization: The OpenSSL libraries (%s and %s) are loaded - Version: %s", path1, path2, mgwsi_ssl.p_SSLeay_version(SSLEAY_VERSION));
#else
      sprintf(message, "m_apache: Initialization: The OpenSSL libraries (%s and %s) are loaded - Version: %s", path1, path2, mgwsi_ssl.p_SSLeay_version(SSLEAY_VERSION));
#endif

   }
   else {

      if (strlen(buffer)) {
#ifdef _WIN32
         sprintf(message, "m_apache: Initialization: Information: The OpenSSL libraries (%s and %s) found on this system are not usable - missing '%s' function", path1, path2, buffer);
#else
         sprintf(message, "m_apache: Initialization: Information: The OpenSSL libraries (%s and %s) found on this system are not usable - missing '%s' function", path1, path2, buffer);
#endif

      }

   }

#else

   mgwsi_ssl.ssl = 1;

#ifdef _WIN32
   sprintf(message, "m_apache: Initialization: The OpenSSL libraries (SSLEAY32 and LIBEAY32) are incorporated in this distribution - Version %s.", mgwsi_SSLeay_version(SSLEAY_VERSION));
#else
   sprintf(message, "m_apache: Initialization: The OpenSSL libraries (libssl and libcrypto) are incorporated in this distribution - Version %s.", mgwsi_SSLeay_version(SSLEAY_VERSION));
#endif

#endif /* #ifdef MGWSI_SSL_USE_DSO */

   mgwsi_ssl.load_attempted = 1;

   if (strlen(message)) {

#if MGWSI_APACHE_VERSION >= 20
      ap_log_error(APLOG_MARK, APLOG_NOTICE, 0, NULL, "%s", message);
#endif
   }

#endif /* #ifdef MGWSI_SSL */

   return 1;

}


int mgwsi_unload_ssl_library(short context)
{

#ifdef MGWSI_SSL
   mgwsi_so_unload(&(mgwsi_ssl.so_ssl));
   mgwsi_so_unload(&(mgwsi_ssl.so_libeay));
#endif

   return 1;
}


int mgwsi_so_load(MGWSISO *p_mgwsiso, char * library)
{

#if defined(_WIN32)
   p_mgwsiso->h_library = LoadLibrary(library);
#else
   p_mgwsiso->h_library = dlopen(library, RTLD_NOW);
#endif

   if (p_mgwsiso->h_library)
      return 1;
   else
      return 0;
}



MGWSIPROC mgwsi_so_sym(MGWSISO *p_mgwsiso, char * symbol)
{
   MGWSIPROC p_proc;

   p_proc = NULL;

#if defined(_WIN32)
   p_proc = GetProcAddress(p_mgwsiso->h_library, symbol);
#else
   p_proc  = (void *) dlsym(p_mgwsiso->h_library, symbol);
#endif

   return p_proc;
}



int mgwsi_so_unload(MGWSISO *p_mgwsiso)
{

#if defined(_WIN32)
   FreeLibrary(p_mgwsiso->h_library);
#else
   dlclose(p_mgwsiso->h_library); 
#endif

   return 1;
}



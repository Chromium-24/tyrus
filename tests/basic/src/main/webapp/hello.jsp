<%--

    DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.

    Copyright (c) 2011 - 2012 Oracle and/or its affiliates. All rights reserved.

    The contents of this file are subject to the terms of either the GNU
    General Public License Version 2 only ("GPL") or the Common Development
    and Distribution License("CDDL") (collectively, the "License").  You
    may not use this file except in compliance with the License.  You can
    obtain a copy of the License at
    http://glassfish.java.net/public/CDDL+GPL_1_1.html
    or packager/legal/LICENSE.txt.  See the License for the specific
    language governing permissions and limitations under the License.

    When distributing the software, include this License Header Notice in each
    file and include the License file at packager/legal/LICENSE.txt.

    GPL Classpath Exception:
    Oracle designates this particular file as subject to the "Classpath"
    exception as provided by Oracle in the GPL Version 2 section of the License
    file that accompanied this code.

    Modifications:
    If applicable, add the following below the License Header, with the fields
    enclosed by brackets [] replaced by your own identifying information:
    "Portions Copyright [year] [name of copyright owner]"

    Contributor(s):
    If you wish your version of this file to be governed by only the CDDL or
    only the GPL Version 2, indicate your decision by adding "[Contributor]
    elects to include this software in this distribution under the [CDDL or GPL
    Version 2] license."  If you don't indicate a single choice of license, a
    recipient has the option to distribute your version of this file under
    either the CDDL, the GPL Version 2 or to extend the choice of license to
    its licensees as provided above.  However, if you add GPL Version 2 code
    and therefore, elected the GPL Version 2 license, then the option applies
    only if the new code is made subject to such option by the copyright
    holder.

--%>
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
</head>

<body>
<meta charset="utf-8">
<title>Web Socket JavaScript Echo Client</title>
<script language="javascript" type="text/javascript">
    var websocket;

    function init() {
        output = document.getElementById("output");
    }

    function say_hello() {
        var url = 'ws://' + document.location.host + document.location.pathname + '../websockets/hello'
        websocket = new WebSocket(url);
        websocket.onopen = function (evt) {
            onOpen(true, evt)
        };
        websocket.onmessage = function (evt) {
            onMessage(evt)
        };
        websocket.onerror = function (evt) {
            onError(evt)
        };
    }

    function say_hello_binary() {
        var url = 'ws://' + document.location.host + document.location.pathname + '/../websockets/hellobyte'
        websocket = new WebSocket(url);
        websocket.onopen = function (evt) {
            onOpen(false, evt)
        };
        websocket.onmessage = function (evt) {
            onMessage(evt)
        };
        websocket.onerror = function (evt) {
            onError(evt)
        };
    }

    function onOpen(bool, evt) {
        writeToScreen("CONNECTED");
        if (bool) {
            writeToScreen("SENT: " + "hello");
            websocket.send("hello");
        } else {
            alert("hi");
            writeToScreen("SENT: " + "hello");
            var buf = new ArrayBuffer(16);
            var bytes = new Uint8Array(buf);
            for (var i = 0; i < bytes.length; i++) {
                bytes[i] = 0xFF;
            }
            websocket.send(buf);
        }

    }

    function onMessage(evt) {
        writeToScreen("RECEIVED: " + evt.data);
        websocket.close();
    }

    function onError(evt) {
        writeToScreen('<span style="color: red;">ERROR:</span> ' + evt.data);
    }

    function doSend(message) {

    }

    function writeToScreen(message) {
        var pre = document.createElement("p");
        pre.style.wordWrap = "break-word";
        pre.innerHTML = message;
        //alert(output);
        output.appendChild(pre);
    }

    window.addEventListener("load", init, false);

</script>

<h2 style="text-align: center;">Hello Test</h2>

<div style="text-align: center;">
    <form action="">
        <input onclick="say_hello()" value="Say Hello" type="button">
        <input onclick="say_hello_binary()" value="Say Hello Binary" type="button">
    </form>
</div>
<div id="output"></div>
</body>
</html>

/*
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 *
 * Copyright (c) 2012 Oracle and/or its affiliates. All rights reserved.
 *
 * The contents of this file are subject to the terms of either the GNU
 * General Public License Version 2 only ("GPL") or the Common Development
 * and Distribution License("CDDL") (collectively, the "License").  You
 * may not use this file except in compliance with the License.  You can
 * obtain a copy of the License at
 * http://glassfish.java.net/public/CDDL+GPL_1_1.html
 * or packager/legal/LICENSE.txt.  See the License for the specific
 * language governing permissions and limitations under the License.
 *
 * When distributing the software, include this License Header Notice in each
 * file and include the License file at packager/legal/LICENSE.txt.
 *
 * GPL Classpath Exception:
 * Oracle designates this particular file as subject to the "Classpath"
 * exception as provided by Oracle in the GPL Version 2 section of the License
 * file that accompanied this code.
 *
 * Modifications:
 * If applicable, add the following below the License Header, with the fields
 * enclosed by brackets [] replaced by your own identifying information:
 * "Portions Copyright [year] [name of copyright owner]"
 *
 * Contributor(s):
 * If you wish your version of this file to be governed by only the CDDL or
 * only the GPL Version 2, indicate your decision by adding "[Contributor]
 * elects to include this software in this distribution under the [CDDL or GPL
 * Version 2] license."  If you don't indicate a single choice of license, a
 * recipient has the option to distribute your version of this file under
 * either the CDDL, the GPL Version 2 or to extend the choice of license to
 * its licensees as provided above.  However, if you add GPL Version 2 code
 * and therefore, elected the GPL Version 2 license, then the option applies
 * only if the new code is made subject to such option by the copyright
 * holder.
 */
package org.glassfish.tyrus.test.e2e;

import java.io.*;
import java.io.OutputStream;
import java.nio.ByteBuffer;
import java.util.concurrent.CountDownLatch;
import javax.net.websocket.Endpoint;
import javax.net.websocket.MessageHandler;
import javax.net.websocket.Session;

/**
 * @author Danny Coward (danny.coward at oracle.com)
 */
public class BlockingBinaryClient extends Endpoint {
    boolean gotTheSameThingBack = false;
    private final CountDownLatch messageLatch;
    private Session session;
    static String MESSAGE_0 = "here ";
    static String MESSAGE_1 = "is ";
    static String MESSAGE_2 = "a ";
    static String MESSAGE_3 = "string ! ";

    public BlockingBinaryClient(CountDownLatch messageLatch) {
        this.messageLatch = messageLatch;
    }

    public void onOpen(Session session) {

        System.out.println("BLOCKINGBCLIENT opened !");

        this.session = session;

        session.addMessageHandler(new MessageHandler.BinaryStream() {
            StringBuilder sb = new StringBuilder();

            public void onMessage(InputStream is) {
                int i = 0;

                try {
                    while ( (i=is.read()) != -1 ) {
                        sb.append((char) i);
                    }

                } catch (IOException ioe) {
                    ioe.printStackTrace();
                }


                gotTheSameThingBack = sb.toString().equals(MESSAGE_0 + MESSAGE_1 + MESSAGE_2 + MESSAGE_3);
                System.out.println("BLOCKINGBCLIENT received whole message:" + sb.toString());
                sb = new StringBuilder();
                messageLatch.countDown();

            }
        });

        try {
            System.out.println("BLOCKINGBCLIENT Client sending data to the blocking output stream. ");
            OutputStream os = session.getRemote().getSendStream();

            os.write(MESSAGE_0.getBytes());
            os.write(MESSAGE_1.getBytes());
            os.write(MESSAGE_2.getBytes());
            os.write(MESSAGE_3.getBytes());
            os.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    private void sendPartial(String partialString, boolean isLast) throws IOException, InterruptedException {
        session.getRemote().sendPartialBytes(ByteBuffer.wrap(partialString.getBytes()), isLast);
    }
}
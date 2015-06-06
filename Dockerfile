# --------------------------------------------------------------
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# --------------------------------------------------------------

FROM udaraliyanage/base-image:4.1.0
MAINTAINER udara

ENV DEBIAN_FRONTEND noninteractive
ENV JDK_VERSION 1.7.0_51
ENV JDK_TAR_FILENAME jdk-7u51-linux-x64.tar.gz
ENV JAVA_HOME /opt/jdk${JDK_VERSION}
ENV WSO2_IS_VERSION 5.0.0
ENV CARBON_HOME /opt/wso2is-${WSO2_IS_VERSION}

# -------------------------------
# Add scripts, packages & plugins
# -------------------------------
ADD scripts/init.sh /usr/local/bin/init.sh
ADD scripts/export-envs.sh /tmp/export-envs.sh
ADD packages/${JDK_TAR_FILENAME} /opt/
ADD packages/wso2is-${WSO2_IS_VERSION}.zip /opt/
ADD packages/patches/ /opt/patches

# -----------------------------
# Install prerequisites and IS
# -----------------------------
WORKDIR /opt

RUN unzip /opt/wso2is-${WSO2_IS_VERSION}.zip -d /opt/ && \
    rm /opt/wso2is-${WSO2_IS_VERSION}.zip && \
    chmod +x /tmp/export-envs.sh && \
    sleep 1 && \
    /tmp/export-envs.sh ${JAVA_HOME} ${CARBON_HOME}

# ----------------------
# Expose container ports
# ----------------------

# IS https port
EXPOSE 9443

# -------------------------------
# Define entry point & start sshd
# -------------------------------

ENTRYPOINT /usr/local/bin/init.sh >> /tmp/init.sh.log | /usr/sbin/sshd -D

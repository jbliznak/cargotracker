#!/bin/bash

# Path to the standalone.xml file
STANDALONE_XML="/opt/server/standalone/configuration/standalone.xml"

# Function to add the jdbc-driver section
add_jdbc_driver() {
   sed -i "/<drivers>/a\\\t\t    <driver name=\"postgresql\" module=\"org.postgresql\"/>" "$STANDALONE_XML"
}

# Function to enable jms
add_messaging() {
  sed -e '/<subsystem xmlns=\"urn:jboss:domain:messaging-activemq:15.0\"\/>/{' -e 'r configuration/messaging.xml' -e 'd}' -i "$STANDALONE_XML"
  sed -i "s/<default-bindings/& jms-connection-factory=\"java:jboss\/DefaultJMSConnectionFactory\" /" "$STANDALONE_XML"
}

# update configuration
add_jdbc_driver
add_messaging

echo "standalone.xml updated"

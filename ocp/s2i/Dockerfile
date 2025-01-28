# Use EAP 8 Builder image to create a JBoss EAP 8 server
# with its default configuration

FROM registry.redhat.io/jboss-eap-8/eap8-openjdk17-builder-openshift-rhel8:latest AS builder

# Set up environment variables for provisioning. 
ENV GALLEON_PROVISION_FEATURE_PACKS org.jboss.eap:wildfly-ee-galleon-pack,org.jboss.eap.cloud:eap-cloud-galleon-pack
ENV GALLEON_PROVISION_LAYERS cloud-default-config
# Specify the JBoss EAP version  
ENV GALLEON_PROVISION_CHANNELS org.jboss.eap.channels:eap-8.0

# ENV MAVEN_MIRROR_URL <maven mirror URL if needed>

# Run the assemble script to provision the server.
RUN /usr/local/s2i/assemble

# Copy the JBoss EAP 8 server from the builder image to the runtime image.
FROM registry.redhat.io/jboss-eap-8/eap8-openjdk17-runtime-openshift-rhel8:latest AS runtime

# Set appropriate ownership and permissions.
COPY --from=builder --chown=jboss:root $JBOSS_HOME $JBOSS_HOME

# Steps to add:
# (1) COPY the WAR/EAR to $JBOSS_HOME/standalone/deployments
#       with the jboss:root user. For example:
#     COPY --chown=jboss:root my-app.war $JBOSS_HOME/standalone/deployments 
# (2) (optional) server modification. You can modify EAP server configuration:
#
#       * invoke management operations. For example
#
#        RUN $JBOSS_HOME/bin/jboss-cli.sh --commands="embed-server,/system-property=Foo:add(value=Bar)"
#
#        First operation must always be embed-server.
#
#       * copy a modified standalone.xml in $JBOSS_HOME/standalone/configuration/
#          for example
#
#      COPY --chown=jboss:root standalone.xml  $JBOSS_HOME/standalone/configuration

COPY --chown=jboss:root modules/ $JBOSS_HOME/modules/
COPY --chown=jboss:root deployments/*.war $JBOSS_HOME/standalone/deployments
# the following is not working
#COPY --chown=jboss:root configuration/standalone-openshift.xml $JBOSS_HOME/standalone/configuration/standalone.xml

COPY --chown=jboss:root configuration/ /home/jboss/configuration/
COPY --chown=jboss:root install.sh /home/jboss
RUN chmod +x /home/jboss/install.sh && /home/jboss/install.sh

# # Ensure appropriate permissions for the copied files.
RUN chmod -R ug+rwX $JBOSS_HOME

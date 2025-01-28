OpenShift Deployment
===============================================================================

## Create project

Create a new project

    oc new-project cargo-tracker-prj

> [!NOTE]
> If you use a different name, update accordingly the env viariable in `ocp/kustomization.yaml`

## Local Java build

    mvn clean package

## Remote Binary build

Build the image from war file in OCP:

    cp target/cargo-tracker.war ocp/s2i/deployments/
    oc new-build --strategy docker --binary --name=cargo-tracker
    oc start-build cargo-tracker --from-dir ocp/s2i/ --follow

Update the imagestream to retrive the image from the OpenShift local registry:

    oc patch imagestream cargo-tracker --type merge -p '{"spec":{"lookupPolicy":{"local":true}}}'

## Deploy the manifest

JGroups Discovery Mechanism need access to Kubernetes' REST API. 

The following command grants view role to default service account in the current project’s namespace:

    oc policy add-role-to-user view system:serviceaccount:$(oc project -q):default -n $(oc project -q)

Deploy resources:

    oc apply -k ocp

## Test the application

Open the application in your web browser

    open "http://$(oc get route cargo-tracker --template='{{ .spec.host }}')/cargo-tracker"

## Documentation References

[Datasource](https://docs.redhat.com/en/documentation/red_hat_jboss_enterprise_application_platform/8.0/html/using_jboss_eap_on_openshift_container_platform/assembly_reference-information-for-openshift-container-platform_default#ref_openshift-datasources_assembly_reference-information-for-openshift-container-platform)

[s2i_modules_drivers_deployments](https://docs.redhat.com/en/documentation/red_hat_jboss_enterprise_application_platform/7.4/html-single/getting_started_with_jboss_eap_for_openshift_container_platform/index?extIdCarryOver=true&intcmp=701f2000000tjyaAAA&sc_cid=RHCTE1240000433669#s2i_modules_drivers_deployments)

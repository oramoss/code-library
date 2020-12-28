# *********************************************************************************
#
# File:    ambari-stop-all-services.sh
# Purpose: stops all ambari services on the cluster via the REST interface
#
# **********************************************************************************

USER=admin
PASSWORD=admin
AMBARI_HOST=localhost
 
#detect name of cluster
output=`curl -s -u $USER:$PASSWORD -i -H 'X-Requested-By: ambari'  http://$AMBARI_HOST:8080/api/v1/clusters`
CLUSTER=`echo $output | sed -n 's/.*"cluster_name" : "\([^\"]*\)".*/\1/p'`
 
#stop all services
curl -u $USER:$PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d  '{"RequestInfo":{"context":"_PARSE_.STOP.ALL_SERVICES","operation_level":{"level":"CLUSTER","cluster_name":"Sandbox"}},"Body":{"ServiceInfo":{"state":"INSTALLED"}}}' http://$AMBARI_HOST:8080/api/v1/clusters/$CLUSTER/services

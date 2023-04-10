#!/bin/bash
###########script start two mechine apache and load balance between then usin nginx proxy pass
#### make  sure nginx mechine can 'ssh' apache mechines with need password
    ###ssh-copy-id <username>@<ip>
IP_NGINX=192.168.139.181
IP_WEB1=192.168.139.193
IP_WEB2=192.168.139.194
source ./function.sh


#####nginx
echo  -e -n " set hostname nginx for ${IP_NGINX}"
##hostname  "nginx" ${IP_NGINX}
echo   "done.."
echo  -e -n " install nginx for ${IP_NGINX}"
##install nginx ${IP_NGINX}
echo   "done.."
echo  -e -n " enable and start nginx for ${IP_NGINX}"
##enable_service nginx ${IP_NGINX}
echo   "done.."
echo  -e -n " add service nginx for firewall and open port 80 for ${IP_NGINX}"
##firewall http ${IP_NGINX}
echo   "done.."
#### set upstream
echo "add upstream at/etc/nginx/conf.d/backend.conf "
BACKEND=(${IP_WEB1} ${IP_WEB2})
UPSTREAM="upstream  backend { "
for IP in ${BACKEND[@]}
do
        UPSTREAM+="\n\tserver ${IP};"
done
UPSTREAM="${UPSTREAM}\n}"
##add_upstream ${IP_NGINX} "${UPSTREAM}" 
echo "done.."
#####add proxy pass
echo "add location section in configuration of nginx "
ssh root@${IP_NGINX} "sed -i 's/^[ ]*location \/ {/\/ { \n\t\tproxy_pass http:\/\/backend;/g' /etc/nginx/nginx.conf"
echo ".. done"
echo -e -n  "work selinux for nginx can load balance"
##selinux ${IP_NGINX}
echo "done..."
echo -e -n  "restart nginx" 
##restart_service nginx  ${IP_NGINX}
echo "done..."
#####apache mechine
BACKEND=(${IP_WEB1} ${IP_WEB2})
CO=1
for i in ${BACKEND[@]}
do
     echo -e -n " set hostname apache ${CO} for ${i}"
    ## hostname  "web${CO}" ${i}
     echo   "done.."
     echo  -e -n " install apache for ${i}"
   ## install httpd ${i}
      echo   "done.."
      echo  -e -n " enable and start apache for ${i}"
    ##  enable_service httpd ${i}
      echo   "done.."
      echo  -e -n " set page for apache ${i}"
      ##set_page ${CO} ${i}
      echo   "done.."
      echo  -e -n " add service apache for firewall and open port 80 for ${i}"
     ## firewall http ${i}
      echo   "done.."





     CO=$[CO+1]
done
exit 0

### change hostname 
function hostname 
{ HOST=${1}
  IP=${2}
  ssh root@${IP} "hostnamectl set-hostname ${HOST}"

}
###function install package
function install
{
  PACK=${1}
  IP=${2}
  ssh root@${IP} "yum -y install ${PACK} "

}
####function enable service 
function enable_service
{
  SER=${1}
  IP=${2}
  ssh root@${IP} "systemctl enable ${SER} "
  ssh root@${IP} "systemctl start ${SER} "
}
########function set page for each apache
function set_page
{
  CONTENT=${1}
  IP=${2}
  ssh root@${IP} "echo "this is page web${CONTENT}" > /var/www/html/index.html "

}
####work service in firewall
function firewall
{ 
  SER=${1}
  IP=${2}
  ssh root@${IP} "firewall-cmd --add-service=${SER} --permanent"
  ssh root@${IP} "firewall-cmd --add-port=80/tcp  --permanent"
  ssh root@${IP} "firewall-cmd --reload "
}
###work selinux
function selinux
{
  IP=${1}
  ssh root@${IP} "setsebool -P httpd_can_network_connect on"

}
function restart_service
{
  RES=${1}
  IP=${2}
  ssh root@${IP} "systemctl restart ${SER} "

}
function add_upstream
{
  IP=${1}
  UPSTREAM=${2}
  ssh root@${IP} "echo -e  \"${UPSTREAM}\" > /etc/nginx/conf.d/backend.conf "

}

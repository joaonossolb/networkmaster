#! /bin/bash
#Desenvolvedor: João Alexandre Nossol Balbino
#github.com/joaonossolb


echo -e " \033[01;31m_   _ _____ _______        _____  ____  _  __
| \ | | ____|_   _\ \      / / _ \|  _ \| |/ /
|  \| |  _|   | |  \ \ /\ / / | | | |_) | ' / 
| |\  | |___  | |   \ V  V /| |_| |  _ <| . \ 
|_| \_|_____| |_|    \_/\_/  \___/|_| \_\_|\_\
                                              
 __  __    _    ____ _____ _____ ____  
|  \/  |  / \  / ___|_   _| ____|  _ \ 
| |\/| | / _ \ \___ \ | | |  _| | |_) |
| |  | |/ ___ \ ___) || | | |___|  _ < 
|_|  |_/_/   \_\____/ |_| |_____|_| \_\
                                       
\033[00;37m"


i=1
if [ "$1" == "" ] #INCIO COD_0
then
	echo ""
	echo -e "\033[01;32m Network Master tem a funcionalidade de inserir um IP(interno) fixo configurando o arquivo localizado em /etc/network/interfaces \033[01;37m"
	echo ""
	echo -e "\033[01;31m Atenção: Para que o script funcione corretamente, o arquivo interfaces (/etc/network/interfaces) deve estar default, sem alterações na placa de rede que irá configurar, por questão de segurança, Network Master criar um backup do arquivo interfaces, localizado na mesma pasta em que o script é executado\033[01;37m"
	echo ""
	echo -e "\033[01;31m Desenvolvedor: João Alexandre Nossol Balbino\033[01;37m"
	echo -e "\033[01;31m github.com/joaonossolb\033[01;37m"

	echo ""
	echo -e "$0 OPC  --> Para ver os comandos de \033[01;31m Network Master \033[01;37m"
fi #FIM DO COD_0

if [ "$1" == "OPC" ] #INCIO COD_0
then
echo ""
	echo -e "\033[01;32m Network Master tem a funcionalidade de inserir um IP(interno) fixo configurando o arquivo localizado em /etc/network/interfaces \033[01;37m"
	echo ""
	echo -e "\033[01;31m Atenção: Para que o script funcione corretamente, o arquivo interfaces (/etc/network/interfaces) deve estar default, sem alterações na placa de rede que irá configurar, por questão de segurança, Network Master criar um backup do arquivo interfaces, localizado na mesma pasta em que o script é executado\033[01;37m"
	echo ""
	echo -e "\033[01;31m Desenvolvedor: João Alexandre Nossol Balbino\033[01;37m"
	echo -e "\033[01;31m github.com/joaonossolb\033[01;37m"

	echo ""
	echo -e "$0 OPC  --> Para ver os comandos de \033[01;31m Network Master \033[01;37m"



echo -e "\033[01;32m Realizando backup do arquivo interfaces \033[01;37m"
cp /etc/network/interfaces .
interfaces=$(ifconfig | cut -d ":" -f1 | grep -v "inet" | grep -v "ether" | grep -v "RX" | grep -v "TX" | grep -v "loop" | grep -v "lo" >> interfaces.tmp)

ip=$(ifconfig | grep "inet" | cut -d " " -f10 | head -n1)
gateway=$(route -n | cut -d " " -f10 | sed -n "3p")
  for interface in $(cat interfaces.tmp)
  do
        echo "$((i++)) $interface" >> interfaces1.tmp
  done
cat interfaces1.tmp
echo -e "\033[01;32m Digite a interface que deseja configurar o IP \033[01;37m"
read interfac

echo -e "Digite o IP que Deseja configurar, IP Atual: $ip"
read ip_config

interface_configurada=$(cat interfaces1.tmp | grep "$interfac" | cut -d " " -f2)
echo "" >> /etc/network/interfaces
echo "#Inicio da configuração realizada pelo script Network Master (github.com/joaonossolb/networkmaster)" >> /etc/network/interfaces
echo "auto $interface_configurada" >> /etc/network/interfaces
echo "iface $interface_configurada" inet static >> /etc/network/interfaces
echo "address $ip_config" >> /etc/network/interfaces
echo "gateway $gateway" >> /etc/network/interfaces
echo "#Fim da configuração realizada pelo script Network Master (github.com/joaonossolb/networkmaster)" >> /etc/network/interfaces
echo -e "\033[01;32m Deletando arquivos temporarios \033[01;37m"
rm  interfaces1.tmp
rm interfaces.tmp
echo -e "\033[01;32m Reiniciando o serviço network  \033[01;37m"
/etc/init.d/networking restart

echo ""
echo -e "\033[01;31m Atenção, se o IP não for configurado imediatamente, digite reboot -f no terminal para reiniciar o linux e ver os efeitos da configuração \033[01;37m"
fi

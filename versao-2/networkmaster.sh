#! /bin/bash
#Desenvolvedor: João Alexandre Nossol Balbino
#github.com/joaonossolb

topo(){
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


i=1 #Contador das interfaces de rede
	echo ""
	echo -e"\033[01;32m Network Master Versão 2 \033[01;37m"
	echo -e "\033[01;32m Network Master tem a funcionalidade de inserir um IP(interno) fixo configurando o arquivo localizado em /etc/network/interfaces \033[01;37m"
	echo ""
	echo -e "\033[01;31m Atenção: Para que o script funcione corretamente, o arquivo interfaces (/etc/network/interfaces) deve estar default, sem alterações na placa de rede que irá configurar, por questão de segurança, Network Master criar um backup do arquivo interfaces, localizado na mesma pasta em que o script é executado\033[01;37m"
	echo ""
	echo -e "\033[01;31m Desenvolvedor: João Alexandre Nossol Balbino\033[01;37m"
	echo -e "\033[01;31m github.com/joaonossolb\033[01;37m"

	echo ""
	echo -e "$0 OPC  --> Para ver os comandos de \033[01;31m Network Master \033[01;37m"
} #FIM DO TOPO(){
		mensagem1(){
		echo -e "\033[01;32m Digite a interface que deseja configurar o IP \033[01;37m"
		read interfac
		if [ -z "$interfac" ];then mensagem1; fi
		}
		mensagem2(){
		echo -e "\033[01;32m Digite o IP que Deseja configurar, IP Atual: $ip \033[01;37m"
		read ip_config
		if [ -z "$ip_config" ];then mensagem2; fi
		}

mensagem(){
if [ ! -d "/tmp" ];then echo "Você não tem a pasta /tmp"
else
echo -e "\033[01;32m Realizando backup do arquivo /etc/network/interfaces \033[01;37m"
cp /etc/network/interfaces ./interfaces.bkp

interfaces=$(ifconfig | cut -d ":" -f1 | grep -v "inet" | grep -v "ether" | grep -v "RX" | grep -v "TX" | grep -v "loop" | grep -v "lo" > /tmp/interfaces.tmp)

ip=$(ifconfig | grep "inet" | cut -d " " -f10 | head -n1)
gateway=$(route -n | cut -d " " -f10 | sed -n "3p")
  for interface in $(cat /tmp/interfaces.tmp)
  do
        echo -e "\033[01;32m	$((i++)) $interface \033[01;37m" >> /tmp/interfaces1.tmp
  done
cat /tmp/interfaces1.tmp
		mensagem1
		mensagem2
interface_configurada=$(cat /tmp/interfaces1.tmp | grep "$interfac" | cut -d " " -f2)
fi # fim do if [ ! -d "/tmp" ];then echo "Você não tem a pasta /tmp"
}
execution(){
topo
if [ "$1" == "OPC" ] #INCIO COD_0
then

mensagem

echo "" >> /etc/network/interfaces
echo "#Inicio da configuração realizada pelo script Network Master (github.com/joaonossolb/networkmaster)" >> /etc/network/interfaces
echo "auto $interface_configurada" >> /etc/network/interfaces
echo "iface $interface_configurada" inet static >> /etc/network/interfaces
echo "address $ip_config" >> /etc/network/interfaces
echo "gateway $gateway" >> /etc/network/interfaces
echo "#Fim da configuração realizada pelo script Network Master (github.com/joaonossolb/networkmaster)" >> /etc/network/interfaces
echo -e "\033[01;32m Deletando arquivos temporarios ..................\033[01;37m"
rm /tmp/interfaces.tmp -rf
rm /tmp/interfaces1.tmp -rf
echo -e "\033[01;32m Reiniciando o serviço networking  \033[01;37m"
/etc/init.d/networking stop
/etc/init.d/networking start

if [ "$?" == 1 ];then
echo -e "\033[01;31m O networking não foi reiniciado :( \033[01;37m"
fi
echo ""
fi

}

root(){
if [ "$USER" == "root" ];then 
execution $1
else
topo
echo "### Precisa ser root para executar o script ###"
fi
}
root $1

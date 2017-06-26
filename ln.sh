#!/bin/bash
echo "Script para rodar no SO Debian/Ubuntu"


#echo "Checando se o Git está instalado"
#eh case sensitive. A string, no caso "git", com o nome do pacote tem que ser toda em letra minuscula.
#e eh preciso ficar atento aos espacos dos colchetes
pacote=$(dpkg --get-selections | grep "git")
if [ -n "$pacote" ];
	then
		echo "O Git já está instalado"

	else
		echo "Instalando o Git"
		sudo apt-get install git
fi

#echo "Checando se a pasta TEST já foi criada"
if [ ! -d TEST ];
	then
		mkdir TEST
	else
		rm -rf TEST
		mkdir TEST
fi

#echo "Checando se a pasta UAT já foi criada"
if [ ! -d UAT ];
	then
		mkdir UAT
	else
		rm -rf UAT
		mkdir UAT
fi

#echo "Checando se a pasta PRODUCTION já foi criada"
if [ ! -d PRODUCTION ];
	then
		mkdir PRODUCTION
	else
		rm -rf PRODUCTION
		mkdir PRODUCTION
fi

#echo "Checando se a pasta DEV já foi criada"
if [ ! -d DEV ];
	then
		#echo "Fazendo um git clone e criando a pasta DEV"
		git clone https://github.com/jfsc/spring-petclinic.git DEV
	else
		#echo "Apagando a pasta e recriando a pasta já fazendo um git clone"
		rm -rf DEV
		git clone https://github.com/jfsc/spring-petclinic.git DEV
fi

pacote=$(dpkg --get-selections | grep "maven")
#echo "Atualizando os pacotes do linux"
sudo apt-get update 
#echo "Instalando o JRE"
sudo apt-get install default-jre
#echo "Instalando o JDK"
sudo apt-get install default-jdk

#echo "Setando o java_home"
#coloquei o caminho entre parenteses e com o $ ao inicio
JAVA_HOME=$(/usr/lib/jvm/default-java/bin)
export JAVA_HOME
PATH=$PATH:$JAVA_HOME
echo $JAVA_HOME

#echo "Checando se o maven está instalado"
if [ -n "$pacote" ];
	then
		echo "O Maven já está instalado"
	else
		echo "Instalando o Maven"
		sudo apt-get install maven
fi

#echo "Checando se o junit está instalado"
pacote=$(dpkg --get-selections | grep "junit")
if [ -n "$pacote" ];
	then
		echo "O JUnit já está instalado"
	else
		echo "Instalando o Junit"
		sudo apt-get install junit
fi

#echo "Indo para a pasta DEV"
cd DEV/

#echo "Executando todo o script"
mvn clean install





pacote=$(dpkg --get-selections | grep "sonar")
if [ -n "$pacote" ]
	then
		echo "O Sonar já está instalado"
	else
		echo "Instalando o Sonar..."
		sudo sh -c "echo 'deb http://downloads.sourceforge.net/project/sonar-pkg/deb binary/' >> /etc/apt/sources.list"
		sudo apt-get update
		sudo apt-get install sonar
fi

#echo "Indo para a pasta DEV"
cd DEV/

#echo "Executando todo o script"
mvn clean install

#echo "Executando o Sonar"
mvn sonar:sonar

echo "Instalação Concluida"

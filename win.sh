#!/bin/bash
echo "Script para rodar no SO Windows"

#  O usuário tem que rodar a Command-Line Interface como administrador 
#para conseguir instalar os programas necessários via Chocolatey
echo "Checando se o Chocolatey está instalado"
pacote=$(command -v choco)
if [ -n "$pacote" ];
	then
		echo "O Chocolatey já está instalado"

	else
		echo "Por favor, instale o Chocolatey antes de continuar"
		exit
fi

#eh case sensitive. A string, no caso "git", com o nome do pacote tem que ser toda em letra minuscula.
#e eh preciso ficar atento aos espacos dos colchetes
echo "Checando se o Git está instalado"
pacote=$(command -v git)
if [ -n "$pacote" ];
	then
		echo "O Git já está instalado"

	else
		echo "Instalando o Git"
		choco install git
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

pacote=$(command -v maven)
#echo "Instalando o JRE"
choco install javaruntime
#echo "Instalando o JDK"
choco install jdk8

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
		choco install maven
fi

#echo "Checando se o junit está instalado"
pacote=$(command -v junit)
if [ -n "$pacote" ];
	then
		echo "O JUnit já está instalado"
	else
		echo "Instalando o Junit"
		#choco install junit #Chocolatey não tem instalador pro junit ainda...
fi

#echo "Indo para a pasta DEV"
cd DEV/

#echo "Executando todo o script"
mvn clean install

pacote=$(command -v sonar)
if [ -n "$pacote" ]
	then
		echo "O Sonar já está instalado"
	else
		echo "Instalando o Sonar..."
		sh -c "echo 'deb http://downloads.sourceforge.net/project/sonar-pkg/deb binary/' >> /etc/apt/sources.list"
		choco install sonarcube-scanner
fi

echo "Instalação Concluida"

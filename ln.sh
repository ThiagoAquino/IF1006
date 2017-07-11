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


pacote=$(dpkg --get-selections | grep "sonar")
if [ -n "$pacote" ];
	then
		echo "O Sonar já está instalado"
	else
		echo "Instalando o Sonar..."
		sudo sh -c "echo 'deb http://downloads.sourceforge.net/project/sonar-pkg/deb binary/' >> /etc/apt/sources.list"
		sudo apt-get update
		sudo apt-get install sonar
		sudo wget https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-6.0.zip
		sudo unzip sonarqube-6.0.zip
		sudo mv sonarqube-6.0 /opt/sonar
fi

pacote=$(dpkg --get-selections | grep "mysql-server")
if [ -n "$pacote" ];
	then
		echo "O MySQL Server já está instalado"
	else
		echo "Instalando o MySQL..."
		sudo apt-get install mysql-server
fi

#para executar comandos no MySQL a partir da linha de comando a estrutura é a seguinte
# mysql -u USER -pPASSWORD -e "SQL_QUERY"
# assumindo o usuário e senha padrão root, para criação do banco de dados e o usuário, ficamos com:
mysql -u root -proot -e "CREATE DATABASE sonar;" >> sqlQueriesResult
mysql -u root -proot -e "CREATE USER 'sonar' IDENTIFIED BY 'sonar';" >> sqlQueriesResult
mysql -u root -proot -e "GRANT ALL ON sonar.* TO 'sonar'@'%' IDENTIFIED BY 'sonar';" >> sqlQueriesResult
mysql -u root -proot -e "GRANT ALL ON sonar.* TO 'sonar'@'localhost' IDENTIFIED BY 'sonar';" >> sqlQueriesResult
mysql -u root -proot -e "FLUSH PRIVILEGES;" >> sqlQueriesResult

# configuração do sonar.properties
# removendo qualquer texto do arquivo por garantia
sed -i ':a;$!{N;s/\n//;ba;}' /opt/sonar/conf/sonar.properties

sed -i 's/.*//g' /opt/sonar/conf/sonar.properties

echo "# su - sonar" > /opt/sonar/conf/sonar.properties
echo -e "# vi conf/sonar.properties\n\n" >> /opt/sonar/conf/sonar.properties

echo "# ------ DATABASE ------" >> /opt/sonar/conf/sonar.properties

echo "sonar.jdbc.username=sonar" >> /opt/sonar/conf/sonar.properties
echo "sonar.jdbc.password=sonar" >> /opt/sonar/conf/sonar.properties
echo "sonar.jdbc.url=jdbc:mysql://localhost:3306/sonar" >> /opt/sonar/conf/sonar.properties

echo -e "# ------ ------\n\n" >> /opt/sonar/conf/sonar.properties

echo "# ------ WEB SERVER ------" >> /opt/sonar/conf/sonar.properties

echo "sonar.web.host=127.0.0.1" >> /opt/sonar/conf/sonar.properties
echo "sonar.web.context=/sonar" >> /opt/sonar/conf/sonar.properties
echo "sonar.web.port=9000" >> /opt/sonar/conf/sonar.properties

echo -e "# ------ ------\n\n" >> /opt/sonar/conf/sonar.properties

sudo /opt/sonar/bin/linux-x86-64/sonar.sh start



#echo "Indo para a pasta DEV"
cd DEV/

#echo "Executando todo o script"
mvn clean install

#echo "Executando o Sonar"
mvn sonar:sonar


#sudo apt-get remove docker docker-engine docker.io

sudo apt-get update

sudo apt-get install \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual

sudo apt-get update

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

sudo apt-get install curl

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update

sudo apt-get install docker-ce

sudo docker build -t projeto-cloud-petclinics .

sudo docker login -u tas4 -p tas41234

sudo docker tag projeto_cloud_petclinics tas4/projeto-cloud-petclinics

sudo docker push tas4/projeto-cloud-petclinics

# Código feito com base no tutorial: https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository

echo "Instalação Concluida"


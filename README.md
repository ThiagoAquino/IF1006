# Projeto PetClinics

## Descrição
   Projeto da disciplina Tópicos Avançados em SI 3 - Cloud Computing (IF1006) do Centro de Informática da Universidade Federal de Pernambuco.

## Objetivo
   Configurar um ambiente via Shell Script, fazer o deploy de uma imagem Docker na Google Cloud e acessar a aplicação de um endereço externo.

## Equipe
- Ângelo Sant'Ana
- Paulo Vaz
- Thiago Aquino

## O que foi feito

   Implementamos um script para preparar uma imagem Docker fazer seu deploy na Google Cloud. O script funciona da seguinte forma:

1) Instala o Git, se já não estiver instalado
2) Cria os quatro ambientes: TEST, UAT, PRODUCTION e DEV 
3) Faz o git clone do projeto https://github.com/jfsc/spring-petclinic.git para o ambiente DEV
4) Instala o JRE e o JDK
5) Configura o PATH do Java
6) Instala o Maven, se já não estiver instalado
7) Instala o JUnit, se já não estiver instalado
8) Instala o Sonar, se já não estiver instalado
9) Instala o MySQL, se já não estiver instalado
10) Configura o MySQL
11) Configura o Sonar
12) Instala as dependências necessárias para utilizar o Docker
13) Cria a imagem do Docker
14) Envia a imagem para o repositório 

   O script foi executado numa máquina com Ubuntu 16.04 LTS. Para executá-lo, abra uma janela de terminal, navegue até o endereço do script (utilizando "cd") e execute os comandos:

$ chmod +x ./[nome_do_script].sh

$ ./[nome_do_script].sh

   Após execução do script criamos uma máquina virtual (também com Ubuntu 16.04 LTS) na Google Cloud para rodar a imagem Docker. Para isso, foi necessário conectar à VM com SSH e executar os seguintes comandos:

$ sudo docker pull tas4/projeto-cloud-petclinics

$ sudo docker run -i -t --expose=5000 -p 5000:8080 -h 35.189.73.25 tas4/projeto-c
loud-petclinics

   Utilizamos o IP externo da VM e a porta 5000, que foi liberada pelo suporte do CIn para testarmos enquanto utilizássemos a rede de lá. Após a execução dos comandos mencionados acima foi possível acessar a aplicação PetClinics pelo endereço http://35.189.73.25:5000.

   Foi criado um script para ser executado numa máquina rodando o sistema operacional Windows também, mas utilizamos o gerenciador de pacotes Chocolatey e encontramos algumas dificuldades para "traduzir" os comandos de Linux pra Windows. Alguns pacotes que estavam disponíveis para Linux não eram disponibilizados pelo Chocolatey, então houve também este empecilho. Contudo, foi possível implementar o código até a configuração do MySQL. O código está também neste repositório.

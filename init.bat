@echo off

if exist DEV (
	echo "Os Diretorios serao recriados"
	rm -R -f DEV
	

) else (
	echo "Criando os diretorios"
	md TEST
	md UAT
	md PRODUTION
)
md DEV
git clone  https://github.com/jfsc/spring-petclinic.git DEV
 

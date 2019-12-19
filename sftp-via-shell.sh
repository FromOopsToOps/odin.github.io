#!/bin/bash

#	---------------------------------
#	Script de Automação
#	SFTP - via Shell Script
#
#	Autor: Rafael Umbelino
#	E-Mail: rafael.umb@hotmail.com.br
#	telegram: @odin_Umbelino
#		Setor de Redes e Infraestrutura
#	---------------------------------

#	Histórico de Versão
#	1.0 - criação do script em 19 de Dezembro de 2019;
#	1.1 - algumas alterações estéticas e funcionais;

#	---------------------------------
#
#	Script projetado para enviar um arquivo para
#	um SFTP. É necessário que
#	tenha instalado no servidor o programa sftp
#	e o programa expect; caso não estejam, instalar.
#
#	---------------------------------


#	Definição de variáveis
#
#	Por padronização, as variáveis estarão em português
#	e em letras maiúsculas, para mais fácil identificação.
#	Variáveis cujo conteúdo seja texto puro devem estar
#	entre aspas duplas (" "), variáveis de caminho que
#	tenham espaços ou caracteres especiais devem estar
#	entre aspas simples (' ') e caminhos devem estar
#	completos e sem a barra final (/home/user).
#	Variáveis numéricas devem ser apresentadas sem aspas.

#	Defina usuário e senha do SFTP
export USUARIO="ZeDasGraça"
export SENHA="aquelaMesmo"

#	Defina o servidor a se conectar, número de tentativas
#	de conexão e qual o tempo limite de espera do servidor.
#	Tempo limite em SEGUNDOS.
export SERVIDOR="exemplo.servidor.com"
export TENTATIVAS=3
export TEMPOLIMITE=60

#	Defina o nome padrão do arquivo (prefixo)
#	Caso sejam vários arquivos, escreva eles separados por
#	um espaço. É possível usar wildcards aqui.
#	Caso seja uma pasta inteira, COMENTE a linha abaixo e
#	DESCOMENTE a linha seguinte; digite o nome da PASTA.
export ARQUIVO=""
# export PASTA=""

#	Defina a pasta onde o arquivo ou pasta se encontram no
#	servidor e a pasta remota onde o arquivo será inserido.
#	Em caso de querer enviar uma pasta inteira, digite aqui
#	a pasta PAI da pasta que você deseja enviar.
export PASTALOCAL=/home/zedasgraca
export PASTAREMOTA=/envios

#	Essa variável define como o sftp irá se comportar.
#	Edite somente se novas configurações forem necessárias.

export OPCOES='-oConnectionAttempts=$TENTATIVAS -oConnectTimeout=$TEMPOLIMITE'

#	---------------------------------

cd $PASTALOCAL 							; # muda para a pasta onde o arquivo se encontra
expect << EOS							; # executa o processo via EXPECT

spawn sftp $::env(OPCOES) $::env(USUARIO)@$::env(SERVIDOR)	; # roda o processo do SFTP dentro do expect
expect "$::env(USUARIO)@$::env(SERVIDOR)'s password: "		; # aguarda pedir senha
send $SENHA\r							; # fornece a senha
expect "sftp>"							; # aguarda o prompt sftp
send -- "cd $PASTAREMOTA\n"					; # muda para a pasta onde botar o arquivo
expect "sftp>"							; # aguarda voltar ao prompt

send -- "put $ARQUIVO\n"					; # faz o envio do arquivo. Comente se for pasta.

# send -- "mkdir $PASTA						; # No caso de fazer o upload de uma pasta toda
# expect "sftp>"						; # comente a o send acima e descomente esse bloco
# send -- put -r $PASTA 					; # dessa forma, fazendo upload da pasta inteira.

expect "sftp>"							; # aguarda o prompt voltar, indicando que terminou
send -- "bye\n"							; # fecha a conexão com o SFTP
								; # termina a execução do expect
EOS

.data 
	menInstrumento: .asciiz"Digite o numero correspondente ao instrumento:\n1 - Piano \n2 - Violão \n3 - Flauta \n4 - Teclado com efeitos"
	menError: .asciiz"Opcao invalida!" # mensagem de opcao invalida
	menArquivo: .asciiz"Digite o nome do arquivo que contém a música"
	menMenu: .asciiz"Escolha uma música:\n1 - Super Mario \n2 - Star Wars \n3 - Cheia de Manias \n4 - BBS \n5 - Furelisa \n6 - Harry Potter \n7 - Natal \n8 - The Walking Dead \n9 - Arquivo musica.txt"
	menContinuar: .asciiz"Deseja Continuar no Programa? \n1 - Sim\n2 - Não"
	music_mario: .asciiz"mario.txt" 
	music_star_wars: .asciiz"star_wars.txt"
	music_harry: .asciiz"harry.txt"
	music_manias : .asciiz"cheia_de_manias.txt"
	music_bbs: .asciiz"bbs.txt"
	music_furelisa: .asciiz"furelisa.txt"
	music_natal: .asciiz"natal.txt"
	music_twd: .asciiz"twd.txt"
	enderecoArquivo: .asciiz "teste" #grava aum asciiz em um endereço de momoria para podermos usar esse endereço depois
	enderecoNota: .word 1 #grava auma palavra em um endereço de momoria para podermos usar esse endereço depois

.text
MENU:
	la $a0, menMenu
	li $v0, 51
	syscall


CHECAR_MENU:
	beq $a1,-2,END
	beq $a1,-1, MENSAGEM_ERROR#ERROR_MENU
	beq $a1,-3, MENSAGEM_ERROR#ERROR_MENU
	move $s4, $a0
	nop
	beq $s4,1,MARIO
	beq $s4,2,STAR_WARS
	beq $s4,3,CHEIA_MANIAS
	beq $s4,4,BBS
	beq $s4,5,FURELISA
	beq $s4,6,HARRY_POTTER
	beq $s4,7,NATAL
	beq $s4,8,TWD
	beq $s4,9,MENSAGEM_ARQUIVO 
	j MENSAGEM_ERROR


MENSAGEM_ARQUIVO:
	li $v0, 54 # 54 e um que representa o tipo de tela que sera exibida (String)
	la $a0, menArquivo # $a0 guarda a string que sera exibida no momento que chama o syscall
	la $a1, enderecoArquivo #endereço de memória onde será salvo
	li $a2, 1000 #para designar o tamanho maximo da string lida
	syscall
	la $t1,enderecoArquivo #endereço de memória onde contém o nome do arquivo com o \n
	addi $s4,$s4, 200 #duração de cada nota (padrão)
	jal TRATAR_STRING #desvia para um ponto mas guarda o endereço atual no registrador $ra
	j MENSAGEM_INSTRUMENTO


#Trata o \n que vem quando o usuario digita o nome do arquivo
TRATAR_STRING:
	lb $t9, ($t1) #salva o conteudo presente em $t1 no registrador $t9
	addi $t1,$t1,1 #percorre a memoria pulando de 1 em 1 endereço
	bne $t9, 10, TRATAR_STRING #se $t9 for diferente do inteiro correspondente a \n então continua a ler a memoria
	li $t9,0
	sb $t9, -1($t1) #salva o 0 como conteudo apontado por $t1. -1 porque o endereço atual está no de (\n+1) já que ele sofreu o addi
	la $t1,enderecoArquivo  #reseta o endereço apontado por $t1 para o inicio da palavra e agora sem o \n
	jr $ra #volta para o ponto do código onde essa função foi chamada "jal TRATAR_STRING"


#Caso o usuario escolha tocar a musica do mario
MARIO:
	li $t3, 2 #2
	li $s4, 150 #200 ou 150
	la $t1, music_mario
	j ABRIR_ARQUIVO
	nop


#Caso o usuario escolha tocar a musica do star wars
STAR_WARS:
	li $t3, 30 #26 #5 #30
	li $s4, 230 #200 ou 230
	la $a0, music_star_wars
	move $t1, $a0
	j ABRIR_ARQUIVO
	nop


#Caso o usuario escolha tocar a musica cheia de manias
CHEIA_MANIAS:
	li $t3, 70 #6 #57 #65 #70
	li $s4, 150
	la $t1, music_manias
	j ABRIR_ARQUIVO
	nop


#Caso o usuario escolha tocar a musica brilha brilha estrelinha
BBS:
	li $t3, 2 #?
	li $s4, 200
	la $t1, music_bbs
	j ABRIR_ARQUIVO
	nop


#Caso o usuario escolha tocar a musica furelisa
FURELISA:
	li $t3, 2
	li $s4, 200
	la $t1, music_furelisa
	j ABRIR_ARQUIVO
	nop


#Caso o usuario escolha tocar a musica do Harry Potter
HARRY_POTTER:
	li $t3, 70 #26 #70
	li $s4, 300
	la $t1, music_harry
	j ABRIR_ARQUIVO
	nop


#Caso o usuario escolha tocar a musica de Natal
NATAL: 
	li $t3, 26
	li $s4, 200
	la $t1, music_natal
	j ABRIR_ARQUIVO
	nop


#Caso o usuario escolha tocar o tema de Abertura de The Walking Dead
TWD:
	li $t3, 27 #27 #26
	li $s4, 200
	la $t1, music_twd
	j ABRIR_ARQUIVO
	nop





#Tela de escolha do instrumento para o arquivo de musica desejado
MENSAGEM_INSTRUMENTO:
	la $a0, menInstrumento # $a0 guarda a string que sera exibida no momento que chama o syscall
	li $v0, 51 # 51 representa o tipo de tela que sera exibida (para inteiros)
	syscall


#Checa as entradas do usuario em relação ao instrumento escolhido
CHECAGEM:
	beq $a1,-2,END #$a1 = -2 o usuario apertou em cancelar
	beq $a1,-1,MENSAGEM_ERROR #$a1 = -1 o usuario digitou um valor que nao e inteiro
	beq $a1,-3,MENSAGEM_ERROR #$a1 = -3 o usuario apertou ok mas nao entrou com nenhum valor inteiro
	move $t0, $a0 #passa a entrada que esta em $a0 para $t0, ou seja, o que o usuario digitou no input
	nop
	beq $t0, 1, PIANO
	beq $t0, 2, VIOLAO
	beq $t0, 3, FLAUTA
	beq $t0, 4, TECLADO


#Tela de mensagem de erro 
MENSAGEM_ERROR:
	la $a0, menError # $a0 guarda a string que sera exibida no momento que chama o syscall
	li $v0, 55 # 55 e um que representa o tipo de tela que sera exibida
	syscall
	beq $s4,9, MENSAGEM_INSTRUMENTO #caso o usuario tenha escolhido a opção de utilizar um arquivo externo
	j MENU
	#j MENSAGEM_INSTRUMENTO

#Parte musicial padrão
PIANO: 
	li $t3, 2 #$t3 guarda o valor inteiro que corresponde ao instrumento necessário
	j ABRIR_ARQUIVO
VIOLAO: 
	li $t3 26 
	j ABRIR_ARQUIVO
FLAUTA: 
	li $t3, 70
	j ABRIR_ARQUIVO
TECLADO: 
	li $t3, 45 


#Abre o arquivo para tocar a musica
ABRIR_ARQUIVO:
li   $v0, 13       		# $v0 = 13, faz com que o sistema abra um arquivo
move $a0, $t1			#carrega em $a0, o endereco de memoria que contem o nome do arquivo da musica
li   $a1, 0	        	# Padrão para Abrir o arquivo para leitura
li   $a2, 0			# Padrão para Abrir o arquivo para leitura
syscall            		# Abre o arquivo, caso nao exista o $v0 = -1, caso exista $v0 = 3
move $s6, $v0      		# Passa para $s6 o descritor do arquivo

#Ler o arquivo para tocar a musica
li   $v0, 14       	# $v0 = 14, faz com que o sistema leia o arquivo
move $a0, $s6      	# passa o descritor do arquivo para o $a0, seja -1 ou 3   	
la   $a1, enderecoNota	# $a1 se torna o buffer que contem o conteudo do arquivo em memoria.
li  $a2, 4096           # tamanho do buffer em bytes
syscall            	# Chama o sistema para ler o arquivo

move $s7, $a1 # copia o ponteiro para o registrador $s7 

#Fecha o arquivo (já que as informações necessárias já estão em memória(enderecoNota))
li   $v0, 16       	# $v0 = 16, faz com que o sistema feche o arquivo
move $a0, $s6      	# passa o descritor para fecha o arquivo
syscall            	# Chama o sistema para fecha o arquivo


#percorrendo o buffer
lw $t2, ($s7) #carrega o primeiro byte do buffer para o registrador $t2 


#processo de converter 4 dígitos em 1 (retirar os 3 espaços vazios)
CONVERTER:
   srl $t2, $t2, 24 #Desloca o conteudo em bits de t2 em 24 casas para a esqueda. Isso porque cada endereço(4) de memória contém palavras de 8 bytes cada.
   sw $t2, 0($s7) #salva o conteudo da memória apontado pelo registrador $s7 no registrador $t2.
   addi $s7, $s7, 4 #adiciona 4 ao registrador $s7 para poder percorrer o próximo endereço.
   lw $t2, ($s7) #Carrega no registrador $t2 o que esta na memoria apontada por $s7
   nop
   bne $t2, $zero, CONVERTER #vai para converter caso o valor em $t2 seja diferente de 0. Por que 0? Por que chegou em um espaço de moria que nao tem conteudo.
   
li $t5, 126 #carrega em t5 o valor correspondente ao símbolo "~" na tabela ASCII

la $s7, enderecoNota #volta para o endereço inicial da memoria apontada pelo buffer enderecoNota
lw $t2, ($s7) #pega o primeiro valor inteiro na memoria apontado por enderecoNota
j TOCA_NOTA_ATUAL


########parte reponsável por tocar a música contida em memória
DORMIR:
    li $a0, 600 #tempo do sleep
    la $v0, 32 #valor do syscall para chamar a função de sleep
    syscall

PROX_NOTA:
  addi $s7, $s7, 4 #desloca para o proximo endereco de memoria
  lw $t2, ($s7) #guarda no registrador $t2 o conteúdo apontado pela memoria contida em $s7
  beq $t2, $zero, END #quando não tiver mais notas vai para o END.

TOCA_NOTA_ATUAL:
   beq $t2,$t5,DORMIR  #leu "~" então tem que chamar a função dormir
   move $a0, $t2 #coloca o inteiro armazenado no registrador $t2 no registrador $a0, é feito isso pois quando vai tocar a nota, o valor identificado como nota deve estar em $a0
   move $a1, $s4 #tempo de duração de cada nota
   move $a2, $t3 #aqui está o instrumento que será tocado
   li $a3, 127 #volume do som
   li $v0, 33 #diz ao sistema que a função tocada será a de música
   syscall
   nop
   j PROX_NOTA #isso que permite o loop acontecer
########

END:
  la $a0, menContinuar # $a0 guarda a string que sera exibida no momento que chama o syscall
  li $v0, 51 # 51 e um que representa o tipo de tela que sera exibida
  syscall
  beq $a0, 1, MENU #volta para o começo do programa caso seja digitado "1"
  
  addi $v0, $zero, 0 #Encerra o programa
  syscall

# 🐧 Comandos Linux para Iniciantes

Anotações do curso **Linux Commands for Beginners** (Learn Linux TV).

🇺🇸 [Read in English](../en/README.md) · ⬅️ [Voltar ao início](../README.md)

## Índice

1. [Navegação e arquivos](#1-navegação-e-arquivos)
2. [Permissões](#2-permissões)
3. [Monitoramento do sistema](#3-monitoramento-do-sistema)
4. [Gerenciamento de pacotes (apt)](#4-gerenciamento-de-pacotes-apt)
5. [Gerenciamento de serviços (systemd)](#5-gerenciamento-de-serviços-systemd)
6. [Logs](#6-logs)
7. [Gerenciamento de usuários e grupos](#7-gerenciamento-de-usuários-e-grupos)
8. [Histórico de comandos](#8-histórico-de-comandos)
9. [Redirecionamento de saída e pipes](#9-redirecionamento-de-saída-e-pipes)
10. [Busca de arquivos (find)](#10-busca-de-arquivos-find)
11. [Gerenciamento remoto com OpenSSH](#11-gerenciamento-remoto-com-openssh)
12. [Transferência de arquivos (scp e rsync)](#12-transferência-de-arquivos-scp-e-rsync)
13. [Desabilitando login do root via SSH](#13-desabilitando-login-do-root-via-ssh)
14. [Variáveis](#14-variáveis)
15. [Observações importantes](#15-observações-importantes)
16. [Pastas e arquivos importantes](#16-pastas-e-arquivos-importantes)

---

## 1. Navegação e arquivos

| Comando | Descrição |
|---|---|
| `ls` | Lista o conteúdo da pasta atual |
| `ls /` | Lista as pastas da raiz (`/`) do sistema de arquivos |
| `ls -l` | Listagem longa, com mais detalhes |
| `ls -a` | Lista também arquivos ocultos |
| `pwd` | *(print working directory)* Mostra o caminho do diretório atual |
| `cd <diretório>` | *(change directory)* Acessa o diretório indicado |
| `touch <arquivo>` | Cria um arquivo |
| `which <app>` | Verifica se o app está instalado na máquina |
| `cp <arquivo1> <novo_arquivo>` | Copia `arquivo1` para `novo_arquivo` |
| `diff <arquivo1> <arquivo2>` | Compara dois arquivos; se forem iguais, não retorna nada |
| `rm <arquivo>` | Remove um arquivo |
| `rm -r <diretório>` | Remove um diretório **e todo o seu conteúdo** (recursivo) |
| `rm -rf <diretório>` | Igual ao anterior, mas com `-f` (*force*): não pede confirmação e ignora arquivos inexistentes |
| `mv <arquivo> <diretório>` | Move o arquivo para o diretório |
| `mv <arquivo> <novo_nome>` | Renomeia o arquivo |
| `alias <atalho>=<comando>` | Define um atalho para um comando (vale só para a sessão atual; para ser permanente, coloque no `~/.bashrc`) |

> ⚠️ **Cuidado com `rm -rf`:** como não pede confirmação, um erro de digitação pode apagar dados importantes.

---

## 2. Permissões

### Lendo a saída de `ls -l`

O comando `ls -l` mostra uma string de permissões dividida em 4 grupos, por exemplo `drwxrwxrwx`:

| Posição | Significado |
|---|---|
| 1º (`d` ou `-`) | Diretório (`d`) ou arquivo (`-`) |
| 2º (`rwx`) | **User**: dono do arquivo ou diretório |
| 3º (`rwx`) | **Group**: grupo |
| 4º (`rwx`) | **Other**: outros usuários |

Letras: `r` = read (ler), `w` = write (escrever), `x` = execute (executar).

### `chmod` (change mode)

```bash
chmod +x myscript.sh      # adiciona execução (para todos)
chmod u+x myscript.sh     # adiciona execução apenas para o user
chmod g+x myscript.sh     # adiciona execução apenas para o group
chmod o+x myscript.sh     # adiciona execução apenas para others
chmod a+rwx myscript.sh   # adiciona rwx para todos
```

### Permissões em diretórios

| Permissão | Efeito |
|---|---|
| `r` | Consegue ver o conteúdo |
| `w` | Consegue alterar o conteúdo |
| `x` | Consegue entrar no diretório |

### Permissões numéricas

| Letra | Valor |
|---|---|
| `r` | 4 |
| `w` | 2 |
| `x` | 1 |

Some os valores de cada grupo (user, group, other):

```bash
chmod 400 textfile   # -r--------  só o user pode ler; group e other = 0
```

---

## 3. Monitoramento do sistema

### Memória: `free`

```bash
free      # mostra a RAM e a Swap
free -m   # mostra a memória em megabytes
```

**Diferença entre `free` e `available`:**
- `free`: memória livre, não está sendo usada por absolutamente nada.
- `available`: memória que poderia ser liberada e usada caso fosse necessária.

### Disco: `df`

```bash
df        # (disk free) espaço em disco
df -h     # -h = human readable (formato legível)
df -i     # quantidade de inodes
```

### Carga do sistema: `uptime`

Mostra há quanto tempo o sistema está ligado e a carga média (*load average*). Os três números indicam a média:

1. No último **1 minuto**
2. Nos últimos **5 minutos**
3. Nos últimos **15 minutos**

Assim é possível ver a tendência de desempenho do sistema. O valor representa, em média, quantas tarefas estão em execução ou aguardando a CPU (no Linux, inclui também tarefas bloqueadas em I/O).

> 💡 Se o sistema está sobrecarregado **depende do número de núcleos**: uma carga de 4 é alta em uma máquina de 2 núcleos, mas normal em uma de 8.

---

## 4. Gerenciamento de pacotes (apt)

```bash
apt search <pacote>                     # procura um pacote
apt search firefox

sudo apt install <pacote>               # instala um pacote
sudo apt install vim-nox
sudo apt install <pacote1> <pacote2>    # instala vários pacotes

sudo apt remove <pacote>                # remove um pacote
sudo apt autoremove                     # remove dependências que ficaram sem uso

sudo apt update                         # atualiza a lista de pacotes
sudo apt upgrade                        # atualiza os pacotes instalados
sudo apt dist-upgrade                   # processa tanto os recém-instalados quanto os que precisam ser removidos

sudo reboot                             # reinicia a máquina
```

---

## 5. Gerenciamento de serviços (systemd)

**systemd** é o gerenciador de processos/serviços em execução nos sistemas Linux.

```bash
systemctl status <unit>          # verifica o status da unidade
systemctl status apache2

sudo systemctl start <unit>      # inicia a unit
sudo systemctl stop <unit>       # para a unit
sudo systemctl restart <unit>    # reinicia a unit
sudo systemctl enable <unit>     # ativa o início automático no boot
sudo systemctl disable <unit>    # desativa o início automático no boot
```

Exemplo com `apache2`:

```bash
sudo systemctl start apache2
sudo systemctl stop apache2
sudo systemctl restart apache2
sudo systemctl enable apache2
sudo systemctl disable apache2
```

### Interpretando a saída de `systemctl status`

```
Loaded: loaded (/usr/lib/systemd/system/apache2.service; enabled; preset: enabled)
Active: active (running)
```

- Primeiro `enabled`: estado atual, o apache2 será iniciado assim que a máquina ligar.
- `preset: enabled`: a configuração padrão (preset) da distribuição manda habilitar esse serviço.
- `active (running)`: está executando corretamente.

---

## 6. Logs

```bash
head <log_file>             # mostra as 10 primeiras linhas
tail <log_file>             # mostra as 10 últimas linhas
tail -n 50 <log_file>       # mostra as 50 últimas linhas (o valor pode ser alterado)
tail -f <log_file>          # acompanha o arquivo em tempo real
```

### journalctl

O `journalctl` faz parte do systemd, assim como o `systemctl`.

```bash
journalctl -u <unit>        # mensagens apenas do serviço/unidade especificado
journalctl -u ssh           # -u = nome de uma unidade
journalctl -fu ssh          # -f = acompanha novas mensagens em tempo real
```

---

## 7. Gerenciamento de usuários e grupos

### Usuários

```bash
sudo adduser <user>              # cria o usuário
sudo adduser batman

su - <user>                      # abre um novo shell de login como o usuário (pede a senha dele)
logout                           # fecha esse shell e volta para o usuário anterior

sudo su - <user>                 # igual, mas sem pedir a senha do usuário (o sudo pede a SUA senha)
sudo su -                        # abre um shell como root; os próximos comandos rodam como root
exit                             # sai do shell atual (logout ou Ctrl+d também funcionam)

passwd                           # altera a senha do usuário ATUAL
sudo passwd <user>               # altera a senha de outro usuário sem precisar logar nele
passwd <user>                    # estando como root, basta isso

sudo userdel -r <user>           # remove o usuário e (-r) o diretório home dele
```

### Grupos

```bash
sudo groupadd <grupo>            # cria um grupo
sudo groupadd heroes

sudo usermod -aG <grupo> <user>  # adiciona o usuário ao grupo
sudo gpasswd -d <user> <grupo>   # remove o usuário do grupo
sudo groupdel <grupo>            # remove o grupo
```

---

## 8. Histórico de comandos

```bash
history      # mostra o histórico de comandos
```

- `Ctrl+r`: busca/autocompleta comandos já utilizados.

---

## 9. Redirecionamento de saída e pipes

```bash
ls -l > file.txt               # envia a saída para file.txt, sobrescrevendo o arquivo
ls -l >> file.txt              # envia a saída para file.txt, sem sobrescrever (acrescenta)
ls -l | grep file              # envia a saída do ls para o grep pesquisar
cat file.txt | sort | uniq     # pega as linhas | ordena | retira duplicatas
```

### Comandos úteis em pipelines

| Comando | Descrição |
|---|---|
| `sort` | Ordena as linhas em ordem alfabética |
| `uniq` | Remove linhas duplicadas **adjacentes** (por isso é usado após `sort`) |
| `grep -v <string>` | Mostra as linhas que **não** contêm a string |
| `wc` | *(word count)* Conta linhas, palavras e bytes (ou caracteres) |

### Descritores de arquivo

| Nº | Nome | Descrição |
|---|---|---|
| 0 | `stdin` | Entrada padrão |
| 1 | `stdout` | Saída padrão |
| 2 | `stderr` | Erro padrão |

Exemplos:

```bash
find / -name "*.log" 2> /dev/null     # descarta os erros enviando-os para /dev/null
find / -name "*.log" 2> errors.txt    # grava os erros em errors.txt
find / -name "*.log" 1> success.txt   # grava os resultados (sucessos) em success.txt
```

---

## 10. Busca de arquivos (find)

```bash
find -name log                              # procura arquivos E pastas chamados "log"
find -type d -name log                      # procura apenas pastas chamadas "log"
find -type f -name log                      # procura apenas arquivos chamados "log"
find /var -type f -name "*log"              # arquivos em /var cujo nome termina com "log"
find /var -type f -name "*log*"             # arquivos em /var com "log" em qualquer parte do nome
find /var -type f -name "*log*" 2> /dev/null   # mesmo comando, descartando os erros
```

### Filtrando por data de modificação

`-mtime` = *modify time* (em dias).

```bash
find /var/log -type f -name "*.log" -mtime -7
# arquivos .log modificados nos últimos 7 dias
```

### Executando um comando nos resultados (`-exec`)

```bash
find /var/log -type f -name "*.log" -mtime +30 -exec rm {} \;
# remove (rm) os arquivos .log modificados há mais de 30 dias
```

> ⚠️ **Cuidado:** teste primeiro com `-exec ls {} \;` antes de usar `rm`.
> `-mtime -30` = modificados **nos últimos** 30 dias; `-mtime +30` = modificados **há mais de** 30 dias.

---

## 11. Gerenciamento remoto com OpenSSH

```bash
sudo ss -tulpn              # verifica se o servidor SSH está rodando/escutando
sudo netstat -tulpn         # equivalente antigo (obsoleto, pode não estar instalado)
ip a                        # mostra o IP da máquina à qual se quer conectar

ssh <username>@<ip_server>  # conecta como username ao ip_server
ssh root@<ip_server>        # conecta como root ao ip_server
exit                        # sai do servidor (Ctrl+d também funciona)
```

---

## 12. Transferência de arquivos (scp e rsync)

### SCP (Secure Copy Protocol)

```bash
# Envia o arquivo para a pasta /home/<username>/ da outra máquina
scp <arquivo> <username>@<ip_server>:/home/<username>/

# Se omitir o usuário, ele usa o nome do seu usuário LOCAL;
# sem caminho depois do ":", o destino é a home do usuário remoto
scp <arquivo> <ip_server>:

# -r = recursivo, envia o diretório inteiro
scp -r <pasta>/ <ip_server>:

# Também funciona para receber (mesmo processo, ao contrário)
scp <ip_server>:<arquivo> <caminho_destino>
```

### rsync

```bash
rsync -r <pasta> <username>@<ip_server>:/home/<username>    # envia o diretório inteiro (-r = recursivo)
rsync -rv <pasta> <username>@<ip_server>:/home/<username>   # igual, mas verboso (-v) e informa o que foi copiado
rsync -rv <pasta> <ip_server>:                              # mesma simplificação do scp
rsync -avz <pasta> <ip_server>:
```

Opções de `-avz`:

| Opção | Descrição |
|---|---|
| `-a` | Modo *archive*: série de opções que já inclui recursividade e mantém permissões e datas/horas |
| `-v` | Modo verboso, mostra mais detalhes da transferência |
| `-z` | Comprime os arquivos durante a transferência (ajuda em conexões lentas) |

O `rsync` consegue reenviar **somente os arquivos que faltam**, caso algo tenha sido apagado ou alterado na máquina de destino.

```bash
# Envia os arquivos para a outra máquina e apaga os ARQUIVOS originais na origem
# (as pastas vazias continuam lá)
rsync -avz --remove-source-files <pasta> <ip_server>:

# Apenas simula: não executa nada, mas mostra o que aconteceria
rsync -avz --remove-source-files --dry-run <pasta> <ip_server>:
```

---

## 13. Desabilitando login do root via SSH

```bash
sudo nvim /etc/ssh/sshd_config
```

Altere/defina:

```
PermitRootLogin no            # método mais seguro (estava como prohibit-password)
PasswordAuthentication no     # a conexão é negada sem nem pedir a senha (estava como yes)
```

> ⚠️ `PasswordAuthentication no` desativa a senha para **todos** os usuários, não só o root: só será possível entrar com chave SSH. Confirme que sua chave funciona antes, ou você ficará trancado para fora.
>
> Depois de editar, reinicie o serviço: `sudo systemctl restart ssh`

---

## 14. Variáveis

```bash
HELLOMSG="Hello World"        # define o valor da variável
echo $HELLOMSG                # chama (usa) a variável

MY_NAME="Thiago"
echo "My name is $MY_NAME"

env                           # mostra as variáveis de ambiente da sessão
export myvar="linux"          # exporta a variável: ela passa a aparecer no env e a ser herdada por processos filhos
```

> `export` pode ser usado depois de definir a variável (`myvar="linux"` e depois `export myvar`).

---

## 15. Observações importantes

- `~` indica o diretório inicial do usuário, o mesmo que `cd /home/nome_usuario`.
- **Inodes:** quando acabam, não é possível **criar novos arquivos**, mesmo com espaço livre em disco, o que pode causar falhas em serviços.
- Comandos iniciados com um espaço em branco não vão para o `history`, se o `HISTCONTROL` tiver `ignorespace` ou `ignoreboth` (padrão no Ubuntu/Debian, mas não em todas as distros).

---

## 16. Pastas e arquivos importantes

| Caminho | Descrição |
|---|---|
| `/home` | Diretório principal, contém as pastas pessoais dos usuários |
| `/etc/passwd` | Lista os usuários: nome, UID, GID (grupo principal), home e shell (**não** contém o hash da senha) |
| `/etc/shadow` | Possui o hash das senhas |
| `/etc/group` | Lista de grupos |

```bash
cat /etc/passwd
sudo cat /etc/shadow    # requer privilégios de root
cat /etc/group
```

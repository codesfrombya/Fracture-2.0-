<h1>Fracture - Uma releitura SABOTAGE</h1>


Este projeto é uma releitura moderna e expandida do clássico jogo Sabotage (Atari) , 
desenvolvida do zero utilizando a linguagem Java dentro do ecossistema Processing. 
O objetivo principal é resgatar a jogabilidade nostálgica dos anos 80, aplicando melhorias visuais modernas (pixel art),
novos modos de jogo e mecânicas de power-ups adaptadas para o público atual.

<h1>PARA O GRUPO:</h1>
Até o momento, o esqueleto lógico do jogo está 90% funcional:<br>
🕹️ Controle Responsivo do Jogador: Sistema de movimentação horizontal liso e preciso para o Canhão, aceitando múltiplos comandos de entrada simultâneos (Setas do Teclado + Teclas A e D), além do gerenciamento dinâmico de disparos via Barra de Espaço.<br>
🚁 IA de Voo dos Inimigos: Os helicópteros nascem automaticamente fora da tela e cruzam o cenário horizontalmente da direita para a esquerda<br>
🪂 Mecânica Realista de Drop: Enquanto voam, os helicópteros calculam chances matemáticas em tempo real para soltar paraquedistas. O boneco herda a posição exata do veículo no momento do pulo e inicia sua descida vertical.<br>
🎬 Sistema de Animação por Frames: Implementação de um temporizador manual que alterna os sprites do helicóptero (heli1 e heli2) a cada 5 frames, criando um efeito visual fluido das hélices girando em alta velocidade.<br>
🌍 Física de Chão e Transição de Estado: Criação de uma superfície física (o Chão). Ao atingir a grama, o jogo detecta a colisão e realiza uma troca dinâmica de sprite: o paraquedas gigante desaparece e o boneco limpo (chaoH) pousa de pé na superfície.<br>
💥 Detecção de Colisão e Placar: Algoritmo matemático baseado em distância (dist()) que identifica quando os tiros vermelhos interceptam os inimigos, limpando-os da memória de forma otimizada para evitar lentidão e computando os pontos no placar da tela.

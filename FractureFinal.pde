import processing.sound.*;

// =============================================
//   SABOTAGE  —  Atari Tribute
//   Menu moderno + 3 Modos de Jogo
// =============================================


// ---- ESTADOS ----
final int MENU     = 0;
final int JOGANDO  = 1;
final int GAMEOVER = 2;
final int VITORIA  = 3;
final int SEL_MODO = 4;
final int CREDITOS = 5;

int estado = MENU;

// ---- MODOS ----
final int MODO_CLASSICO = 0;
final int MODO_ARCADE   = 1;
final int MODO_TEMPO    = 2;
int modoJogo = MODO_CLASSICO;

// ---- VARIÁVEIS GERAIS ----
int pontuacao     = 0;
int vidas         = 3;
int recordeArcade = 0;

PImage imgInimigoCP;
PImage imgInimigoSP;
PImage imgHeli1;
PImage imgHeli2;
PImage imgPUVida;
PImage imgPUBomba;
PImage imgPUTiro;
PImage imgLogo;
PImage imgVidaHUD;

SoundFile somTiro;
SoundFile somExplosao;
SoundFile somVida;
SoundFile somTiroRap;
SoundFile Gameover;
SoundFile Victory;
SoundFile bgMusic;

// ---- MODO CLÁSSICO ----
int ondaAtual           = 0;
final int TOTAL_ONDAS   = 5;
int inimigosNaOnda      = 0;
int inimigosEliminados  = 0;
int inimigosNecessarios = 0;
boolean ondaAtiva       = false;
int pausaEntreOndas     = 0;

// ---- MODO CONTRA O TEMPO ----
int timerMissao         = 0;
String missaoTexto      = "";
int metaMissao          = 0;
int progressoMissao     = 0;
int missaoAtual         = 0;
final int MISSOES_TOTAL = 3;
boolean missaoConcluida = false;
int celebracaoTimer     = 0;

String[] missaoNomes = {
  "ABATA 5 HELICOPTEROS",
  "ELIMINE 3 PARAQUEDISTAS",
  "ALCANCE 300 PONTOS"
};
int[] missaoMetas = {5, 3, 300};
int[] missaoTipo  = {0, 1, 2};

int helisSalvos = 0;
int parasSalvas = 0;

// ---- CANHÃO ----
float canhaoX, canhaoY;
float anguloCanao  = -PI / 2;
float velAngulo    = 0.04;
float limiteMin    = -PI + 0.15;
float limiteMax    = -0.15;

// ---- TIROS ----
ArrayList<PVector> tiros     = new ArrayList<PVector>();
ArrayList<PVector> tirosDirs = new ArrayList<PVector>();
float velTiro        = 12;
int   cooldownTiro   = 0;
int   cooldownMaximo = 18;

// ---- HELICÓPTEROS ----
ArrayList<PVector> helis    = new ArrayList<PVector>();
ArrayList<Integer> heliDirs = new ArrayList<Integer>();
float velHeli        = 2.0;
int   spawnTimer     = 0;
int   spawnIntervalo = 210;

// ---- PARAQUEDISTAS ----
ArrayList<PVector> paras = new ArrayList<PVector>();
float velPara = 1.3;

// ---- EXPLOSÕES ----
ArrayList<PVector> explosoes      = new ArrayList<PVector>();
ArrayList<Integer> explosoesTimer = new ArrayList<Integer>();

// ---- POWER-UPS ----
// tipo: 0 = vida, 1 = cadência, 2 = bomba
ArrayList<PVector> powerups     = new ArrayList<PVector>();
ArrayList<Integer> powerupTipos = new ArrayList<Integer>();
ArrayList<Integer> powerupTimer = new ArrayList<Integer>();

boolean cadenciaAtiva        = false;
int     cadenciaTimer        = 0;
final int CADENCIA_DURACAO   = 420;
final int COOLDOWN_RAPIDO    = 6;
final int COOLDOWN_NORMAL    = 18;

color COR_PU_VIDA     = color(220, 60, 80);
color COR_PU_CADENCIA = color(80, 200, 255);
color COR_PU_BOMBA    = color(120, 80, 255);

// ---- ESTRELAS ----
int NUM_ESTRELAS = 120;
float[] estrelaX      = new float[NUM_ESTRELAS];
float[] estrelaY      = new float[NUM_ESTRELAS];
float[] estrelaTam    = new float[NUM_ESTRELAS];
int[]   estrelaBrilho = new int[NUM_ESTRELAS];

float alturaChao;
int   frameHeli = 0;

// ---- MENU ANIMAÇÃO ----
float menuHeliX       = -110;
float menuHeliDir     = 1;
float menuParaY       = 0;
boolean menuParaAtivo = false;
float menuParaX       = 0;
int   menuSelecao     = 0;

// Nebulosa animada
float[] nebX    = new float[6];
float[] nebY    = new float[6];
float[] nebR    = new float[6];
color[] nebC    = new color[6];
float nebPhase  = 0;

// Partículas do menu
float[] partX   = new float[30];
float[] partY   = new float[30];
float[] partVY  = new float[30];
float[] partAlf = new float[30];
color[] partCor = new color[30];

// ---- PALETA ----
color COR_CEU      = color(4, 6, 18);
color COR_CHAO     = color(22, 80, 14);
color COR_CHAO2    = color(10, 50, 6);
color COR_HELI     = color(140, 140, 160);
color COR_HELI2    = color(80, 80, 100);
color COR_HELICE   = color(210, 210, 230);
color COR_PARA_CAP = color(210, 60, 0);
color COR_PARA_BOD = color(140, 140, 160);
color COR_CANHAO   = color(50, 140, 40);
color COR_CANHAO2  = color(20, 80, 14);
color COR_TIRO     = color(255, 240, 100);
color COR_EXPLO1   = color(255, 140, 20);
color COR_EXPLO2   = color(255, 255, 80);
color COR_BRANCO   = color(240, 240, 255);
color COR_TEXTO    = color(140, 220, 150);
color COR_TITULO   = color(255, 230, 80);
color COR_VIDAS    = color(220, 60, 40);
color COR_AZUL     = color(80, 180, 240);
color COR_ROXO     = color(170, 90, 240);
color COR_VERDE_N  = color(60, 255, 130);
color COR_DOURADO  = color(255, 200, 60);


// =============================================
//   SETUP
// =============================================
void setup() {
  size(800, 600);
  smooth(4);
  imageMode(CENTER);
  rectMode(CORNER);
  somTiro     = new SoundFile(this, "gunshot.wav");
  somExplosao = new SoundFile(this, "explosion.wav");
  somVida     = new SoundFile(this, "plusLife.wav");
  somTiroRap  = new SoundFile(this, "moreshots.wav");
  Gameover  = new SoundFile(this, "Gameover.wav");
  Victory  = new SoundFile(this, "Victory.wav");
  bgMusic  = new SoundFile(this, "BgMusic.wav");
  bgMusic.loop();
  bgMusic.amp(0.3);
  

  imgInimigoCP = loadImage("paraquedista.png");
  imgInimigoSP = loadImage("bonequinho.png");
  imgHeli1     = loadImage("heli1.png");
  imgHeli2     = loadImage("heli2.png");
  imgPUVida    = loadImage("vida.png");
  imgPUBomba   = loadImage("bomba.png");
  imgPUTiro    = loadImage("TiroRap.png");
  imgLogo      = loadImage("Logo.png");
  imgVidaHUD   = loadImage("vidahud.png");

  alturaChao = height - 50;
  canhaoX    = width / 2;
  canhaoY    = alturaChao - 16;

  for (int i = 0; i < NUM_ESTRELAS; i++) {
    estrelaX[i]      = random(width);
    estrelaY[i]      = random(alturaChao - 20);
    estrelaTam[i]    = random(0.8, 2.8);
    estrelaBrilho[i] = (int) random(80, 255);
  }

  color[] pCores = {
    color(60, 0, 120, 40), color(0, 40, 120, 35),
    color(120, 30, 0, 30), color(0, 80, 80, 30),
    color(80, 0, 80, 25), color(0, 60, 120, 28)
  };
  for (int i = 0; i < 6; i++) {
    nebX[i] = random(width);
    nebY[i] = random(alturaChao * 0.6);
    nebR[i] = random(80, 180);
    nebC[i] = pCores[i];
  }

  for (int i = 0; i < 30; i++) resetParticula(i);
}

void resetParticula(int i) {
  partX[i]   = random(width);
  partY[i]   = random(height);
  partVY[i]  = random(-0.4, -0.1);
  partAlf[i] = random(30, 120);
  color[] ops = {COR_AZUL, COR_ROXO, COR_VERDE_N, COR_TITULO};
  partCor[i]  = ops[(int) random(ops.length)];
}


// =============================================
//   DRAW
// =============================================
void draw() {
  switch (estado) {
  case MENU:
    desenharMenu();
    break;
  case SEL_MODO:
    desenharSelModo();
    break;
  case JOGANDO:
    jogar();
    break;
  case GAMEOVER:
    desenharGameOver();
    break;
  case VITORIA:
    desenharVitoria();
    break;
  case CREDITOS:
    desenharCreditos();
    break;
  }
}


// =============================================
//   FUNDO ESPACIAL
// =============================================
void desenharFundoEspaco() {
  background(COR_CEU);
  nebPhase += 0.003;
  noStroke();
  for (int i = 0; i < 6; i++) {
    float pulse = 1.0 + 0.08 * sin(nebPhase + i * 1.1);
    float r     = nebR[i] * pulse;
    int   a     = (int)(alpha(nebC[i]) * (0.85 + 0.15 * sin(nebPhase + i)));
    color c     = color(red(nebC[i]), green(nebC[i]), blue(nebC[i]), a);
    for (float rr = r; rr > 0; rr -= r / 8.0) {
      float t_ = rr / r;
      fill(red(c), green(c), blue(c), alpha(c) * (1 - t_) * 0.6);
      ellipse(nebX[i], nebY[i], rr * 2, rr * 1.3);
    }
  }
  for (int i = 0; i < NUM_ESTRELAS; i++) {
    float scint = 0.7 + 0.3 * sin(frameCount * 0.03 + i * 0.7);
    float b     = estrelaBrilho[i] * scint;
    fill(b, b, b + 20);
    ellipse(estrelaX[i], estrelaY[i], estrelaTam[i], estrelaTam[i]);
  }
}


// =============================================
//   CHÃO
// =============================================
void desenharChao() {
  noStroke();
  for (int i = 0; i < 8; i++) {
    float t_ = i / 8.0;
    fill(lerpColor(color(30, 110, 20), COR_CHAO2, t_));
    rect(0, alturaChao + i * 6, width, 6);
  }
  fill(80, 200, 60, 160);
  rect(0, alturaChao - 2, width, 3);
  fill(60, 170, 50, 100);
  for (int i = 0; i < width; i += 12) rect(i, alturaChao - 3, 6, 3);
}


// =============================================
//   PARTÍCULAS FLUTUANTES
// =============================================
void Partículas() {
  noStroke();
  for (int i = 0; i < 30; i++) {
    partY[i] += partVY[i];
    if (partY[i] < -10) resetParticula(i);
    float a = partAlf[i] * (0.7 + 0.3 * sin(frameCount * 0.04 + i));
    fill(red(partCor[i]), green(partCor[i]), blue(partCor[i]), a);
    ellipse(partX[i], partY[i], 2, 2);
  }
}


// =============================================
//   MENU PRINCIPAL
// =============================================
void desenharMenu() {
  desenharFundoEspaco();
  Partículas();
  desenharChao();

  // Helicóptero animado no fundo
  menuHeliX += menuHeliDir * 1.6;
  if (menuHeliDir ==  1 && menuHeliX >  width + 120) {
    menuHeliDir = -1;
    menuHeliX =  width + 120;
  }
  if (menuHeliDir == -1 && menuHeliX < -120) {
    menuHeliDir =  1;
    menuHeliX = -120;
  }
  desenharHeliPixel(menuHeliX, 72, (int) menuHeliDir);

  // Paraquedista animado
  if (!menuParaAtivo && random(220) < 1) {
    menuParaAtivo = true;
    menuParaX     = random(120, width - 120);
    menuParaY     = 100;
  }
  if (menuParaAtivo) {
    menuParaY += 0.6;
    desenharParaPixel(menuParaX, menuParaY);
    if (menuParaY > alturaChao - 20) menuParaAtivo = false;
  }

  desenharCanhaoSmooth(width / 2, height - 58, -PI / 2);

  // Overlay escuro
  noStroke();
  fill(0, 0, 0, 155);
  rect(0, 0, width, height);

  // Logo
  blendMode(SCREEN);
  float logoW = 400;
  float logoH = logoW * (imgLogo.height / (float) imgLogo.width);
  image(imgLogo, width / 2, 105, logoW, logoH);
  blendMode(BLEND);

  fill(160, 165, 190, 210);
  textAlign(CENTER, CENTER);
  textSize(9);
  text("SABOTAGE  —  ATARI TRIBUTE", width / 2, 156);

  noStroke();
  fill(255, 255, 255, 35);
  rect(width / 2 - 150, 168, 300, 2);

  // Opções
  String[] opcoes    = {"START GAME", "CREDITS"};
  String[] subtextos = {"escolher modo de jogo", "equipe do projeto"};
  color[]  acents    = {color(61, 220, 132), color(78, 140, 255)};

  menuSelecao = constrain(menuSelecao, 0, 1);

  float itemH  = 72;
  float itemY0 = 230;

  for (int i = 0; i < opcoes.length; i++) {
    float iy    = itemY0 + i * itemH;
    boolean sel = (menuSelecao == i);

    if (sel) {
      noStroke();
      fill(red(acents[i]), green(acents[i]), blue(acents[i]), 18);
      rect(0, iy - 12, width, 52);
      fill(acents[i]);
      rect(width / 2 - 130, iy - 2, 3, 36);
      fill(acents[i]);
      int cx = width / 2 - 120;
      int cy = (int)(iy + 8);
      triangle(cx, cy, cx + 10, cy + 8, cx, cy + 16);
      fill(255);
      textSize(20);
    } else {
      noStroke();
      fill(70, 80, 115);
      textSize(20);
    }

    textAlign(CENTER, CENTER);
    text(opcoes[i], width / 2, iy + 10);

    if (sel) fill(red(acents[i]), green(acents[i]), blue(acents[i]), 180);
    else     fill(40, 50, 78);
    textSize(9);
    text(subtextos[i], width / 2, iy + 30);
  }

  // Rodapé
  fill(50, 58, 90, 200);
  textAlign(CENTER, CENTER);
  textSize(7);
  text("W / S   MOVER          ENTER   CONFIRMAR", width / 2, height - 70);

  fill(80, 200, 255, 150);
  textAlign(LEFT, CENTER);
  textSize(8);
  text("HI  " + nf(recordeArcade, 6), 14, 18);

  fill(255, 100, 150, 150);
  textAlign(RIGHT, CENTER);
  text("1UP  000000", width - 14, 18);
}

void entrarEstado(int novoEstado) {
  // Para tudo antes de trocar
  somTiro.stop();
  somExplosao.stop();
  Victory.stop();
  Gameover.stop();
  if (novoEstado == GAMEOVER || novoEstado == VITORIA) {
    bgMusic.stop();  // ← para a música de fundo
  } else {
    if (!bgMusic.isPlaying()) bgMusic.loop();  // ← retoma se voltou ao jogo/menu
  }


  if (novoEstado == GAMEOVER) Gameover.play();
  if (novoEstado == VITORIA)  Victory.play();


  estado = novoEstado;
}

// =============================================
//   CRÉDITOS
// =============================================
void desenharCreditos() {
  desenharFundoEspaco();
  Partículas();
  desenharChao();

  menuHeliX += menuHeliDir * 1.6;
  if (menuHeliDir ==  1 && menuHeliX >  width + 120) {
    menuHeliDir = -1;
    menuHeliX =  width + 120;
  }
  if (menuHeliDir == -1 && menuHeliX < -120) {
    menuHeliDir =  1;
    menuHeliX = -120;
  }
  desenharHeliPixel(menuHeliX, 72, (int) menuHeliDir);

  if (!menuParaAtivo && random(220) < 1) {
    menuParaAtivo = true;
    menuParaX     = random(120, width - 120);
    menuParaY     = 100;
  }
  if (menuParaAtivo) {
    menuParaY += 0.6;
    desenharParaPixel(menuParaX, menuParaY);
    if (menuParaY > alturaChao - 20) menuParaAtivo = false;
  }

  desenharCanhaoSmooth(width / 2, height - 58, -PI / 2);

  noStroke();
  fill(0, 0, 0, 155);
  rect(0, 0, width, height);

  blendMode(SCREEN);
  float logoW = 300;
  float logoH = logoW * (imgLogo.height / (float) imgLogo.width);
  image(imgLogo, width / 2, 80, logoW, logoH);
  blendMode(BLEND);

  fill(255, 255, 255, 220);
  textAlign(CENTER, CENTER);
  textSize(11);
  text("C R É D I T O S", width / 2, 128);

  noStroke();
  fill(255, 255, 255, 35);
  rect(width / 2 - 150, 140, 300, 2);

  String[] secTitulo = {"IGAC Int."};
  String[][] secNomes = {{
      "Miguel Andrade França dos Santos",
      "Miguel Othon Araújo Barbosa",
      "Emily Ialy Nunes Mineo",
      "Larissa Angelote Firmino",
      "Thamyres Beatriz Santos Medeiros"
  }};
  color[] secCores = {color(61, 220, 132)};

  float y = 175;
  for (int s = 0; s < secTitulo.length; s++) {
    fill(secCores[s]);
    textAlign(CENTER, CENTER);
    textSize(9);
    text(secTitulo[s], width / 2, y);
    y += 22;

    fill(red(secCores[s]), green(secCores[s]), blue(secCores[s]), 80);
    rect(width / 2 - 80, y - 8, 160, 1);
    y += 6;

    for (int n = 0; n < secNomes[s].length; n++) {
      fill(200, 205, 225, 220);
      textSize(12);
      text(secNomes[s][n], width / 2, y);
      y += 28;
    }
    y += 16;
  }

  fill(255, 255, 255, 20);
  rect(width / 2 - 150, y, 300, 2);
  y += 16;

  float pulse = 0.5 + 0.5 * sin(frameCount * 0.05);
  fill(160, 165, 190, (int)(180 * pulse));
  textSize(8);
  text("SABOTAGE  —  ATARI TRIBUTE  —  2025", width / 2, y + 10);

  fill(55, 65, 100);
  textSize(7);
  text("ESC   VOLTAR", width / 2, height - 70);
}


// =============================================
//   SELEÇÃO DE MODO
// =============================================
void desenharSelModo() {
  desenharFundoEspaco();
  Partículas();
  desenharChao();

  blendMode(SCREEN);
  float logoW = 260;
  float logoH = logoW * (imgLogo.height / (float) imgLogo.width);
  image(imgLogo, width / 2, 52, logoW, logoH);
  blendMode(BLEND);

  fill(160, 165, 190, 200);
  textAlign(CENTER, CENTER);
  textSize(13);
  text("SELECIONE O MODO DE JOGO", width / 2, 88);

  noStroke();
  fill(255, 255, 255, 35);
  rect(width / 2 - 180, 100, 360, 2);

  String[] nomes   = {"CLÁSSICO", "ARCADE", "CONTRA O TEMPO"};
  String[] linhas1 = {"5 ondas progressivas", "Ondas infinitas", "Missões com tempo limite"};
  String[] linhas2 = {"Vidas limitadas", "Foco em pontuação", "Objetivos específicos"};
  String[] linhas3 = {"Vitória ao completar tudo", "Bata seu recorde", "Complete 3 desafios"};
  String[] icones  = {"I", "II", "III"};
  color[]  cores   = {COR_TEXTO, COR_AZUL, COR_ROXO};

  int boxW   = 192;
  int boxH   = 220;
  int gap    = 22;
  int totalW = boxW * 3 + gap * 2;
  int startX = (width - totalW) / 2;
  int boxY   = 120;

  for (int i = 0; i < 3; i++) {
    int bx      = startX + i * (boxW + gap);
    boolean sel = (menuSelecao == i);
    float pulse = 0.5 + 0.5 * sin(frameCount * 0.05 + i * 1.2);

    fill(0, 0, 0, 100);
    rect(bx + 5, boxY + 5, boxW, boxH, 8);

    if (sel) {
      for (int row = 0; row < boxH; row++) {
        float t_ = row / (float) boxH;
        color c1 = lerpColor(
          color(red(cores[i]), green(cores[i]), blue(cores[i]), 55),
          color(red(cores[i]) * 0.3, green(cores[i]) * 0.3, blue(cores[i]) * 0.3, 25), t_);
        fill(c1);
        rect(bx, boxY + row, boxW, 1);
      }
    } else {
      fill(8, 10, 22, 210);
      rect(bx, boxY, boxW, boxH, 8);
    }

    noFill();
    if (sel) {
      strokeWeight(2);
      stroke(lerpColor(cores[i], COR_BRANCO, 0.35 * pulse));
      rect(bx, boxY, boxW, boxH, 8);
      strokeWeight(1);
      stroke(cores[i], 50);
      rect(bx + 3, boxY + 3, boxW - 6, boxH - 6, 6);
    } else {
      strokeWeight(1);
      stroke(50, 55, 80, 180);
      rect(bx, boxY, boxW, boxH, 8);
    }
    noStroke();

    float faixaA = sel ? (160 + 60 * pulse) : 60;
    fill(red(cores[i]), green(cores[i]), blue(cores[i]), faixaA);
    rect(bx, boxY, boxW, 4, 8, 8, 0, 0);

    textSize(sel ? 36 : 28);
    fill(sel ? lerpColor(cores[i], COR_BRANCO, 0.5 * pulse) : color(70, 75, 100));
    text(icones[i], bx + boxW / 2, boxY + 40);

    textSize(sel ? 15 : 13);
    fill(sel ? lerpColor(cores[i], COR_BRANCO, 0.3) : color(90, 95, 120));
    text(nomes[i], bx + boxW / 2, boxY + 76);

    fill(sel ? color(red(cores[i]), green(cores[i]), blue(cores[i]), 80) : color(30, 32, 50));
    rect(bx + 18, boxY + 88, boxW - 36, 1);

    fill(sel ? color(190, 195, 215) : color(65, 68, 90));
    textSize(10);
    text(linhas1[i], bx + boxW / 2, boxY + 108);
    text(linhas2[i], bx + boxW / 2, boxY + 124);
    text(linhas3[i], bx + boxW / 2, boxY + 140);

    if (sel) {
      float ba  = 130 + 90 * pulse;
      float bw_ = 100;
      float bh_ = 24;
      float bxx = bx + boxW / 2 - bw_ / 2;
      float byy = boxY + boxH - 36;
      fill(red(cores[i]), green(cores[i]), blue(cores[i]), ba * 0.25);
      rect(bxx, byy, bw_, bh_, 4);
      noFill();
      stroke(cores[i], ba);
      strokeWeight(1);
      rect(bxx, byy, bw_, bh_, 4);
      noStroke();
      fill(cores[i], ba);
      textSize(11);
      text("[ ENTER ]", bx + boxW / 2, byy + bh_ / 2);
    }
  }

  noStroke();
  fill(menuSelecao > 0 ? color(200, 205, 225, 200) : color(40, 42, 60, 120));
  triangle(startX - 14, boxY + boxH/2, startX - 28, boxY + boxH/2 - 10, startX - 28, boxY + boxH/2 + 10);

  fill(menuSelecao < 2 ? color(200, 205, 225, 200) : color(40, 42, 60, 120));
  triangle(startX + totalW + 14, boxY + boxH/2, startX + totalW + 28, boxY + boxH/2 - 10, startX + totalW + 28, boxY + boxH/2 + 10);

  fill(100, 105, 130, 200);
  textSize(12);
  text("< > ou A/D para navegar   ·   ENTER para confirmar   ·   ESC para voltar", width / 2, 346);

  desenharCanhaoSmooth(width / 2, height - 58, -PI / 2);
  textAlign(CENTER, CENTER);
}


// =============================================
//   JOGO
// =============================================
void jogar() {
  atualizarLogica();
  renderizar();
}

void atualizarLogica() {
  // Mover canhão
  if (keyPressed) {
    if (keyCode == LEFT  || key == 'a' || key == 'A') anguloCanao -= velAngulo;
    if (keyCode == RIGHT || key == 'd' || key == 'D') anguloCanao += velAngulo;
  }
  anguloCanao = constrain(anguloCanao, limiteMin, limiteMax);
  if (cooldownTiro > 0) cooldownTiro--;

  // Lógica por modo
  if      (modoJogo == MODO_CLASSICO) logicaClassico();
  else if (modoJogo == MODO_ARCADE)   logicaArcade();
  else if (modoJogo == MODO_TEMPO)    logicaTempo();

  // Mover helis
  for (int i = helis.size() - 1; i >= 0; i--) {
    PVector h = helis.get(i);
    h.x += velHeli * heliDirs.get(i);
    if (h.x > width + 110 || h.x < -110) {
      helis.remove(i);
      heliDirs.remove(i);
    }
  }

  // Spawn paras a partir dos helis
  float margemPara = 80;
  for (int i = 0; i < helis.size(); i++) {
    float hx = helis.get(i).x;
    if (random(1000) < 3.5 && hx > margemPara && hx < width - margemPara && paras.size() < 3) {
      paras.add(new PVector(hx, helis.get(i).y + 32));
    }
  }

  // Mover paras
  for (int i = paras.size() - 1; i >= 0; i--) {
    PVector p = paras.get(i);
    p.y += velPara;
    if (p.y >= alturaChao - 20) {
      paras.remove(i);
      if (modoJogo != MODO_TEMPO) {
        vidas--;
        if (vidas <= 0) {
        somTiro.stop();
        entrarEstado(GAMEOVER);
      }
     }
   }
 }

  // Mover tiros
  for (int i = tiros.size() - 1; i >= 0; i--) {
    PVector t  = tiros.get(i);
    PVector td = tirosDirs.get(i);
    t.x += td.x;
    t.y += td.y;
    if (t.y < 0 || t.x < 0 || t.x > width) {
      tiros.remove(i);
      tirosDirs.remove(i);
    }
  }

  // Colisão tiro x heli
  for (int t = tiros.size() - 1; t >= 0; t--) {
    PVector tp = tiros.get(t);
    for (int h = helis.size() - 1; h >= 0; h--) {
      PVector hp = helis.get(h);
      if (dist(tp.x, tp.y, hp.x, hp.y) < 50) {
        explosoes.add(new PVector(hp.x, hp.y));
        explosoesTimer.add(28);
        //somMorteInimigo.play();

        // Spawn power-up com chance ponderada por velocidade
        if (random(1) < 0.22) {
          float chanceBomba = constrain(map(velHeli, 2.0, 6.0, 0.10, 0.40), 0.10, 0.40);
          float roll = random(1);
          int tipo;
          if (roll < chanceBomba) {
            tipo = 2; // bomba
          } else if (roll < chanceBomba + 0.47) {
            tipo = 0; // vida
          } else {
            tipo = 1; // tiro rápido
          }
          powerups.add(new PVector(hp.x, hp.y));
          powerupTipos.add(tipo);
          powerupTimer.add(300);
        }

        helis.remove(h);
        heliDirs.remove(h);
        tiros.remove(t);
        tirosDirs.remove(t);
        pontuacao += 50;
        inimigosEliminados++;
        helisSalvos++;
        if (modoJogo == MODO_TEMPO && missaoTipo[missaoAtual] == 0) progressoMissao++;
        if (modoJogo == MODO_TEMPO && missaoTipo[missaoAtual] == 2) progressoMissao = pontuacao;
        verificarVitoria();
        break;
      }
    }
  }

  // Colisão tiro x para
  for (int t = tiros.size() - 1; t >= 0; t--) {
    if (t >= tiros.size()) continue;
    PVector tp = tiros.get(t);
    for (int p = paras.size() - 1; p >= 0; p--) {
      PVector pp = paras.get(p);
      if (dist(tp.x, tp.y, pp.x, pp.y) < 24) {
        explosoes.add(new PVector(pp.x, pp.y));
        explosoesTimer.add(18);
        paras.remove(p);
        tiros.remove(t);
        tirosDirs.remove(t);
        pontuacao += 10;
        parasSalvas++;
        if (modoJogo == MODO_TEMPO && missaoTipo[missaoAtual] == 1) progressoMissao++;
        if (modoJogo == MODO_TEMPO && missaoTipo[missaoAtual] == 2) progressoMissao = pontuacao;
        verificarVitoria();
        break;
      }
    }
  }

  // Atualizar explosões
  for (int i = explosoesTimer.size() - 1; i >= 0; i--) {
    explosoesTimer.set(i, explosoesTimer.get(i) - 1);
    if (explosoesTimer.get(i) <= 0) {
      explosoes.remove(i);
      explosoesTimer.remove(i);
    }
  }

  // Animação heli
  if (frameCount % 7 == 0) frameHeli = (frameHeli + 1) % 2;

  // Atualizar power-ups
  for (int i = powerups.size() - 1; i >= 0; i--) {
    PVector pu = powerups.get(i);
    pu.y += 1.8;
    powerupTimer.set(i, powerupTimer.get(i) - 1);
    if (pu.y >= alturaChao - 10) {
      aplicarPowerUp(powerupTipos.get(i));
      powerups.remove(i);
      powerupTipos.remove(i);
      powerupTimer.remove(i);
      continue;
    }
    if (powerupTimer.get(i) <= 0) {
      powerups.remove(i);
      powerupTipos.remove(i);
      powerupTimer.remove(i);
    }
  }

  // Cadência ativa
  if (cadenciaAtiva) {
    cadenciaTimer--;
    if (cadenciaTimer <= 0) {
      cadenciaAtiva  = false;
      cooldownMaximo = COOLDOWN_NORMAL;
    }
  }
}


// =============================================
//   LÓGICAS POR MODO
// =============================================
void logicaClassico() {
  if (!ondaAtiva) {
    pausaEntreOndas--;
    if (pausaEntreOndas <= 0) {
      ondaAtual++;
      if (ondaAtual > TOTAL_ONDAS) {
        entrarEstado(VITORIA);
        return;
      }
      iniciarOnda(ondaAtual);
    }
    return;
  }
  spawnTimer++;
  if (spawnTimer >= spawnIntervalo && inimigosEliminados < inimigosNecessarios) {
    spawnTimer = 0;
    spawnHeli();
  }
  if (inimigosEliminados >= inimigosNecessarios && helis.size() == 0 && paras.size() == 0) {
    ondaAtiva       = false;
    pausaEntreOndas = 150;
  }
}

void iniciarOnda(int onda) {
  inimigosNaOnda      = 0;
  inimigosEliminados  = 0;
  inimigosNecessarios = 3 + onda * 2;
  velHeli             = 2.0 + onda * 0.4;
  velPara             = 1.3 + onda * 0.15;
  spawnIntervalo      = max(70, 210 - onda * 28);
  ondaAtiva           = true;
}

void logicaArcade() {
  spawnTimer++;
  if (spawnTimer >= spawnIntervalo) {
    spawnTimer = 0;
    spawnHeli();
    if (spawnIntervalo > 85) spawnIntervalo -= 1;
    velHeli = min(6.0, velHeli + 0.02);
  }
  if (pontuacao > recordeArcade) recordeArcade = pontuacao;
}

void logicaTempo() {
  if (missaoConcluida) {
    celebracaoTimer--;
    if (celebracaoTimer <= 0) {
      missaoAtual++;
      if (missaoAtual >= MISSOES_TOTAL) {
        entrarEstado(VITORIA);
        return;
      }
      iniciarMissao(missaoAtual);
    }
    return;
  }
  spawnTimer++;
  if (spawnTimer >= spawnIntervalo) {
    spawnTimer = 0;
    spawnHeli();
  }
  timerMissao--;
  if (timerMissao <= 0 && !missaoConcluida) 
  somTiro.stop();
  entrarEstado(GAMEOVER);
}

void iniciarMissao(int m) {
  missaoTexto     = missaoNomes[m];
  metaMissao      = missaoMetas[m];
  progressoMissao = 0;
  helisSalvos     = 0;
  parasSalvas     = 0;
  timerMissao     = 1800;
  missaoConcluida = false;
  helis.clear();
  heliDirs.clear();
  paras.clear();
  tiros.clear();
  tirosDirs.clear();
}

void verificarVitoria() {
  if (modoJogo == MODO_TEMPO && !missaoConcluida && progressoMissao >= metaMissao) {
    missaoConcluida = true;
    celebracaoTimer = 120;
  }
}


// =============================================
//   POWER-UPS
// =============================================
void aplicarPowerUp(int tipo) {
  if (tipo == 0) {
    vidas = min(vidas + 1, 3);
    somVida.stop();
    somVida.play();
  } else if (tipo == 1) {
    cadenciaAtiva  = true;
    cadenciaTimer  = CADENCIA_DURACAO;
    cooldownMaximo = COOLDOWN_RAPIDO;
    somTiroRap.stop();
    somTiroRap.play();
  } else if (tipo == 2) {
    somExplosao.stop();
    somExplosao.play();
    // BOMBA — explode tudo na tela
    for (int i = helis.size() - 1; i >= 0; i--) {
      explosoes.add(new PVector(helis.get(i).x, helis.get(i).y));
      explosoesTimer.add(40);
      pontuacao += 50;
      inimigosEliminados++;
      if (modoJogo == MODO_TEMPO && missaoTipo[missaoAtual] == 0) progressoMissao++;
      if (modoJogo == MODO_TEMPO && missaoTipo[missaoAtual] == 2) progressoMissao = pontuacao;
    }
    for (int i = paras.size() - 1; i >= 0; i--) {
      explosoes.add(new PVector(paras.get(i).x, paras.get(i).y));
      explosoesTimer.add(28);
      pontuacao += 10;
      parasSalvas++;
      if (modoJogo == MODO_TEMPO && missaoTipo[missaoAtual] == 1) progressoMissao++;
      if (modoJogo == MODO_TEMPO && missaoTipo[missaoAtual] == 2) progressoMissao = pontuacao;
    }
    helis.clear();
    heliDirs.clear();
    paras.clear();
    verificarVitoria();
  }
}

void desenharPowerUp(float x, float y, int tipo, int timer) {
  float pulso = 0.6 + 0.4 * sin(frameCount * 0.12);
  color cor;
  if      (tipo == 0) cor = COR_PU_VIDA;
  else if (tipo == 1) cor = COR_PU_CADENCIA;
  else                cor = COR_PU_BOMBA;

  noStroke();
  fill(red(cor), green(cor), blue(cor), 80 * pulso);
  ellipse(x, y, 32, 32);

  if      (tipo == 0) image(imgPUVida, x, y, 60, 60);
  else if (tipo == 1) image(imgPUTiro, x, y, 60, 60);
  else                image(imgPUBomba, x, y, 60, 50);
}

void spawnHeli() {
  int dir  = (random(1) > 0.5) ? -1 : 1;
  float sx = (dir == 1) ? -90.0 : width + 90.0;
  float sy = random(55, 190);
  helis.add(new PVector(sx, sy));
  heliDirs.add(dir);
}


// =============================================
//   RENDERIZAÇÃO
// =============================================
void renderizar() {
  desenharFundoEspaco();
  desenharChao();

  for (int i = 0; i < helis.size(); i++)
    desenharHeliPixel(helis.get(i).x, helis.get(i).y, heliDirs.get(i));
  for (int i = 0; i < paras.size(); i++)
    desenharParaPixel(paras.get(i).x, paras.get(i).y);

  // Tiros
  for (int i = 0; i < tiros.size(); i++) {
    PVector t = tiros.get(i);
    noStroke();
    fill(COR_TIRO, 80);
    ellipse(t.x, t.y, 10, 10);
    fill(COR_TIRO);
    ellipse(t.x, t.y, 5, 5);
  }

  for (int i = 0; i < explosoes.size(); i++)
    desenharExplosao(explosoes.get(i).x, explosoes.get(i).y, explosoesTimer.get(i));

  for (int i = 0; i < powerups.size(); i++)
    desenharPowerUp(powerups.get(i).x, powerups.get(i).y, powerupTipos.get(i), powerupTimer.get(i));

  desenharCanhaoSmooth(canhaoX, canhaoY, anguloCanao);
  desenharHUD();

  if (modoJogo == MODO_CLASSICO) hudClassico();
  else if (modoJogo == MODO_TEMPO) hudTempo();
}


// =============================================
//   HUD PRINCIPAL
// =============================================
void desenharHUD() {
  noStroke();
  for (int y = 0; y < 40; y++) {
    float t_ = y / 40.0;
    fill(lerpColor(color(8, 10, 24), color(4, 6, 18), t_));
    rect(0, y, width, 1);
  }
  fill(255, 255, 255, 18);
  rect(0, 39, width, 1);

  // Pontuação
  fill(COR_TITULO);
  textAlign(LEFT, CENTER);
  textSize(18);
  text(nf(pontuacao, 6), 14, 20);
  fill(COR_TITULO, 90);
  textSize(8);
  text("PTS", 14, 32);

  // Nome do modo
  String[] nomesModo = {"CLASSICO", "ARCADE", "TEMPO"};
  color[]  coresModo = {COR_TEXTO, COR_AZUL, COR_ROXO};
  fill(coresModo[modoJogo], 200);
  textAlign(CENTER, CENTER);
  textSize(9);
  text(nomesModo[modoJogo], width / 2, 20);
  fill(coresModo[modoJogo], 60);
  rect(width / 2 - 28, 27, 56, 1);

  // Vidas — Clássico
  if (modoJogo == MODO_CLASSICO) {
    fill(COR_VIDAS, 120);
    textAlign(RIGHT, CENTER);
    textSize(8);
    text("VIDAS", width - 14, 32);
    for (int i = 0; i < vidas; i++) {
      float hx = width - 14 - (vidas - 1 - i) * 28;
      image(imgVidaHUD, hx, 20, 24, 24);
    }
  }

  // Vidas + Recorde — Arcade
  if (modoJogo == MODO_ARCADE) {
    fill(COR_VIDAS, 120);
    textAlign(RIGHT, CENTER);
    textSize(8);
    text("VIDAS", width - 40, 40);
    for (int i = 0; i < vidas; i++) {
      float hx = width - 14 - (vidas - 1 - i) * 28;
      image(imgVidaHUD, hx, 20, 100, 100);
    }
    fill(COR_DOURADO, 190);
    textAlign(RIGHT, CENTER);
    textSize(8);
    text("REC  " + nf(recordeArcade, 6), width - 40, 40);
  }

  // Cadência ativa
  if (cadenciaAtiva) {
    int puX = 14;
    int puY = 54;
    float pct  = (float) cadenciaTimer / CADENCIA_DURACAO;
    float barW = 80;
    noStroke();
    fill(COR_PU_CADENCIA, 200);
    rect(puX, puY - 7, 14, 14, 2);
    fill(255, 255, 255, 220);
    textAlign(CENTER, CENTER);
    textSize(9);
    text("»", puX + 7, puY);
    fill(20, 30, 50);
    rect(puX + 18, puY - 4, barW, 8, 3);
    fill(COR_PU_CADENCIA, 220);
    rect(puX + 18, puY - 4, barW * pct, 8, 3);
    fill(COR_PU_CADENCIA, 170);
    textAlign(LEFT, CENTER);
    textSize(8);
    text("TIRO RAPIDO", puX + 18 + barW + 6, puY);
  }
}

// ---- HUD Clássico ----
void hudClassico() {
  if (!ondaAtiva && ondaAtual > 0 && ondaAtual <= TOTAL_ONDAS) {
    fill(0, 0, 0, 160);
    rect(0, height / 2 - 36, width, 72);
    fill(0, 0, 0, 80);
    rect(160, height / 2 - 36, width - 320, 72, 6);
    fill(COR_VERDE_N);
    textAlign(CENTER, CENTER);
    textSize(22);
    text("ONDA " + ondaAtual + " CONCLUÍDA!", width / 2, height / 2 - 8);
    if (ondaAtual < TOTAL_ONDAS) {
      fill(COR_TEXTO, 200);
      textSize(13);
      text("próxima onda em breve...", width / 2, height / 2 + 14);
    }
  }
  if (!ondaAtiva && ondaAtual == 0) {
    fill(0, 0, 0, 140);
    rect(0, height / 2 - 30, width, 60);
    fill(COR_TITULO);
    textAlign(CENTER, CENTER);
    textSize(18);
    text("Onda 1 em breve...", width / 2, height / 2);
  }
  fill(COR_TEXTO, 180);
  textAlign(LEFT, CENTER);
  textSize(11);
  text("Onda " + ondaAtual + "/" + TOTAL_ONDAS, 12, 52);
  if (ondaAtiva) {
    int bw = 110, bx = 12, by = 61;
    fill(20, 24, 40);
    rect(bx, by, bw, 7, 3);
    float pct = (float) inimigosEliminados / max(1, inimigosNecessarios);
    fill(COR_VERDE_N, 200);
    rect(bx, by, (int)(bw * pct), 7, 3);
    fill(COR_TEXTO, 160);
    textSize(9);
    text(inimigosEliminados + "/" + inimigosNecessarios, bx + bw + 5, by + 3);
  }
}

// ---- HUD Tempo ----
void hudTempo() {
  fill(0, 0, 0, 160);
  rect(0, 38, width, 42);
  fill(COR_ROXO, 60);
  rect(0, 79, width, 2);

  fill(COR_BRANCO, 220);
  textAlign(LEFT, CENTER);
  textSize(11);
  text("Missão " + (missaoAtual + 1) + "/" + MISSOES_TOTAL + "  ·  " + missaoTexto, 14, 52);

  int bw = 280, bx = 14, by = 63;
  float pct = constrain((float) progressoMissao / max(1, metaMissao), 0, 1);
  fill(20, 22, 40);
  rect(bx, by, bw, 9, 4);
  fill(lerpColor(COR_VIDAS, COR_VERDE_N, pct), 220);
  rect(bx, by, (int)(bw * pct), 9, 4);
  fill(COR_BRANCO, 180);
  textSize(9);
  text(progressoMissao + "/" + metaMissao, bx + bw + 6, by + 4);

  int segs   = timerMissao / 60;
  int frames = timerMissao % 60;
  fill((segs < 10) ? COR_VIDAS : COR_TITULO);
  textAlign(RIGHT, CENTER);
  textSize(20);
  text(nf(segs, 2) + ":" + nf(frames / 6, 1), width - 14, 59);

  if (missaoConcluida) {
    fill(0, 0, 0, 190);
    rect(0, height / 2 - 46, width, 92);
    fill(COR_VERDE_N);
    textAlign(CENTER, CENTER);
    textSize(28);
    text("MISSÃO CONCLUÍDA!", width / 2, height / 2 - 10);
    if (missaoAtual < MISSOES_TOTAL - 1) {
      fill(COR_TITULO);
      textSize(14);
      text("Próxima missão...", width / 2, height / 2 + 18);
    }
  }
}


// =============================================
//   GAME OVER
// =============================================
void desenharGameOver() {
  desenharFundoEspaco();

  for (float r = max(width, height) * 0.8; r > 0; r -= 20) {
    float a = map(r, 0, max(width, height) * 0.8, 60, 0);
    fill(180, 20, 20, a);
    ellipse(width / 2, height / 2, r * 2, r * 1.6);
  }

  fill(6, 6, 16, 220);
  rect(80, 110, 640, 320, 10);
  stroke(COR_VIDAS, 180);
  strokeWeight(1.5);
  noFill();
  rect(80, 110, 640, 320, 10);
  noStroke();
  fill(COR_VIDAS);
  rect(80, 110, 640, 3, 10, 10, 0, 0);

  textAlign(CENTER, CENTER);
  fill(0, 0, 0, 160);
  textSize(64);
  text("GAME OVER", width / 2 + 4, 234);
  fill(COR_VIDAS, 200);
  textSize(64);
  text("GAME OVER", width / 2, 232);
  fill(COR_BRANCO);
  textSize(62);
  text("GAME OVER", width / 2, 230);

  fill(COR_VIDAS, 80);
  rect(180, 268, 440, 1);

  fill(COR_TITULO);
  textSize(22);
  text("Pontuação  " + pontuacao, width / 2, 292);

  if (modoJogo == MODO_ARCADE) {
    fill(COR_AZUL, 220);
    textSize(15);
    text("Recorde  ·  " + recordeArcade, width / 2, 318);
  }
  if (modoJogo == MODO_TEMPO) {
    fill(COR_ROXO, 220);
    textSize(15);
    text("Missão  " + (missaoAtual + 1) + " de " + MISSOES_TOTAL, width / 2, 318);
  }

  if (millis() % 900 < 560) {
    fill(COR_TEXTO, 220);
    textSize(14);
    text("ENTER  ·  jogar novamente", width / 2, 366);
    text("ESC  ·  menu principal", width / 2, 388);
  }
}


// =============================================
//   VITÓRIA
// =============================================
void desenharVitoria() {
  desenharFundoEspaco();

  noStroke();
  for (int i = 0; i < 20; i++) {
    float ang = frameCount * 0.04 + i * TWO_PI / 20;
    float r   = 140 + 30 * sin(frameCount * 0.03 + i * 0.5);
    float px_ = width / 2 + cos(ang) * r;
    float py_ = height / 2 - 30 + sin(ang) * r * 0.4;
    color[] cs = {COR_TITULO, COR_VERDE_N, COR_AZUL, COR_ROXO, COR_DOURADO};
    fill(cs[i % cs.length], 160 + (int)(80 * sin(frameCount * 0.08 + i)));
    ellipse(px_, py_, 5, 5);
  }

  fill(6, 16, 8, 220);
  rect(80, 160, 640, 260, 10);
  stroke(COR_VERDE_N, 180);
  strokeWeight(1.5);
  noFill();
  rect(80, 160, 640, 260, 10);
  noStroke();
  fill(COR_VERDE_N);
  rect(80, 160, 640, 3, 10, 10, 0, 0);

  textAlign(CENTER, CENTER);
  fill(0, 0, 0, 150);
  textSize(58);
  text("VITÓRIA!", width / 2 + 4, 254);
  fill(COR_VERDE_N, 200);
  textSize(58);
  text("VITÓRIA!", width / 2, 252);
  fill(COR_BRANCO);
  textSize(56);
  text("VITÓRIA!", width / 2, 250);

  fill(COR_VERDE_N, 80);
  rect(180, 282, 440, 1);

  fill(COR_TITULO);
  textSize(22);
  text("Pontuação Final  ·  " + pontuacao, width / 2, 306);

  if (millis() % 900 < 560) {
    fill(COR_TEXTO, 220);
    textSize(14);
    text("ENTER  ·  jogar novamente   ·   ESC  ·  menu", width / 2, 376);
  }
}


// =============================================
//   SPRITES
// =============================================
void desenharHeliPixel(float x, float y, int dir) {
  pushMatrix();
  translate(x, y);
  scale(-dir, 1);
  if (frameCount % 10 < 5) image(imgHeli1, 0, 0, 105, 85);
  else                      image(imgHeli2, 0, 0, 105, 85);
  popMatrix();
}

void desenharParaPixel(float x, float y) {
  if (alturaChao - y > 65) image(imgInimigoCP, x, y, 60, 82);
  else                      image(imgInimigoSP, x, y + 10, 60, 70);
}

void desenharCanhaoSmooth(float cx, float cy, float angulo) {
  noStroke();
  fill(0, 0, 0, 80);
  ellipse(cx + 3, cy + 26, 58, 14);

  fill(COR_CANHAO2);
  ellipse(cx - 18, cy + 20, 22, 22);
  ellipse(cx + 18, cy + 20, 22, 22);
  fill(COR_CEU);
  ellipse(cx - 18, cy + 20, 10, 10);
  ellipse(cx + 18, cy + 20, 10, 10);

  fill(COR_CANHAO);
  rect(cx - 28, cy - 4, 56, 20, 4);

  fill(COR_CANHAO);
  ellipse(cx, cy - 14, 34, 28);
  fill(COR_CANHAO2);
  rect(cx - 15, cy - 18, 30, 5, 2);

  float comp = 38;
  float pX2  = cx + cos(angulo) * comp;
  float pY2  = (cy - 16) + sin(angulo) * comp;
  stroke(COR_CANHAO2);
  strokeWeight(9);
  line(cx, cy - 16, pX2, pY2);
  stroke(COR_CANHAO);
  strokeWeight(6);
  line(cx, cy - 16, pX2, pY2);
  noStroke();

  fill(COR_CANHAO2);
  ellipse(pX2, pY2, 10, 10);
  fill(COR_CANHAO);
  ellipse(pX2, pY2, 7, 7);
}

void desenharExplosao(float ex, float ey, int timer) {
  noStroke();
  int maxTimer = 28;
  float prog   = 1.0 - (float) timer / maxTimer;
  for (int j = 0; j < 14; j++) {
    float ang = j * TWO_PI / 14 + prog * 0.5;
    float r   = prog * 52;
    float px_ = ex + cos(ang) * r;
    float py_ = ey + sin(ang) * r;
    float a   = (1 - prog) * 220;
    float sz  = (1 - prog) * 10 + 3;
    color c   = (timer > maxTimer / 2) ? COR_EXPLO2 : COR_EXPLO1;
    fill(red(c), green(c), blue(c), a);
    ellipse(px_, py_, sz, sz);
  }
  fill(255, 255, 200, (1 - prog) * 200);
  ellipse(ex, ey, (1 - prog) * 18, (1 - prog) * 18);
}


// =============================================
//   CONTROLES
// =============================================
void keyPressed() {
  if (estado == MENU) {
    if (key == ESC){
    key = 0;
    Victory.stop();
    Gameover.stop();
    }
    if (keyCode == UP   || key == 'w' || key == 'W') menuSelecao = (menuSelecao - 1 + 2) % 2;
    if (keyCode == DOWN || key == 's' || key == 'S') menuSelecao = (menuSelecao + 1) % 2;
    if (keyCode == ENTER) {
      if (menuSelecao == 0) {
        estado = SEL_MODO;
        menuSelecao = 0;
      } else {
        estado = CREDITOS;
      }
    }
    return;
  }

  if (estado == CREDITOS) {
    if (key == ESC) {
      key = 0;
      estado = MENU;
    }
    return;
  }

  if (estado == SEL_MODO) {
    if (key == ESC) {
      key = 0;
      estado = MENU;
      return;
    }
    if (keyCode == LEFT  || key == 'a' || key == 'A') menuSelecao = max(0, menuSelecao - 1);
    if (keyCode == RIGHT || key == 'd' || key == 'D') menuSelecao = min(2, menuSelecao + 1);
    if (keyCode == ENTER) {
      modoJogo = menuSelecao;
      resetarJogo();
      estado = JOGANDO;
    }
    return;
  }

  if (estado == GAMEOVER || estado == VITORIA) {
    if (keyCode == ENTER) {
      resetarJogo();
      estado = JOGANDO;
    }
    if (key == ESC) {
      key = 0;
      estado = MENU;
    }
    return;
  }

  if (estado == JOGANDO) {
    if (key == ' ' && cooldownTiro <= 0) {
      float dx = cos(anguloCanao) * velTiro;
      float dy = sin(anguloCanao) * velTiro;
      float pX = canhaoX + cos(anguloCanao) * 42;
      float pY = (canhaoY - 18) + sin(anguloCanao) * 42;
      tiros.add(new PVector(pX, pY));
      tirosDirs.add(new PVector(dx, dy));
      cooldownTiro = cooldownMaximo;
      somTiro.stop();
      somTiro.play();
    }
    if (key == ESC) {
      key = 0;
      estado = MENU;
    }
  }
}


// =============================================
//   RESET
// =============================================
void resetarJogo() {
  pontuacao      = 0;
  vidas          = 3;
  anguloCanao    = -PI / 2;
  spawnTimer     = 0;
  spawnIntervalo = 210;
  cooldownTiro   = 0;
  velHeli        = 2.0;
  velPara        = 1.3;

  tiros.clear();
  tirosDirs.clear();
  helis.clear();
  heliDirs.clear();
  paras.clear();
  explosoes.clear();
  explosoesTimer.clear();
  powerups.clear();
  powerupTipos.clear();
  powerupTimer.clear();
  Victory.stop();
  Gameover.stop();
  cadenciaAtiva  = false;
  cadenciaTimer  = 0;
  cooldownMaximo = COOLDOWN_NORMAL;

  ondaAtual           = 0;
  ondaAtiva           = false;
  pausaEntreOndas     = 90;
  inimigosNaOnda      = 0;
  inimigosEliminados  = 0;
  inimigosNecessarios = 0;

  missaoAtual     = 0;
  missaoConcluida = false;
  celebracaoTimer = 0;
  progressoMissao = 0;
  helisSalvos     = 0;
  parasSalvas     = 0;

  if (modoJogo == MODO_TEMPO) iniciarMissao(0);
}

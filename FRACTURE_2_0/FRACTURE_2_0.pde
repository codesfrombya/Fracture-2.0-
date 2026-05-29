int pontuacao = 0; 

// --- COISAS DO JOGADOR ---
float canhaoX = 400; 

// --- LISTAS PARA GUARDAR AS COISAS QUE SE MOVEM ---
ArrayList<Float> listaTirosX = new ArrayList<Float>();
ArrayList<Float> listaTirosY = new ArrayList<Float>();

ArrayList<Float> listaHelisX = new ArrayList<Float>();
ArrayList<Float> listaHelisY = new ArrayList<Float>();

ArrayList<Float> listaParasX = new ArrayList<Float>();
ArrayList<Float> listaParasY = new ArrayList<Float>();

// --- VARIÁVEIS PARA AS FOTOS ---
PImage fotoHeli1, fotoHeli2, fotoPara, fotoPara2; // NOVO: Guarda o sprite dele sem o paraquedas

// --- CONTROLADOR MANUAL DE ANIMAÇÃO ---
int frameAtualHeli = 1;

// --- CONFIGURAÇÃO DO CHÃO ---
float alturaChao = 560; 

void setup() {
  size(800, 600); 
  rectMode(CENTER); 
  imageMode(CENTER); 
  
  fotoHeli1 = loadImage("heli1.png");
  fotoHeli2 = loadImage("heli2.png");
  fotoPara = loadImage("paraquedista.png");
  fotoPara2 = loadImage("bonequinho.png"); // NOVO: Carrega seu sprite do chão
}

void draw() {
  background(180, 220, 255); 
  
  // --- DESENHAR O CHÃO ---
  fill(34, 177, 76); 
  noStroke();
  rect(width/2, alturaChao + 20, width, 40); 
  
  // --- ATUALIZA A ANIMAÇÃO DA HÉLICE A CADA 5 FRAMES ---
  if (frameCount % 5 == 0) {
    frameAtualHeli = (frameAtualHeli == 1) ? 2 : 1;
  }
  //-----------------------------------------//
  
  
  // === PARTE 1: MOVER E DESENHAR O CANHÃO ===
  if (keyPressed) {
    if (keyCode == LEFT || key == 'a' || key == 'A') canhaoX = canhaoX - 5; 
    if (keyCode == RIGHT || key == 'd' || key == 'D') canhaoX = canhaoX + 5; 
  }
  canhaoX = constrain(canhaoX, 25, 775); 
  
  fill(0, 100, 0); 
  rect(canhaoX, alturaChao - 10, 50, 20); 
  rect(canhaoX, alturaChao - 25, 10, 20); 
  
  // === PARTE 2: MOVER E DESENHAR OS TIROS ===
  fill(255);  
  for (int i = listaTirosY.size() - 1; i >= 0; i--) {
    float tiroY = listaTirosY.get(i) - 8; 
    listaTirosY.set(i, tiroY); 
    ellipse(listaTirosX.get(i), tiroY, 8, 8); 
    
    if (tiroY < 0) {
      listaTirosX.remove(i);
      listaTirosY.remove(i);
    }
  }
  
  // === PARTE 3: CRIAR E MOVER OS HELICÓPTEROS ===
  if (frameCount % 240 == 0) {
    listaHelisX.add(850.0); 
    listaHelisY.add(random(50, 150)); 
  }
  
  for (int i = listaHelisX.size() - 1; i >= 0; i--) {
    float heliX = listaHelisX.get(i) - 2; 
    listaHelisX.set(i, heliX); 
    float heliY = listaHelisY.get(i); 
    
    if (frameAtualHeli == 1) image(fotoHeli1, heliX, heliY, 150, 80); 
    else image(fotoHeli2, heliX, heliY, 150, 80);
    
    if (random(100) < 0.3) { 
      listaParasX.add(heliX); 
      listaParasY.add(heliY + 40); 
    }
    
    if (heliX < -100) {
      listaHelisX.remove(i);
      listaHelisY.remove(i);
    }
  }
  
  // === PARTE 4: MOVER E DESENHAR OS PARAQUEDISTAS ===
  for (int i = listaParasY.size() - 1; i >= 0; i--) {
    float paraX = listaParasX.get(i);
    float paraY = listaParasY.get(i);
    
    // NOVO: Verifica se o boneco tocou o chão (com uma folga física para os pés)
    boolean tocouOChao = (paraY >= alturaChao - 35); 
    
    if (!tocouOChao) { 
      // Se não tocou o chão, ele continua caindo e usa o sprite com paraquedas aberto
      paraY = paraY + 1.5; 
      listaParasY.set(i, paraY); 
      image(fotoPara, paraX, paraY, 95, 120);
    } else {
      // Se ele tocou o chão, ele para de cair e troca o desenho para o boneco LIMPO
      // Ajustamos ele para ficar bem em cima da grama. Ajustei o tamanho dele para 50x70 (ajuste se precisar)
      image(fotoPara2, paraX, alturaChao - 35, 120, 120); 
    }
  }
  
  // === PARTE 5: SISTEMA DE COLISÕES ===
  for (int t = listaTirosY.size() - 1; t >= 0; t--) {
    float tx = listaTirosX.get(t);
    float ty = listaTirosY.get(t);
    
    for (int h = listaHelisX.size() - 1; h >= 0; h--) {
      float hx = listaHelisX.get(h);
      float hy = listaHelisY.get(h);
      if (dist(tx, ty, hx, hy) < 50) {
        listaHelisX.remove(h); 
        listaHelisY.remove(h);
        listaTirosX.remove(t); 
        listaTirosY.remove(t);
        pontuacao += 30;       
        break;                 
      }
    }
    
    if (t < listaTirosY.size()) {
      for (int p = listaParasY.size() - 1; p >= 0; p--) {
        float px = listaParasX.get(p);
        float py = listaParasY.get(p);
        if (dist(tx, ty, px, py) < 40) {
          listaParasX.remove(p); 
          listaParasY.remove(p);
          listaTirosX.remove(t); 
          listaTirosY.remove(t);
          pontuacao += 10;       
          break;
        }
      }
    }
  }
  
  // === PARTE 6: PLACAR ===
  fill(0);          
  textSize(24);     
  textAlign(LEFT, TOP);
  text("PONTOS: " + pontuacao, 20, 20); 
}

void keyReleased() {
  if (key == ' ') { 
    listaTirosX.add(canhaoX); 
    listaTirosY.add(alturaChao - 35); 
  }
}

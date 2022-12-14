PImage pict;
//左クリックでジャンプします
Pipe[] pipes = new Pipe[1000];
Cloud[] cloud = new Cloud[1000];
Character character = new Character();
int time = 0;
int point = 0;
boolean gameover = false;

void setup() {
    size(960,540);
    colorMode(HSB,360,100,100);
    rectMode(CENTER);
    textAlign(CENTER);
    pict = loadImage("flappybird.png");
    for (int i = 0; i < pipes.length;i++) {
        pipes[i] = new Pipe(width + i*300);
        cloud[i] = new Cloud(width - 150 + (i-1)*300);
    }
}


void draw() {
    if(gameover) {
        background(210,100,100);
        fill(30,70,85);
        rect(width/2,height-40,width,80);
        for (int i = 0; i < pipes.length;i++) {
            cloud[i].display();
            pipes[i].display();
        }

        character.action();
        character.display();
        
        textSize(80);
        fill(0,0,0);
        text(point, width/2, 80);
        textSize(120);
        text("Game Over", width/2,height/2);
        textSize(50);
        text("Press ENTER to Restart",width/2, height/2 + 100);
        if(keyPressed) {
            if(key == ENTER) {
                point = 0;
                for(int i = 0; i < pipes.length;i++) {
                    pipes[i] = new Pipe(width + i*300);
                    cloud[i] = new Cloud(width - 150 + (i-1)*300);
                }
                character.x = 100;
                character.y = height/2;
                character.vy = 2;
                gameover = false;
                
            }
        }
    }else {
        time++;
        background(210,100,100);

        fill(30,70,85);
        rect(width/2,height-40,width,80);


        for (int i = 0; i < pipes.length;i++) {
            cloud[i].action();
            cloud[i].display();
            pipes[i].update();
            pipes[i].display();
        }

        character.action();
        character.display();

        for(int i = 0; i < pipes.length;i++) {
            if(character.x > pipes[i].x-1 && character.x < pipes[i].x + 1) {
                point = point + 1;
            }
        }
        textSize(80);
        fill(0,0,0);
        text(point, width/2, 80);
    }
}

class Pipe {
    //パイプのフィールド
    float x, y;
    float vx;
    color c;

    Pipe(int px) {
        x = px;
        y = random(75,height-75);
        vx = 2; //パイプの移動速度
        c = color(120,100,100);
    }

    void update() {
        x -= vx;
    }

    void display() {
        stroke(0,0,0);
        strokeWeight(5);
        fill(c);
        rect(x,y-75,100,50);
        rect(x,y+75,100,50);
        rect(x,(y-75-25)/2,60,(y-75-25));
        //(y-75-25) = 上のパイプの長さ
        rect(x,(y+75+25)+(height-(y+75+25))/2,60,(height-(y+75+25)));
        //(height-(y+75+25) = 下のパイプの長さ
    }
}

class Character {
    float x,y;
    float vx,vy;

    Character() {
        x = 100;
        y = height/2;
        vy = 2; //キャラクターが落ちるスピード
    }
    void action() {
        if(mousePressed && gameover != true) { //右クリックでジャンプ
            if(mouseButton == LEFT ) {
                vy = 2;
                y -= 4*vy;
                y = constrain(y,15,height-15);
            }
        }else{  
            y += vy;
            vy += 0.05;
            y = constrain(y,15,height-15);
        }
        for(int i = 0; i < pipes.length;i++) {
            if(character.x > pipes[i].x - 40 && character.x < pipes[i].x + 40) {
                if(character.y < pipes[i].y - 100 || character.y > pipes[i].y + 100) {
                    gameOver();
                }
            }
            if(character.x > pipes[i].x - 65 && character.x < pipes[i].x + 65) {
                if(character.y < pipes[i].y - 35 && character.y > pipes[i].y - 95 ) {
                    gameOver();
                }else
                if(character.y > pipes[i].y + 35 && character.y < pipes[i].y + 95 ) {
                    gameOver();
                }
            }
        }
    }

    void display() {
        image(pict,x-15,y-15,30,30);
    }
}

class Cloud {
    float x,y;
    float vx;
    color c;

    Cloud(float cx) {
        x = cx;
        y = random(100,height/2);
        vx = pipes[0].vx;
        c = color(0,0,100);
    }

    void action() {
        x -= vx;
    }

    void display() {
        stroke(0,0,0);
        strokeWeight(6);
        fill(c);
        rect(x,y,100,60);
    }
}

void gameOver() {
    character.vy = 5;
    for(int i = 0; i < pipes.length;i++) {
        pipes[i].vx = 0;
        cloud[i].vx = 0;
    }
    gameover = true;
    
}

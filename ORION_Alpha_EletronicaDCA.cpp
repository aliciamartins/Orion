#include <Wire.h>

//Endereço padrão para o I2C (WHO_AM_I)
const int IMU = 0x68;

//Variáveis dos sensores
float aX, aY, aZ, T, gX, gY, gZ;

//Variáveis dos sensores
float psi[10], phi[10], theta[10], p[10], q[10],r[10], t[10];
int i = 1;

void setup() {
  Serial.begin(9600);

  //Iniciando o sensor 
  Wire.begin();
  Wire.beginTransmission(IMU);
  Wire.write(0x6B);  //Endereço de Power Mananegement
  Wire.write(0);
  Wire.endTransmission(true);


  Wire.beginTransmission(IMU);
  Wire.write(0x1B); //Endereço da configuração do giroscópio
  Wire.write(0b00000000); //Escala do gisroscópio
  Wire.endTransmission(true);


  Wire.beginTransmission(IMU);
  Wire.write(0x1C); //Endereço da configuração do acelerômetro (GYRO_CONFIG)
  Wire.write(0b00000000); //Escala do acelerômetro (ACCEL_CONFIG)
  Wire.endTransmission(true);
}

void loop() {
  //Iniciando transmissão de dados
  Wire.beginTransmission(IMU);
  Wire.write(0x3B); //Endereço do inicio dos dados
  Wire.endTransmission(false);
  Wire.requestFrom(IMU, 14, true); //Solicita os dados do sensor

  //Armazena os dados coletados colocando dois bytes por vez dentro das variáveis
  aX = Wire.read() << 8 | Wire.read();
  aY = Wire.read() << 8 | Wire.read();
  aZ = Wire.read() << 8 | Wire.read();
  T  = Wire.read() << 8 | Wire.read();
  gX = Wire.read() << 8 | Wire.read();
  gY = Wire.read() << 8 | Wire.read();
  gZ = Wire.read() << 8 | Wire.read();


  //Converte os valores para unidades usuais
  aX = aX/16384;
  aY = aY/16384;
  aZ = aZ/16384;
  gX = gX/131;
  gY = gY/131;
  gZ = gZ/131;

  //Trapezio 
  i = i + 1;
  t[i] = millis()/1000;

  p[i] = gX;
  q[i] = gY;
  r[i] = gZ;


  psi[1] = 0;
  phi[1] = 0;
  theta[1] = 0;
  


  phi[i] = phi[i - 1] + ((t[i] - t[i - 1])*(p[i] + p[i-1])/2);
  theta[i] = theta[i - 1] + ((t[i] - t[i - 1])*(q[i] + q[i-1])/2);
  psi[i] = psi[i - 1] + ((t[i] - t[i - 1])*(r[i] + r[i-1])/2);


  //Imprime os valores
  Serial.print("aX: ");
  Serial.print(aX);
  Serial.print(" | ");
  Serial.print("aY: ");
  Serial.print(aY);
  Serial.print(" | ");
  Serial.print("aZ: ");
  Serial.print(aZ);
  Serial.print(" | ");
  Serial.print("gX: ");
  Serial.print(gX);
  Serial.print(" | ");
  Serial.print("gY: ");
  Serial.print(gY);
  Serial.print(" | ");
  Serial.print("gZ: ");
  Serial.print(gZ);
  Serial.println(" | ");

  Serial.print("phi: ");
  Serial.print(phi[i]);
  Serial.print(" | ");
  Serial.print("theta: ");
  Serial.print(theta[i]);
  Serial.print(" | ");
  Serial.print("psi: ");
  Serial.print(psi[i]);
  Serial.print(" | ");
  Serial.print("t: ");
  Serial.print(t[i]);
  Serial.println(" | ");
  Serial.println("");
  
  delay(2500);
}

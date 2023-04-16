
% ATTITUDE ESTIMATION USING GYRO-RATE

% ----- PARADO -----
dtp = importdata('PARADO_04_SILENCIO_placa_parada.txt');
norm_giro = 14.375;
norm_girox = deg2rad(dtp(:, 7)./norm_giro);
norm_giroy = deg2rad(dtp(:, 8)./norm_giro);
norm_giroz = deg2rad(dtp(:, 9)./norm_giro);

%Giro
ideal_girox = 0;
ideal_giroy = 0;
ideal_giroz = 0;
media_girox = mean(norm_girox);
media_giroy = mean(norm_giroy);
media_giroz = mean(norm_giroz);
desv_girox = ideal_girox - media_girox;
desv_giroy = ideal_giroy - media_giroy;
desv_giroz = ideal_giroz - media_giroz;


% ----- EM MOVIMENTO ------
dtm = importdata('1_MOVIMENTO.txt');

% Giro normalizado
norm_girox = deg2rad(dtm(:, 7)/norm_giro);
norm_giroy = deg2rad(dtm(:, 8)/norm_giro);
norm_giroz = deg2rad(dtm(:, 9)/norm_giro);

% Tempo
tempo_dtm = dtp(:,10);

cal_norm_girox = norm_girox + desv_girox;
cal_norm_giroy = norm_giroy + desv_giroy;
cal_norm_giroz = norm_giroz + desv_giroz;

% Rate gyro
% p = deg2rad(dtm(:,7)); %Vel. ang x-axis
% q = deg2rad(dtm(:,8)); %Vel. ang y-axis
% r = deg2rad(dtm(:,9)); %Vel. ang z-axis
% T = 1e-3;

p = cal_norm_girox;
q = cal_norm_giroy;
r = cal_norm_giroz;

% Initial conditions
fi = 0; %Phi [rad] x-axis
th = 0; %Theta [rad] y-axis
ps = 0; %Psi [rad] z-axis

% Prealocation
dfi = zeros(length(p),1); %Derivada de Phi
dth = zeros(length(p),1); %Derivada de Theta
dps = zeros(length(p),1); %Derivada de Psi

fiest = zeros(length(p),1); %Phi
thest = zeros(length(p),1); %Theta
psest = zeros(length(p),1); %Psi

for i = 1:length(p)
    %Derivada dos angulos de euler
    dfi(i) = p(i) + q(i)*sin(fi)*tan(th) + r(i)*cos(fi)*tan(th);
    dth(i) = q(i)*cos(fi) - r(i)*sin(fi);
    dps(i) = q(i)*(sin(fi)/cos(th)) + r(i)*(cos(fi)/cos(th));
    
    %Estimativa
    fiest(i) = fi + 1e-3*tempo_dtm(i)*dfi(i);
    thest(i) = th + 1e-3*tempo_dtm(i)*dth(i);
    psest(i) = ps + 1e-3*tempo_dtm(i)*dps(i);
    
    %Atualizacao
    fi = fiest(i);
    th = thest(i);
    ps = psest(i);
end


% rad -> deg
fiest = rad2deg(fiest);
thest = rad2deg(thest);
psest = rad2deg(psest);

% Visualizacao
figure(1);
plot(fiest,'k','linewidth',1.25); grid on;
xlabel('T [s]'); ylabel('Phi [deg]');
title('Phi estimado [deg] (eixo-x)','fontweight','bold');

figure(2);
plot(thest,'k','linewidth',1.25); grid on;
xlabel('T [s]'); ylabel('Theta [deg]');
title('Theta estimado [deg] (eixo-y)','fontweight','bold');

figure(3);
plot(psest,'k','linewidth',1.25); grid on;
xlabel('T [s]'); ylabel('Psi [deg]');
title('Psi estimado [deg] (eixo-z)','fontweight','bold');

figure(4);
plot(fiest,'r','linewidth',1.25);
hold on;
plot(thest,'g','linewidth',1.25); 
plot(psest,'b','linewidth',1.25); 
legend('\phi','\theta','\psi');
ylabel('Ângulo (°)'); xlabel('Delta Tempo (s)');
    

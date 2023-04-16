%% Attitude Determination

clear all
clc

% Dados de entrada - parado - ref (para medir sensibilidade)
file = 'parada.txt';                          %Situacao inicial de leitura
g_ref = readtable(file);                      %Dados de entrada


norm_giro = 14.375;
norm_girox = table2array(g_ref(:, 7))/norm_giro;
norm_giroy = table2array(g_ref(:, 8))/norm_giro;
norm_giroz = table2array(g_ref(:, 9))/norm_giro;

ideal_girox = 0;
ideal_giroy = 0;
ideal_giroz = 0;

media_girox = mean(norm_girox);
media_giroy = mean(norm_giroy);
media_giroz = mean(norm_giroz);
desv_girox = ideal_girox - media_girox;
desv_giroy = ideal_giroy - media_giroy;
desv_giroz = ideal_giroz - media_giroz;


% Dados de entrada em movimento
file = '90yzx.txt';
g = readtable(file);                      %Dados de entrada

% Normalizar os dados
norm_giro = 14.375;
norm_girox = table2array(g(:, 7))/norm_giro;
norm_giroy = table2array(g(:, 8))/norm_giro;
norm_giroz = table2array(g(:, 9))/norm_giro;

% Calibrar dados
cal_norm_gx = norm_girox + desv_girox;
cal_norm_gy = norm_giroy + desv_giroy;
cal_norm_gz = norm_giroz + desv_giroz;


% Integracao numerica

time_dt = table2array(g(:, 10));     % Intervalo de tempo
time(1) = time_dt(1);
for i = 2:length(time_dt)
    time(i) = time(i - 1) + time_dt(i);
end
time = time';                             % Tempo

%time = 1/1000;


psi(1) = 0;
phi(1) = 0;
theta(1) = 0;

for i = 2:length(time)
    
    psi(i) = psi(i - 1) + (((time(i) - time(i - 1))/1000)*(cal_norm_gz(i) + cal_norm_gz(i - 1))/2);
    phi(i) = phi(i - 1) + (((time(i) - time(i - 1))/1000)*(cal_norm_gx(i) + cal_norm_gx(i - 1))/2);
    theta(i) = theta(i - 1) + (((time(i) - time(i - 1))/1000)*(cal_norm_gy(i) + cal_norm_gy(i - 1))/2);

end




%{
figure(1)
plot(time/1000, psi)
figure
plot(time/1000, phi)
figure
plot(time/1000, theta)
%}

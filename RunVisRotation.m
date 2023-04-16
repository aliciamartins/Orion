
figure;
for ii = 1:length(psest)
    vist3euler(psest(ii),thest(ii), fiest(ii));
    pause(0.0001);
    clf('reset');
end

function vist3euler(angz,angy,angx)
%VIST3EULER retorna uma visualizacao da rotacao 321/ZYX 
% Metodo de rotacao: matriz de cossenos
% -> angz [deg] em torno do eixo z;
% -> angy [deg] em torno do eixo y;
% -> angz [deg] em torno do eixo x;
%vist3euler(20,15,-10)


%ANTI HORARIO POSITIVO
angz = -angz;
angy = -angy;
angx = -angx;

%----- ROTACAO EIXO Z
rz = [cosd(angz) sind(angz) 0;
    -sind(angz) cosd(angz) 0;
    0 0 1];

%plot rotacao z
%figure;
%quiver3(zeros(1,3),zeros(1,3),zeros(1,3),...
%    [-1 0 0],[0 -1 0],[0 0 1],1,'k','linewidth',1.5);
%axis equal; axis off; grid off;
%hold on;
%quiver3(zeros(1,3),zeros(1,3),zeros(1,3),...
%    [-1 0 0]*rz,[0 -1 0]*rz,[0 0 1]*rz,1,'b','linewidth',1.5);
%title('rot eixo z em relacao ao inicial');

%----- ROTACAO EIXO Y
ry = [cosd(angy) 0 -sind(angy); 
      0 1 0;
      sind(angy) 0 cosd(angy)];
%plot rotacao y em relacao ao z
%figure;
%quiver3(zeros(1,3),zeros(1,3),zeros(1,3),...
%    [-1 0 0]*rz,[0 -1 0]*rz,[0 0 1]*rz,1,'k','linewidth',1.5);
%axis equal; axis off; grid off;
%hold on;
%quiver3(zeros(1,3),zeros(1,3),zeros(1,3),...
%    [-1 0 0]*rz*ry,[0 -1 0]*rz*ry,[0 0 1]*rz*ry,1,'b','linewidth',1.5);
%title('rotacao eixo y em relacao ao z');


%----- ROTACAO EIXO X
rx = [1 0 0; 
    0 cosd(angx) sind(angx);
    0 -sind(angx) cosd(angx)];
%plot rotacao x em relacao a zy
%figure;
%quiver3(zeros(1,3),zeros(1,3),zeros(1,3),...
%    [-1 0 0]*rz*ry,[0 -1 0]*rz*ry,[0 0 1]*rz*ry,1,'k','linewidth',1.5);
%axis equal; axis off; grid off;
%hold on;
%quiver3(zeros(1,3),zeros(1,3),zeros(1,3),...
%    [-1 0 0]*rz*ry*rx,[0 -1 0]*rz*ry*rx,[0 0 1]*rz*ry*rx,1,...
%    'b','linewidth',1.5);
%title('rotacao eixo x em relacao ao zy');  

%ROTACOES SUCESSIVAS
r = rz*ry*rx;

%PLOT DO SISTEMA ROTACIONADO
quiver3(zeros(1,3),zeros(1,3),zeros(1,3),...
    [-1 0 0],[0 -1 0],[0 0 1],1,'k','linewidth',1.5)
axis equal; axis off; grid off;
axis([-1 1 -1 1 -1 1])
hold on;
quiver3(zeros(1,3),zeros(1,3),zeros(1,3),...
    [-1 0 0]*r,[0 -1 0]*r,[0 0 1]*r,1,'r','linewidth',1.5);
legend('Sistema Inercial','Sistema Sensor Gyro');
end

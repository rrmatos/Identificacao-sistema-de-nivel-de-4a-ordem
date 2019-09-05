identif; % parametros dado pelo aluno
para4nl; % gera os parametros dados pelo professor 
sim('liq4MA'); % experimento simuldado
inp = y1.signals.values(:,3);
out = y1.signals.values(:,2);
tam = length(inp);
vet = 0:2:100000;
tam1 = length(vet);
ent = idout.signals.values(:,1);
sysL = lsim(g, idout.signals.values(:,1),vet);
data_id = iddata(inp(1:floor(tam*0.8)),out(1:floor(tam*0.8)), 1); %falores de entrada e saída
data_val = iddata(inp(floor(tam*0.8):end),out(floor(tam*0.8):end), 1);
model_lin = iddata(sysL,ent, 1);
% Tirar a tendencia 
%data_id = model_lin;
data_id = detrend(data_id);
data_val = detrend(data_val);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Indentificação Função de Transferência
np = 4;
nz = 1;
model_tf = tfest(data_id,np,nz);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Identificação ARX
order_arx = [4 1 1];
model_arx = arx(data_id,order_arx); 
%H = tf([model_arx.A],[model_arx.B],1);
%Hc = d2c(H,'tustin');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Identificação ARX
order_armax = [4 4 1 1];
model_armax = armax(data_id,order_armax);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Identificação Output-Error (EO)
order_eo = [4 4 1];
model_eo = oe(data_id,order_eo);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Identificação Box-Jenkins (JB)
order_bj = [1 1 4 4 1];
model_bj = bj(data_id,order_bj);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%g
%Identificação State-Space (SS)
model_ss = ssest(data_id,4,'Form','canonical');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Lin_Analitica(PO,k12,k23,k34,k2,k4);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
compare(model_lin,model_tf, model_arx, model_armax, model_eo, model_bj, model_ss);
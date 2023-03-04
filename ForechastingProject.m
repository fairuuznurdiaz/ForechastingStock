clear all
clc;
data_protofolio_bank = readtable('Data_Protofolio_Coba.xlsx');
BABP_JK = data_protofolio_bank.BABP_JK;
BBCA_JK = data_protofolio_bank.BBCA_JK;
BBNI_JK = data_protofolio_bank.BBNI_JK;
data = [BABP_JK BBCA_JK BBNI_JK];
datarate = zeros(268,3);
% menghitung rate investment
for i = 1:268
    for j = 1:3
        datarate(i,j) = (data(i+1,j)-data(i,j))/data(i,j);
    end
end
mean = mean(datarate);
korelasi = cov(datarate);
eTrans = ones(1,3);
covar = 1/2*korelasi;
% misal x = BABP y = BBCA dan z = BBNI
syms x y z alfa beta miu gamma teta1 teta2 teta3 rho1 rho2 rho3
f = [x y z]*covar*[x;y;z];
g1 = eTrans*[x;y;z] - 15000000000;
g2 = -mean*[x;y;z] + 750000;
g3 = -x+teta1^2;
g4 = -y+teta2^2;
g5 = -z+teta3^2;
L = f - alfa * (g1+miu^2) - beta * (g2+gamma^2) - rho1*g3 - rho2*g4 - rho3*g5;
dL_dx = diff(L,x) == 0; 
dL_dy = diff(L,y) == 0;
dL_dz = diff(L,z) == 0;
dL_dalfa = diff(L,alfa) == 0; 
dL_dbeta = diff(L,beta) == 0;
dL_dmiu = diff(L,miu) == 0;
dL_gamma = diff(L,gamma) == 0;
dL_dteta1 = diff(L,teta1) == 0;
dL_dteta2 = diff(L,teta2) == 0;
dL_dteta3 = diff(L,teta3) == 0;
dL_drho1 = diff(L,rho1) == 0;
dL_drho2 = diff(L,rho2) == 0;
dL_drho3 = diff(L,rho3) == 0;
system = [dL_dx dL_dy dL_dz dL_dalfa dL_dbeta dL_dmiu dL_gamma dL_dteta1 dL_dteta2 dL_dteta3 dL_drho1 dL_drho2 dL_drho3];
[xval yval zval, alfaval betaval miueval gammaeval tetaeval1 tetaeval2 tetaeval3 rhoeval1 rhoeval2 rhoeval3] = solve(system, [x y z alfa beta miu gamma teta1 teta2 teta3 rho1 rho2 rho3], 'Real', true);
result_numerik = double([xval yval zval]);
unik = unique(result_numerik, 'rows', 'stable');
obj = zeros(length(unik),1);
disp('===========================================================================')
result_numerik_new = unik
disp('===========================================================================')

for i = 1:length(unik)
    stock = unik(i,:);
    obj(i,1) = stock*covar*stock';
end
fmaks = max(obj,[],1);
fmin = min(obj,[],1);
id_maks = find(obj == fmaks);
id_min = find(obj== fmin);
disp('===========================================================================')
disp(['Min  Rp ' num2str(fmin)]);
disp(['BBAP = Rp ' num2str(unik(id_min,1))]);
disp(['BBCA = Rp ' num2str(unik(id_min,2))]);
disp(['BBNI = Rp ' num2str(unik(id_min,3))]);

disp('===========================================================================')
disp(['Max  Rp ' num2str(fmaks)]);
disp(['BBAP = Rp ' num2str(unik(id_maks,1))]);
disp(['BBCA = Rp ' num2str(unik(id_maks,2))]);
disp(['BBNI = Rp ' num2str(unik(id_maks,3))]);

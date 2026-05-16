%% project part 2
clc; clear;
load("iddata-09.mat");

%% initializare date si plot 

t_sampling=id.Ts;
u_id=id.U;
y_id=id.Y;
u_val=val.U;
y_val=val.Y;

t_id=0:t_sampling:(length(u_id)-1)*t_sampling;
t_val=0:t_sampling:(length(u_val)-1)*t_sampling;

N_id=length(y_id);
N_val=length(y_val);

figure(1);
plot(t_id,u_id);
hold on;
plot(t_id,y_id);
title("Identification data");
legend("input","output");
figure(2);
plot(t_val,u_val);
hold on;
plot(t_val,y_val);
title("Validation data");
legend("input","output");

%%
max_na=6;  
max_m=3;

AMSE_id_pred=zeros(max_na,max_m);
AMSE_id_sim=zeros(max_na,max_m);
AMSE_val_sim=zeros(max_na,max_m);
AMSE_val_pred=zeros(max_na,max_m); 
% provizorii pana cand na si nb sunt diferite

for m=1:max_m
    for na=1:max_na
        nb=na;
        pow=powers_generator(na+nb,m);

        % IDENTIFICATION
        % pt fiecare m aven cate 6 na=nb si facem cate un theta pt fiecare
        % in total 6*6=36 thetauri
        Phi_id=[];
        Y_id=y_id(:);
        for k=1:N_id
            phi_k=phi_arx_generator(y_id,u_id,k,na,nb,m);
            Phi_id=[Phi_id; phi_k];
        end

        theta=Phi_id\Y_id;
        y_id_pred=Phi_id*theta;

        % simulation on id
        y_id_sim=zeros(N_id,1);
        for k=1:N_id
            phi_k=phi_arx_generator(y_id_sim,u_id,k,na,nb,m);
            y_id_sim(k)=phi_k*theta;
        end

        % PREDICTION on val
        %la fel pt fiecare m si cate 5 na=nb avem cate o predictie
        y_val_pred=zeros(N_val,1);
        for k=1:N_val
            phi_k=phi_arx_generator(y_val,u_val,k,na,nb,m);
            y_val_pred(k)=phi_k*theta;
        end

        % SIMULATION on val
        y_val_sim=zeros(N_val,1);
        for k=1:N_val
            phi_k=phi_arx_generator(y_val_sim,u_val,k,na,nb,m);
            y_val_sim(k)=phi_k*theta;
        end

        % ERRORS
        AMSE_id_pred(na,m)=mean((y_id-y_id_pred).^2);
        AMSE_id_sim(na,m)=mean((y_id-y_id_sim).^2);
        AMSE_val_pred(na,m)=mean((y_val-y_val_pred).^2);
        AMSE_val_sim(na,m)=mean((y_val-y_val_sim).^2);
        % formule alternative pt calcul MSE
        % AMSE_id_pred(na,m)=(1/length(y_id))*sum((y_id_pred-y_id).^2);
        % AMSE_id_sim(na,m)=(1/length(y_id))*sum((y_id_sim-y_id).^2);
%AMSE_val_pred(na,m)=(1/length(y_val))*sum((y_val_pred(1:length(y_val))-y_val).^2);
%AMSE_val_sim(na,m)=(1/length(y_val))*sum((y_val_sim(1:length(y_val))-y_val).^2);

        if (m==1&&na==1) 
            min_MSE_val_sim=AMSE_val_sim(na,m);
            min_MSE_val_pred=AMSE_val_pred(na,m);
            min_MSE_id_pred=AMSE_id_pred(na,m);
            min_MSE_id_sim=AMSE_id_sim(na,m);
        end

        if AMSE_id_pred(na,m)<=min_MSE_id_pred
            min_MSE_id_pred=AMSE_id_pred(na,m);
            id_pred_optimal_p=iddata(y_id_pred,u_id,t_sampling);
            id_sim_optimal_p=iddata(y_id_sim,u_id,t_sampling);
        end

        if AMSE_id_sim(na,m)<=min_MSE_id_sim
            min_MSE_id_sim=AMSE_id_sim(na,m);
            id_sim_optimal_s=iddata(y_id_sim,u_id,t_sampling);
            id_pred_optimal_s=iddata(y_id_pred,u_id,t_sampling);
        end

        if AMSE_val_sim(na,m)<=min_MSE_val_sim
            min_MSE_val_sim=AMSE_val_sim(na,m);
            val_pred_optimal_s=iddata(y_val_pred,u_val,t_sampling);
            val_sim_optimal_s=iddata(y_val_sim,u_val,t_sampling);
        end

        if AMSE_val_pred(na,m)<=min_MSE_val_pred
            min_MSE_val_pred=AMSE_val_pred(na,m);
            val_pred_optimal_p=iddata(y_val_pred,u_val,t_sampling);
            val_sim_optimal_p=iddata(y_val_sim,u_val,t_sampling);
        end

    end
end


%% IDENTIFICATION

%% Best model on identification (SIMULATION CRITERION) 
% (cele mai bune combinatii de na,nb,m dupa MSE_sim)

[minAMSE_id_sim,idx]=min(AMSE_id_sim(:));
[id_best_na_sim,id_best_m_sim]=ind2sub(size(AMSE_id_sim),idx);

fprintf('\nBest simulation model on id:\n');
fprintf('na = nb = %d\n',id_best_na_sim);
fprintf('m = %d\n',id_best_m_sim);
fprintf('MSE = %.6f\n',minAMSE_id_sim);

%% Compare plot on identification with the best fit (SIMULATION CRITERION)
figure(1);
compare(id,id_pred_optimal_s,id_sim_optimal_s);
title("Nonlinear ARX model on identification – simulation criterion");

%% Best model on identification (PREDICTION CRITERION) 
% (cele mai bune combinatii de na,nb,m dupa MSE_pred)

[minAMSE_id_pred,idx]=min(AMSE_id_pred(:));
[id_best_na_pred,id_best_m_pred]=ind2sub(size(AMSE_id_pred),idx);

fprintf('\nBest prediction model on id:\n');
fprintf('na = nb = %d\n',id_best_na_pred);
fprintf('m = %d\n',id_best_m_pred);
fprintf('MSE = %.6f\n',minAMSE_id_pred);

%% Compare plot on identification with the best fit (PREDICTION CRITERION)
figure(2);
compare(id,id_pred_optimal_p);
title("Nonlinear ARX model on identification – prediction criterion");


%% VALIDATION


%% Best model on validation (SIMULATION CRITERION)
% (cele mai bune combinatii de na,nb,m dupa MSE_sim)

[minAMSE_val_sim,idx]=min(AMSE_val_sim(:));
[val_best_na_sim,val_best_m_sim]=ind2sub(size(AMSE_val_sim),idx);

fprintf('\nBest simulation model on val:\n');
fprintf('na = nb = %d\n',val_best_na_sim);
fprintf('m = %d\n',val_best_m_sim);
fprintf('MSE = %.6f\n',minAMSE_val_sim);

%% Compare plot on validation with the best fit (SIMULATION CRITERION)
figure(1);
compare(val,val_pred_optimal_s,val_sim_optimal_s);
title("Nonlinear ARX model on validation – simulation criterion");

%% Best model on validation (PREDICTION CRITERION)
% (cele mai bune combinatii de na,nb,m dupa MSE_pred)

[minAMSE_val_pred,idx]=min(AMSE_val_pred(:));
[val_best_na_pred,val_best_m_pred]=ind2sub(size(AMSE_val_pred),idx);

fprintf('\nBest prediction model on val:\n');
fprintf('na = nb = %d\n',val_best_na_pred);
fprintf('m = %d\n',val_best_m_pred);
fprintf('MSE = %.6f\n',minAMSE_val_pred);

%% Compare plot on validation with the best fit (PREDICTION CRITERION)
figure(2);
compare(val,val_pred_optimal_p,val_sim_optimal_p);
title("Nonlinear ARX model on validation – prediction criterion");





%% Comparare AMSE on validation

% on simulation
figure(1);
hold on;
for m=1:max_m
    plot(1:max_na,AMSE_val_sim(:,m),'-o', 'LineWidth',1.5);
end
grid on;
xlabel('na = nb');
ylabel('Simulation AMSE');
legend(arrayfun(@(x) sprintf('m = %d', x), 1:max_m, 'UniformOutput', false));
title('Simulation AMSE vs model degree');

% on prediction
figure(2);
hold on;
for m=1:max_m
    plot(1:max_na,AMSE_val_pred(:,m),'-o','LineWidth',1.5);
end
grid on;
xlabel('na = nb');
ylabel('Prediction AMSE');
legend(arrayfun(@(x) sprintf('m = %d', x), 1:max_m, 'UniformOutput', false));
title('Prediction AMSE vs model degree');

%% AMSE MAP aceelasi lucru da ii imagine colorata( nu arata pre bine)
figure
imagesc(1:max_m,1:max_na,AMSE_val_sim)
xlabel('Polynomial degree m')
ylabel('na = nb')
colorbar
title('Simulation AMSE')

figure
imagesc(1:max_m,1:max_na,AMSE_val_pred)
xlabel('Polynomial degree m')
ylabel('na = nb')
colorbar
title('Prediction AMSE')

%% Acelasi lucru dar este suprafata (nu arata prea bine)

[MM,NA]= meshgrid(1:max_m,1:max_na);

figure(3);
surf(MM,NA,AMSE_val_sim);
xlabel('Polynomial degree m');
ylabel('na = nb');
zlabel('Simulation AMSE');
title('Simulation AMSE surface');
shading interp;

figure(4);
surf(MM,NA,AMSE_val_pred);
xlabel('Polynomial degree m');
ylabel('na = nb');
zlabel('Prediction AMSE');
title('Prediction AMSE surface');
shading interp;

%% Comparare MSE identification vs validation (SIMULATION)
% pentru cel mai bun caz de pe validare

na=val_best_na_sim;
nb=val_best_na_sim;
m=val_best_m_sim;

Phi_id_best=[];
for k=1:N_id
    phi_k=phi_arx_generator(y_id,u_id,k,na,nb,m);
    Phi_id_best=[Phi_id_best; phi_k];
end
theta_best=Phi_id_best\y_id(:);

y_id_pred_best=zeros(N_id,1);
for k=1:N_id
    phi_k=phi_arx_generator(y_id,u_id,k,na,nb,m);
    y_id_pred_best(k)=phi_k*theta_best;
end

y_val_sim_best=zeros(N_val,1);
for k=1:N_val
    phi_k=phi_arx_generator(y_val_sim_best,u_val,k,na,nb,m);
    y_val_sim_best(k)=phi_k*theta_best;
end

MSE_vector_id=(y_id_pred_best-y_id).^2;
MSE_vector_sim=(y_val_sim_best-y_val).^2;

figure(1);
hold on;
grid on;

plot(1:max_na,AMSE_id_sim(:,val_best_m_sim),'r-o','LineWidth',1.5);
plot(1:max_na,AMSE_val_sim(:,val_best_m_sim),'b-o','LineWidth',1.5);
legend('MSE on identification','MSE on validation');
xlabel('Model order na = nb');
ylabel('AMSE');
title('MSE identification and validation for simulation');

%% Comparare MSE identification vs validation (PREDICTION)
% pentru cel mai bun caz de pe validare

na=val_best_na_pred;
nb=val_best_na_pred;
m=val_best_m_pred;

Phi_id_best=[];
for k=1:N_id
    phi_k=phi_arx_generator(y_id,u_id,k,na,nb,m);
    Phi_id_best=[Phi_id_best; phi_k];
end
theta_best=Phi_id_best\y_id(:);

y_id_pred_best=zeros(N_id,1);
for k = 1:N_id
    phi_k=phi_arx_generator(y_id,u_id,k,na,nb,m);
    y_id_pred_best(k)=phi_k*theta_best;
end

y_val_pred_best=zeros(N_val,1);
for k=1:N_val
    phi_k=phi_arx_generator(y_val,u_val,k,na,nb,m);
    y_val_pred_best(k)=phi_k*theta_best;
end

MSE_vector_id=(y_id_pred_best-y_id).^2;
MSE_vector_val=(y_val_pred_best-y_val).^2;

figure(2);
hold on;
grid on;
plot(1:max_na,AMSE_id_pred(:,val_best_m_pred),'r-o','LineWidth',1.5);
plot(1:max_na,AMSE_val_pred(:,val_best_m_pred),'b-o','LineWidth',1.5);
legend('MSE on identification','MSE on validation');
xlabel('Model order na = nb');
ylabel('AMSE');
title('MSE identification and validation for prediction');

%% Functii generare phi

function phi_k=phi_arx_generator(y,u,k,na,nb,m)

    d=zeros(1,na+nb);
    for i=1:na
        if k-i>0
            d(i)=y(k-i);
        end
    end

    for j=1:nb
        if k-j>0
            d(na+j)=u(k-j);
        end
    end
    phi_k=[1 d];

    if m>=2
        for i=1:length(d)
            for j=i:length(d)
                phi_k=[phi_k d(i)*d(j)];
            end
        end
    end

    if m>=3
        for i=1:length(d)
            for j=i:length(d)
                for l=j:length(d)
                    phi_k=[phi_k d(i)*d(j)*d(l)];
                end
            end
        end
    end

end

% generarea unui tabel de exponenți
function pow=powers_generator(p,m)
    pow=zeros(1,p);
    for i=1:p
        e=zeros(1,p);
        e(i)=1;
        pow=[pow;e];
    end
    if m>=2
        for i=1:p
            for j=i:p
                e=zeros(1,p); e(i)=e(i)+1; e(j)=e(j)+1;
                pow=[pow;e];
            end
        end
    end
    if m>=3
        for i=1:p
            for j=i:p
                for k=j:p
                    e=zeros(1,p); e(i)=e(i)+1; e(j)=e(j)+1; e(k)=e(k)+1;
                    pow=[pow;e];
                end
            end
        end
    end
end

% generarea phi cu ajutorul tabelului de exponenți
% mai bun pentru alte valori ale lui m 
function phi_k=powers_phi_arx_generator(y,u,k,na,nb,pow)

    d=zeros(1,na+nb);
    for i=1:na
        if (k-i)>0
            d(i)=y(k-i);
        end
    end

    for j=1:nb
        if (k-j)>0
            d(na+j)=u(k-j);
        end
    end

    phi_k=zeros(1,size(pow,1));
    for r=1:size(pow,1)
        phi_k(r)=prod(d.^pow(r,:));
    end

end

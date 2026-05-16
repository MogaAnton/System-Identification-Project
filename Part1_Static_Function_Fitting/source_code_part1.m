%% project part 1

% initialise variables
clc
clear
load('proj_fit_02');

n=3;

X1_id=id.X{1};
X2_id=id.X{2};
N1_id=length(X1_id);
N2_id=length(X2_id);

mesh(X1_id,X2_id,id.Y);

%copiaza linia x1_id de 41 de ori, adica face o matrice de 41 pe 41
[X1_id_grid, X2_id_grid] = meshgrid(X1_id, X2_id);

% stack-eaza coloanele una peste alta / vectorizeaza
X1_id_vec = X1_id_grid(:);
X2_id_vec = X2_id_grid(:);

% same here / vectorizeaza Y_id
Y_id=[];
for i=1:N1_id
    Y_id=[Y_id ; id.Y(:,i)];
end

% genereaza Phi mare coloana cu coloana
big_phi_id=[];

for i=0:n
    for j=0:n-i
        x=(X1_id_vec.^i).*(X2_id_vec.^j);
        big_phi_id=[big_phi_id, x];
    end
end

% afla theta
Theta=big_phi_id\Y_id;

% aflam y_aprox_id
y_aprox_id=big_phi_id*Theta;

%comparing the shapes
y_aprox_id_matrix=reshape(y_aprox_id,N1_id,N2_id);%readuce la forma de matrice

figure(2);
mesh(X1_id,X2_id,y_aprox_id_matrix);

figure(3)
surf(X1_id, X2_id, id.Y,'FaceColor', 'blue', 'EdgeAlpha', 0.1, 'FaceAlpha', 0.4);
hold on;
surf(X1_id, X2_id, y_aprox_id_matrix,'FaceColor', 'red', 'EdgeAlpha', 0.3, 'FaceAlpha', 0.7);

%calc mse pe identificare
suma=0;
for i=1:length(Y_id)
   suma=suma + (y_aprox_id(i)-Y_id(i))^2;
end
MSE= 1/length(Y_id)*suma;
MSE

%% for validation set

%initializare date
X1_val=val.X{1};
X2_val=val.X{2};
N1_val=length(X1_val);
N2_val=length(X2_val);

mesh(X1_val,X2_val,val.Y);

[X1_val_grid, X2_val_grid] = meshgrid(X1_val, X2_val);


X1_val_vec = X1_val_grid(:);
X2_val_vec = X2_val_grid(:);

Y_val_vec=val.Y(:);

%calc phi mare pt validare
big_phi_val=big_phi_generator(n,X1_val_vec,X2_val_vec);

y_aprox_val=big_phi_val*Theta;

%comparing the shapes
y_aprox_val_matrix=reshape(y_aprox_val,N1_val,N2_val);
figure(2);

mesh(X1_val,X2_val,y_aprox_val_matrix);

figure(3)
surf(X1_val, X2_val, val.Y,'FaceColor', 'blue', 'EdgeAlpha', 0.1, 'FaceAlpha', 0.4);
hold on;

surf(X1_val, X2_val, y_aprox_val_matrix,'FaceColor', 'red', 'EdgeAlpha', 0.3, 'FaceAlpha', 0.7);

%calc mse validare
suma=0;
for i=1:length(Y_val_vec)
   suma=suma + (y_aprox_val(i)-Y_val_vec(i))^2;
end
MSE_val= 1/length(Y_val_vec)*suma;
MSE_val

%% aflam n optim

% am ales gradul maxim 15 pentru a scapa de warning: rank defficiency

%am mai gasit si o varianta mai rapida de a forma big_phi_id cu suma gauss

%vectors to store MSE values
MSE_vector_val=zeros(15,1);
MSE_vector_id=zeros(15,1);

%to store the approximated outputs
date_id= zeros(N1_id*N2_id,15);
date_val= zeros(N1_val*N2_val,15);

% Y vectorizat in alta metoda
Y_id_vec=id.Y(:);
Y_val_vec=val.Y(:);

for k=1:15
    
    n=k;

    % obtaining the model for each n
    big_phi_id=optimised_big_phi_generator(n,X1_id,X2_id);
    
    Theta=big_phi_id\Y_id_vec;
    
    y_aprox_id=big_phi_id*Theta;
    date_id(:,k)=y_aprox_id;

    %mse pt id
    suma=0;
    for i=1:length(Y_id_vec)
        suma=suma + (y_aprox_id(i)-Y_id_vec(i))^2;
    end
    MSE_vector_id(k) = 1/length(Y_id)*suma;

    %vadidare

    big_phi_val=element_wise_big_phi_generator(n,X1_val,X2_val);

    y_aprox_val=big_phi_val*Theta;
    date_val(:,k)=y_aprox_val;

    %mse val
    suma=0;
    for i=1:length(Y_val_vec)
        suma=suma + (y_aprox_val(i)-Y_val_vec(i))^2;
    end
    MSE_vector_val(k)= 1/length(Y_val_vec)*suma;

end

%find the smallest MSE value on the validation set
[~,n_min]=min(MSE_vector_val);
n_min

%% plotting the best approx on the id set
n=1:15;
figure(1)
hold on;
plot(n,MSE_vector_id,'r');grid;
plot(n,MSE_vector_val,'b');
legend("MSE on identification","MSE on validation")

figure(2)
mesh(X1_id,X2_id,id.Y);

y_aprox_id_matrix=reshape(date_id(:,n_min),N1_id,N2_id);
figure(3);

mesh(X1_id,X2_id,y_aprox_id_matrix);

figure(4)
surf(X1_id,X2_id,id.Y,'FaceColor', 'blue', 'EdgeAlpha', 0.1, 'FaceAlpha', 0.4);
hold
surf(X1_id,X2_id,y_aprox_id_matrix,'FaceColor', 'red', 'EdgeAlpha', 0.3, 'FaceAlpha', 0.7);

%% plotting the best approximation for validation
n=1:15;
figure(1)
hold on;
plot(n,MSE_vector_id,'r');grid;
plot(n,MSE_vector_val,'b');
legend("MSE on identification","MSE on validation")

figure(2)
mesh(X1_val,X2_val,val.Y);

y_aprox_val_matrix=reshape(date_val(:,n_min),N1_val,N2_val);
figure(3);

mesh(X1_val,X2_val,y_aprox_val_matrix);

figure(4)
surf(X1_val,X2_val,val.Y,'FaceColor', 'blue', 'EdgeAlpha', 0.1, 'FaceAlpha', 0.4);
hold
surf(X1_val,X2_val,y_aprox_val_matrix,'FaceColor', 'red', 'EdgeAlpha', 0.3, 'FaceAlpha', 0.7);


%% calculare n optim varianta fara vectori de date

MSE_vector_val=zeros(15,1);
MSE_vector_id=zeros(15,1);
n_optim=1;
for k=1:15

    n=k;

    big_phi_id=[];

    for i=0:n
        for j=0:n-i
            x=(X1_id_vec.^i).*(X2_id_vec.^j);
            big_phi_id=[big_phi_id, x];
        end
    end

    Theta=big_phi_id\Y_id_vec;

    y_aprox_id=big_phi_id*Theta;

    suma=0;
    for i=1:length(Y_id_vec)
        suma=suma + (y_aprox_id(i)-Y_id_vec(i))^2;
    end
    MSE_vector_id(k) = 1/length(Y_id)*suma;

    %vadidare
    big_phi_val=[];

    for i=0:n
        for j=0:n-i
            x=(X1_val_vec.^i).*(X2_val_vec.^j);
            big_phi_val=[big_phi_val, x];
        end
    end

    y_aprox_val=big_phi_val*Theta;

    suma=0;
    for i=1:length(Y_val_vec)
        suma=suma + (y_aprox_val(i)-Y_val_vec(i))^2;
    end
    MSE_vector_val(k)= 1/length(Y_val_vec)*suma;

    if k==1
        MSE_n_optim=MSE_vector_val(k);
        n_optim=k;
        y_aprox_val_n_optim=y_aprox_val;
    end

    if MSE_vector_val(k)<MSE_n_optim
        MSE_n_optim=MSE_vector_val(k);
        n_optim=k;
        y_aprox_val_n_optim=y_aprox_val;
    end
end
n_optim
MSE_n_optim


figure(1)
hold on;
plot(MSE_vector_id,'r');grid;
plot(MSE_vector_val,'b');
legend("MSE on identification","MSE on validation")

figure(2)
surf(X1_val, X2_val, val.Y,'FaceColor', 'blue', 'EdgeAlpha', 0.1, 'FaceAlpha', 0.4);
hold on;
y_aprox_val_n_optim=reshape(y_aprox_val_n_optim,N1_val,N2_val);
surf(X1_val, X2_val, y_aprox_val_n_optim,'FaceColor', 'red', 'EdgeAlpha', 0.3, 'FaceAlpha', 0.7);


%% functii generare big_phi

function [big_phi_matrix] = big_phi_generator(degree,input1,input2)
    
    big_phi_matrix=[];

    for i=0:degree
        for j=0:degree-i
            x=(input1.^i).*(input2.^j);
            big_phi_matrix=[big_phi_matrix, x];
        end
    end

end

% a more time efficient method
function [big_phi_matrix] = optimised_big_phi_generator(degree,input1,input2)
    
    size=(degree+1)*(degree+2)/2;
    big_phi_matrix=zeros(length(input1)*length(input2),size);
    
    contor=1;

    [input1_grid, input2_grid] = meshgrid(input1, input2);
    input1_vec=input1_grid(:);
    input2_vec=input2_grid(:);

    for i=0:degree
       for j=0:degree-i
          x=(input1_vec.^i).*(input2_vec.^j);
          big_phi_matrix(:,contor)=x;
          contor=contor+1;
       end
    end

end

% another way: element by element
function [big_phi_matrix] = element_wise_big_phi_generator(degree,input1,input2)

    size=(degree+1)*(degree+2)/2;
    big_phi_matrix=zeros(length(input1)*length(input2),size);

    [input1_grid, input2_grid] = meshgrid(input1, input2);
    input1_vec=input1_grid(:);
    input2_vec=input2_grid(:);

    for k=1:(length(input1)*length(input2))
        
        index=0;
        for i=0:degree
            for j=0:degree-i
                index=index+1;
                term=input1_vec(k)^i*input2_vec(k)^j;
                big_phi_matrix(k,index)=term;
            end
        end

    end

end
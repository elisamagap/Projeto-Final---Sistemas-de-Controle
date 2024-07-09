%% Sistemas de Controle I
%% Entrega 1 - Motor DC
% Grupo: Elisa Magalhães Pinto (13673468)
%        Emilio de Castro van Leggelo (13673520)
%        Gustavo Florida Defant (13673364)
%        João Vitor Forner (13673385)
%        Rafael Basaglia Gimenez (13673430)

clear all
close all
clc

%% Modelagem do motor
% Definindo parâmetros do motor ===========================================

R = .179;            % Resistência [ohm] = [(kg.m^2)/(s^3.A^2)]
L = .0456 * 10^-3;   % Indutância [mH] -> [H] = [(kg.m^2)/(s^2.A^2)]
J = 35.1 * 10^-7;    % Inércia do Rotor [g.cm^2] -> [kg.m^2]
c = 5.4096 * 10^-6;  % Coeficiente de fricção do rotor 
kt = 12 * 10^-3;     % Cte de torque [mNm/A] -> [Nm/A] = [(kg.m^2)/(s^2.A)]
kv = 797 * (pi/30);  % Cte de velocidade [rpm/V]->[(rad.s^2.A)/(kg.m^2)]
ke = 1/kv;           % Cte de força eletromotriz [V/rpm]-> [(kg.m^2)/(s^2.A.rad)]

% Espaço de Estados =======================================================

A = [-R/L -ke/L;
    kt/J -c/J];

B = [1/L 0;
    0 -1/J];

C = [1 0;
    0 1];

[rows_C, ~] = size(C);     % Número de linhas de C
[~, columns_B] = size(B);  % Número de colunas de B

D = zeros(rows_C, columns_B);

model = ss(A, B, C, D); 

% Entradas ================================================================

Va = 10 * ones(10000, 1);          % entrada de tensão constante e igual a 10V ao longo de todo o período de simulação
tau = .091 * ([zeros(5000, 1); ...
                ones(5000, 1)]);   % torque externo aplicado na ponta do eixo, entrada degrau a partir da metade da simulação
time = linspace(0, 20, 10000)';    % transposto, define o tempo como indo de 0 a 20s com 10000 pontos de medição. Metade da simulação t=10s

% Plot entradas ===========================================================

figure(1)
subplot(2, 1, 1);
plot(time, Va, '-b', 'LineWidth', 1.5)
xlabel('Time [s]')
ylabel('Va [V]')
title('Tensão na armadura (V_a) vs Tempo')
grid on

subplot(2, 1, 2);
plot(time, tau, '-r', 'LineWidth', 1.5)
xlabel('Time [s]')
ylabel('\tau [Nm]')
title('Torque aplicado na ponta do eixo (\tau) vs Tempo')
grid on

% Plot saídas =============================================================

[y, t] = lsim(model, [Va tau], time);           % Simular a resposta no tempo do modelo de espaaço de estados, com as entradas [Va tau] do mesmo comprimento que o vetor de tempo time. Ignorei o x em [y, t, x] pois ele não será relevante na análise

figure(2);
subplot(2, 1, 1);
    plot(t, y(:, 1), '-b', 'LineWidth', 1.5);   % A 1ª coluna de y refere-se a saída para corrente, determinado pela matriz C
    xlabel('Tempo [s]');
    xlim([-0.1 inf]);
    ylabel('Corrente [A]');
    ylim([-2 45]);
    title('Resposta da Corrente no Tempo');
    grid on;

subplot(2, 1, 2);
    plot(t, y(:, 2), '-r', 'LineWidth', 1.5);
    xlabel('Tempo [s]');
    xlim([-0.1 inf]);
    ylabel('Velocidade de rotação [rad/s]');
    ylim([0 1000]);
    yticks(0:200:1000); 
    title('Resposta da Rotação no Tempo');
    grid on;

% Cálculo das eficiências =================================================

I = y(:, 1);   % Corrente elétrica 
P_eletrica = Va .* y(:,1);                     % Potência elétrica = V * I
P_mecanica = tau .* y(:, 2);                   % Potência mecânica = \omega * tau [(rad/s)*Nm]

R_indutor = L .* y(:, 2);                      % Resistência aproximada do Indutor = 2*pi*f*L (f = omega/2pi)
P_resistor = I.* I * R;                        % Potência dissipada pelo resistor P_R = I^2 * R
P_indutor = I.* I .* R_indutor;                % pelo indutor
P_dissipada = (P_indutor) + (P_resistor);

P_eletrica_util = P_eletrica - (P_dissipada);  % Potência que de fato chega ao motor para gerar torque


eficiencia_mecanica = (P_mecanica) ./ (P_eletrica);         % Calcula a eficiência mecânica com o quanto da potência elétrica fornecida foi tranformada em trabalho
mean_mecanica = mean(P_mecanica) / mean(P_eletrica);        % Eficiência média
eficiencia_eletrica = (P_eletrica_util) ./ (P_eletrica);    % Ef elétrica como sendo a potência que de fato entra no motor em relação a total do sistema
mean_eletrica = mean (P_eletrica_util) ./ mean(P_eletrica);


figure(3);
plot(time, eficiencia_mecanica, '-r', 'LineWidth', 1.5);
hold on
plot(time, eficiencia_eletrica, '-y', 'LineWidth', 1.5)
xlabel('Tempo [s]');
ylabel('Eficiência [-]');
ylim([-.01 1.5]);
yticks(0:0.1:1.5); 
legend('Mecânica', 'Elétrica');
title('Eficiência vs Tempo');
grid on;


% Cálculo das médias em intervalos específicos
t0 = find(t > 0, 1);
t9 = find(t >= 9, 1);
t11 = find(t >= 11, 1);
t20 = find(t == 20, 1);

P_eletrica_0_9s = mean(P_eletrica(t0:t9));
P_mecanica_0_9s = mean(P_mecanica(t0:t9));
eficiencia_mecanica_0_9s = mean(eficiencia_mecanica(t0:t9));
eficiencia_eletrica_0_9s = mean(eficiencia_eletrica(t0:t9));

P_eletrica_11_20s = mean(P_eletrica(t11:t20));
P_mecanica_11_20s = mean(P_mecanica(t11:t20));
eficiencia_mecanica_11_20s = mean(eficiencia_mecanica(t11:t20));
eficiencia_eletrica_11_20s = mean(eficiencia_eletrica(t11:t20));

disp('Eficiências médias ========================')
disp('de 0 a 9s:');
disp(['Mecânica: ' char(951) ' = ' num2str(eficiencia_mecanica_0_9s)])
disp(['Elétrica: ' char(951) ' = ' num2str(eficiencia_eletrica_0_9s)])
disp('  ');
disp('de 11 a 20s:');
disp(['Mecânica: ' char(951) ' = ' num2str(eficiencia_mecanica_11_20s)])
disp(['Elétrica: ' char(951) ' = ' num2str(eficiencia_eletrica_11_20s)])



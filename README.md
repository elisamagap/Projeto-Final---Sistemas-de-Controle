# Projeto Final - Sistemas de Controle I
 Elisa Magalhães Pinto (13673468)   
 Emilio de Castro van Leggelo (13673520)  
 Gustavo Florida Defant (13673364)  
 João Vitor Forner (13673385)  
 Rafael Basaglia Gimenez (13673430)  

 
O projeto em questão foi desenvolvido o objetivo final de complementar o aprendizado e possibilitar a aplicação da teoria apresentada em sala de aula na disciplina de Sistemas de Controle para 
Aeronaves I, possibilitando aos alunos um melhor domínio sobre a área. A fim de realizar de familiar-se com o funcionamento de motores e de sistemas controláveis, o projeto foi dividido em 2 
etapas: Motor DC e Drone 2D.

## Etapa 1 - Motor DC

O motor no qual vamos basear a análise é representado pelo esquema abaixo e, nele, é possível identificar alguns componentes importantes que serão considerados na análise do sistema. 

![MotorDC_circuito](https://github.com/elisamagap/Projeto-Final---Sistemas-de-Controle/assets/175037231/27d9b51a-eca8-425f-b61c-ba4bf3266564)

Baseando-se, então, no esquema apresentado e nos parâmetros do motor **ECX 32 flat UAV** disponibilizados pelo fabricante, foi possível desenvolver uma rotina computacional em MATLAB que apresentasse
as saídas para corrente e para rotação do mesmo frente a condições de entrada pré-definidas e um esquema em SIMULINK do sistema.

![Simulink_MotorDC](https://github.com/elisamagap/Projeto-Final---Sistemas-de-Controle/assets/175037231/155a6987-5557-47dd-810d-05428a638b43)

![Corrente_Rotacao](https://github.com/elisamagap/Projeto-Final---Sistemas-de-Controle/assets/175037231/f5384662-fcd6-4816-abf7-ac7c72b49e54)

Tendo em vista as respostas apresentadas para corrente e para velocidade de rotação, percebe-se que estão de acordo com as determinações nominais de funcionamento fornecidas pelo _data_sheet_ do motor.
Quanto à análise da corrente, percebe-se que, previamente à atuação do degrau de torque externo ($\tau$) em t=10s, a corrente necessária para manter o sistema funcionando é inferior àquela após a aplicação
da carga mecânica, visto que esses dois parâmetros se relacionam de maneira diretamente proporcional pela relação $\tau = k_t . I$ (em que $k_t$ é a constante de torque). Sendo assim, quanto maior o torque
exigido pela carga externa, maior é a resistência que o motor apresenta no circuito, requisitando aumento da corrente a fim de atender aos critérios de potência do mesmo. 

Quanto ao quesito velocidade de rotação ($\omega$), é deprendido do gráfico de resposta uma diminuição da rotação graças ao mesmo degrau de 0,091 em t=10s. Como a tensão é mantida, o comportamento em questão
pode ser explicado pois, com a carga mecânica, o motor, a fim de manter sua potência (definida como $P_{mecanica} = \omega.\tau$), apresenta menor velocidade angular.

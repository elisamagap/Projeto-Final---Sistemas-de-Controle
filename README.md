# Projeto Final - Sistemas de Controle I
> Elisa Magalhães Pinto (13673468)   
> Emilio de Castro van Leggelo (13673520)  
> Gustavo Florida Defant (13673364)  
> João Vitor Forner (13673385)  
> Rafael Basaglia Gimenez (13673430)  

 
O projeto em questão foi desenvolvido o objetivo final de complementar o aprendizado e possibilitar a aplicação da teoria apresentada em sala de aula na disciplina de Sistemas de Controle para Aeronaves I, possibilitando aos alunos um melhor domínio sobre a área. A fim de realizar de familiar-se com o funcionamento de motores e de sistemas controláveis, o projeto foi dividido em 2 etapas: Motor DC e Drone 2D.

## Etapa 1 - Motor DC

O motor no qual vamos basear a análise é representado pelo esquema abaixo e, nele, é possível identificar alguns componentes importantes que serão considerados na análise do sistema. 

<img src="/Trabalho/MotorDC_circuito.png" alt="MotorDC_circuito" width="400">

Pela lei de Kirchoff é possível determinar a EDO de equilíbrio elétrico do sistema, enquanto o equilíbrio mecânico é estabelecido pelo equilíbrio dos torques no motor e, ao solucionar essas duas EDOs, obtemos um sistema como este:

<img src="/Trabalho/EDOs equilibrio.PNG" alt="EDOs equilibrio" width="300">

### Corrente e Rotação

Baseando-se, então, no esquema apresentado e nos parâmetros do motor **ECX 32 flat UAV** disponibilizados pelo fabricante, foi possível desenvolver uma rotina computacional em MATLAB ([MotorDC.m](/Trabalho/MotorDC.m)) que apresentasse as saídas para corrente e para rotação do mesmo frente a condições de entrada pré-definidas e um esquema em SIMULINK do sistema ([MotorDC.slx](/Trabalho/simulink_MotorDC.slx)). 

<img src="/Trabalho/Corrente_Rotacao.jpg" alt="Corrente_Rotacao.jpg" width="400"> <img src="/Trabalho/Simulink_MotorDC.jpg" alt="Simulink_MotorDC" width="400">

Tendo em vista as respostas apresentadas para corrente e para velocidade de rotação, percebe-se que estão de acordo com as determinações nominais de funcionamento fornecidas pelo _data sheet_ do motor.

Quanto à análise da corrente, percebe-se que, previamente à atuação do degrau de torque externo ($\tau$) em t=10s, a corrente necessária para manter o sistema funcionando é inferior àquela após a aplicação da carga mecânica, visto que esses dois parâmetros se relacionam de maneira diretamente proporcional pela relação $\tau = k_t . I$ (em que $k_t$ é a constante de torque). Sendo assim, quanto maior o torque exigido pela carga externa, maior é a resistência que o motor apresenta no circuito, requisitando aumento da corrente a fim de atender aos critérios de potência do mesmo. 

Quanto ao quesito velocidade de rotação ($\omega$), é deprendido do gráfico de resposta uma diminuição da rotação graças ao mesmo degrau de 0,091 em t=10s. Como a tensão é mantida, o comportamento em questão pode ser explicado pois, com a carga mecânica, o motor, a fim de manter sua potência (definida como $P_{mecanica} = \omega.\tau$), apresenta menor velocidade angular.

### Eficiência Mecânica e Elétrica

Em posse das respostas de corrente ($I$) e de velocidade angular($\omega$) e das entradas e parâmetros do motor, foi possível estimar a eficiência do sistema ao longo do tempo. Considerando $\eta=\frac{P_{saída}}{P_{entrada}}$ e determinando as potências do sistema como sendo:

$P_{mecanica} = \omega . \tau$  
$P_{eletrica} = V_a . I$  
$P_{util} = P_{eletrica} - P_{dissipada}$

> **OBS.:** $P_{dissipada}$ foi estimada pelo resistor e pelo indutor (com aproximação para o valor de sua resistência como $R_{indutor} = \omega L$)

Assim sendo, as eficiências foram calculadas:

$\eta_{mecanica} = \frac{P_{mecanica}}{P_{eletrica}}$  
$\eta_{eletrica} = \frac{P_{util}}{P_{eletrica}}$ 


<img src="/Trabalho/eficiencias.jpg" alt="grafico eficiencias" width="400"> <img src="/Trabalho/Eficiencias medias.jpg" alt="Eficiencias medias" width="400">

> **OBS.:** O salto apresentado na eficiência mecânica pode ser explicado pela brusca alteração de valores nos parâmetros e pode ser desconsiderado.

A análise dos resultados apresentados nos leva a perceber que, nos primeiros 10s a eficiência não está de acordo com a máxima prevista pelas especificações do fabricante, indicando que não seria uma condição de uso do motor válido na vida real, além da eficiência mecânica ser nula, confirmando que não há aplicação de nenhum torque externo a ser superado pelo motor. No entanto, de 10s em diante, ambas as eficiências atendem ao máximo de 84,6%, sugerindo que, com $\tau$, o motor está operando nas condições previstas pelo fabricante e está realizando trabalho útil com eficiência ótima.


## Etapa 2 - Drone 2D

Para esta etapa, a partir da planta de drone bidirecional fornecida, composta pelas entradas de potência dos rotores e também pelas saídas de movimento de altitude, deslocamento lateral e ângulo de rotação no tempo, é necessário realizar o controle de potência das duas hélices do drone 2D (lado direito e lado esquerdo) de modo com que o mesmo realize suas missões.

### Etapa inicial: análise da resposta do drone 

A partir da planta do drone, primeiramente, analisou-se a resposta que o mesmo teria a partir de uma entrada degrau de potência em suas hélices.

<img src="/Etapa 2/img_1_eixoz.png" alt="eixo z" width="400"> 

Com isso, percebemos que a partir de um certo tempo, definido pelo momento inicial da sua entrada, há um movimento no eixo Z, indicando uma alteração de altitude do drone até chegar no valor máximo estabelecido na entrada degrau. Além disso, destaca-se a não mudança do drone em relação às outras saídas, assim, não se deslocando para esquerda ou direita e, como estão relacionados, consequentemente, não variando seu ângulo de rotação (phi).

<img src="/Etapa 2/img_2_eixophi.png" alt="eixo phi" width="400"> <img src="/Etapa 2/img_3_eixox.png" alt="eixo x" width="400"> 

### Etapa intermediária: descrição de entradas e saídas

A planta do drone bidirecional fornecida conta com três entradas e seis saídas.

<img src="/Etapa 2/img_4_plantdrone.png" alt="plantdrone" width="500"> 

**Entradas:** são nomeadas como __Omega 1__ e __Omega 2__ na planta do drone ilustrada acima e representam a potência do motor em cada uma das hélices, direita e esquerda. Além disso, o drone também possui como terceira e última entrada __m__, indicando a massa. Dessa forma, com apenas essas três entradas é possível garantir a movimentação do drone em três graus de liberdades, para cima e para baixo, direita e esquerda e rotacionando sobre o próprio eixo, porém de maneira sub-atuada, que será comentado posteriormente.

**Sáidas:** na representação acima, são nomeadas como __x__ e __xv__, deslocamento lateral e velocidade do deslocamento lateral respectivamente, como __z__ e __vz__, a altitude e a velocidade de deslocamento vertical, e, por fim, as últimas saídas são __phi__ e __p__, o ângulo de rotação e a velocidade angular de rotação.

**Modelo sub-atuado:** como explicado anteriormente, o drone movimenta-se em três graus de liberdade, contudo, possui apenas dois rotores, isso significa que o sistema é sub-atuado, ou seja, para que haja o movimento em um grau de liberdade ele será relacionado ao movimento de outro grau de liberdade. No caso aqui presente, para que seja possível fazer o drone deslocar-se bidirecionalmente, é necessário que haja primeiro uma rotação do mesmo, variando o ângulo phi, para que, só após isso, ocorra o movimento devido a decomposição do vetor de forças.

<img src="/Etapa 2/img_5_decompdrone.png" alt="decompdrone" width="400"> 

### Primeira Missão - Drone em hover

Essa etapa tem como objetivo manter o drone em uma altitude constante, ou seja, mantê-lo no estado de hover. No nosso caso, a altitude escolhida foi de 5 metros. Abaixo encontra-se o diagrama de blocos feito em _simulink_ para controlar o drone.

<img src="/Etapa 2/img_6_hovergeral.png" alt="hover geral" width="600"> 

Além disso, abaixo mostra-se o controlador do hover em si.

<img src="/Etapa 2/img_7_hoverespecifico.png" alt="hoverespecifico" width="500"> 

Por fim, também é mostrado a configuração do PID utilizado.

<img src="/Etapa 2/img_8_hoverPID.png" alt="hover PID" width="500"> 

Com essas configurações é possível obter a resposta da altitude em função do tempo como demonstrado no gráfico abaixo.

<img src="/Etapa 2/img_9_hovereixoz.png" alt="hover eixo z" width="500"> 

### Segunda Missão - Drone deslocar lateralmente ainda em hover

Após o drone atingir a altitude desejada na etapa anterior, requisita-se que o mesmo desloque-se lateralmente até uma posição determinada, neste trabalho cosidera-se até a posição 5 metros positivo. O controle também foi feito a partir do _simulink_ e está demonstrado abaixo.

<img src="/Etapa 2/img_10_deslocgeral.png" alt="deslocgeral" width="700"> 

Além disso, também encontra-se a montagem do controlador do deslocamento.

<img src="/Etapa 2/img_11_deslocespecifico.png" alt="deslocamento especifico" width="600"> 

E por fim, apresenta-se as configurações dos PIDs 2 e 3 respectivamente.

<img src="/Etapa 2/img_12_deslocpid2.png" alt="desloc pid 2" width="400"> <img src="/Etapa 2/img_13_deslocpid3.png" alt="deslocpid3" width="400"> 

Com essas configurações é possível obter os seguintes gráficos de deslocamento lateral (__x__), altitude (__z__) e ângulo de rotação (__phi__) pelo tempo, respectivamente.

<img src="/Etapa 2/img_14_desloceixox.png" alt="desloc eixo x" width="450"> <img src="/Etapa 2/img_15_desloceixoz.png" alt="" width="450"> <img src="/Etapa 2/img_16_desloceixophi.png" alt="" width="450"> 

A lógica por trás do funcionamento do deslocamento lateral ocorre pelo sistema de feedback utilizando o PID. Isso porque, dado o comando de que o drone deveria ir para a posição de 5 metros deslocado da origem, o PID calcula o módulo da diferença existente entre a posição atual até a desejada e envia um sinal para controlar a potência dos rotores.

Ademais, após a primeira vez que o erro da distância requisitada for zero, um switch é acionado para que o ângulo de rotação seja zerado, para isso também é utilizado um PID de feedback. Dessa forma, ao zerar o phi, o drone para de se deslocar lateralmente, permanecendo na posição pedida.

> **OBS:** para que o drone não saia da altitude requisitada, o PID responsável pelo eixo x e pelo eixo phi envia um sinal de aumento de intensidade para um rotor e diminuição da outra hélice de mesma magnitude. Assim, o drone gera um deslocamento lateral, contudo não aumenta sua força de sustentação total, mantendo-se na mesma altitude.

### Terceira Missão - Diminuição repentina de massa do drone

Por fim, a última etapa é a análise dos efeitos da diminuição de massa do drone a partir de uma unidade de tempo, neste exemplo essa diminuição ocorre aos 15 segundos após o início. Vale destacar que todos os efeitos das etapas anteriores estão presentes aqui. Abaixo encontra-se a montagem do sistema utilizando SIMULINK.

<img src="/Etapa 2/img_17_massageral.png" alt="" width="700"> 

A entrada em degrau apresenta uma diminuição de 300 gramas na massa total do drone, fazendo com que o mesmo após 15 segundos tenha sua massa total como 203 gramas apenas. Nessas condições mostra-se os eixos de deslocamento, altitude e rotação do drone, respectivamente.

<img src="/Etapa 2/img_18_massaeixox.png" alt="" width="450"> <img src="/Etapa 2/img_19_massaeixoz.png" alt="" width="450"> <img src="/Etapa 2/img_20_massaeixophi.png" alt="decompdrone" width="450"> 

Com os gráficos dos eixos, é possível perceber que a partir dos 15 segundos, apenas o eixo z é alterado. Isso faz sentido, pois o drone continuou com a rotação suficiente para estabilizar um drone de 503 gramas, contudo, como agora possui apenas 203 gramas ele continuará subindo visto que possui mais sustentação que peso. Assim, sua resultante é para cima fazendo com que o mesmo aumente sua altitude. O arquivo com a montagem final pode ser encontrado em  ([DroneModel2D]/Etapa 2/DroneModel2D_final_old2022.slx).

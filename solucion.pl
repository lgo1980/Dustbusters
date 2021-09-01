%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parcial - Dustbusters
% NOMBRE: Leonardo Olmedo - lgo1980
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
En épocas de crisis financiera, incluso los habitantes
del mundo paranormal abandonan el plano físico
en busca de empleo, dejando montones de hogares
dados vuelta y con sustancias pegajosas en lugares
exóticos. Sin fantasmas, y ninguna fuente de
ingresos estable, los cazafantasmas (Peter, Egon,
Ray y Winston) deciden cambiar de rumbo en una
empresa de otro calibre, la tenebrosa limpieza a
domicilio.
Sabemos cuáles son las herramientas requeridas
para realizar una tarea de limpieza. Además, para
las aspiradoras se indica cuál es la potencia mínima
requerida para la tarea en cuestión.
*/

herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).
tarea(Tarea):-
  herramientasRequeridas(Tarea,_).
/*
Se pide resolver los siguientes requerimientos aprovechando las ideas del paradigma lógico, y
asegurando que los predicados principales sean completamente inversibles, a menos que se
indique lo contrario:
1. Agregar a la base de conocimientos la siguiente información:*/
%a. Egon tiene una aspiradora de 200 de potencia.
tiene(egon,aspiradora(200)).
%b. Egon y Peter tienen un trapeador, Ray y Winston no.
tiene(egon,trapeador).
tiene(egon,plumero).
tiene(peter,trapeador).
%c. Sólo Winston tiene una varita de neutrones.
tiene(winston,varitaDeNeutrones).
%d. Nadie tiene una bordeadora.
/*
2. Definir un predicado que determine si un integrante satisface la necesidad de una
herramienta requerida. Esto será cierto si tiene dicha herramienta, teniendo en cuenta
que si la herramienta requerida es una aspiradora, el integrante debe tener una con
potencia igual o superior a la requerida.
Nota: No se pretende que sea inversible respecto a la herramienta requerida.
*/
integranteContieneHerramientaRedquerida(Herramienta, Integrante):-
  poseeHerramienta(Herramienta, Integrante).

poseeHerramienta(aspiradora(Potencia), Integrante):-
  tiene(Integrante,aspiradora(PotenciaIntegrante)),
  PotenciaIntegrante >= Potencia.
poseeHerramienta(Herramienta, Integrante):-
  tiene(Integrante,Herramienta).

/*
  3. Queremos saber si una persona puede realizar una tarea, que dependerá de las
herramientas que tenga. Sabemos que:
- Quien tenga una varita de neutrones puede hacer cualquier tarea,
independientemente de qué herramientas requiera dicha tarea.
- Alternativamente alguien puede hacer una tarea si puede satisfacer la necesidad de
todas las herramientas requeridas para dicha tarea.
*/
realizarTarea(Persona,Tarea):-
  tarea(Tarea),
  tiene(Persona,varitaDeNeutrones).
realizarTarea(Persona,Tarea):-
  tiene(Persona,_),
  herramientasRequeridas(Tarea,Herramientas),
  forall(member(Herramienta,Herramientas),integranteContieneHerramientaRedquerida(Herramienta,Persona)).

/*
  4. Nos interesa saber de antemano cuanto se le debería cobrar a un cliente por un pedido
(que son las tareas que pide). Para ellos disponemos de la siguiente información en la
base de conocimientos:
- tareaPedida/3: relaciona al cliente, con la tarea pedida y la cantidad de metros
cuadrados sobre los cuales hay que realizar esa tarea.
- precio/2: relaciona una tarea con el precio por metro cuadrado que se cobraría al
cliente.
Entonces lo que se le cobraría al cliente sería la suma del valor a cobrar por cada tarea,
multiplicando el precio por los metros cuadrados de la tarea.
*/
%tareaPedida(,Tarea,CantidadMetros).
%tareaPedida(tarea, cliente, metrosCuadrados).
tareaPedida(ordenarCuarto, dana, 20).
tareaPedida(cortarPasto, walter, 50).
tareaPedida(limpiarTecho, walter, 70).
tareaPedida(limpiarBanio, louis, 15).

%precio(tarea, precioPorMetroCuadrado).
precio(ordenarCuarto, 13).
precio(limpiarTecho, 20).
precio(limpiarBanio, 55).
precio(cortarPasto, 10).
precio(encerarPisos, 7).

presupuesto(Cliente,Presupuesto):-
  cliente(Cliente),
  findall(Precio,generarPrecio(Cliente,Precio),Precios),
  sum_list(Precios, Presupuesto).
  
cliente(Cliente):-
  tareaPedida(_,Cliente,_).

generarPrecio(Cliente,PrecioTotal):-
  tareaPedida(Tarea, Cliente, Precio),
  precio(Tarea, MetrosCuadrados),
  PrecioTotal is Precio * MetrosCuadrados.

/*
  5. Finalmente necesitamos saber quiénes aceptarían el pedido de un cliente. Un
integrante acepta el pedido cuando puede realizar todas las tareas del pedido y
además está dispuesto a aceptarlo.
Sabemos que Ray sólo acepta pedidos que no incluyan limpiar techos, Winston sólo
acepta pedidos que paguen más de $500, Egon está dispuesto a aceptar pedidos que
no tengan tareas complejas y Peter está dispuesto a aceptar cualquier pedido.
Decimos que una tarea es compleja si requiere más de dos herramientas. Además la
limpieza de techos siempre es compleja.
*/
tareaCompleja(limpiarTecho).
tareaCompleja(Tarea):-
  herramientasRequeridas(Tarea, Tareas),
  length(Tareas,Cantidad),
  Cantidad > 2.

aceptarPedido(Cliente,Integrante):-
  tareaPedida(Tarea, Cliente, _),
  realizarTarea(Integrante,Tarea),
  verificarQuienAcepta(Cliente,Integrante).

verificarQuienAcepta(_,peter).
verificarQuienAcepta(Cliente,winston):-
  presupuesto(Cliente,Presupuesto),
  Presupuesto > 500.
verificarQuienAcepta(Cliente,ray):-
  tareaPedida(Tarea, Cliente, _),
  Tarea \= limpiarTecho.
verificarQuienAcepta(Cliente,egon):-
  tareaPedida(Tarea, Cliente, _),
  not(tareaCompleja(Tarea)).

/*
  6. Necesitamos agregar la posibilidad de tener herramientas reemplazables, que incluyan
2 herramientas de las que pueden tener los integrantes como alternativas, para que
puedan usarse como un requerimiento para poder llevar a cabo una tarea.
a. Mostrar cómo modelarías este nuevo tipo de información modificando el
hecho de herramientasRequeridas/2 para que ordenar un cuarto pueda
realizarse tanto con una aspiradora de 100 de potencia como con una escoba,
además del trapeador y el plumero que ya eran necesarios.
b. Realizar los cambios/agregados necesarios a los predicados definidos en los
puntos anteriores para que se soporten estos nuevos requerimientos de
herramientas para poder llevar a cabo una tarea, teniendo en cuenta que para
las herramientas reemplazables alcanza con que el integrante satisfaga la
necesidad de alguna de las herramientas indicadas para cumplir dicho
requerimiento.
c. Explicar a qué se debe que esto sea difícil o fácil de incorporar.
*/

:- begin_tests(utneanos).
  test(personas_que_le_gustan_el_vacio, set(Integrante=[egon,peter])):-
    integranteContieneHerramientaRedquerida(trapeador, Integrante).
  test(quien_tiene_una_varita_de_neutrones_puede_hacer_cualquier_tarea, set(Tarea=[ordenarCuarto,limpiarTecho,cortarPasto,limpiarBanio,encerarPisos])):-
    realizarTarea(winston, Tarea).
  test(persona_que_puede_realizar_una_tarea_si_cumple_con_todos_los_requerimientos, set(Tarea=[ordenarCuarto])):-
   realizarTarea(egon, Tarea).
  test(cobrarle_a_un_cliente_un_pedido_determinado, set(Presupuesto=[1900])):-
    presupuesto(walter,Presupuesto).
  test(integrante_determinado_acepta_un_pedido_determinado, set(Integrante=[winston])):-
    aceptarPedido(walter,Integrante).
:- end_tests(utneanos).
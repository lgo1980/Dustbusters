%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parcial - Las Casas de Hogwarts
% NOMBRE: Leonardo Olmedo - lgo1980
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
En Hogwarts, el colegio de magia y hechicería, hay 4 casas en las cuales los nuevos alumnos se distribuyen ni bien ingresan. 
Cada año estas casas compiten entre ellas para consagrarse la ganadora de la copa.
*/
/*
Parte 1 - Sombrero Seleccionador
Para determinar en qué casa queda una persona cuando ingresa a Hogwarts, el Sombrero Seleccionador tiene en cuenta el carácter de la persona,
 lo que prefiere y en algunos casos su status de sangre.
Tenemos que registrar en nuestra base de conocimientos qué características tienen los distintos magos que ingresaron a Hogwarts, 
el status de sangre que tiene cada mago y en qué casa odiaría quedar. Actualmente sabemos que:
• Harry es sangre mestiza, y se caracteriza por ser corajudo, amistoso, orgulloso e inteligente. Odiaría que el sombrero lo mande a Slytherin.
• Draco es sangre pura, y se caracteriza por ser inteligente y orgulloso, pero no es corajudo ni amistoso. Odiaría que el sombrero lo mande a Hufflepuff.
• Hermione es sangre impura, y se caracteriza por ser inteligente, orgullosa y responsable. No hay ninguna casa a la que odiaría ir.
*/
sangre(harry,mestiza).
sangre(draco,pura).
sangre(hermione,impura).
sangre(ron,pura).
sangre(ron1,pura).
mago(Mago):-
  sangre(Mago,_).

caracteristicaMago(harry,corajudo).
caracteristicaMago(harry,amistoso).
caracteristicaMago(harry,orgulloso).
caracteristicaMago(harry,inteligente).
caracteristicaMago(draco,corajudo).
caracteristicaMago(draco,amistoso).
caracteristicaMago(hermione,responsable).
caracteristicaMago(hermione,orgulloso).
caracteristicaMago(hermione,inteligente).

odiaIr(harry,slytherin).
odiaIr(draco,hufflepuff).

/*
Además nos interesa saber cuáles son las características principales que el sombrero tiene en cuenta para elegir la casa más apropiada:
• Para Gryffindor, lo más importante es tener coraje.
• Para Slytherin, lo más importante es el orgullo y la inteligencia.
• Para Ravenclaw, lo más importante es la inteligencia y la responsabilidad.
• Para Hufflepuff, lo más importante es ser amistoso.
*/
casa(gryffindor).
casa(slytherin).
casa(ravenclaw).
casa(hufflepuff).
caracteristicaCasa(gryffindor,corajudo).
caracteristicaCasa(slytherin,orgulloso).
caracteristicaCasa(slytherin,inteligente).
caracteristicaCasa(ravenclaw,inteligente).
caracteristicaCasa(ravenclaw,responsable).
caracteristicaCasa(hufflepuff,amistoso).

/*
Se pide:
1. Saber si una casa permite entrar a un mago, lo cual se cumple para cualquier mago y cualquier casa excepto en el caso de Slytherin, 
que no permite entrar a magos de sangre impura.
*/
permisoDeLaCasa(Casa,Mago):-
  casa(Casa),
  mago(Mago),
  not((sangre(Mago,impura),Casa = slytherin)).

/*
2. Saber si un mago tiene el carácter apropiado para una casa, lo cual se cumple para cualquier mago si sus características
incluyen todo lo que se busca para los integrantes de esa casa, independientemente de si la casa le permite la entrada.
*/
caracterApropiado(Mago,Casa):-
  casa(Casa),
  mago(Mago),
  forall(caracteristicaCasa(Casa,Caracteristica),caracteristicaMago(Mago,Caracteristica)).
/*
3. Determinar en qué casa podría quedar seleccionado un mago sabiendo que tiene que tener el carácter adecuado para la casa,
 la casa permite su entrada y además el mago no odiaría que lo manden a esa casa. Además Hermione puede quedar seleccionada en Gryffindor,
  porque al parecer encontró una forma de hackear al sombrero.
*/
quedarSeleccionado(Casa,Mago):-
  caracterApropiado(Mago,Casa),
  permisoDeLaCasa(Casa,Mago),
  not(odiaIr(Mago,Casa)).
quedarSeleccionado(gryffindor,hermione).

/*
4. Definir un predicado cadenaDeAmistades/1 que se cumple para una lista de magos si todos ellos se caracterizan por ser amistosos
 y cada uno podría estar en la misma casa que el siguiente. No hace falta que sea inversible, se consultará de forma individual.
*/
cadenaDeAmistades(Magos):-
  serAmistosos(Magos),
  quedarEnLaMismaCasa(Magos).

serAmistosos(Magos):-
  forall(member(Mago,Magos),caracteristicaMago(Mago,amistoso)).

quedarEnLaMismaCasa([]).
quedarEnLaMismaCasa([_]).
quedarEnLaMismaCasa([Mago1,Mago2|Magos]):-
  quedarSeleccionado(Casa,Mago1),
  quedarSeleccionado(Casa,Mago2),
  quedarEnLaMismaCasa([Mago2|Magos]).

/*
Parte 2 - La copa de las casas
A lo largo del año los alumnos pueden ganar o perder puntos para su casa en base a las buenas y malas acciones realizadas,
 y cuando termina el año se anuncia el ganador de la copa. Sobre las acciones que impactan al puntaje actualmente tenemos la siguiente información:
• Malas acciones: son andar de noche fuera de la cama (que resta 50 puntos) o ir a lugares prohibidos. La cantidad de puntos 
que se resta por ir a un lugar prohibido se indicará para cada lugar. Ir a un lugar que no está prohibido no afecta al puntaje.
• Buenas acciones: son reconocidas por los profesores y prefectos individualmente y el puntaje se indicará para cada acción premiada.
Necesitamos registrar las distintas acciones que hicieron los alumnos de Hogwarts durante el año. Sabemos que:
*/
%• Harry anduvo fuera de cama.
accion(harry,mala(fueraDeLaCama,50)).
%• Hermione fue al tercer piso y a la sección restringida de la biblioteca.
accion(hermione,mala(biblioteca,10)).
accion(hermione,mala(tercerPiso,75)).
%• Harry fue al bosque y al tercer piso.
accion(harry,mala(bosque,50)).
accion(harry,mala(tercerPiso,75)).
%• Draco fue a las mazmorras.
%• A Ron le dieron 50 puntos por su buena acción de ganar una partida de ajedrez mágico.
accion(ron,buena(ajedrezMagico,50)).
%• A Hermione le dieron 50 puntos por usar su intelecto para salvar a sus amigos de una muerte horrible.
accion(draco,buena(usarIntelecto,50)).
%• A Harry le dieron 60 puntos por ganarle a Voldemort.
accion(harry,buena(ganarleAVoldemort,60)).
accion(hermione,respuesta(dondeSeEncuentraUnBezoar,20,snape)).
accion(hermione,respuesta(comoHacerLevitarUnaPluma,25,flitwick)).
/*
También sabemos que los siguientes lugares están prohibidos:
• El bosque, que resta 50 puntos.
• La sección restringida de la biblioteca, que resta 10 puntos.
• El tercer piso, que resta 75 puntos.
*/

%También sabemos en qué casa quedó seleccionado efectivamente cada alumno mediante el predicado esDe/2 que relaciona a la persona con su casa, 
%por ejemplo:
esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

/*
Se pide incorporar a la base de conocimiento la información sobre las acciones realizadas y agregar la siguiente lógica a nuestro programa:
1.
1. Saber si un mago es buen alumno, que se cumple si hizo alguna acción y ninguna de las cosas que hizo se considera una mala acción (que son aquellas que provocan un puntaje negativo).
*/
esBuenAlumno(Mago):-
  mago(Mago),
  accion(Mago,buena(_,_)),
  not(accion(Mago,mala(_,_))).
/*
2. Saber si una acción es recurrente, que se cumple si más de un mago hizo esa misma acción.
*/
accionRecurrente(Accion):-
  accion(Accion),
  findall(Accion,buscarAccion(Accion),Acciones),
  length(Acciones, SumaAcciones),
  SumaAcciones > 1.

accion(Accion):-
  accion(_,Accion).

buscarAccion(Accion):-
  mago(Mago),
  accion(Mago,Accion).

%2. Saber cuál es el puntaje total de una casa, que es la suma de los puntos obtenidos por sus miembros.
puntajeTotalCasa(Casa,PuntajeTotal):-
  casaCompetidora(Casa),
  findall(Puntos,obtenerPuntosDeLosMagosDeLaCasa(Casa,Puntos),PuntosTotales),
  sum_list(PuntosTotales,PuntajeTotal).

casaCompetidora(Casa):-
  esDe(_,Casa).

obtenerPuntosDeLosMagosDeLaCasa(Casa,Puntos):-
  esDe(Mago,Casa),
  accion(Mago,Accion),
  generarPuntos(Accion,Puntos).

generarPuntos(mala(_,PuntosMago),PuntosFinal):-
  PuntosFinal is PuntosMago * (-1).
generarPuntos(buena(_,PuntosMago),PuntosMago).
generarPuntos(respuesta(_,PuntosPregunta,snape),PuntosMago):-
  PuntosMago is PuntosPregunta / 2.
generarPuntos(respuesta(_,PuntosPregunta,Profesor),PuntosPregunta):-
  Profesor \= snape.

%3. Saber cuál es la casa ganadora de la copa, que se verifica para aquella casa que haya obtenido una cantidad mayor de puntos que todas las otras.
ganadoraDeLaCopa(Casa):-
  puntajeTotalCasa(Casa,PuntajeMayor),
  forall((puntajeTotalCasa(OtraCasa,PuntajeMenor),Casa \= OtraCasa),PuntajeMenor < PuntajeMayor).
/*
4. Queremos agregar la posibilidad de ganar puntos por responder preguntas en clase. La información que nos interesa de las respuestas en clase son:
 cuál fue la pregunta, cuál es la dificultad de la pregunta y qué profesor la hizo.

Por ejemplo, sabemos que Hermione respondió a la pregunta de dónde se encuentra un Bezoar, de dificultad 20, realizada por el profesor Snape, 
y cómo hacer levitar una pluma, de dificultad 25, realizada por el profesor Flitwick. 

Modificar lo que sea necesario para que este agregado funcione con lo desarrollado hasta ahora, teniendo en cuenta que los puntos que se otorgan 
equivalen a la dificultad de la pregunta, a menos que la haya hecho Snape, que da la mitad de puntos en relación a la dificultad de la pregunta.
*/


:- begin_tests(utneanos).
  test(mago_que_se_le_permite_entrar_a_una_casa,set(Mago=[harry,draco,ron,ron1])):-
    permisoDeLaCasa(slytherin,Mago).
  test(mago_que_puede_entrar_a_una_casa_por_sus_caracteristicas,set(Mago=[harry,hermione])):-
    caracterApropiado(Mago,slytherin).
  test(mago_que_puede_entrar_a_una_casa_determinada_dependiendo_de_todas_las_condiciones_necesarias,set(Casa=[gryffindor,hufflepuff])):-
    quedarSeleccionado(Casa,harry).
  test(magos_quePueden_estar_en_una_lista_de_amistades,nondet):-
    cadenaDeAmistades([harry,draco]).
  test(si_un_mago_determinado_es_buen_alumno,set(Mago=[ron,draco])):-
    esBuenAlumno(Mago).
  test(saber_que_una_accion_es_recurrente,set(Accion=[mala(tercerPiso,75)])):-
    distinct(accionRecurrente(Accion)).
  test(saber_el_puntaje_total_de_una_casa_determinada,set(PuntajeTotal=[-115])):-
    distinct(puntajeTotalCasa(gryffindor,PuntajeTotal)).
  test(casa_ganadora_de_la_copa,set(Casa=[slytherin])):-
    ganadoraDeLaCopa(Casa).

:- end_tests(utneanos).
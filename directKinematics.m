function pos = directKinematics(entr)
% directKinematics Calcula la posición de un brazo robótico de dos eslabones
% a partir de las longitudes de los eslabones y los ángulos de las articulaciones.
%
%   entr: Un vector de entrada con los siguientes componentes:
%       entr(1) -> l1: longitud del primer eslabón
%       entr(2) -> l2: longitud del segundo eslabón
%       entr(3) -> q1: ángulo de la primera articulación (en radianes)
%       entr(4) -> q2: ángulo de la segunda articulación (en radianes)
%       entr(5:6) -> q_dot: velocidades angulares (aunque no se utilizan en este cálculo)
%
%   pos: Un vector de salida con la posición (x, y, z) del extremo del brazo.

% Extracción de las longitudes y ángulos
l1 = entr(1); % Longitud del primer eslabón
l2 = entr(2); % Longitud del segundo eslabón
q1 = entr(3); % Ángulo de la primera articulación
q2 = entr(4); % Ángulo de la segunda articulación
q_dot = entr(5:6); % Velocidades angulares (no usadas en esta función)

% Cálculo de la posición del extremo del brazo
x = l2 * cos(q1) * cos(q2);
y = l2 * sin(q1) * cos(q2);
z = l1 + l2 * sin(q2);

% Posición final del extremo del brazo
pos = [x; y; z];
end

% Importar el archivo CSV
filename = 'CSVdeLTSpice.txt'
data = readtable(filename);
time = data.time;
output = data.V_n001_;

% Filtrar los datos después de 2 segundos
filter_time = 1.1;
filtered_indices = time > filter_time;
filtered_time = time(filtered_indices);
filtered_output = output(filtered_indices);

% Calcular la derivada primera
dy = diff(filtered_output) ./ diff(filtered_time);
dy_time = filtered_time(1:end-1);

% Calcular la derivada segunda
d2y = diff(dy) ./ diff(dy_time);
d2y_time = dy_time(1:end-1);

% Detectar el punto de inflexión (cambio de signo en la segunda derivada)
inflection_index = find(diff(sign(d2y)) ~= 0, 1);
inflection_time = d2y_time(inflection_index);
inflection_output = interp1(time, output, inflection_time);

% Calcular la pendiente en el punto de inflexión
slope = dy(inflection_index);

% Ecuación de la recta tangente: y = mx + b
intercept = inflection_output - slope * inflection_time;

% Crear puntos para la recta tangente
tangent_time = linspace(min(time), max(time), 100);
tangent_line = slope * tangent_time + intercept;

% Determinar el valor de estado estacionario
estado_estacionario = mean(output(end-10:end)); % Promedio de los últimos 10 puntos

% Intersección de la recta tangente con y=0 (eje x)
interseccion_x = -intercept / slope;

% Intersección de la recta tangente con la recta del valor de estado estacionario
interseccion_tiempo_asentamiento = (estado_estacionario - intercept) / slope;

% Graficar los resultados
figure;
plot(time, output, 'b', 'DisplayName', 'Salida');
hold on;
plot(inflection_time, inflection_output, 'ro', 'DisplayName', 'Punto de inflexión');
plot(tangent_time, tangent_line, 'r--', 'DisplayName', 'Recta tangente');
yline(estado_estacionario, 'g--', 'DisplayName', 'Valor de estado estacionario');
plot(interseccion_x, 0, 'ko', 'DisplayName', 'Interseccion y=0');
plot(interseccion_tiempo_asentamiento, estado_estacionario, 'mo', 'DisplayName', 'Interseccion Estado Estacionario');
xlabel('Tiempo');
ylabel('Voltaje');
title('Respuesta Temporal');
legend;
grid on;

xlim([0 10])
ylim([0 1])

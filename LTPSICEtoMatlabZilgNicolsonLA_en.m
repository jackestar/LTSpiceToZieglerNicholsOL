% Import CSV file
filename = 'CSVfilefromLTSpice.txt'
data = readtable(filename);
time = data.time;
output = data.V_n001_;

% Filter data after 2 seconds
filter_time = 1.1;
filtered_indices = time > filter_time;
filtered_time = time(filtered_indices);
filtered_output = output(filtered_indices);

% Calculate the first derivative
dy = diff(filtered_output) ./ diff(filtered_time);
dy_time = filtered_time(1:end-1);

% Calculate the second derivative
d2y = diff(dy) ./ diff(dy_time);
d2y_time = dy_time(1:end-1);

% Detect the inflection point (sign change in the second derivative)
inflection_index = find(diff(sign(d2y)) ~= 0, 1);
inflection_time = d2y_time(inflection_index);
inflection_output = interp1(time, output, inflection_time);

% Calculate the slope at the inflection point
slope = dy(inflection_index);

% Equation of the tangent line: y = mx + b
intercept = inflection_output - slope * inflection_time;

% Create points for the tangent line
tangent_time = linspace(min(time), max(time), 100);
tangent_line = slope * tangent_time + intercept;

% Intersection of the tangent line with y=0 (x axis)
stationary_state = mean(output(end-10:end)); % Average of the last 10 points

% Intersección de la recta tangente con y=0 (eje x)
interseccion_x = -intercept / slope;

% Intersection of the tangent line with the steady-state value line
interseccion_tiempo_asentamiento = (stationary_state - intercept) / slope;

% Plot the results
figure;
plot(time, output, 'b', 'DisplayName', 'Output');
hold on;
plot(inflection_time, inflection_output, 'ro', 'DisplayName', 'Inflection Point');
plot(tangent_time, tangent_line, 'r--', 'DisplayName', 'Tangent Line');
yline(stationary_state, 'g--', 'DisplayName', 'Steady State Value');
plot(interseccion_x, 0, 'ko', 'DisplayName', 'Intersection with y=0');
plot(interseccion_tiempo_asentamiento, stationary_state, 'mo', 'DisplayName', 'Intersection with Steady State Line');
xlabel('Time');
ylabel('Output');
title('Output with Tangent Line, Steady State Value, and Intersections');
legend;
grid on;

xlim([0 10])
ylim([0 1])

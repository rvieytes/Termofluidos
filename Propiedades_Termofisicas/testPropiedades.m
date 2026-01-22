#test_properties.m
# Realizado con ayuda de IA
# Gemini 3
clear all; clc; close all;
fprintf(1, '\033c');
restoredefaultpath;
% --- INICIO DEL PUENTE ---
directorio_shared = '../shared';
directorio_octave = '../shared/octave';
directorio_Python = '../shared/Pyton';

if ~exist(directorio_shared, 'dir')
    fprintf(2, '\n[!] ERROR DE ESTRUCTURA DE DIRECTORIOS\n');
    fprintf(2, 'No se pudo encontrar la carpeta "%s".\n', directorio_shared);
    fprintf(2, 'ASEGURATE de ejecutar este script desde su propia carpeta.\n');
    fprintf(2, 'Lee la Seccion 1.2 de las Notas ("Organizacion del Espacio de Trabajo").\n\n');
    error('Ejecucion abortada por configuracion de entorno incorrecta.');
end

subproject_name='Propiedades_Termofisicas';
addpath(directorio_octave);
check_environment(subproject_name);


% --- 2. CONFIGURACIÓN DEL COMANDO ---
% Definimos la ubicación relativa del motor Python desde la Sandbox
path_python_script = fullfile("..", "shared", "Python", "thermo_state.py");

% Ejemplo de datos (esto vendría de su lógica de cálculo)
nombre_fluido = "Water";
temperatura = 353.15;
presion = 150e3;
fase = "liq"; % liq o vap

% El comando blindado (las comillas "" dentro del string protegen la ruta completa)
command = sprintf('python3 "%s" "%s" %f %f "%s"', ...
                  path_python_script, nombre_fluido, temperatura, presion, fase);

% --- 3. EJECUCIÓN ---
fprintf('Llamando al motor termofísico...\n');
[status, result] = system(command);

if status == 0
    data = jsondecode(result);
    disp('Datos recibidos con éxito:');
else
    error("Error en el motor Python: %s", result);
end
t=temperatura
p=presion
fluido=nombre_fluido
k=data.k
rho=data.rho
nu=data.nu
Pr=data.Pr


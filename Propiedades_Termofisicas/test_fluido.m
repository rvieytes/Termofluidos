% Test de la clase Fluido y conexión con CoolProp
clear; clc;

% 1. Configuración del entorno (agregamos la ruta a shared)
% Esto permite que Octave encuentre los scripts de inicialización
addpath('../shared/Octave');

% 2. Inicializar el puente con Python
% (Asumimos que tienes una función init_python.m en shared/Octave)
% Si aún no la tienes, por ahora usamos la vía directa:
setenv('PYTHONPATH', [pwd, '/../shared/Python']);

% 3. Definir el estado del fluido
% Intentaremos obtener la densidad del Agua a 1 atm y 20°C
nombre = 'Water';
T = 293.15; % K
P = 101325; % Pa

% 4. Llamada al motor Python (vía la clase Fluido)
% Usamos pyrun para instanciar la clase y obtener un JSON
py_cmd = [ ...
    'from Fluido import Fluido; import json; ', ...
    sprintf('f = Fluido("%s", fase="liq", temperatura=%f, presion=%f); ', nombre, T, P), ...
    'print(f.to_json())' ...
];
try
    resultado_json = pyrun(py_cmd, "resultado");
    data = jsondecode(resultado_json);

    % 5. Mostrar resultados en pantalla
    fprintf('--- Resultados para %s ---\n', nombre);
    fprintf('Densidad (rho): %.2f kg/m3\n', data.rho);
    fprintf('Entalpía (h):   %.2f J/kg\n', data.h);
    fprintf('Viscosidad (mu): %.6f Pa.s\n', data.mu);

catch ME
    fprintf('Error en la conexión: %s\n', ME.message);
end

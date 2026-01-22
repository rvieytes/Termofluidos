## Copyright (C) 2025 Roberto
## Author: Roberto <roberto@GrayHole>
## Created: 2025-12-17
function check_environment(subproject_name)
    % CHECK_ENVIRONMENT: Versión compatible y robusta.
    current_path = pwd();
    anchor = "Termofluidos";

    % Buscamos el ancla (el origen de coordenadas)
    idx = strfind(current_path, anchor);
    if isempty(idx)
        error("Error fatal: No se encontró la carpeta raíz '%s' en la ruta.", anchor);
    end

    % Definimos la raíz absoluta del proyecto
    root_end = idx(end) + length(anchor) - 1;
    project_root = current_path(1:root_end);

    % Verificamos que el usuario esté en el subproyecto correcto
    if isempty(strfind(current_path, subproject_name))
        fprintf(2, '\n[!] ERROR DE CONTEXTO\n');
        fprintf(2, 'Este script pertenece a: "%s"\n', subproject_name);
        error("Ubicación de ejecución inválida.");
    end

    % Agregamos local_bin si existe (al lado del script)
    local_bin = fullfile(current_path, "local_bin");
    if exist(local_bin, 'dir')
        addpath(local_bin);
    end

    fprintf('Entorno verificado: %s\n', subproject_name);
end

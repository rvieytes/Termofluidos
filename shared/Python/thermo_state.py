# thermo_state2.py
import sys
import json
from Fluido import Fluido


if __name__ == "__main__":
    if len(sys.argv) not in (4, 5):
        print(json.dumps({"error": "Uso: python thermo_state.py <fluido> <T> <P> [fase]"}))
        sys.exit(1)
#captura de parámetros desde línea de comandos
    nombre_fluido = sys.argv[1]
    temperatura = float(sys.argv[2])
    presion = float(sys.argv[3])
# Manejo de la fase (Octave puede enviar 'None' como string)
    fase_arg = sys.argv[4] if len(sys.argv) == 5 else None
    fase = None if fase_arg == 'None' else fase_arg
    try:
       # Instanciamos la clase que ya tienes en Fluido.py
        fluido = Fluido(nombre_fluido, fase=fase, temperatura=temperatura, presion=presion)

        # json.dumps convierte el diccionario a un string JSON estándar
        # (Usa comillas dobles y convierte None en null automáticamente)
        print(json.dumps(fluido.to_dict()))
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

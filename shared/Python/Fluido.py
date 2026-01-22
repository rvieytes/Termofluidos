#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#Clase fluido
#versión 2
import CoolProp.CoolProp as CP

class Fluido:

    def __init__(self, nombre, fase=None, temperatura=293.15, presion=101325):
        self.nombre = nombre
        self.temperatura = temperatura
        self.presion = presion
        self.fase_usuario = fase  # 'liq', 'vap' o None

        # Determinar fase real
        fase_real = CP.PhaseSI('T', self.temperatura, 'P', self.presion, self.nombre)

        # Validación de fase
        if self.fase_usuario is not None:
            if self.fase_usuario not in ('liq', 'vap'):
                raise ValueError("fase debe ser 'liq' o 'vap'")

            if fase_real == 'liquid' and self.fase_usuario == 'vap':
                raise ValueError("No existe vapor a estas condiciones")
            if fase_real == 'gas' and self.fase_usuario == 'liq':
                raise ValueError("No existe líquido a estas condiciones")
            if fase_real == 'twophase':
                # Mapear a Q según la fase solicitada
                self.Q = 0.0 if self.fase_usuario == 'liq' else 1.0
            else:
                self.Q = None
        else:
            # Usuario no especificó fase
            if fase_real == 'twophase':
                raise ValueError("Estado bifásico: debe especificar fase='liq' o 'vap'")
            self.Q = None
        self.fase_real=fase_real
        self.evaluate_properties()

    def evaluate_properties(self):
        def props(key):
            return CP.PropsSI(key, 'T', self.temperatura, 'P', self.presion, self.nombre)

        sBETA = 'ISOBARIC_EXPANSION_COEFFICIENT'

        self.rho = props('D')
        self.mu  = props('V')
        self.nu  = self.mu / self.rho
        self.cp  = props('C')
        self.k   = props('L')
        self.Pr  = props('Prandtl')
        self.h   = props('H')
        self.u   = props('U')
        self.s   = props('S')
        self.c_s = props('A')
        self.beta = props(sBETA)
        if self.fase_real=='liquid':  # fase líquida
            self.surface_tension = CP.PropsSI(
            'SURFACE_TENSION',
            'T', self.temperatura,
            'Q', 0,
            self.nombre
        )
        else:
            self.surface_tension = None

    def to_dict(self):
        return {
            "fase": self.fase_real,
            "rho": self.rho,
            "beta": self.beta,
            "cp": self.cp,
            "k": self.k,
            "mu": self.mu,
            "nu": self.nu,
            "Pr": self.Pr,
            "h": self.h,
            "u": self.u,
            "s": self.s,
            "c_s": self.c_s,
            "Upsilon": self.surface_tension
        }

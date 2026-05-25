# 🧠 Lógica de Negocio: Tecda Maniquí Factory

Este documento explica **qué** problemas resuelven nuestras automatizaciones de base de datos desde una perspectiva conceptual, sin entrar en detalles de código.

---

## 1. El Problema del "Maniquí Frankenstein"
En una fábrica de maniquíes, cada modelo (ej: "Hércules Realista", "Busto Elegance") tiene piezas diseñadas específicamente para él. 

**El Riesgo:** Que un operario asigne una cabeza de un modelo "Busto" a un cuerpo de un modelo "Hércules". Esto crearía una unidad defectuosa e invendible.

**Nuestra Solución (Trigger Anti-Frankenstein):**
Hemos programado al motor de la base de datos para que sea un "supervisor incansable". Cada vez que alguien intenta unir una pieza a un maniquí, el motor verifica si ambos pertenecen al mismo diseño técnico. Si no coinciden, **la base de datos rechaza la operación** y lanza una alerta.

---

## 2. Nomenclatura Inteligente (Seriales Automáticos)
Tradicionalmente, asignar seriales a mano (`001`, `002`) lleva a errores y duplicados.

**Nuestra Solución (Trigger Generador de Seriales):**
Cuando nace una nueva pieza, la base de datos lee sus características y le otorga un nombre "hablado". 
*   Ejemplo: `PZ-CAB-INT-0042`
    *   `PZ`: Es una Pieza.
    *   `CAB`: Es una Cabeza.
    *   `INT`: Es de fabricación Interna.
    *   `0042`: Es la unidad número 42 de este tipo.
Esto garantiza trazabilidad total desde el primer segundo.

---

## 3. Ensamblaje Atómico (Todo o Nada)
Armar un maniquí implica registrar la unidad y, al mismo tiempo, "quitar" del stock las 6 piezas (Cabeza, Torso, Brazos, Piernas) que lo componen.

**El Riesgo:** Que el sistema registre el maniquí pero falle al asignar las piernas, dejando los datos inconsistentes (un maniquí "fantasma" sin partes).

**Nuestra Solución (Stored Procedure Transaccional):**
Usamos el concepto de **Atomicidad**. El procedimiento de ensamblaje garantiza que:
1.  O se completan todos los pasos (registro + asignación de las 6 piezas).
2.  O no se hace nada (Rollback).
Esto asegura que el stock siempre sea real y exacto.

---

## 4. Analítica de Márgenes
¿Cuánto ganamos realmente por cada maniquí vendido? No es solo "Precio - Costo del Molde". Cada pieza física tiene un costo (materia prima, pintura, origen).

**Nuestra Solución (Vistas Analíticas):**
Hemos creado una "lente" mágica que cruza los datos de los moldes con los costos reales de cada pieza asignada a un maniquí específico. Esto permite a la gerencia ver, en tiempo real, el margen de ganancia neto de cada unidad que sale de la fábrica.

---
*Este documento es parte del material didáctico del proyecto TECDA.*

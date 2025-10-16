<!-- README.md (README.md) -->

# Descripción general

Nuestro proyecto busca predecir las tendencias de gasto en las 10 principales categorías de consumo de tarjetas de crédito Visa, con un horizonte de 14 semanas.  
La solución combina ingeniería de datos, modelado estadístico y visualización interactiva, permitiendo al negocio anticipar comportamientos del consumidor y tomar decisiones estratégicas basadas en datos.

# Arquitectura general del sistema

La arquitectura del proyecto está diseñada para ser modular, escalable y reproducible, cumpliendo los tres requisitos clave del hackathon: automatización, escalabilidad y observabilidad.

# Componentes principales

## Ingesta y almacenamiento (ETL - Data Engineering)

- Procesa datos históricos (4 años) provenientes de archivos CSV, JSON y XML.
- Los datos se cargan en una base de datos PostgreSQL, utilizando un flujo ETL desarrollado en Python y orquestado con Apache Airflow.
- Se construyen dos capas:
  - `transactions_raw`: datos crudos.
  - `spend_weekly`: agregaciones semanales por categoría.

## Modelado y forecasting (Data Science)

- Se emplea el modelo Prophet de Meta para pronosticar el gasto semanal por categoría.
- Cada categoría tiene su propia serie temporal, y se generan predicciones para las próximas 14 semanas.
- Los resultados se guardan en la tabla `predictions`, junto con el identificador de la corrida y la métrica de evaluación sMAPE.

## API REST (Backend / Integración)

- Desarrollada con FastAPI, expone los datos históricos y las predicciones en endpoints JSON.
- Permite conectar fácilmente la capa de visualización o integrarse con otros sistemas internos.

## Dashboard (Visualización y Negocio)

- Construido con Streamlit, permite visualizar el gasto histórico y los pronósticos por categoría.
- Incluye filtros por rango de fechas, categoría y vista combinada de histórico + predicción.
- Está diseñado para ejecutarse directamente desde Docker o en local.

## Infraestructura y despliegue

- Todos los componentes (PostgreSQL, Airflow, API, Dashboard) corren bajo Docker Compose para facilitar la portabilidad y reproducibilidad.
- Se incluyen scripts de inicialización (`init_db.sh`) y definición de esquema (`schemas.sql`).

# Flujo de datos

1. **Ingesta:** Archivos fuente (CSV/JSON/XML) → `transactions_raw`
2. **Transformación:** `transactions_raw` → agregaciones semanales → `spend_weekly`
3. **Modelado:** `spend_weekly` → modelo Prophet → predicciones → `predictions`
4. **Exposición:** `predictions` → API FastAPI → Dashboard Streamlit

# Tecnologías utilizadas

| Capa               | Tecnología                                  | Rol                                                          |
| ------------------ | ------------------------------------------- | ------------------------------------------------------------ |
| Base de datos      | PostgreSQL                                  | Almacenamiento de datos históricos, agregados y predicciones |
| ETL / Orquestación | Apache Airflow, Python (Pandas, SQLAlchemy) | Limpieza, agregación y carga automática                      |
| Modelado           | Prophet, Scikit-learn                       | Predicciones semanales por categoría                         |
| API REST           | FastAPI                                     | Exposición de resultados al dashboard                        |
| Visualización      | Streamlit, Plotly                           | Dashboard interactivo para análisis del negocio              |
| Infraestructura    | Docker Compose                              | Despliegue y entorno reproducible                            |
| Monitoreo          | Airflow UI, logs locales                    | Seguimiento y control de errores                             |

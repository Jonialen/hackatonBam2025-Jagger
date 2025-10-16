-- schemas.sql (infra/schemas.sql)

-- 1️⃣ Datos crudos (ingesta directa desde CSV o API)
CREATE TABLE IF NOT EXISTS transactions_raw (
    transaction_id SERIAL PRIMARY KEY,
    customer_id VARCHAR(50),
    category VARCHAR(100),
    amount NUMERIC(12,2),
    transaction_date DATE,
    payment_method VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_raw_category_date
    ON transactions_raw (category, transaction_date);

-- 2️⃣ Datos agregados semanalmente
CREATE TABLE IF NOT EXISTS spend_weekly (
    id SERIAL PRIMARY KEY,
    category VARCHAR(100),
    week_start DATE,
    total_amount NUMERIC(12,2),
    avg_amount NUMERIC(12,2),
    transaction_count INT,
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_weekly_category_week
    ON spend_weekly (category, week_start);

-- 3️⃣ Predicciones generadas
CREATE TABLE IF NOT EXISTS predictions (
    id SERIAL PRIMARY KEY,
    category VARCHAR(100),
    prediction_date DATE,
    predicted_amount NUMERIC(12,2),
    model_name VARCHAR(100),
    run_id VARCHAR(100),
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (category) REFERENCES spend_weekly (category)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_predictions_category_date
    ON predictions (category, prediction_date);

-- 4️⃣ Registro de ejecuciones de modelos
CREATE TABLE IF NOT EXISTS model_runs (
    run_id VARCHAR(100) PRIMARY KEY,
    model_name VARCHAR(100),
    train_start DATE,
    train_end DATE,
    smape NUMERIC(8,4),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_runs_model
    ON model_runs (model_name);


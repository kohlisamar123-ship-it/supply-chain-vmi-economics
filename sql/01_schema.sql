
DROP TABLE IF EXISTS order_list;
DROP TABLE IF EXISTS freight_rates;
DROP TABLE IF EXISTS plant_ports;
DROP TABLE IF EXISTS products_per_plant;
DROP TABLE IF EXISTS vmi_customers;
DROP TABLE IF EXISTS wh_capacities;
DROP TABLE IF EXISTS wh_costs;

CREATE TABLE IF NOT EXISTS wh_costs (
    plant_code VARCHAR(10) PRIMARY KEY NOT NULL ,
    cost_per_unit REAL NOT NULL
);

CREATE TABLE IF NOT EXISTS wh_capacities (
    plant_code VARCHAR(10) PRIMARY KEY NOT NULL,
    daily_capacity INTEGER NOT NULL,
    FOREIGN KEY (plant_code) REFERENCES wh_costs(plant_code)
);

CREATE TABLE IF NOT EXISTS vmi_customers (
    line_id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer VARCHAR(10) NOT NULL,
    plant_code VARCHAR(10) NOT NULL,
    FOREIGN KEY (plant_code) REFERENCES wh_costs(plant_code)
);

CREATE TABLE IF NOT EXISTS products_per_plant (
    line_id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id VARCHAR(10) NOT NULL,
    plant_code VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS plant_ports (
    line_id INTEGER PRIMARY KEY AUTOINCREMENT,
    plant_code TEXT NOT NULL,
    ports VARCHAR(10) NOT NULL,
    FOREIGN KEY (plant_code) REFERENCES wh_costs(plant_code)
);

CREATE TABLE IF NOT EXISTS order_list (
    order_id TEXT PRIMARY KEY,
    order_date TEXT NOT NULL,
    orig_port TEXT NOT NULL,
    carrier TEXT NOT NULL,
    tpt_day_count INTEGER NOT NULL,
    service_level TEXT NOT NULL,
    ship_ahead_day_count INTEGER NOT NULL,
    customer TEXT NOT NULL,
    product_id TEXT NOT NULL,
    plant_code TEXT NOT NULL,
    dest_port TEXT NOT NULL,
    unit_quant INTEGER NOT NULL,
    weight REAL NOT NULL,
    FOREIGN KEY (plant_code) REFERENCES wh_costs(plant_code)
);

CREATE TABLE IF NOT EXISTS freight_rates (
    rate_id INTEGER PRIMARY KEY AUTOINCREMENT,
    carrier TEXT NOT NULL,
    orig_port TEXT NOT NULL,
    dest_port TEXT NOT NULL,
    min_weight_quant REAL NOT NULL,
    max_weight_quant REAL NOT NULL,
    service_level TEXT NOT NULL,
    min_cost REAL NOT NULL,
    rate REAL NOT NULL,
    mode_dsc TEXT NOT NULL,
    tpt_day_count INTEGER NOT NULL,
    carrier_type TEXT NOT NULL

);




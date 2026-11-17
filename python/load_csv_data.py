import sqlite3
import pandas as pd

# 1. Connecting the database
conn = sqlite3.connect("supply_chain.db")
conn.execute("PRAGMA foreign_keys = ON;")

tables = ["order_list", "freight_rates", "plant_ports", "products_per_plant", "vmi_customers", "wh_capacities", "wh_costs"]
for t in tables:
    conn.execute(f"DELETE FROM {t};")
conn.commit()

# 2. Loading wh_costs.csv into the database
df_costs = pd.read_csv("wh_costs.csv")
df_costs.columns = df_costs.columns.str.lower()
df_costs.to_sql("wh_costs", conn, if_exists="append", index=False)

# 3. Loading wh_capacities.csv into the database
df_capacities = pd.read_csv("wh_capacities.csv")
df_capacities.columns = df_capacities.columns.str.lower()
df_capacities.to_sql("wh_capacities", conn, if_exists="append", index=False)

# 4. Loading vmi_customers.csv into the database
df_cust = pd.read_csv("vmi_customers.csv")
df_cust.columns = df_cust.columns.str.lower()
df_cust.to_sql("vmi_customers", conn, if_exists="append", index=False)

# 5. Loading products_per_plant.csv into the database
df_products = pd.read_csv("products_per_plant.csv")
df_products.columns = df_products.columns.str.lower()
df_products.to_sql("products_per_plant", conn, if_exists="append", index=False)

# 6. Loading plant_ports.csv into the database
df_ports = pd.read_csv("plant_ports.csv")
df_ports.columns = df_ports.columns.str.lower()
df_ports.to_sql("plant_ports", conn, if_exists="append", index=False)

# 7. Loading order_list.csv into the database
df_orders = pd.read_csv("order_list.csv")
df_orders.columns = df_orders.columns.str.lower()
df_orders.to_sql("order_list", conn, if_exists="append", index=False)

# 8. Loading freight_rates.csv into the database
df_fri = pd.read_csv("frieght_rates.csv")
df_fri.columns = df_fri.columns.str.lower()
df_fri.to_sql("freight_rates", conn, if_exists="append", index=False)


conn.close()
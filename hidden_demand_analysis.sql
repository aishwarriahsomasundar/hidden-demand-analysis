CREATE TABLE public.hidden_demand_sales_clean (
    sale_date DATE,
    product TEXT,
    units_sold INTEGER,
    availability TEXT,
    unit_price NUMERIC(8, 2)
);
CREATE TABLE IF NOT EXISTS public.hidden_demand_sales_clean (
    sale_date DATE,
    product TEXT,
    units_sold INTEGER,
    availability TEXT,
    unit_price NUMERIC(8, 2)
);
CREATE TABLE IF NOT EXISTS public.hidden_demand_sales_clean (
    sale_date DATE,
    product TEXT,
    units_sold INTEGER,
    availability TEXT,
    unit_price NUMERIC(8, 2)
);
SELECT product, COUNT(*) AS rows_imported
FROM public.hidden_demand_sales_clean
GROUP BY product
ORDER BY product;
SELECT
    s.sale_date AS stockout_date,
    s.product,
    COUNT(h.units_sold) AS comparison_days,
    ROUND(AVG(h.units_sold), 2) AS expected_units,
    ROUND((AVG(h.units_sold) - s.units_sold) * s.unit_price, 2)
        AS estimated_missed_revenue_aud
FROM public.hidden_demand_sales_clean AS s
JOIN public.hidden_demand_sales_clean AS h
    ON h.product = s.product
    AND h.sale_date < s.sale_date
    AND EXTRACT(ISODOW FROM h.sale_date) = EXTRACT(ISODOW FROM s.sale_date)
    AND h.availability = 'In stock all day'
WHERE s.availability = 'Out of stock all day'
GROUP BY s.sale_date, s.product, s.units_sold, s.unit_price
ORDER BY estimated_missed_revenue_aud DESC;

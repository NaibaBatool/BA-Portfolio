-- Q1: Film performance -- fast vs slow movers
SELECT 
    f.title,
    c.name AS category,
    f.rental_rate,
    f.replacement_cost,
    COUNT(r.rental_id) AS total_rentals,
    CASE 
        WHEN COUNT(r.rental_id) >= 30 THEN 'Fast Mover'
        WHEN COUNT(r.rental_id) >= 15 THEN 'Medium Mover'
        ELSE 'Slow Mover'
    END AS mover_status
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title, c.name, f.rental_rate, f.replacement_cost
ORDER BY total_rentals DESC;

-- Notice Rocketeer Mother and Grit Clockwork have rental rate of only $0.99 but are Fast Movers — the store is underpricing its most popular films. That's a real business insight.


-- Q2: Revenue by category
SELECT 
    c.name AS category,
    COUNT(DISTINCT f.film_id) AS total_films,
    COUNT(r.rental_id) AS total_rentals,
    SUM(p.amount) AS total_revenue,
    ROUND(SUM(p.amount) / COUNT(r.rental_id), 2) AS avg_revenue_per_rental,
    ROUND(SUM(p.amount) / COUNT(DISTINCT f.film_id), 2) AS revenue_per_film
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY total_revenue DESC;

-- Sports leads in total revenue ($5,314) and total rentals (1,179) making it the strongest category overall. 
-- However Comedy and Sci-Fi show superior revenue efficiency per film ($78 and $80 respectively), suggesting these categories generate strong returns relative to their catalog size. 
-- Foreign category is over-represented in inventory (67 films) but underperforms on revenue per film ($63.74), indicating poor stock allocation. 
-- Music and Travel are the weakest performers across all metrics and should be prioritised for inventory reduction on next reorder.

-- Q3: Films never rented (dead inventory)
SELECT 
    f.title,
    c.name AS category,
    f.rental_rate,
    f.replacement_cost,
    i.store_id,
    COUNT(i.inventory_id) AS copies_in_stock
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL
GROUP BY f.title, c.name, f.rental_rate, f.replacement_cost, i.store_id
ORDER BY f.replacement_cost DESC;

-- Dead stock analysis reveals only 1 inventory item has never been rented — Academy Dinosaur in Store 2. 
-- This indicates excellent inventory utilisation across both stores. Recommendation: remove or replace this copy on next reorder cycle

-- Q4: Reorder suggestions -- high demand low stock
SELECT 
    f.title,
    c.name AS category,
    f.rental_rate,
    COUNT(DISTINCT i.inventory_id) AS copies_in_stock,
    COUNT(r.rental_id) AS total_rentals,
    ROUND(COUNT(r.rental_id) / COUNT(DISTINCT i.inventory_id), 1) AS rentals_per_copy,
    CASE
        WHEN COUNT(r.rental_id) / COUNT(DISTINCT i.inventory_id) >= 8 THEN 'Urgent Reorder'
        WHEN COUNT(r.rental_id) / COUNT(DISTINCT i.inventory_id) >= 5 THEN 'Consider Reorder'
        ELSE 'Stock OK'
    END AS reorder_flag
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title, c.name, f.rental_rate
HAVING reorder_flag != 'Stock OK'
ORDER BY rentals_per_copy DESC;

-- All 17 films sit exactly at the 5.0 threshold — meaning our reorder logic is catching the right borderline cases
-- Love Suicides (Horror) has 4 copies but still flags — highest stock of any flagged film, yet still hitting 5 rentals per copy meaning it's genuinely in demand
-- Mystic Truman (Comedy, $0.99 rental rate) — being rented 5x per copy despite cheapest possible rental rate, severely underpriced
-- No "Urgent Reorder" films means overall stock levels are healthy — but these 17 need attention before demand increases

-- Q5: Store performance comparison
SELECT 
    s.store_id,
    ci.city AS store_city,
    COUNT(DISTINCT i.inventory_id) AS total_inventory,
    COUNT(DISTINCT r.rental_id) AS total_rentals,
    SUM(p.amount) AS total_revenue,
    ROUND(SUM(p.amount) / COUNT(DISTINCT r.rental_id), 2) AS avg_revenue_per_rental,
    COUNT(DISTINCT r.customer_id) AS unique_customers,
    ROUND(SUM(p.amount) / COUNT(DISTINCT r.customer_id), 2) AS revenue_per_customer
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN inventory i ON s.store_id = i.store_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY s.store_id, ci.city;

-- Both stores perform near-identically across all metrics despite being in different cities — Lethbridge (Store 1) and Woodridge (Store 2) each serve exactly 599 unique customers with revenue per customer of $56.23 and $56.31 respectively. 
-- Store 2 leads marginally in total rentals (8,121 vs 7,923) and revenue ($33,726 vs $33,679) due to slightly larger inventory (2,310 vs 2,270 items).
--  However Store 1 commands a higher average revenue per rental ($4.25 vs $4.15), suggesting its catalog skews toward premium-priced titles.
--   Recommendation: analyse Store 1's film mix to identify which higher-rate titles could be replicated in Store 2 to boost its per-rental revenue.
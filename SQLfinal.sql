SELECT
    NOW() kevin_bell, CONCAT(
        customer.first_name,
        ' ',
        customer.last_name
    ) AS customer_name,
    s.store_id,
    AVG(
        TIMESTAMPDIFF(
            DAY,
            r.return_date,
            payment.payment_date
        )
    ) AS customer_avg,
    (
    SELECT
        AVG(
            TIMESTAMPDIFF(
                DAY,
                rent.return_date,
                payment.payment_date
            )
        )
    FROM
        rental AS rent
    JOIN payment ON rent.rental_id = payment.rental_id
    JOIN inventory ON rent.inventory_id = inventory.inventory_id
    JOIN store AS s2
    ON
        inventory.store_id = s2.store_id
    WHERE
        s2.store_id = s.store_id
) AS store_avg
FROM
    rental AS r
JOIN payment ON r.rental_id = payment.rental_id
JOIN inventory ON r.inventory_id = inventory.inventory_id
JOIN store AS s
ON
    inventory.store_id = s.store_id
JOIN customer ON r.customer_id = customer.customer_id
GROUP BY
    r.customer_id,
    s.store_id
HAVING
    customer_avg > store_avg
ORDER BY
    customer.customer_id, s.store_id
DESC PRODUCT_INFORMATION;

--SELECT DISTINCT PRODUCT_STATUS FROM PRODUCT_INFORMATION;
SELECT UPPER(product_status), SUM(list_price), COUNT(*)
FROM product_information
WHERE upper(product_status) NOT LIKE 'ORDERABLE'
GROUP BY upper(product_status)
HAVING SUM(LIST_PRICE) > 4000;

--product_informaiton, product_id, product_name, product_description

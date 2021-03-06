
SELECT PRODUCT_NAME, CATALOG_URL, REPLACE(SUBSTR(CATALOG_URL, 
    1, INSTR(CATALOG_URL, '.com') - 1), 'http://www.supp-') AS SUPP_CODE
FROM PRODUCT_INFORMATION
WHERE upper(PRODUCT_DESCRIPTION) LIKE '%COLOR%' AND upper(PRODUCT_DESCRIPTION) LIKE '%PRINTER%';
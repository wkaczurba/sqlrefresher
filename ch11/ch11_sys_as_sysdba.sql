SELECT object_type, count(object_type)
FROM dba_objects
GROUP BY object_type
ORDER BY object_type;

SELECT object_type, count(1)
FROM dba_objects WHERE upper(object_type) IN (
  'TABLE','VIEW','SYNONYM','SEQUENCE','INDEX'
) GROUP BY object_type;


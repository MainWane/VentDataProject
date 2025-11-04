CREATE TABLE sensors (
    ts TIMESTAMP,
    device STRING,
    value DOUBLE
) TIMESTAMP(ts) PARTITION BY DAY;

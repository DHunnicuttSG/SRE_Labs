CREATE TABLE IF NOT EXISTS tickets (

    id SERIAL PRIMARY KEY,

    title VARCHAR(255),

    description TEXT,

    status VARCHAR(50),

    priority VARCHAR(50),

    owner VARCHAR(100)
);

INSERT INTO tickets
(title, description, status, priority, owner)

VALUES

(
'API Login Failure',
'Customers unable to authenticate',
'OPEN',
'HIGH',
'support1'
),

(
'Database Timeouts',
'Intermittent SQL failures',
'IN_PROGRESS',
'HIGH',
'support2'
),

(
'Slow Dashboard',
'Grafana loading slowly',
'OPEN',
'MEDIUM',
'support1'
);
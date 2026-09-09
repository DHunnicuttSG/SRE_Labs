CREATE TABLE IF NOT EXISTS tickets (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    status VARCHAR(50),
    priority VARCHAR(50),
    owner VARCHAR(100),
    severity VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    acknowledged_at TIMESTAMP,
    resolved_at TIMESTAMP,
    sla_target_minutes INTEGER,
    sla_breached BOOLEAN DEFAULT FALSE
);

INSERT INTO tickets
(title, description, status, priority, owner)
VALUES
('API Login Failure','Customers unable to authenticate','OPEN','HIGH','support1'),
('Database Timeouts','Intermittent SQL failures','IN_PROGRESS','HIGH','support2'),
('Slow Dashboard','Grafana loading slowly','OPEN','MEDIUM','support1');


CREATE TABLE IF NOT EXISTS comments (
    id SERIAL PRIMARY KEY,
    ticket_id INTEGER NOT NULL,
    author VARCHAR(100) NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ticket
        FOREIGN KEY(ticket_id)
        REFERENCES tickets(id)
);

INSERT INTO comments
(ticket_id, author, comment)
VALUES
(1,'support1','Issue reported by customer.'),
(1,'support2','Investigating authentication service.'),
(2,'support1','Database team engaged.');

CREATE TABLE IF NOT EXISTS assignment_history (
    id SERIAL PRIMARY KEY,
    ticket_id INTEGER NOT NULL,
    old_owner VARCHAR(100),
    new_owner VARCHAR(100) NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_assignment_ticket
        FOREIGN KEY(ticket_id)
        REFERENCES tickets(id)
);

CREATE TABLE IF NOT EXISTS assignment_history (
    id SERIAL PRIMARY KEY,
    ticket_id INTEGER NOT NULL,
    old_owner VARCHAR(100),
    new_owner VARCHAR(100) NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_assignment_ticket
        FOREIGN KEY(ticket_id)
        REFERENCES tickets(id)
);

CREATE TABLE IF NOT EXISTS status_history (
    id SERIAL PRIMARY KEY,
    ticket_id INTEGER NOT NULL,
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_status_ticket
        FOREIGN KEY(ticket_id)
        REFERENCES tickets(id)
);
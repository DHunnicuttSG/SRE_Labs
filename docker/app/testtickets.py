from app import app
from database import db
from models import Ticket

with app.app_context():

    tickets = [

        Ticket(
            title="Database Outage",
            description="Primary PostgreSQL database unavailable",
            status="OPEN",
            priority="HIGH",
            owner="support1",
            severity="SEV1",
            sla_target_minutes=30
        ),

        Ticket(
            title="Authentication Failure",
            description="Users unable to log in",
            status="IN_PROGRESS",
            priority="HIGH",
            owner="support2",
            severity="SEV1",
            sla_target_minutes=30
        ),

        Ticket(
            title="API Latency",
            description="Response times greater than 5 seconds",
            status="OPEN",
            priority="MEDIUM",
            owner="support1",
            severity="SEV2",
            sla_target_minutes=120
        ),

        Ticket(
            title="Grafana Dashboard Error",
            description="Operations dashboard not loading",
            status="RESOLVED",
            priority="MEDIUM",
            owner="support3",
            severity="SEV3",
            sla_target_minutes=480
        ),

        Ticket(
            title="Redis Cache Miss Spike",
            description="Increased cache misses detected",
            status="OPEN",
            priority="MEDIUM",
            owner="support2",
            severity="SEV2",
            sla_target_minutes=120
        ),

        Ticket(
            title="Disk Space Warning",
            description="Filesystem above 85 percent utilization",
            status="OPEN",
            priority="LOW",
            owner="support1",
            severity="SEV4",
            sla_target_minutes=1440
        ),

        Ticket(
            title="Nginx 502 Errors",
            description="Users receiving bad gateway errors",
            status="IN_PROGRESS",
            priority="HIGH",
            owner="support2",
            severity="SEV1",
            sla_target_minutes=30
        )
    ]

    db.session.add_all(tickets)

    db.session.commit()

    print("Test tickets loaded successfully.")
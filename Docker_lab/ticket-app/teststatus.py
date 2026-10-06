from app import app
from database import db
from models import StatusHistory

with app.app_context():

    rows = [

        StatusHistory(
            ticket_id=2,
            old_status="OPEN",
            new_status="IN_PROGRESS"
        ),

        StatusHistory(
            ticket_id=4,
            old_status="OPEN",
            new_status="IN_PROGRESS"
        ),

        StatusHistory(
            ticket_id=4,
            old_status="IN_PROGRESS",
            new_status="RESOLVED"
        )
    ]

    db.session.add_all(rows)

    db.session.commit()

    print("Status history loaded.")
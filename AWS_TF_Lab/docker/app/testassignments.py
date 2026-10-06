from app import app
from database import db
from models import AssignmentHistory

with app.app_context():

    rows = [

        AssignmentHistory(
            ticket_id=1,
            old_owner="support1",
            new_owner="support2"
        ),

        AssignmentHistory(
            ticket_id=4,
            old_owner="support2",
            new_owner="support3"
        ),

        AssignmentHistory(
            ticket_id=7,
            old_owner="support1",
            new_owner="support2"
        )
    ]

    db.session.add_all(rows)

    db.session.commit()

    print("Assignment history loaded.")
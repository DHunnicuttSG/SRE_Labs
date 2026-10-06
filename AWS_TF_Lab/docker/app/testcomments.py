from app import app
from database import db
from models import Comment

with app.app_context():

    comments = [

        Comment(
            ticket_id=1,
            author="support1",
            comment="Database team engaged."
        ),

        Comment(
            ticket_id=1,
            author="support2",
            comment="Primary node unreachable."
        ),

        Comment(
            ticket_id=2,
            author="support2",
            comment="Authentication service restarted."
        ),

        Comment(
            ticket_id=3,
            author="support1",
            comment="Collecting latency metrics."
        ),

        Comment(
            ticket_id=7,
            author="support3",
            comment="Nginx configuration under review."
        )
    ]

    db.session.add_all(comments)

    db.session.commit()

    print("Comments loaded successfully.")